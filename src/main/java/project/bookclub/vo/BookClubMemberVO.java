package project.bookclub.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class BookClubMemberVO {
    private Long book_club_seq;          // PK, FK
    private Long book_club_member_seq;    // PK (중간테이블 row id)
    private Long member_seq;            // FK

    private Boolean leader_yn;
    private String join_st;             // ENUM(예: ACTIVE/PENDING/BANNED 등) -> 일단 String
    private LocalDateTime join_st_update_dtm;
}
