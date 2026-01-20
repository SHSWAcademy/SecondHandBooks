package project.chat.message;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MessageMapper {
    List<MessageVO> findByRoomSeq(@Param("chat_room_seq") long chat_room_seq);
    int save(MessageVO message);
}
