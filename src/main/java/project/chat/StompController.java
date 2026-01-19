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

    @MessageMapping("/chat/{roomId}")
    public void sendMessage(@DestinationVariable Long roomId,
                            @Payload MessageVO message) {

        // 1. DB에 메시지 저장
        MessageVO savedMessage = chatService.saveMessage(roomId, message);

        // 2. 해당 방 구독자들에게 실시간 전송
        messagingTemplate.convertAndSend(
                "/topic/room/" + roomId,
                savedMessage
        );
    }
}
