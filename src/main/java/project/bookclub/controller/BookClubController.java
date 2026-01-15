package project.bookclub.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import project.bookclub.service.BookClubService;
import project.bookclub.vo.BookClubVO;
import project.member.MemberVO;

import javax.servlet.http.HttpSession;

@Controller
@Slf4j
@RequiredArgsConstructor
public class BookClubController {
    //주석 테스트
    private final BookClubService bookClubService;

    /**
     * 독서모임 상세 페이지 (2단계: 버튼 분기/상태 계산)
     * GET /bookclubs/{bookClubId}
     * - 모임 1건 조회 + JSP 출력
     * - 로그인 여부, 모임장/멤버 판단 로직 추가
     * - JSP에서 버튼 분기 처리 가능하도록 model 데이터 제공
     */
    @GetMapping("/bookclubs/{bookClubId}")
    public String getBookClubDetail(
            @PathVariable("bookClubId") Long bookClubId,
            HttpSession session,
            Model model
    ) {
        // 1. 모임 조회
        BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);

        // 2. 조회 결과 없음 처리
        if (bookClub == null) {
            model.addAttribute("errorMessage", "존재하지 않거나 삭제된 모임입니다.");
            return "bookclub/bookclub_detail";  // JSP에서 에러 메시지 표시
        }

        // 3. 세션에서 로그인 멤버 정보 가져오기
        MemberVO loginMember = (MemberVO) session.getAttribute("loginSess");
        boolean isLogin = (loginMember != null);
        model.addAttribute("isLogin", isLogin);

        // 4. 로그인 상태일 때만 추가 상태 계산
        if (isLogin) {
            Long loginMemberSeq = loginMember.getMemberSeq();
            model.addAttribute("loginMemberSeq", loginMemberSeq);

            // 4-1. 모임장 여부 판단 (book_club_leader_seq == loginMemberSeq)
            boolean isLeader = bookClub.getBook_club_leader_seq().equals(loginMemberSeq);
            model.addAttribute("isLeader", isLeader);

            // 4-2. 멤버 여부 판단 (book_club_member 테이블에서 join_st='JOINED' 확인)
            boolean isMember = bookClubService.isMemberJoined(bookClubId, loginMemberSeq);
            model.addAttribute("isMember", isMember);
        } else {
            // 비로그인 시 기본값 설정
            model.addAttribute("isLeader", false);
            model.addAttribute("isMember", false);
        }

        // 5. 현재 참여 인원 수 조회
        int joinedMemberCount = bookClubService.getTotalJoinedMemberCount(bookClubId);
        model.addAttribute("joinedMemberCount", joinedMemberCount);

        // 6. Model에 데이터 담기
        model.addAttribute("bookClub", bookClub);
        return "bookclub/bookclub_detail";
    }
} 
