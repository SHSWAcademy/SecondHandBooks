package project.admin;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class LoginInfoVO {
    private Long login_info_seq;
    private Long admin_seq;
    private Long member_seq;
    private LocalDateTime login_dtm;
    private LocalDateTime logout_dtm;
    private String login_ip;
    private String logout_ip;

    private String admin_login_id;

    private String member_nicknm;
    private String member_email;
}
