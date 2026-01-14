package project.trade;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
@Slf4j
@RequiredArgsConstructor
public class TradeController {
    private final TradeService tradeService;

    // 판매글 상세조회
    @GetMapping("/main/trade/{tradeSeq}")
    public String getSaleDetail(@PathVariable long tradeSeq, Model model) {
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
    public String uploadTrade(TradeVO tradeVO) throws Exception {
        if (tradeVO == null || tradeVO.checkTradeVO()){
            throw new Exception("cannot upload trade");
        }
        tradeService.process(tradeVO);

        return "redirect:/main";
    }
}
