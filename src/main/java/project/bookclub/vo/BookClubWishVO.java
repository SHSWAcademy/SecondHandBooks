package project.bookclub.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class BookClubWishVO {
    private Long book_club_seq; // pk, fk
    private Long book_club_wish_seq; // pk
    private Long member_seq; // fk
    private LocalDateTime crt_dtm;

}
