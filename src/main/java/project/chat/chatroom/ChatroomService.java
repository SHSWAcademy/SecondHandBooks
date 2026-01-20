package project.chat.chatroom;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import project.chat.message.MessageVO;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ChatroomService {

    private final ChatroomMapper chatroomMapper;

    public List<ChatroomVO> searchAll(long member_seq) {
        return chatroomMapper.findAllByMemberSeq(member_seq);
        //select * from chatroom where member_seq = #{member_seq}
    }

    @Transactional
    public ChatroomVO findOrCreateRoom(long member_seller_seq, long member_buyer_seq, long trade_seq, String sale_title) {
        ChatroomVO findChatroom = chatroomMapper.findRoom(member_seller_seq, member_buyer_seq, trade_seq);
        // 이미 채팅 전적이 있다면
        if (findChatroom != null) {
            return findChatroom;
        }

        // 신규 채팅일 때
        try {
            ChatroomVO chatroom = new ChatroomVO(trade_seq, member_buyer_seq, member_seller_seq, sale_title);
            int result = chatroomMapper.save(chatroom);

            if (result > 0) {
                log.info("new chatroom save success");
            } else {
                throw new RuntimeException("fail to save new chatroom");
            }

            return chatroom;
        } catch (DuplicateKeyException e) {
            // 동시에 생성된 경우 : 다시 조회
            return chatroomMapper.findRoom(member_seller_seq, member_buyer_seq, trade_seq);
        }
    }

    /*
    채팅방 메시지 전체 조회는 messageService 에서 처리
    public List<MessageVO> getAllMessages(long chat_room_seq) {
        return chatroomMapper.findAllByChatRoomSeq(chat_room_seq);
        // select * from messageVO where chatRoomSeq = chat_room_seq
    }
     */

}
