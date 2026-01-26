package project.member;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import project.member.ENUM.MemberStatus;
import project.util.Const;

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
    private LocalDateTime upd_dtm;

    @JsonIgnore  // JSON 변환 시 제외
    private LocalDateTime crt_dtm;

    // JSON으로 반환할 포맷팅된 문자열
    @JsonProperty("crt_dtm")
    public String getCrtDtmFormatted() {
        return crt_dtm != null ? crt_dtm.format(Const.DATETIME_FORMATTER) : null;
    }
}
