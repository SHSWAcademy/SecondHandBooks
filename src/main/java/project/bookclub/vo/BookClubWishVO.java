package project.bookclub.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class BookClubWishVO {
    private Long bookClubSeq; // pk, fk
    private Long bookClubWishSeq; // pk
    private Long memberSeq; // fk
    private LocalDateTime createdAt;

}
