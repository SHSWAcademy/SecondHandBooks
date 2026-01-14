package project.bookclub.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class BookClubBoardVO {
    private Long book_club_seq; // 독서모임의 ID, PK, FK
    private Long book_club_board_seq; // 독서모임 게시판의 게시글 ID, PK
    private Long member_seq; // 멤버 ID, FK
    private Long parent_book_club_board_seq; // 부모 게시글 ID, FK

    private String board_title; // 게시글 제목
    private String board_cont; // 게시글 내용
    private String board_img_url; // 게시글에 첨부된 사진

    private Long book_seq; // 책 API의 ID, FK
    private Boolean board_deleted_yn; // 게시글 삭제 여부
    private LocalDateTime board_deleted_dtm; // 게시글 삭제 시간
    private LocalDateTime board_crt_dtm; // 게시글 생성 시간
    private LocalDateTime board_upd_dtm; // 게시글 수정 시간
}
