package project.trade;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import project.member.MemberVO;
import project.payment.PaymentVO;
import project.trade.ENUM.SaleStatus;
import project.util.S3Service;
import project.util.exception.TradeNotFoundException;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class TradeService {
    private final TradeMapper tradeMapper;
    private final BookImgMapper bookImgMapper;
    private final S3Service s3Service;

    @Value("${file.dir}")
    private String fileDir;


    // 판매글 전체 조회
    public List<TradeVO> searchAll() {
        return tradeMapper.findAll();
    }

    // 판매글 단일 조회
    @Cacheable(value = "trade", key = "#trade_seq", unless = "#result == null")
    public TradeVO search(long trade_seq) {
        // 쿼리를 2번 조회하기 때문에 cache
        TradeVO findTrade = tradeMapper.findBySeq(trade_seq);

        if (findTrade == null) {
            log.info("데이터 조회 실패 : DB에서 데이터를 조회하지 못했습니다.");
            throw new TradeNotFoundException("Cannot find trade_seq=" + trade_seq);
        }

        List<TradeImageVO> imgUrl = tradeMapper.findImgUrl(trade_seq); // imgUrl은 null 이어도 된다 (썸네일 이미지만 보여진다)

        findTrade.setTrade_img(imgUrl);

        return findTrade;
    }

    // 리스트 : 페이징 조회
    @Cacheable(value = "tradeList",
            key = "'page:' + #page + ':size:' + #size + ':cat:' + #searchVO.category_seq + ':word:' +#searchVO.search_word + ':sort:' + #searchVO.sort + ':saleSt:' + #searchVO.sale_st + ':bookSt:' + #searchVO.book_st")
    public List<TradeVO> searchAllWithPaging(int page, int size, TradeVO searchVO) {
        int offset = (page - 1) * size;  // page가 1부터 시작한다고 가정
        return tradeMapper.findAllWithPaging(size, offset, searchVO);
    }

    // 전체 개수
    @Cacheable(value = "tradeList",
            key = "'page:' + #page + ':size:' + #size + ':cat:' + #searchVO.category_seq + ':word:' +#searchVO.search_word + ':sort:' + #searchVO.sort + ':saleSt:' + #searchVO.sale_st + ':bookSt:' + #searchVO.book_st")
    public int countAll(TradeVO searchVO) {
        return tradeMapper.countAll(searchVO);
    }

    // 판매글 등록
    @Transactional
    @CacheEvict(value = "tradeList", allEntries = true)
    public boolean upload(TradeVO tradeVO) {

        int result = tradeMapper.save(tradeVO);
        log.info("Saved result count = {}", result);

        // 등록된 이미지 처리
        if (tradeVO.getImgUrls() != null && !tradeVO.getImgUrls().isEmpty()) {
            for (String imgUrl : tradeVO.getImgUrls()) {
                log.info("Saving image: {} for trade_seq: {}", imgUrl, tradeVO.getTrade_seq());
                bookImgMapper.save(imgUrl, tradeVO.getTrade_seq());
            }
        }
        return result > 0;
    }

    // 판매글 수정
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "trade", key = "#trade_seq"),
            @CacheEvict(value = "tradeList", allEntries = true)
    })
    public boolean modify(Long trade_seq, TradeVO updateTrade) {
        // tradeSeq : 기존 trade의 seq, updateTrade : 변경값을 담은 trade 객체
        // 변경하려는 trade에 현재 seq을 넣기
        updateTrade.setTrade_seq(trade_seq);

        int result = tradeMapper.update(updateTrade);
        log.info("Updated result count = {}", result);

        // 이미지 처리
        List<String> newImgUrls = updateTrade.getImgUrls();
        if (newImgUrls == null) newImgUrls = new ArrayList<>();

        // 기존 이미지 목록 조회
        List<TradeImageVO> existingImages = tradeMapper.findImgUrl(trade_seq);

        // S3에서 삭제할 이미지 찾기 (기존 이미지 중 새 목록에 없는 것)
        if (existingImages != null && !existingImages.isEmpty()) {
            List<String> urlsToDelete = new ArrayList<>();
            for (TradeImageVO existingImg : existingImages) {
                String existingUrl = existingImg.getImg_url();
                if (!newImgUrls.contains(existingUrl)) {
                    // S3 이미지인 경우만 삭제 (http로 시작하는 URL)
                    if (existingUrl != null && existingUrl.startsWith("http")) {
                        urlsToDelete.add(existingUrl);
                    }
                }
            }
            // S3에서 삭제
            if (!urlsToDelete.isEmpty()) {
                try {
                    s3Service.deleteFilesByUrls(urlsToDelete);
                    log.info("Deleted S3 images: {}", urlsToDelete);
                } catch (Exception e) {
                    log.error("Failed to delete S3 images: {}", e.getMessage());
                }
            }
        }

        // DB에서 기존 이미지 전부 삭제
        bookImgMapper.deleteBySeq(trade_seq);

        // 새 이미지 목록이 있으면 저장 (유지할 이미지 + 새로 업로드한 이미지)
        if (!newImgUrls.isEmpty()) {
            for (String imgUrl : newImgUrls) {
                log.info("Saving image: {} for trade_seq: {}", imgUrl, trade_seq);
                bookImgMapper.save(imgUrl, trade_seq);
            }
        }
        return result > 0;
    }


    // 판매글 삭제
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "trade", key = "#trade_seq"),
            @CacheEvict(value = "tradeList", allEntries = true)
    })
    public boolean remove(Long trade_seq) {

        // 이미지 url 조회
        List<TradeImageVO> imgUrls = tradeMapper.findImgUrl(trade_seq);
        if (imgUrls != null && !imgUrls.isEmpty()) {
            List<String> s3UrlsToDelete = new ArrayList<>();
            for (TradeImageVO vo : imgUrls) {
                String imgUrl = vo.getImg_url();
                if (imgUrl != null && imgUrl.startsWith("http")) {
                    // S3 이미지
                    s3UrlsToDelete.add(imgUrl);
                } else {
                    // 로컬 이미지 (기존 로직 유지)
                    File file = new File(fileDir + "/" + imgUrl);
                    if (file.exists()) file.delete();
                }
            }
            // S3에서 삭제
            if (!s3UrlsToDelete.isEmpty()) {
                try {
                    s3Service.deleteFilesByUrls(s3UrlsToDelete);
                    log.info("Deleted S3 images on trade removal: {}", s3UrlsToDelete);
                } catch (Exception e) {
                    log.error("Failed to delete S3 images on trade removal: {}", e.getMessage());
                }
            }
        }

        bookImgMapper.deleteBySeq(trade_seq); // 기존 이미지 url들을 db에서 먼저 삭제

        int result = tradeMapper.delete(trade_seq);
        log.info("Deleted result count = {}", result);

        return result > 0;
    }

    // 카테고리 조회
    public List<TradeVO> selectCategory() {
        return tradeMapper.selectCategory();
    }
    //public List<TradeVO> selectBookState() { return tradeMapper.findBookState(); }

    // 판매글 sale status를 sold로 업데이트
