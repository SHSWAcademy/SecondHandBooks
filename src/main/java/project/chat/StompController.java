package project.chat;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import project.chat.message.MessageService;
import project.chat.message.MessageVO;

@Slf4j
@RequiredArgsConstructor
@Controller
public class StompController {
    private final SimpMessagingTemplate messagingTemplate;
    private final MessageService messageService;

    @MessageMapping("/chat/{chat_room_seq}")
    public void sendMessage(@DestinationVariable Long chat_room_seq, @Payload MessageVO message) {
        // @Payload : 메시지의 본문(body)을 객체로 변환해서 받는다

        log.info("메시지 수신: chat_room_seq={}, sender={}, content={}", chat_room_seq, message.getSender_seq(), message.getChat_cont());

        // 채팅방 id 설정
        message.setChat_room_seq(chat_room_seq);

        // DB에 메시지 저장
        messageService.saveMessage(message);

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