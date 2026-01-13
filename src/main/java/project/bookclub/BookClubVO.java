package project.bookclub;

import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class BookClubVO {
    private long bookClubSeq;
    private String name;
    private String description;
    private String region;
    private int maxMember;
    private LocalDate deletedDate;
    private String bannerImgUrl;
    private String schedule;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

}
