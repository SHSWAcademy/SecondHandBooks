package project.bookclub.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import project.bookclub.dto.BookClubCreateDTO;
import project.bookclub.service.BookClubService;
import project.bookclub.vo.BookClubVO;
import project.member.MemberVO;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bookclubs")
public class BookClubController {
    //주석 테스트
    private final BookClubService bookClubService;

    /*
    * 독서모임 메인
    * getBookClubs : keyword 없이 모임 전체 조회
    * searchBookClubs : keyword로 모임 검색
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

    @PostMapping
    @ResponseBody
    public Map<String, Object> createBookClubs(BookClubVO vo, HttpSession session) {
        MemberVO loginUser = (MemberVO) session.getAttribute("loginSess");

        if (loginUser == null) {
            return Map.of(
                    "status", "fail",
                    "message", "LOGIN_REQUIRED"
            );
        }
        vo.setBook_club_leader_seq(loginUser.getMember_seq());
//        log.info("login member_seq = {}", loginUser.getMember_seq());
//
//        vo.setBook_club_leader_seq(loginUser.getMember_seq());
//        bookClubService.createBookClubs(vo);
//        return Map.of("status", "ok");
        try {
//            vo.setBook_club_leader_seq(loginUser.getMember_seq());
            bookClubService.createBookClubs(vo);
            return Map.of("status", "ok");
        } catch (IllegalStateException e) {
            return Map.of(
                    "status", "fail",
                    "message", e.getMessage()
            );
        }
    }
}
