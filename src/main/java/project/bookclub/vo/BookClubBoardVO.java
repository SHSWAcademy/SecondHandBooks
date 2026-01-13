package project.bookclub.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class BookClubBoardVO {
    private Long book_club_seq; // PK, FK
    private Long book_club_board_seq; // PK
    private Long member_seq; // FK
    private Long parent_book_club_board_seq; // FK

    private String board_title;
    private String board_cont;
    private String board_img_url;

    private Long book_seq; // FK
    private Boolean board_deleted_yn;
    private LocalDateTime board_deleted_dtm;
}
