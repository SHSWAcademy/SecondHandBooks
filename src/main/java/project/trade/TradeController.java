package project.trade;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
@Slf4j
@RequiredArgsConstructor
public class TradeController {
    private final TradeService tradeService;

    @GetMapping("/main/trade/{tradeSeq}")
    public String getSaleDetail(@PathVariable long tradeSeq, Model model) {
        TradeVO trade = tradeService.findBySeq(tradeSeq);
        log.info("findTrade: {}", trade);

        model.addAttribute("trade", trade);
        return "trade/tradeDetail";
    }
}
