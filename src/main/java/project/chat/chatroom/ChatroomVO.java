package project.chat.chatroom;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ChatroomVO {
    private long chat_room_seq;
    private long trade_seq;
    private LocalDateTime last_msg_dtm;
    private String last_msg;
    private LocalDateTime crt_dtm;
    private long member_buyer_seq;
    private long member_seller_seq;
}
