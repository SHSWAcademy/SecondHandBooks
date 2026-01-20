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
import project.chat.message.MessageService;
import project.chat.message.MessageVO;
import project.member.MemberVO;
import project.util.Const;

import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@Controller
public class StompController {
    private final SimpMessagingTemplate messagingTemplate;
    private final MessageService messageService;
    private final ChatroomService chatroomService;

    @MessageMapping("/chat/{chat_room_seq}")
    public void sendMessage(@DestinationVariable Long chat_room_seq, @Payload MessageVO message
                            , SimpMessageHeaderAccessor headerAccessor) {
        // @Payload : JSON 메시지의 본문(body)을 객체로 변환해서 받는다
        // 프론트에서 chat_room_seq, chat_cont, sender_seq, trade_seq 를 파싱해서 받아 message 객체에 넣는다

        // 세션에서 로그인 회원 정보 가져오기
        Map<String, Object> sessionAttrs = headerAccessor.getSessionAttributes();
        MemberVO sessionMember = (MemberVO) sessionAttrs.get(Const.SESSION);

        if (sessionMember == null) {
            log.warn("비로그인 사용자 메시지 전송 시도");
            return;
        }

        // 해당 채팅방의 참여자인지 검증
        if (!chatroomService.isMemberOfChatroom(chat_room_seq, sessionMember.getMember_seq())) {
            log.warn("권한 없는 채팅방 접근 시도: member_seq={}, chat_room_seq={}", sessionMember.getMember_seq(), chat_room_seq);
            return;
        }

        // sender_seq를 세션에서 가져온 값으로 설정 (프론트 값 신뢰하지 않는다)
        message.setSender_seq(sessionMember.getMember_seq());


        log.info("메시지 수신: chat_room_seq={}, sender={}, content={}", chat_room_seq, message.getSender_seq(), message.getChat_cont());

        message.setChat_room_seq(chat_room_seq); // 채팅방 id 설정
        messageService.saveMessage(message); // DB에 메시지 저장

        // 해당 채팅방 구독자들에게 실시간 전송, 클라이언트는 /chatroom/{roomId} 를 구독
        messagingTemplate.convertAndSend("/chatroom/" + chat_room_seq, message);
    }
    /*

      1. 클라이언트 전송: /sendMessage/chat/{chat_room_seq}

      2. StompController @MessageMapping("/chat/{chat_room_seq}")

      3. DB 저장, 구독자에게 전송: /chatroom/{chat_room_seq}

      4. 클라이언트 구독: /chatroom/{chat_room_seq}
     */
}