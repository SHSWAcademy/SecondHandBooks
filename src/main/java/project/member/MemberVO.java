package project.member;

import lombok.Data;
import java.time.LocalDateTime;


@Data
public class MemberVO {
    private long member_seq;
    private String login_id;
    private String member_pwd;
    private String member_email;
    private String member_tel_no;
    private String member_nicknm;
    private LocalDateTime member_deleted_dtm;
    private LocalDateTime member_last_login_dtm;
    private MemberStatus member_st;
    private LocalDateTime crt_dtm;
    private LocalDateTime upd_dtm;
}
