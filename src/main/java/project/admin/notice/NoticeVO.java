package project.admin.notice;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import project.util.Const;

import java.time.LocalDateTime;


@Data
public class NoticeVO {
    private Long notice_seq;
    private Long admin_seq;
    private String notice_title;
    private int notice_priority;
    private boolean active;
    private String notice_cont;
    private LocalDateTime upd_dtm;

    private String admin_login_id;
    private Long view_count;

    @JsonIgnore  // JSON 변환 시 제외
    private LocalDateTime crt_dtm;

    // JSON으로 반환할 포맷팅된 문자열
    @JsonProperty("crt_dtm")
    public String getCrtDtmFormatted() {
        return crt_dtm != null ? crt_dtm.format(Const.DATETIME_FORMATTER) : null;
    }
}
