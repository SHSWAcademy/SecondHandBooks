package project.member;

import lombok.Data;
import java.time.LocalDateTime;


@Data
public class MemberVO {
    private long memberSeq;
    private String loginId;
    private String passWord;
    private String email;
    private String tel;
    private String nickName;
    private LocalDateTime deletedAt;
    private LocalDateTime lastLoginDate;
    private MemberStatus memberStatus;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
