package project.bookclub.dto;

import lombok.Data;

@Data
public class BookClubCreateDTO {
    private String book_club_name;      // 모임 이름 (필수)
    private String book_club_desc;      // 모임 설명 (선택)
    private String book_club_rg;        // 활동 지역 (필수)
    private int book_club_max_member;   // 최대 인원 (필수, 정책상 int)
    private String banner_img_url;      // 모임 이미지 URL (선택)
    private String book_club_schedule;  // 모임 일정 (선택)
}
