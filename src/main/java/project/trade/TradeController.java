package project.trade;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import project.member.MemberService;
import project.member.MemberVO;
import project.trade.ENUM.SaleStatus;
import project.util.Const;
import project.util.book.BookApiService;
import project.util.book.BookVO;
import project.util.exception.NoSessionException;
import project.util.exception.TradeNotFoundException;
import project.util.imgUpload.FileStore;
import project.util.imgUpload.UploadFile;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Slf4j
@RequiredArgsConstructor
public class TradeController {
    private final TradeService tradeService;
    private final BookApiService bookApiService;
    private final FileStore fileStore; // 이미지 저장 기능을 수행하는 객체

    // 판매글 단일 조회
    @GetMapping("/trade/{tradeSeq}")
    public String getSaleDetail(@PathVariable long tradeSeq, Model model, HttpSession session) {
        TradeVO trade = tradeService.search(tradeSeq);

        int wishCount = tradeService.countLikeAll(tradeSeq); // 총 찜 개수
        boolean wished = false;

        MemberVO login = (MemberVO) session.getAttribute(Const.SESSION);
        MemberVO seller_info = tradeService.findSellerInfo(tradeSeq);   // 판매자 정보조회
        if (login != null) {
            wished = tradeService.isWished(tradeSeq, login.getMember_seq());    // 찜하기 눌렀는지 검증
        }
        model.addAttribute("seller_info", seller_info);
        model.addAttribute("trade", trade);
        model.addAttribute("wishCount", wishCount);
        model.addAttribute("wished", wished);

        return "trade/tradedetail";
    }

    // 판매글 등록
    @GetMapping("/trade")
    public String getTrade(Model model, HttpSession session) {

        // 세션 검증
        if(session.getAttribute(Const.SESSION) == null) {
            return "redirect:/";
        }
        // 카테고리 데이터 add
        model.addAttribute("category", tradeService.selectCategory());
        return "trade/tradeform";
    }

    // 판매글 create
    @PostMapping("/trade")
    public String uploadTrade(TradeVO tradeVO, HttpSession session,
                              RedirectAttributes redirectAttributes) throws Exception {

        checkSessionAndTrade(session, tradeVO);
        // 이미지 파일 처리 (서버에 uuid 이름으로 저장, db 에 실제 이름으로 저장)
        List<MultipartFile> uploadFiles = tradeVO.getUploadFiles(); // form 에서 받은 데이터 조회
        log.info("uploadFiles: {}", uploadFiles);

        if (uploadFiles != null && !uploadFiles.isEmpty()) {
            List<UploadFile> storeImgFiles = fileStore.storeFiles(uploadFiles); // 서버 저장용, 내부에 multipartFile.transferTo로 서버 경로에 저장
            log.info("storeImgFiles: {}", storeImgFiles);

            List<String> imgUrls = new ArrayList<>(); // db 저장용

            // storeImgFiles 리스트 반복
            for (UploadFile file : storeImgFiles) {
                String storeFileName = file.getStoreFileName();
                imgUrls.add(storeFileName);
            }

            log.info("imgUrls: {}", imgUrls);
            tradeVO.setImgUrls(imgUrls);
        }

        if (tradeService.upload(tradeVO)) {
            log.info("trade save success, book isbn : {}", tradeVO.getIsbn());
            redirectAttributes.addAttribute("tradeSeq", tradeVO.getTrade_seq());
            return "redirect:/trade/{tradeSeq}";
        }
        // 실패 시
        return "error/500";
    }

    // 판매글 update 요청
    @GetMapping("/trade/modify/{tradeSeq}")
    public String modifyRequest(@PathVariable Long tradeSeq, Model model, HttpSession session) {

        TradeVO trade = tradeService.search(tradeSeq);

        // 세션 검증
        try {
            checkSessionAndTrade(session, trade);
        } catch (NoSessionException | TradeNotFoundException e) {
            return "redirect:/";
        } catch (Exception e) {
            return "redirect:/";
        }
        // 수정하려는 사람의 pk가 게시글의 작성자 pk와 동일한지 검증
        MemberVO sessionMember = (MemberVO) session.getAttribute(Const.SESSION);
        if (trade.getMember_seller_seq() != sessionMember.getMember_seq()) {
            return "redirect:/";
        }

        // 카테고리 데이터 add
        model.addAttribute("category", tradeService.selectCategory());
        model.addAttribute("trade", trade);
        return "trade/tradeupdate";
    }

