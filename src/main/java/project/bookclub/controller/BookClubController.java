package project.bookclub.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
//    @GetMapping
//    public List<BookClubVO> getBookClubs(@RequestParam(required = false) String keyword) {
//        log.info(">>> bookclubs. controller called");
//        return bookClubService.searchBookClubs(keyword);
//    }

    @GetMapping
    public String getBookClubs(Model model) {
        List<BookClubVO> bookClubs = bookClubService.searchAll();
        model.addAttribute(bookClubs);
        return "bookclub/bookclubs";
    }


//    @GetMapping
//    public String getBookClubs(@RequestParam(required = false) String keyword, Model model) {
////        log.info(">>> bookclubs. controller called");
//        List<BookClubVO> bookClubs = bookClubService.searchBookClubs(keyword);
//        model.addAttribute("bookClubs", bookClubs);
//        model.addAttribute("keyword", keyword);
//        return "bookclub/bookclubs";
//    }
}
