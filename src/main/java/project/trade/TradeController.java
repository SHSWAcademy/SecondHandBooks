package project.trade;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import project.member.MemberVO;
import project.util.Const;
import project.util.book.BookApiService;
import project.util.book.BookVO;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@Slf4j
@RequiredArgsConstructor
public class TradeController {
    private final TradeService tradeService;
    private final BookApiService bookApiService;

    // 판매글 상세조회
    @GetMapping("/main/trade/{tradeSeq}")
    public String getSaleDetail(@PathVariable long tradeSeq, Model model) {
        log.info("hello");
        TradeVO trade = tradeService.findBySeq(tradeSeq);
        log.info("findTrade: {}", trade);

        model.addAttribute("trade", trade);
        return "trade/tradeDetail";
    }

    // 판매글 등록
    @GetMapping("/trade")
    public String getTrade() {
        return "trade/tradeForm";
    }

    // 판매글 업로드
    @PostMapping("/trade")
    public String uploadTrade(TradeVO tradeVO, HttpSession session) throws Exception {

        MemberVO loginMember = (MemberVO)session.getAttribute(Const.SESSION);

        if (loginMember == null) {
            log.info("no session");
            throw new Exception("no session");
        }

        //tradeVO.setMember_seller_seq(loginMember.getMemberSeq());

        if (tradeVO == null || !tradeVO.checkTradeVO()){
            log.error("Invalid trade data: {}", tradeVO);
            throw new Exception("cannot upload trade");
        }

        if (tradeService.save(tradeVO)) {
            log.info("trade save success, book isbn : {}", tradeVO.getIsbn());
            return "redirect:/main";
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
}
