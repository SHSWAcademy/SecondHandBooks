package project.chat;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import project.chat.chatroom.ChatroomService;
import project.chat.chatroom.ChatroomVO;
import project.chat.message.MessageService;
import project.chat.message.MessageVO;
import project.member.MemberVO;
import project.trade.ENUM.SaleStatus;
import project.trade.TradeService;
import project.trade.TradeVO;
import project.util.Const;

import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@Controller
public class StompController {
    private final SimpMessagingTemplate messagingTemplate;
    private final MessageService messageService;
    private final ChatroomService chatroomService;
    private final TradeService tradeService;

    /*
      1. 클라이언트 전송: /sendMessage/chat/{chat_room_seq}

      2. StompController @MessageMapping("/chat/{chat_room_seq}")

      3. DB 저장, 구독자에게 전송: /chatroom/{chat_room_seq}

      4. 클라이언트 구독: /chatroom/{chat_room_seq}
     */
    @MessageMapping("/chat/{chat_room_seq}")
    public void sendMessage(@DestinationVariable Long chat_room_seq, @Payload MessageVO message,
                            SimpMessageHeaderAccessor headerAccessor) {


        // 검증 : 로그인 및 채팅방 참여자, trade 번호
        MemberVO sessionMember = validateSessionAndMembership(chat_room_seq, headerAccessor);
        long trade_seq = message.getTrade_seq();
        if (sessionMember == null || trade_seq <= 0) {
            return; // 검증 실패 시 바로 종료
        }
        // 세션 seq기준 닉네임 조회
        message.setMember_seller_nicknm(messageService.findBySellerNicknm(sessionMember.getMember_seq()));
        // sender_seq를 세션에서 가져온 값으로 설정
        message.setSender_seq(sessionMember.getMember_seq());
        message.setChat_room_seq(chat_room_seq);

        String chatMessage = message.getChat_cont();

        // 안전 결제 요청일 경우, 이용 불가 시 return
        if (!canUseSafePayment(chat_room_seq, trade_seq, chatMessage, sessionMember)) return;

        log.info("메시지 수신: chat_room_seq={}, sender={}, content={}", chat_room_seq, message.getSender_seq(), message.getChat_cont());

        // 1. DB에 메시지 저장
        messageService.saveMessage(message);

        // 2. last message 업데이트
        chatroomService.updateLastMessage(chat_room_seq, chatMessage);

        // 3. 해당 채팅방 구독자에게 메시지 전송
        messagingTemplate.convertAndSend("/chatroom/" + chat_room_seq, message);
    }

    private boolean canUseSafePayment(Long chat_room_seq, long trade_seq, String chatMessage, MemberVO sessionMember) {
        if ("[SAFE_PAYMENT_REQUEST]".equals(chatMessage)) {

            // // '판매자' 만 안전 결제 요청 가능, 다른 유저가 시도 시 return false
            TradeVO trade = tradeService.search(trade_seq);
            if (trade == null || trade.getMember_seller_seq() != sessionMember.getMember_seq()) {
                log.warn("안전결제 요청 권한 없음: member_seq={}, trade_seq={}", sessionMember.getMember_seq(), trade_seq);

                // 에러 메시지 전송
                MessageVO errorMsg = new MessageVO();
                errorMsg.setChat_room_seq(chat_room_seq);
                errorMsg.setSender_seq(sessionMember.getMember_seq());
                errorMsg.setChat_cont("[SAFE_PAYMENT_UNAUTHORIZED]");
                errorMsg.setTrade_seq(trade_seq);

                messagingTemplate.convertAndSend("/chatroom/" + chat_room_seq, errorMsg);
                return false;
            }

            // 안전 결제 요청 시 해당 상품 판매상태 확인
            if (trade.getSale_st() == SaleStatus.SOLD) {
                log.warn("이미 판매 완료된 상품 안전결제 요청: trade_seq={}", trade_seq);
                MessageVO errorMsg = new MessageVO();
                errorMsg.setChat_room_seq(chat_room_seq);
                errorMsg.setSender_seq(sessionMember.getMember_seq());
                errorMsg.setChat_cont("[SAFE_PAYMENT_ALREADY_SOLD]");
                errorMsg.setTrade_seq(trade_seq);
                messagingTemplate.convertAndSend("/chatroom/" + chat_room_seq, errorMsg);
                return false;
            }

            // 안전 결제 요청 : 현재 채팅방의 구매자를 대상으로 지정
            ChatroomVO chatroom = chatroomService.findByChatRoomSeq(chat_room_seq);
            boolean canRequest = tradeService.requestSafePayment(trade_seq, chatroom.getMember_buyer_seq());
            if (!canRequest) { // 안전 결제 불가능할 경우 (다른 트랜잭션이 안전 결제를 진행하는 중일 경우)
                // 이미 진행 중이면 에러 메시지 전송 (에러 메시지는 DB에 저장하지 않음)
                MessageVO errorMsg = new MessageVO();
                errorMsg.setChat_room_seq(chat_room_seq);
                errorMsg.setSender_seq(sessionMember.getMember_seq());
                errorMsg.setChat_cont("[SAFE_PAYMENT_IN_PROGRESS]");
                errorMsg.setTrade_seq(trade_seq);

                // 요청한 사람에게 에러 메시지 전송
                messagingTemplate.convertAndSend("/chatroom/" + chat_room_seq, errorMsg);

                log.info("안전결제 요청 거부: trade_seq={}, 이미 진행 중", trade_seq);
                return false; // 안전 결제 이용 불가
            }
            log.info("안전결제 요청 승인: trade_seq={}", trade_seq);
        }
        return true; // 안전 결제 이용 가능
    }

    // 로그인 및 채팅방 참여자 검증
    private MemberVO validateSessionAndMembership(Long chatRoomSeq, SimpMessageHeaderAccessor headerAccessor) {
        Map<String, Object> sessionAttrs = headerAccessor.getSessionAttributes();
        MemberVO sessionMember = (MemberVO) sessionAttrs.get(Const.SESSION);

        if (sessionMember == null) {
            log.warn("비로그인 사용자 메시지 전송 시도");
            return null;
        }

        if (!chatroomService.isMemberOfChatroom(chatRoomSeq, sessionMember.getMember_seq())) {
            log.warn("권한 없는 채팅방 접근 시도: member_seq={}, chat_room_seq={}",
                    sessionMember.getMember_seq(), chatRoomSeq);
            return null;
        }

        return sessionMember;
    }
}