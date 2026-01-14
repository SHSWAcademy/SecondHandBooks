package project.bookclub.vo;

import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class BookClubVO {
    private long book_club_seq;
    private String book_club_name;
    private String book_club_desc;
    private String book_club_rg;
    private int book_club_max_member;
    private LocalDate book_club_deleted_dt;
    private String banner_img_url;
    private String book_club_schedule;
    private LocalDateTime crt_dtm;
    private LocalDateTime upd_dtm;

}
