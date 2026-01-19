package project.chat.message;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MessageService {

    private final MessageMapper messageMapper;

    // 메시지 저장
    @Transactional
    public void saveMessage(MessageVO message) {
        messageMapper.save(message);
        log.info("메시지 저장 완료: roomSeq={}, sender={}", message.getChat_room_seq(), message.getSender_seq());
    }

    // 채팅방 메시지 조회
    public List<MessageVO> getMessages(long chat_room_seq) {
        return messageMapper.findByRoomSeq(chat_room_seq);
    }
}
