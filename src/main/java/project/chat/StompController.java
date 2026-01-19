package project.chat;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import project.chat.chatMessage.ChatService;
import project.chat.chatMessage.MessageVO;

@Slf4j
@RequiredArgsConstructor
@Controller
public class StompController {
    private final SimpMessagingTemplate messagingTemplate;
    private final ChatService chatService;

    @MessageMapping("/chat/{chat_room_seq}")
    public void sendMessage(@DestinationVariable Long chat_room_seq,
                            @Payload MessageVO message) {

        System.out.println("메시지 내용" + message.getChat_cont());
        // 2. 해당 방 구독자들에게 실시간 전송
        messagingTemplate.convertAndSend(
                "/chatroom/" + chat_room_seq,
                message.getChat_cont()
        );
    }
}
