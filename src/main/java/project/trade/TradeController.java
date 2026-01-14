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

    @GetMapping("/main/trade/{trade_seq}")
    public String getSaleDetail(@PathVariable long trade_seq, Model model) {

        TradeVO findTrade = tradeService.findBySeq(trade_seq);
        log.info("findTrade.getTrade_seq() : {}", findTrade.getTrade_seq());

        model.addAttribute("book", findTrade); // jsp에서 book으로 받고 있어서 book으로 임의 변경
        return "/trade/tradeDetail";
    }
}
