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
        log.info("========== [ENTER] 독서모임 상세 조회 요청 ==========");
        log.info("요청 URL: /bookclubs/{}", bookClubId);
        log.info("bookClubId 타입: {}, 값: {}", bookClubId.getClass().getSimpleName(), bookClubId);

        // 1. 모임 조회
        log.debug("Service 호출 전: bookClubService.getBookClubById({})", bookClubId);
        BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);
        log.debug("Service 호출 후: bookClub = {}", bookClub);

        // 2. 조회 결과 없음 처리
        if (bookClub == null) {
            log.warn("❌ 존재하지 않거나 삭제된 모임: bookClubId={}", bookClubId);
            log.warn("→ Model에 errorMessage 추가");
            model.addAttribute("errorMessage", "존재하지 않거나 삭제된 모임입니다.");
            log.info("→ return view: bookclub/bookclub_detail (에러 표시)");
            return "bookclub/bookclub_detail";  // JSP에서 에러 메시지 표시
        }

        // 3. Model에 데이터 담기
        log.info("✅ 독서모임 조회 성공!");
        log.info("   - book_club_seq: {}", bookClub.getBook_club_seq());
        log.info("   - book_club_name: {}", bookClub.getBook_club_name());
        log.info("   - book_club_desc: {}", bookClub.getBook_club_desc() != null ?
                 bookClub.getBook_club_desc().substring(0, Math.min(50, bookClub.getBook_club_desc().length())) + "..." : "null");
        log.info("   - book_club_rg: {}", bookClub.getBook_club_rg());
        log.info("   - book_club_max_member: {}", bookClub.getBook_club_max_member());
        log.info("   - banner_img_url: {}", bookClub.getBanner_img_url());
        log.info("   - crt_dtm: {}", bookClub.getCrt_dtm());

        model.addAttribute("bookClub", bookClub);
        log.info("→ Model에 bookClub 추가 완료");
        log.info("→ return view: bookclub/bookclub_detail (정상 표시)");
        log.info("========== [EXIT] 독서모임 상세 조회 완료 ==========");

        return "bookclub/bookclub_detail";
    }
}
