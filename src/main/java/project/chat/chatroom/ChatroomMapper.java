package project.chat.chatroom;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import project.chat.message.MessageVO;

import java.util.List;

@Mapper
public interface ChatroomMapper {
    public int createRoom(@Param("member_seller_seq") long member_seller_seq,
                          @Param("member_buyer_seq") long member_buyer_seq,
                          @Param("trade_seq") long trade_seq);
    public ChatroomVO findRoom(
            @Param("member_seller_seq") long member_seller_seq,
            @Param("member_buyer_seq") long member_buyer_seq,
            @Param("trade_seq") long trade_seq
    );
    public List<ChatroomVO> findAllByMemberSeq(long member_seq);
    public List<MessageVO> findAllByChatRoomSeq(long chat_room_seq);
}
