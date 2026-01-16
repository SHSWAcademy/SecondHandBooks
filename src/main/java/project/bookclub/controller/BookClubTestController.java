package project.bookclub.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import project.bookclub.dto.BookClubCreateDTO;
import project.bookclub.service.BookClubService;

@Controller
@RequiredArgsConstructor
public class BookClubTestController {

    private final BookClubService bookClubService;

    @GetMapping("/test/bookclub/create")
    @ResponseBody
    public String testCreate() {

        BookClubCreateDTO dto = new BookClubCreateDTO();
        dto.setBook_club_name("테스트 독서모임");
        dto.setBook_club_desc("서비스 테스트용");
        dto.setBook_club_rg("서울");
        dto.setBook_club_max_member(10);
        dto.setBanner_img_url("test.png");
        dto.setBook_club_schedule("매주 토요일");

        // 가짜 로그인 사용자 ID
        Long leaderId = 1L;

//        bookClubService.create(dto, leaderId);

        return "SERVICE CALL SUCCESS";
    }
}
