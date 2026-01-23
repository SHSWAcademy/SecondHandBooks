package project.trade;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import project.member.MemberVO;
import project.util.exception.TradeNotFoundException;

import java.io.File;
import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class TradeService {
    private final TradeMapper tradeMapper;
    private final BookImgMapper bookImgMapper;

    @Value("${file.dir}")
    private String fileDir;


    // 판매글 전체 조회
    public List<TradeVO> searchAll() {
        return tradeMapper.findAll();
    }

    // 판매글 단일 조회
    public TradeVO search(long trade_seq) {
        TradeVO findTrade = tradeMapper.findBySeq(trade_seq);

        if (findTrade == null) {
            log.info("데이터 조회 실패 : DB에서 데이터를 조회하지 못했습니다.");
            throw new TradeNotFoundException("Cannot find trade_seq=" + trade_seq);
        }

        List<TradeImageVO> imgUrl = tradeMapper.findImgUrl(trade_seq); // imgUrl은 null 이어도 된다 (썸네일 이미지만 보여진다)

        findTrade.setTrade_img(imgUrl);

        return findTrade;
    }

    // 페이징 조회
    public List<TradeVO> searchAllWithPaging(int page, int size, TradeVO searchVO) {
        int offset = (page - 1) * size;  // page가 1부터 시작한다고 가정
        return tradeMapper.findAllWithPaging(size, offset, searchVO);
    }

    // 전체 개수
    public int countAll(TradeVO searchVO) {
        return tradeMapper.countAll(searchVO);
    }

    // 판매글 등록
    @Transactional
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
    public boolean modify(Long tradeSeq, TradeVO updateTrade) {
        // tradeSeq : 기존 trade의 seq, updateTrade : 변경값을 담은 trade 객체
        // 변경하려는 trade에 현재 seq을 넣기
        updateTrade.setTrade_seq(tradeSeq);

        int result = tradeMapper.update(updateTrade);
        log.info("Updated result count = {}", result);

        // 업데이트 이미지 처리
        if (updateTrade.getImgUrls() != null && !updateTrade.getImgUrls().isEmpty()) {
            bookImgMapper.deleteBySeq(tradeSeq); // 기존 이미지들을 먼저 삭제한다
            for (String imgUrl : updateTrade.getImgUrls()) {
                log.info("Updating image: {} for trade_seq: {}", imgUrl, updateTrade.getTrade_seq());
                bookImgMapper.save(imgUrl, updateTrade.getTrade_seq());
            }
        }
        return result > 0;
    }


    // 판매글 삭제
    @Transactional
    public boolean remove(Long tradeSeq) {

        // 이미지 url 조회
        List<TradeImageVO> imgUrls = tradeMapper.findImgUrl(tradeSeq);
        if (imgUrls != null && !imgUrls.isEmpty()) {
            for (TradeImageVO vo : imgUrls) {
                File file = new File(fileDir + "/" + vo.getImg_url());
                if (file.exists()) file.delete();
            }
        }

        bookImgMapper.deleteBySeq(tradeSeq); // 기존 이미지 url들을 db에서 먼저 삭제

        int result = tradeMapper.delete(tradeSeq);
        log.info("Deleted result count = {}", result);

        return result > 0;
    }

    // 카테고리조회
    public List<TradeVO> selectCategory() {
        return tradeMapper.selectCategory();
    }
    public List<TradeVO> selectBookState() { return tradeMapper.findBookState(); }

    @Transactional
    public void updateStatus(Long trade_seq, String sold, Long member_buyer_seq) {
        tradeMapper.updateStatus(trade_seq, sold, member_buyer_seq);
    }

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

        for (TradeVO trade : trades) {
            List<TradeImageVO> images = tradeMapper.findImgUrl(trade.getTrade_seq());
            trade.setTrade_img(images);
        }

        return trades;
    }

    // 판매내역
    public List<TradeVO> getSaleTrades(long member_seq, String status) {
        List<TradeVO> trades =  tradeMapper.selectSaleTrades(member_seq, status);

        // 각 거래에 이미지 리스트 채우기
        for (TradeVO trade : trades) {
            List<TradeImageVO> images = tradeMapper.findImgUrl(trade.getTrade_seq());
            trade.setTrade_img(images);
        }

        return trades;
    }
}
