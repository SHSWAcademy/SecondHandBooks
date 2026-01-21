package project.payment;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
    private final TossApiService tossApiService;

    @GetMapping("/payments")
    public String showPayment(HttpSession session, Long trade_seq, Model model) {

        if (!Util.checkSession(session)) {
            return "redirect:/";
        }

        TradeVO search = tradeService.search(trade_seq);
        model.addAttribute("trade", search);

        // 검증된 회원인지 확인 필요

        MemberVO sessionMember = (MemberVO) session.getAttribute(Const.SESSION);
        List<AddressVO> address = paymentService.findAddress(sessionMember.getMember_seq());
        model.addAttribute("addressList", address);

        return "payment/payform";
    }


    @GetMapping("/payments/success")
    public String success(@RequestParam Long trade_seq,
                          @RequestParam String paymentKey,
                          @RequestParam String orderId,
                          @RequestParam int amount,
                          HttpSession session,
                          Model model) {


        // 토스 결제 승인 API 호출
        TossPaymentResponse tossResponse = tossApiService.confirmPayment(paymentKey, orderId, amount);

        // 승인 실패 시
        if (tossResponse == null || !"DONE".equals(tossResponse.getStatus())) {
            model.addAttribute("errorMessage", tossResponse != null ? tossResponse.getMessage() : "결제 승인 실패");
            return "payment/fail";
        }


        // 모델에 전달
        MemberVO buyer = (MemberVO) session.getAttribute(Const.SESSION);

        PaymentVO payment = new PaymentVO();
        payment.setTrade_seq(trade_seq);
        payment.setMember_buyer_seq(buyer.getMember_seq());
        payment.setPayment_key(paymentKey);
        //payment.setOrder_id(orderId);
        payment.setAmount(amount);
        payment.setStatus(tossResponse.getStatus());
        payment.setMethod(tossResponse.getMethod());

        model.addAttribute("payment", payment);

        // 판매 완료 처리
        tradeService.updateStatus(trade_seq, "SOLD", buyer.getMember_seq());

        model.addAttribute("payment", payment);
        return "payment/success";
    }

    @GetMapping("/payments/fail")
    public String fail(@RequestParam(required = false) String code,
                       @RequestParam(required = false) String message,
                       @RequestParam(required = false) Long trade_seq,
                       Model model) {

        model.addAttribute("errorCode", code);
        model.addAttribute("errorMessage", message);
        model.addAttribute("trade_seq", trade_seq);

        return "payment/fail";
    }



}
