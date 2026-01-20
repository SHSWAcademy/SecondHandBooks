package project.chat.chatroom;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface ChatroomMapper {
    public int save(ChatroomVO chatroomVO);
    public ChatroomVO findRoom(
            @Param("member_seller_seq") long member_seller_seq,
            @Param("member_buyer_seq") long member_buyer_seq,
            @Param("trade_seq") long trade_seq
    );
    public List<ChatroomVO> findAllByMemberSeq(@Param("member_seq") long member_seq);

    public boolean isMemberOfChatroom(@Param("chat_room_seq") long chat_room_seq,
                                      @Param("member_seq") long member_seq);

    // public List<MessageVO> findAllByChatRoomSeq(long chat_room_seq); -> message mapper 에서 처리
}
