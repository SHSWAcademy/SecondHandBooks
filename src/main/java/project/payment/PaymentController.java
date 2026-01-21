package project.payment;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import project.address.AddressVO;
import project.member.MemberVO;
import project.trade.TradeService;
import project.trade.TradeVO;
import project.util.Const;
import project.util.Util;

import javax.servlet.http.HttpSession;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Controller
public class PaymentController {

    private final PaymentService paymentService;
    private final TradeService tradeService;

    @GetMapping("/payments")
    public String showPayment(HttpSession session, Long trade_seq, Model model) {

        if (!Util.checkSession(session)) {
            return "redirect:/";
        }

        TradeVO search = tradeService.search(trade_seq);
        model.addAttribute("trade", search);



        MemberVO sessionMember = (MemberVO) session.getAttribute(Const.SESSION);
        List<AddressVO> address = paymentService.findAddress(sessionMember.getMember_seq());
        model.addAttribute("addressList", address);


        return "payment/payform";
    }



}
