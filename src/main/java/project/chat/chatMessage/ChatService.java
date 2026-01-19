package project.chat.chatMessage;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class ChatService {
    public MessageVO saveMessage(Long roomId, MessageVO message) {
        return new MessageVO();
    }

    // 채팅방 생성 또는 조회

    // 메시지 저장

    // 메시지 조회 (채팅 이력)

    // 읽음 처리
}
