package project.bookclub.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import project.bookclub.dto.BookClubCreateDTO;
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
    public String getBookClubs(Model model) {
        List<BookClubVO> bookClubs = bookClubService.getBookClubList();
        model.addAttribute("bookclubList", bookClubs);
        return "bookclub/bookclub_list";
    }

    @GetMapping("/search")
    @ResponseBody
    public List<BookClubVO> searchBookClubs(@RequestParam(required = false) String keyword) {
        return bookClubService.searchBookClubs(keyword);
    }

//    @GetMapping
//    public String getBookClubs(@RequestParam(required = false) String keyword, Model model) {
////        log.info(">>> bookclubs. controller called");
//        List<BookClubVO> bookclubList = bookClubService.searchBookClubs(keyword);
//        model.addAttribute("bookclubList", bookclubList);
//        model.addAttribute("keyword", keyword);
//        return "bookclub/bookclub_list";
//    }

//    @PostMapping
//    @ResponseBody
//    public void createBookClub(BookClubCreateDTO dto) {
////        bookClubService.create(vo);
////        BookClubCreateDTO dto = new BookClubCreateDTO();
//        dto.setBook_club_name("테스트 모임");
//        dto.setBook_club_desc("설명");
//        dto.setBook_club_rg("서울");
//        dto.setBook_club_max_member(10);
//        dto.setBanner_img_url("test.png");
//        dto.setBook_club_schedule("매주 토요일");
//
//        Long leaderId = 1L;
//        bookClubService.create(dto, leaderId);
//    }

    @PostMapping//("/bookclubs")
    @ResponseBody
    public void create(BookClubVO vo) {
        log.info("vo = {}", vo);
        bookClubService.create(vo);
//        return "redirect:/bookclubs";
    }
}
