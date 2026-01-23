package project.payment;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import project.address.AddressVO;
import project.chat.chatroom.ChatroomService;
import project.chat.message.MessageService;
import project.chat.message.MessageVO;
import project.member.MemberVO;
import project.trade.TradeService;
import project.trade.TradeVO;
import project.util.Const;
import project.util.Util;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@Controller
public class PaymentController {

    private final PaymentService paymentService;
    private final TradeService tradeService;
    private final TossApiService tossApiService;
    private final MessageService messageService;
    private final SimpMessagingTemplate messagingTemplate;
    private final ChatroomService chatroomService;

    @GetMapping("/payments")
    public String showPayment(HttpSession session, Long trade_seq, Model model) {

        if (!Util.checkSession(session)) {
            return "redirect:/";
        }


        TradeVO search = tradeService.search(trade_seq);
        model.addAttribute("trade", search);

        MemberVO sessionMember = (MemberVO) session.getAttribute(Const.SESSION);

        // 검증된 회원인지 확인 필요 : if (sessionMember.getMemberSeq != chatroom의 seller.getSellerSeq) return "redirect:/"

        List<AddressVO> address = paymentService.findAddress(sessionMember.getMember_seq());
        model.addAttribute("addressList", address);

        // 남은 결제 시간 (초) DB 에서 조회 후 전달
        long remainingSeconds = tradeService.getSafePaymentExpireSeconds(trade_seq);
        model.addAttribute("remainingSeconds", remainingSeconds);

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
            // 안전결제 상태를 NONE 으로 변경 (재시도 가능)
            tradeService.cancelSafePayment(trade_seq);
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


        // 1. 판매 완료 처리
        tradeService.updateStatus(trade_seq, "SOLD", buyer.getMember_seq());

        // 2. 안전결제 상태를 COMPLETED로 변경
        tradeService.completeSafePayment(trade_seq);

        // 채팅방 조회 후 결제 완료 메시지 전송
        Long chatRoomSeq = chatroomService.findChatRoomSeqByTradeSeq(trade_seq);
        if (chatRoomSeq != null) {
            MessageVO completeMsg = new MessageVO();
            completeMsg.setChat_room_seq(chatRoomSeq);
            completeMsg.setSender_seq(buyer.getMember_seq());
            completeMsg.setChat_cont("[SAFE_PAYMENT_COMPLETE]");

            messageService.saveMessage(completeMsg);
            messagingTemplate.convertAndSend("/chatroom/" + chatRoomSeq,
                    completeMsg);
        }

        model.addAttribute("payment", payment);
        return "payment/success";
    }

    @GetMapping("/payments/fail")
    public String fail(@RequestParam(required = false) String code,
                       @RequestParam(required = false) String message,
                       @RequestParam(required = false) Long trade_seq,
                       Model model) {

        // 안전결제 상태를 NONE 으로 변경 (재시도 가능)
        if (trade_seq != null) {
            tradeService.cancelSafePayment(trade_seq);
            log.info("결제 실패로 안전결제 상태 초기화: trade_seq={}", trade_seq);

            // 채팅방에 결제 실패 메시지 전송
            sendPaymentFailedMessage(trade_seq);
        }

        model.addAttribute("errorCode", code);
        model.addAttribute("errorMessage", message);
        model.addAttribute("trade_seq", trade_seq);

        return "payment/fail";
    }

    // 결제 타임아웃 처리 (프론트에서 5분 경과 시 또는 페이지 이탈 시 호출)
    @PostMapping("/payments/timeout")
    @ResponseBody
    public Map<String, Object> timeout(@RequestParam Long trade_seq, HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        if (!Util.checkSession(session)) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        // 안전결제 상태를 NONE으로 변경 (재시도 가능)
        tradeService.cancelSafePayment(trade_seq);
        log.info("결제 타임아웃으로 안전결제 상태 초기화: trade_seq={}", trade_seq);

        // 채팅방에 결제 실패 메시지 전송
        sendPaymentFailedMessage(trade_seq);

        result.put("success", true);
        result.put("message", "결제 시간이 만료되었습니다.");
        return result;
    }


    // 남은 결제 시간 조회 API (채팅방에서 실시간 동기화용)
    @GetMapping("/payments/remaining-time")
    @ResponseBody
    public Map<String, Object> getRemainingTime(@RequestParam Long trade_seq) {
        Map<String, Object> result = new HashMap<>(); // JSON 변환 용도
        //{
        //  "remainingSeconds": 120,
        //  "status": "NONE"
        //}

        long remainingSeconds = tradeService.getSafePaymentExpireSeconds(trade_seq);
        String status = tradeService.getSafePaymentStatus(trade_seq);

        result.put("remainingSeconds", remainingSeconds);
        result.put("status", status);
        return result;
    }

    // 결제 실패 시 채팅방에 메시지 전달
    private void sendPaymentFailedMessage(Long trade_seq) {
        Long chatRoomSeq = chatroomService.findChatRoomSeqByTradeSeq(trade_seq);
        if (chatRoomSeq != null) {
            MessageVO failMsg = new MessageVO();
            failMsg.setChat_room_seq(chatRoomSeq);
            failMsg.setSender_seq(0L); // 시스템 메시지
            failMsg.setChat_cont("[SAFE_PAYMENT_FAILED]");

            messageService.saveMessage(failMsg);
            messagingTemplate.convertAndSend("/chatroom/" + chatRoomSeq, failMsg);

            log.info("결제 실패 메시지 전송: chat_room_seq={}", chatRoomSeq);
        }
    }

}
