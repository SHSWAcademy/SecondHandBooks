package project.bookclub.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class BookClubMemberVO {
    private Long bookClubSeq;          // PK, FK
    private Long bookClubMemberSeq;    // PK (중간테이블 row id)
    private Long memberSeq;            // FK

    private Boolean leaderYn;
    private String joinStatus;             // ENUM(예: ACTIVE/PENDING/BANNED 등) -> 일단 String
    private LocalDateTime joinStUpdateAt;
}