//    @Transactional
//    @CacheEvict(value = "trade", key = "#trade_seq")
//    public void updateStatusToSold(Long trade_seq, String sold, Long member_buyer_seq) {
//        tradeMapper.updateStatus(trade_seq, sold, member_buyer_seq);
//    }

    // 안전 결제 상태 업데이트
    // 안전 결제 접근 시 인증 후 safe_payment_st를 PENDING으로 업데이트
    // 안전 결제로 판매 완료 시 sale_st를 sold로, safe_payment_st를 COMPLETED로 업데이트
    // 안전 결제로 결제 실패 시 safe_payment_st를 PENDING -> NONE으로 업데이트
//    @Transactional
//    public void updateSafePaymentStatus(long trade_seq, String status) {
//        tradeMapper.updateSafePaymentStatus(trade_seq, status);
//    }

    // 찜하기 insert
    @Transactional
    public boolean saveLike(long trade_seq, long member_seq) {
        int cnt = tradeMapper.countLike(trade_seq, member_seq);
        log.info("Like count = {}", cnt);
        if (cnt > 0) {  // 이미 누른 카운트가 있다면 delete하고 false 리턴
            tradeMapper.deleteLike(trade_seq, member_seq);
            return false;
        } else {        // 좋아요 누른게 없다면 true
            int insertLike = tradeMapper.saveLike(trade_seq, member_seq);
            log.info("Like insert = {}", insertLike);
            return true;
        }
    }

    // 찜하기 이전에 눌렀는지 조회
    public boolean isWished(long trade_seq, long member_seq) {
        return tradeMapper.countLike(trade_seq, member_seq) > 0;
    }
    // 찜하기 전체 갯수 조회
    public int countLikeAll(long trade_seq) {
        return tradeMapper.countLikeAll(trade_seq);
    }

    // chat_room_seq 으로 trade 찾기
    public TradeVO findByChatRoomSeq(long chat_room_seq) {
        return tradeMapper.findByChatRoomSeq(chat_room_seq);
    }

    // 판매자 정보조회
    public MemberVO findSellerInfo(long tradeSeq) {
        return tradeMapper.findSellerInfo(tradeSeq);
    }
    public List<TradeVO> getWishTrades(long member_seq) {
        return tradeMapper.selectWishTrades(member_seq);
    }

    // 구매내역
    public List<TradeVO> getPurchaseTrades(long member_seq) {
        List<TradeVO> trades = tradeMapper.selectPurchaseTrades(member_seq);
//
//        // trade_seq 모음
//        List<Long> tradeSeqList = new ArrayList<>();
//        for (TradeVO trade : trades) {
//            tradeSeqList.add(trade.getTrade_seq());
//        }
//
//        // trade_seq기준 이미지 조회
//        List<TradeImageVO> images = tradeMapper.findImgUrlByTradeSeqList(tradeSeqList);
//
//        // Map trade_seq를 키값으로 이미지객체 value에 넣기
//        Map<Long, List<TradeImageVO>> imgMap = new HashMap<>();
//        for (TradeImageVO img : images) {
//            Long trade_seq = img.getTrade_seq();
//            if (!imgMap.containsKey(trade_seq)) {
//                imgMap.put(trade_seq, new ArrayList<>());
//            }
//
//            imgMap.get(trade_seq).add(img);
//        }
//
//        // 위에서 출력된 trade객체의 trade_seq와 map의 key값인 trade_seq 값이 같다면 이미지객체 넣기
//        for (TradeVO trade : trades) {
//            trade.setTrade_img(imgMap.getOrDefault(trade.getTrade_seq(), new ArrayList<>()));
//        }
//
//        for (TradeVO trade : trades) {
//            List<TradeImageVO> images = tradeMapper.findImgUrl(trade.getTrade_seq());
//            trade.setTrade_img(images);
//        }

        return trades;
    }

    // 판매내역
    public List<TradeVO> getSaleTrades(long member_seq, String status) {
        List<TradeVO> trades =  tradeMapper.selectSaleTrades(member_seq, status);

//        // trade_seq 모음
//        List<Long> tradeSeqList = new ArrayList<>();
//        for (TradeVO trade : trades) {
//            tradeSeqList.add(trade.getTrade_seq());
//        }
//
//        // trade_seq기준 이미지 조회
//        List<TradeImageVO> images = tradeMapper.findImgUrlByTradeSeqList(tradeSeqList);
//
//        // Map trade_seq를 키값으로 이미지객체 value에 넣기
//        Map<Long, List<TradeImageVO>> imgMap = new HashMap<>();
//        for (TradeImageVO img : images) {
//            Long trade_seq = img.getTrade_seq();
//            if (!imgMap.containsKey(trade_seq)) {
//                imgMap.put(trade_seq, new ArrayList<>());
//            }
//
//            imgMap.get(trade_seq).add(img);
//        }
//
//        // 위에서 출력된 trade객체의 trade_seq와 map의 key값인 trade_seq 값이 같다면 이미지객체 넣기
//        for (TradeVO trade : trades) {
//            trade.setTrade_img(imgMap.getOrDefault(trade.getTrade_seq(), new ArrayList<>()));
//        }
//
//        // 각 거래에 이미지 리스트 채우기
//        for (TradeVO trade : trades) {
//            List<TradeImageVO> images = tradeMapper.findImgUrl(trade.getTrade_seq());
//            trade.setTrade_img(images);
//        }

        return trades;
    }

    // 안전 결제 상태 조회
    @Transactional
    public String getSafePaymentStatus(long trade_seq) {
        String status = tradeMapper.findSafePaymentStatus(trade_seq);
        return status;
    }

    // 안전 결제 요청 처리 (트랜잭션으로 상태 체크, 업데이트 원자적 처리), 5분 만료 시간 설정
    // return true : 안전 결제 요청 성공, false : 이미 안전 결제 요청 처리
    @Transactional
    @CacheEvict(value = "trade", key = "#trade_seq")
    public boolean requestSafePayment(long trade_seq, long pending_buyer_seq) {
        // 안전 결제 진행 중이 아닌 상태라면 PENDING(안전 결제 시작) 으로 변경 + 5분 만료 시간 설정
        tradeMapper.updateSafePaymentWithExpire(trade_seq, "PENDING", 5, pending_buyer_seq);
        return true; // 안전 결제 시작
    }

