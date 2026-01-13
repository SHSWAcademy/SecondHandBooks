package project.bookclub.vo;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class BookClubRequestVO {
    private Long bookClubSeq;
    private Long bookClubRequestSeq;
    private Long requestMemberSeq;

    private String requestCont;
    private String requestSt;
    private LocalDateTime requestDtm;
    private LocalDate requestProcessedDt;
}