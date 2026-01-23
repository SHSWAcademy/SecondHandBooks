package project.chat.chatroom;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

@Data
@NoArgsConstructor
public class ChatroomVO {
    private long chat_room_seq;
    private long trade_seq;
    private LocalDateTime last_msg_dtm;
    private LocalDateTime crt_dtm;
    private String last_msg;
    private String sale_title;
    private long member_buyer_seq;
    private long member_seller_seq;

    public ChatroomVO(long trade_seq, long member_buyer_seq, long member_seller_seq, String sale_title) {
        this.trade_seq = trade_seq;
        this.member_buyer_seq = member_buyer_seq;
        this.member_seller_seq = member_seller_seq;
        this.sale_title = sale_title;
    }

    public Date getLastMsgDtmAsDate() {
        return last_msg_dtm == null ? null : Date.from(last_msg_dtm.atZone(ZoneId.systemDefault()).toInstant());
    }
}
