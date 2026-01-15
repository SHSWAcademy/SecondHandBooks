package project.bookclub.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import project.bookclub.service.BookClubService;
import project.bookclub.vo.BookClubVO;

@Controller
@Slf4j
@RequiredArgsConstructor
public class BookClubController {
    //주석 테스트
    private final BookClubService bookClubService;

    /**
     * 독서모임 상세 페이지 (1단계 MVP)
     * GET /bookclubs/{bookClubId}
     * - 모임 1건 조회 + JSP 출력만 구현
     * - 멤버/찜/게시판/버튼 분기 등은 TODO로 남김
     */
    @GetMapping("/bookclubs/{bookClubId}")
    public String getBookClubDetail(
            @PathVariable("bookClubId") Long bookClubId,
            Model model
    ) {
        // 1. 모임 조회
        BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);

        // 2. 조회 결과 없음 처리
        if (bookClub == null) {
            model.addAttribute("errorMessage", "존재하지 않거나 삭제된 모임입니다.");
            
            return "bookclub/bookclub_detail";  // JSP에서 에러 메시지 표시
        }
        // 3. Model에 데이터 담기
        model.addAttribute("bookClub", bookClub);
        return "bookclub/bookclub_detail";
    }
} 
