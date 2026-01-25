package project.admin.notice;

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
    private LocalDateTime crt_dtm;
    private LocalDateTime upd_dtm;

    private String admin_login_id;
    private Long view_count;

    public String getFormattedCrtDtm() {
        return crt_dtm != null ? crt_dtm.format(Const.DATETIME_FORMATTER) : "-";
    }
}
