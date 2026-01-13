package project.bookclub.vo;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class BookClubRequestVO {
    private Long book_club_seq;
    private Long book_club_request_seq;
    private Long request_member_seq;

    private String request_cont;
    private String request_st;
    private LocalDateTime request_dtm;
    private LocalDate request_processed_dt;
}