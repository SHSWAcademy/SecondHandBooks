package project.chat.message;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class MessageVO {
    private long chat_msg_seq;
    private long chat_room_seq;
    private long trade_seq;

    private long sender_seq;
    private String chat_cont;
    private LocalDateTime sent_dtm;
    private boolean read_yn; // 읽음 여부

}
