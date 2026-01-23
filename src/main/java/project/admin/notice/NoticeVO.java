package project.admin.notice;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NoticeVO {
    private Long notice_seq;
    private Long admin_seq;
    private String notice_title;
    private int notice_priority;
    private boolean is_active;
    private String notice_cont;
    private LocalDateTime crt_dtm;


}
