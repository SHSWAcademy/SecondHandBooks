package project.bookclub.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class BookClubBoardVO {
    private Long BookClubBoardSeq; // pk
    private Long bookClubSeq; // fk (해당 독서모임)
    private Long memberSeq; // fk (작성자)
    private Long parentBookClubBoardSeq; // fk (부모글/댓글)

    private String title;
    private String content;
    private String imageUrl;

    private Long bookSeq;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String deletedYn;
    private LocalDateTime deletedAt;
}