    // 판매글 update 등록
    @PostMapping("/trade/modify/{tradeSeq}")
    public String modifyUpload(@PathVariable Long tradeSeq, TradeVO updateTrade,
                               RedirectAttributes redirectAttributes, HttpSession session) throws Exception {

        // 검증 - 기존 게시글 조회
        TradeVO existingTrade = tradeService.search(tradeSeq);
        if (existingTrade == null) {
            return "redirect:/";
        }

        // 검증 - PENDING 상태일 때는 수정 불가
        String safePaymentStatus = tradeService.getSafePaymentStatus(tradeSeq);
        if ("PENDING".equals(safePaymentStatus)) {
            return "redirect:/";
        }

        // 세션 검증
        MemberVO sessionMember = (MemberVO) session.getAttribute(Const.SESSION);
        if (sessionMember == null) {
            return "redirect:/";
        }

        // 수정하려는 사람의 pk가 게시글의 작성자 pk와 동일한지 검증
        if (existingTrade.getMember_seller_seq() != sessionMember.getMember_seq()) {
            return "redirect:/";
        }

        // updateTrade에 seller seq 할당
        updateTrade.setMember_seller_seq(sessionMember.getMember_seq());


        // 이미지 파일 처리 (서버에 uuid 이름으로 저장, db 에 실제 이름으로 저장)
        List<MultipartFile> uploadFiles = updateTrade.getUploadFiles(); // form 에서 받은 데이터 조회
        log.info("uploadFiles: {}", uploadFiles);

        if (uploadFiles != null && !uploadFiles.isEmpty()) {
            List<UploadFile> storeImgFiles = fileStore.storeFiles(uploadFiles); // 서버 저장용, 내부에 multipartFile.transferTo로 서버 경로에 저장
            log.info("storeImgFiles: {}", storeImgFiles);

            List<String> imgUrls = new ArrayList<>(); // db 저장용

            // storeImgFiles 리스트 반복
            for (UploadFile file : storeImgFiles) {
                String storeFileName = file.getStoreFileName();
                imgUrls.add(storeFileName);
            }

            log.info("imgUrls: {}", imgUrls);
            updateTrade.setImgUrls(imgUrls);
        }

        // 수정에 성공했을 때
        try {
            if (tradeService.modify(tradeSeq, updateTrade)) {
                log.info("update Success");
                redirectAttributes.addAttribute("tradeSeq", tradeSeq);
                return "redirect:/trade/{tradeSeq}";
            }
        } catch (Exception e) {
            return "error/500";
        }

        return "error/500";
    }

    // 판매글 delete
    @PostMapping("/trade/delete/{tradeSeq}")
    public String remove(@PathVariable Long tradeSeq,
                         RedirectAttributes redirectAttributes, HttpSession session) throws Exception {

        // 세션 검증
        TradeVO trade = tradeService.search(tradeSeq);

        // 세션 검증
        try {
            checkSessionAndTrade(session, trade);
        } catch (NoSessionException | TradeNotFoundException e) {
            return "redirect:/";
        } catch (Exception e) {
            return "redirect:/";
        }
        // 검증 : 삭제하려는 사람의 pk가 게시글의 작성자 pk와 동일한지
        MemberVO sessionMember = (MemberVO) session.getAttribute(Const.SESSION);
        if (trade.getMember_seller_seq() != sessionMember.getMember_seq()) {
            return "redirect:/";
        }

        // 검증 - PENDING 상태일 때는 삭제 불가
        String safePaymentStatus = tradeService.getSafePaymentStatus(tradeSeq);
        if ("PENDING".equals(safePaymentStatus)) {
            return "redirect:/";
        }

        if (tradeService.remove(tradeSeq)) {
            log.info("delete Success");
            return "redirect:/";
        }
        return "error/500";
    }


    // 도서 검색
    @GetMapping("/trade/book")
    @ResponseBody
    public List<BookVO> findBookByTitle(@RequestParam String query) { // query = 검색어
        // query로 책 검색
        log.info(query);
        return bookApiService.searchBooks(query);
    }

    private void checkSessionAndTrade(HttpSession session, TradeVO tradeVO) throws Exception {

        // 세션 검증
        MemberVO loginMember = (MemberVO)session.getAttribute(Const.SESSION);
        if (loginMember == null) {
            log.info("no session");
            throw new NoSessionException("no session");
        }

        // tradeVO 검증
        if (tradeVO == null || !tradeVO.checkTradeVO()){
            log.info("Invalid trade data: {}", tradeVO);
            throw new TradeNotFoundException("cannot upload trade");
        }
        // tradeVO에 seller seq 할당
        tradeVO.setMember_seller_seq(loginMember.getMember_seq());
    }

    // 찜하기 처리
    @PostMapping("/trade/like")
    @ResponseBody
    public Map<String, Object> tradeLike(@RequestParam long trade_seq, HttpSession session) {
        MemberVO memberVO = (MemberVO) session.getAttribute(Const.SESSION);
        // 비동기처리를 위해 map을 json으로 변환하여 전달
        Map<String, Object> result = new HashMap<>();

        if (memberVO == null || memberVO.getMember_seq() == 0) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        boolean wished = tradeService.saveLike(trade_seq, memberVO.getMember_seq());
        result.put("success", true);
        result.put("wished", wished);

        return result;
    }

    // 판매자 수동 sold 변경 API, 새로 추가
    @PostMapping("/trade/sold/{trade_seq}")
    @ResponseBody
    public Map<String, Object> updateToSold(
            @PathVariable long trade_seq,
            HttpSession session
    ) {
        MemberVO member = (MemberVO) session.getAttribute(Const.SESSION);

        Map<String, Object> result = new HashMap<>();

        if (member == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        boolean success = tradeService.updateToSoldManually(
                trade_seq, member.getMember_seq()
        );

        result.put("success", success);
        return result;
    }


    // 구매 확정 api
    @PostMapping("/trade/confirm/{trade_seq}")
    @ResponseBody
    public Map<String, Object> confirmPurchase(
            @PathVariable long trade_seq,
            HttpSession session
    ) {
        MemberVO member = (MemberVO) session.getAttribute(Const.SESSION);

        Map<String, Object> result = new HashMap<>();

        if (member == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        boolean success = tradeService.confirmPurchase(
                trade_seq, member.getMember_seq()
        );

        result.put("success", success);
        return result;
    }


    // 판매상태 수동처리, 범근님 추가
    @PostMapping("/trade/statusUpdate")
    @ResponseBody
    public boolean statusUpdate (@RequestParam long trade_seq) {
        return tradeService.statusUpdate(trade_seq);
    }

}
