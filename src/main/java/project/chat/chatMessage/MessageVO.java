package project.chat.chatMessage;

import lombok.Data;
import project.member.MemberVO;

import java.time.LocalDateTime;

@Data
public class MessageVO {
    // 보낸 사람, 받는 사람은 trade 에서 가져오는지 ?
    private MemberVO sender;
    private MemberVO recipient;

    private String chat_cont;     // 내용
    private LocalDateTime send_dtm;
    private boolean read_yn; // 읽음 여부
}
