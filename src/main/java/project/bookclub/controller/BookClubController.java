package project.bookclub.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import project.bookclub.service.BookClubService;
import project.bookclub.vo.BookClubVO;

import java.util.List;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bookclubs")
public class BookClubController {
    //주석 테스트
    private final BookClubService bookClubService;

    /*
    * 독서모임 메인
    * keyword 없으면 모임 전체 조회
    * keyword 있으면 검색
    */
    @GetMapping
    public List<BookClubVO> getBookClubs(@RequestParam(required = false) String keyword) {
        return bookClubService.searchBookClubs(keyword);
    }
}
