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
import project.trade.ENUM.SaleStatus;
import project.trade.TradeService;
import project.trade.TradeVO;
import project.util.Const;

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

        MemberVO sessionMember = (MemberVO) session.getAttribute(Const.SESSION);
        TradeVO trade = tradeService.search(trade_seq);

        // 검증 : trade.getMember_buyer_seq()는 현재 시점에서는 null
        if (sessionMember == null || trade.getMember_seller_seq() == sessionMember.getMember_seq()) {return "redirect:/";} // 검증 : 구매자 seq !=  세션 seq일 경우 홈으로 리다이렉트

        // 검증 : 이미 판매 완료된 상품인지 체크
        if (trade.getSale_st() == SaleStatus.SOLD) {
            log.error("이미 판매 완료된 상품: trade_seq={}", trade_seq);
            model.addAttribute("errorMessage", "이미 판매 완료된 상품입니다.");
            return "payment/fail";
        }

        // 검증 : 안전결제 상태 확인 (직접 url 접근 시 체크)
        String safePaymentStatus = tradeService.getSafePaymentStatus(trade_seq);
        if (!"PENDING".equals(safePaymentStatus)) {
            return "redirect:/";  // 안전결제 요청이 없으면 접근 불가
        }

        // 검증 : 안전결제 대상 구매자인지 확인
        Long pendingBuyerSeq = tradeService.getPendingBuyerSeq(trade_seq);
        if (pendingBuyerSeq == null || pendingBuyerSeq != sessionMember.getMember_seq()) {
            return "redirect:/";  // 안전결제 대상 구매자가 아니면 접근 불가
        }

        // 정상 로직
        long remainingSeconds = tradeService.getSafePaymentExpireSeconds(trade_seq); // 남은 결제 시간 (초) DB 에서 조회 후 전달
        List<AddressVO> address = paymentService.findAddress(sessionMember.getMember_seq()); // 구매자 주소 DB 에서 조회 후 전달

        model.addAttribute("remainingSeconds", remainingSeconds);
        model.addAttribute("addressList", address);
        model.addAttribute("trade", trade);

        return "payment/payform";
    }


    // 안전 결제 성공 시
    @GetMapping("/payments/success")
    public String success(@RequestParam Long trade_seq,
                          @RequestParam String paymentKey,
                          @RequestParam String orderId,
                          @RequestParam int amount,
                          HttpSession session,
                          Model model) {

        // 검증 - 결제 금액 : DB의 실제 가격과 비교 먼저 하기
        TradeVO trade = tradeService.search(trade_seq);
        if (trade == null || trade.getSale_price() + trade.getDelivery_cost() != amount) {
            log.error("결제 금액 불일치: trade_seq={}, 요청금액={}, 실제가격={}", trade_seq, amount, trade != null ? trade.getSale_price() : "null");
            tradeService.cancelSafePayment(trade_seq); // DB 실제 가격과 다를 경우 결제 취소 쳐리
            model.addAttribute("errorMessage", "결제 금액이 일치하지 않습니다.");
            return "payment/fail";
        }

        // 검증 - 판매 상태
        if (trade.getSale_st() == SaleStatus.SOLD) {
            tradeService.cancelSafePayment(trade_seq);
            model.addAttribute("errorMessage", "이미 판매 완료된 상품입니다.");
            return "payment/fail";
        }

        // 검증 모두 통과 시 토스 결제 승인 API 호출
        TossPaymentResponse tossResponse = tossApiService.confirmPayment(paymentKey, orderId, amount);

        // 승인 실패 시
        if (tossResponse == null || !"DONE".equals(tossResponse.getStatus())) {
            // 안전결제 상태를 NONE 으로 변경 (재시도 가능하게 되는데, 재시도 가능한게 비즈니스 로직 상에서 맞는지)
            tradeService.cancelSafePayment(trade_seq);
            model.addAttribute("errorMessage", tossResponse != null ? tossResponse.getMessage() : "결제 승인 실패");
            return "payment/fail";
        }


        // 승인 성공 시 :
        // 0. 모델로 프론트에 전달할 결제 VO
        MemberVO buyer = (MemberVO) session.getAttribute(Const.SESSION);
        if (buyer == null) {
            model.addAttribute("errorMessage", "세션 누락");
            return "payment/fail";
        }

        PaymentVO payment = new PaymentVO();
        payment.setTrade_seq(trade_seq);
        payment.setMember_buyer_seq(buyer.getMember_seq());
        payment.setPayment_key(paymentKey);
        payment.setAmount(amount);
        payment.setStatus(tossResponse.getStatus());
        payment.setMethod(tossResponse.getMethod());

        model.addAttribute("payment", payment);

        // 프론트에 payment 전송 후

        // 1. trade의 sale_st를 SOLD로 변경 : 판매 완료 처리
        tradeService.updateStatusToSold(trade_seq, "SOLD", buyer.getMember_seq());

        // 2. trade의 safe_payment_st를 COMPLETED로 변경 : 안전결제 완료 처리
        tradeService.completeSafePayment(trade_seq);

        // 3. 채팅방 조회 후 결제 완료 메시지 전송
        Long chat_room_seq = chatroomService.findChatRoomSeqByTradeAndBuyer(trade_seq, buyer.getMember_seq()); // 3-1. 채팅방 조회
        if (chat_room_seq != null) {
            // 3-2. 결제 완료 메시지 준비
            try {
                MessageVO completeMsg = new MessageVO();
                completeMsg.setChat_room_seq(chat_room_seq);
                completeMsg.setSender_seq(buyer.getMember_seq());
                completeMsg.setChat_cont("[SAFE_PAYMENT_COMPLETE]");

                messageService.saveMessage(completeMsg); // 메시지 DB에 저장
                messagingTemplate.convertAndSend("/chatroom/" + chat_room_seq, completeMsg); // 결제 완료 메시지 전송
            } catch (Exception e) {
                log.error("결제 완료 메시지 전송 실패: trade_seq={}, chatRoomSeq={}", trade_seq, chat_room_seq, e);
                // 결제는 이미 완료된 상태이므로 메시지 실패는 무시하고 진행
            }
        } else {
            log.warn("채팅방을 찾을 수 없음: trade_seq={}", trade_seq);
        }

        return "payment/success";
    }

    @GetMapping("/payments/fail")
    public String fail(@RequestParam(required = false) String code,
                       @RequestParam(required = false) String message,
                       @RequestParam(required = false) Long trade_seq,
                       Model model, HttpSession session) {

        MemberVO sessionMember = (MemberVO) session.getAttribute(Const.SESSION);
        if (trade_seq != null && sessionMember != null) {
            TradeVO trade = tradeService.search(trade_seq);
            // 채팅방 참여자(구매자)인지 확인 (결제 실패 시점에서 member_buyer_seq는 아직 설정되지 않았으므로 채팅방으로 검증)
            if (trade != null && chatroomService.isBuyerOfTrade(trade_seq, sessionMember.getMember_seq())) {
                tradeService.cancelSafePayment(trade_seq); // 1.안전결제 상태를 NONE 으로 변경 (재시도 가능)
                sendPaymentFailedMessage(trade_seq, sessionMember.getMember_seq()); // 2.채팅방에 결제 실패 메시지 전송
                log.info("결제 실패로 안전결제 상태 초기화: trade_seq={}", trade_seq);
            } else {
                return "redirect:/"; // 구매자가 아닌 경우 홈으로 리다이렉트 (url로 거래 접근 방지)
            }
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

        // 검증 : 세션 검증
        MemberVO sessionMember = (MemberVO) session.getAttribute(Const.SESSION);
        if (sessionMember == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        // 검증 : 구매자 seq != 세션 seq일 경우
        TradeVO trade = tradeService.search(trade_seq);
        if (trade == null || !chatroomService.isBuyerOfTrade(trade_seq, sessionMember.getMember_seq())) {
            result.put("success", false);
            result.put("message", "권한이 없습니다.");
            return result;
        }

        // 1. 안전결제 상태를 NONE으로 변경 (재시도 가능)
        tradeService.cancelSafePayment(trade_seq);
        log.info("결제 타임아웃으로 안전결제 상태 초기화: trade_seq={}", trade_seq);

        // 2. 채팅방에 결제 실패 메시지 전송
        sendPaymentFailedMessage(trade_seq, sessionMember.getMember_seq());

        result.put("success", true);
        result.put("message", "결제 시간이 만료되었습니다.");
        return result;
    }


    // 남은 결제 시간 조회 api (채팅방에서 실시간 동기화용)
    @GetMapping("/payments/remaining-time")
    @ResponseBody
    public Map<String, Object> getRemainingTime(@RequestParam Long trade_seq, HttpSession session) {
        Map<String, Object> result = new HashMap<>(); // JSON 변환 용도
        //{
        //  "remainingSeconds": 120,
        //  "status": "NONE"
        //}

        // 세션 검증 추가
        MemberVO sessionMember = (MemberVO) session.getAttribute(Const.SESSION);
        if (sessionMember == null) {
            result.put("error", true);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        long remainingSeconds = tradeService.getSafePaymentExpireSeconds(trade_seq);
        String status = tradeService.getSafePaymentStatus(trade_seq);

        result.put("remainingSeconds", remainingSeconds);
        result.put("status", status);
        return result;
    }

    // 결제 실패 시 채팅방에 메시지 전달
    private void sendPaymentFailedMessage(Long trade_seq, Long member_seq) {
        try {
            Long chat_room_seq = chatroomService.findChatRoomSeqByTradeAndBuyer(trade_seq, member_seq);
            if (chat_room_seq != null) {
                MessageVO failMsg = new MessageVO();
                failMsg.setChat_room_seq(chat_room_seq);
                failMsg.setSender_seq(0L); // 시스템 메시지
                failMsg.setChat_cont("[SAFE_PAYMENT_FAILED]");

                messageService.saveMessage(failMsg);
                messagingTemplate.convertAndSend("/chatroom/" + chat_room_seq, failMsg);

                log.info("결제 실패 메시지 전송: chat_room_seq={}", chat_room_seq);
            }
        } catch (Exception e) {
            log.error("결제 실패 메시지 전송 실패 : trade_seq = {}", trade_seq, e);
            // 상세 예외 처리 마지막에 하기 + 리팩토링
        }
    }

}