//    public Long getPendingBuyerSeq(long trade_seq) {
//        return tradeMapper.findPendingBuyerSeq(trade_seq);
//    }


    // 안전 결제 상태를 COMPLETED 로 변경
//    @Transactional
//    public void completeSafePayment(long trade_seq) {
//        tradeMapper.updateSafePaymentStatus(trade_seq, "COMPLETED");
//    }


    // 안전 결제 실패, NONE 으로 update,  채팅방으로 다시 돌아가도록 하기
    @Transactional
    @CacheEvict(value = "trade", key = "#trade_seq")
    public void cancelSafePayment(long trade_seq) {
        tradeMapper.updateSafePaymentStatus(trade_seq, "NONE");
    }


    public long getSafePaymentExpireSeconds(long trade_seq) {
        Long seconds = tradeMapper.findSafePaymentExpireSeconds(trade_seq); // trade의 안전 결제 만료 시간이 몇 초 남았는지 조회

        if (seconds == null) return 0;
        else return seconds;
    }

    @Transactional
    @CacheEvict(value = "trade", allEntries = true)
    public int resetExpiredSafePayments() {
        return tradeMapper.resetExpiredSafePayments();
    }


    // 판매자 수동 sold 변경
    @Transactional
    @CacheEvict(value = "trade", key = "#trade_seq")
    public boolean updateToSoldManually(long trade_seq, long member_seq) {
        return tradeMapper.updateToSoldManually(trade_seq, member_seq) > 0;
    }

    // 구매 확정
    @Transactional
    @CacheEvict(value = "trade", key = "#trade_seq")
    public boolean confirmPurchase(long trade_seq, long member_seq) {
        return tradeMapper.confirmPurchase(trade_seq, member_seq) > 0;
    }

    // 15일 지난 미확정 건 자동 확정
    @Transactional
    @CacheEvict(value = "trade", allEntries = true)
    public int autoConfirmExpiredPurchases() {
        return tradeMapper.autoConfirmExpiredPurchases();
    }

    // 구매자의 안전결제 구매 내역 조회
