package project.bookclub.vo;

import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class BookClubVO {
    private Long book_club_seq; // 독서모임 ID
    private Long book_club_leader_seq; // 모임장 ID, FK
    private String book_club_name; // 독서모임명
    private String book_club_desc; // 독서모임 설명
    private String book_club_rg; // 독서모임 지역
    private Integer book_club_max_member; // 독서모임의 최대 인원
    private LocalDate book_club_deleted_dt; // 독서모임 삭제 일시
    private String banner_img_url; // 독서모임 배너 이미지
    private String book_club_schedule; // 독서모임 정기 일정
    private LocalDateTime upd_dtm; // 독서모임의 내용 수정 일시
    private Integer joined_member_count; // 독서모임의 가입 회원 수

    // 찜 관련 (DB 매핑 아님, Controller에서 설정)
    private boolean wished; // 현재 로그인 사용자의 찜 여부
    private Integer wish_count; // 찜 개수

    @JsonIgnore  // JSON 변환 시 제외
    private LocalDateTime crt_dtm;

    // JSON으로 반환할 포맷팅된 문자열
    @JsonProperty("crt_dtm")
    public String getCrtDtmFormatted() {
        return crt_dtm != null ? crt_dtm.format(Const.DATETIME_FORMATTER) : null;
    }
}