//    public List<TradeVO> findPurchasesByBuyer(long member_seq) {
//        return tradeMapper.findPurchasesByBuyer(member_seq);
//    }




    // 수정 가능 여부 체크
//    public boolean canEdit(TradeVO trade, long member_seq) {
//        // 본인 글이 아니면 불가
//        if (trade.getMember_seller_seq() != member_seq) return false;
//        // sold면 불가
//        if ("sold".equals(trade.getSale_st())) return false;
//        // 안전결제 진행중(PENDING)이면 불가
//        if ("PENDING".equals(trade.getSafe_payment_st())) return false;
//        return true;
//    }
//
//    // 삭제 가능 여부 체크
//    public boolean canDelete(TradeVO trade, long member_seq) {
//        // 본인 글이 아니면 불가
//        if (trade.getMember_seller_seq() != member_seq) return false;
//        // 안전결제 완료(COMPLETED)면 불가
//        if ("COMPLETED".equals(trade.getSafe_payment_st())) return false;
//        // 안전결제 진행중(PENDING)이면 불가
//        if ("PENDING".equals(trade.getSafe_payment_st())) return false;
//        // 수동 sold(confirm_purchase가 null)면 삭제 가능
//        return true;
//    }


    // 판매상태 수동 업데이트
    @Transactional
    @CacheEvict(value = "trade", key = "#trade_seq")
    public boolean statusUpdate(long trade_seq) {
        return tradeMapper.statusUpdate(trade_seq, SaleStatus.SOLD) > 0;
    }

    @Transactional
    @CacheEvict(value = "trade", key = "#tradeSeq")
    public void successPurchase(Long tradeSeq, long memberSeq, String postNo, String addrH, String addrD) {
        tradeMapper.successPurchase(tradeSeq, memberSeq, postNo, addrH, addrD);
    }
    // 결제창 진입 시 유효성 검사 항목
    @Transactional
    public PaymentVO getPaymentCheckInfo(Long trade_seq) {
        return tradeMapper.getPaymentCheckInfo(trade_seq);
    }


    @Caching(evict = {
            @CacheEvict(value = "trade", allEntries = true),
            @CacheEvict(value = "tradeList", allEntries = true)
    })
    @Transactional
    public int deleteAllByMember(long member_seq) { // 회원이 탈퇴 시 회원이 작성한 trade 삭제
        // 1. 해당 회원의 모든 Trade 이미지 URL 한번에 조회
        List<String> allImageUrls =
                tradeMapper.findAllImageUrlsByMember(member_seq);

        // 2. S3 이미지 삭제
        if (allImageUrls != null && !allImageUrls.isEmpty()) {
            List<String> s3Urls = allImageUrls.stream()
                    .filter(url -> url != null && url.startsWith("http"))
                    .collect(Collectors.toList());

            if (!s3Urls.isEmpty()) {
                try {
                    s3Service.deleteFilesByUrls(s3Urls);
                    log.info("Deleted {} S3 images for member: {}", s3Urls.size(),
                            member_seq);
                } catch (Exception e) {
                    log.error("Failed to delete S3 images: {}", e.getMessage());
                }
            }
        }

        // 3. Trade soft delete
        return tradeMapper.deleteAll(member_seq);
    }
}