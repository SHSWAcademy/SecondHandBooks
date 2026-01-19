package project.bookclub.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import project.bookclub.ENUM.JoinRequestResult;
import project.bookclub.service.BookClubService;
import project.bookclub.vo.BookClubBoardVO;
import project.bookclub.vo.BookClubVO;
import project.member.MemberVO;

import java.util.List;

import javax.servlet.http.HttpSession;

@Controller
@Slf4j
@RequiredArgsConstructor
public class BookClubController {
    //주석 테스트
    private final BookClubService bookClubService;
    /**
     * 독서모임 상세 페이지 공통 model 세팅 (조회 로직 재사용)
     * - fragment 엔드포인트에서도 동일한 model 데이터 필요
     * - 비즈니스 로직 변경 없이 조회 로직만 재사용
     */
    private void loadBookClubDetailModel(Long bookClubId, HttpSession session, Model model) {
        // 1. 모임 조회
        BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);

        // 2. 조회 결과 없음 처리
        if (bookClub == null) {
            model.addAttribute("errorMessage", "존재하지 않거나 삭제된 모임입니다.");
            return;
        }

        // 3. 세션에서 로그인 멤버 정보 가져오기
        MemberVO loginMember = (MemberVO) session.getAttribute("loginSess");
        boolean isLogin = (loginMember != null);
        model.addAttribute("isLogin", isLogin);

        // 4. 로그인 상태일 때만 추가 상태 계산
        if (isLogin) {
            Long loginMemberSeq = loginMember.getMember_seq();
            model.addAttribute("loginMemberSeq", loginMemberSeq);

            // 4-1. 모임장 여부 판단
            boolean isLeader = bookClub.getBook_club_leader_seq().equals(loginMemberSeq);
            model.addAttribute("isLeader", isLeader);

            // 4-2. 멤버 여부 판단
            boolean isMember = bookClubService.isMemberJoined(bookClubId, loginMemberSeq);
            model.addAttribute("isMember", isMember);

            // 4-3. 대기중인 가입 신청 여부 판단
            boolean hasPendingRequest = bookClubService.hasPendingRequest(bookClubId, loginMemberSeq);
            model.addAttribute("hasPendingRequest", hasPendingRequest);
        } else {
            // 비로그인 시 기본값 설정
            model.addAttribute("isLeader", false);
            model.addAttribute("isMember", false);
            model.addAttribute("hasPendingRequest", false);
        }

        // 5. 현재 참여 인원 수 조회
        int joinedMemberCount = bookClubService.getTotalJoinedMemberCount(bookClubId);
        model.addAttribute("joinedMemberCount", joinedMemberCount);

        // 6. 찜 개수 조회
        int wishCount = bookClubService.getWishCount(bookClubId);
        model.addAttribute("wishCount", wishCount);

        // 7. Model에 데이터 담기
        model.addAttribute("bookClub", bookClub);
    }

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
        // 공통 model 세팅 메서드 호출
        loadBookClubDetailModel(bookClubId, session, model);
        return "bookclub/bookclub_detail";
    }

    /**
     * 독서모임 상세 페이지 - 게시판 탭 fragment
     * GET /bookclubs/{bookClubId}/board-fragment
     * - fetch로 호출되어 게시판 탭 본문만 반환
     * - 동일한 model 세팅 재사용 (fragment에서도 bookClub 등 필요)
     * - 게시판 목록 조회 추가 (최근 원글 10개)
     */
    @GetMapping("/bookclubs/{bookClubId}/board-fragment")
    public String getBoardFragment(
            @PathVariable("bookClubId") Long bookClubId,
            HttpSession session,
            Model model
    ) {
        // 공통 model 세팅 메서드 호출 (조회 로직 재사용)
        loadBookClubDetailModel(bookClubId, session, model);

        // 게시판 목록 조회 (최근 원글 10개)
        List<BookClubBoardVO> boards = bookClubService.getRecentBoards(bookClubId);
        model.addAttribute("boards", boards);

        // bookClubId를 model에 추가 (fragment에서 링크 생성 시 필요)
        model.addAttribute("bookClubId", bookClubId);

        return "bookclub/bookclub_detail_board";
    }

    /**
     * 독서모임 게시글 상세 페이지
     * GET /bookclubs/{bookClubId}/posts/{postId}
     * - 게시글 단건 조회 (본문 렌더링)
     * - 댓글 조회/작성은 TODO (추후 구현)
     */
    @GetMapping("/bookclubs/{bookClubId}/posts/{postId}")
    public String getPostDetail(
            @PathVariable("bookClubId") Long bookClubId,
            @PathVariable("postId") Long postId,
            Model model
    ) {
        // 게시글 조회
        BookClubBoardVO post = bookClubService.getBoardDetail(bookClubId, postId);

        // 게시글 없음 처리
        if (post == null) {
            model.addAttribute("errorMessage", "게시글을 찾을 수 없거나 삭제되었습니다.");
            return "error/404"; // 또는 redirect:/bookclubs/{bookClubId}
        }

        // model에 데이터 담기
        model.addAttribute("post", post);
        model.addAttribute("bookClubId", bookClubId);

        return "bookclub/bookclub_post_detail";
    }

    /**
     * 독서모임 가입 신청 (승인형) - 개선판
     * POST /bookclubs/{bookClubId}/join-requests
     *
     * 개선사항:
     * - Controller에서 비즈니스 검증(isMemberJoined) 제거 → Service로 이동
     * - try-catch 예외 처리 제거 → enum 결과로 통일
     * - Flash 메시지 추가 (enum.getMessage() 활용)
     *
     * @param bookClubId 독서모임 ID
     * @param session 세션 (로그인 확인용)
     * @param redirectAttributes Flash 메시지 전달용
     * @return redirect URL
     */

    @PostMapping("/bookclubs/{bookClubId}/join-requests")
    public String createJoinRequest(
            @PathVariable("bookClubId") Long bookClubId,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        // 1. 로그인 확인 (Controller 책임 유지)
        MemberVO loginMember = (MemberVO) session.getAttribute("loginSess");
        if (loginMember == null) {
            log.warn("비로그인 상태에서 가입 신청 시도: bookClubId={}", bookClubId);
            return "redirect:/login";
        }

        // 2. Service 호출 → enum 결과 받기 (비즈니스 로직은 Service에 위임)
        JoinRequestResult result = bookClubService.createJoinRequest(
                bookClubId,
                loginMember.getMember_seq(),
                null
        );

        // 3. enum 기반 분기 처리 (간결하고 명확)
        switch (result) {
            case SUCCESS:
                redirectAttributes.addFlashAttribute("successMessage", result.getMessage());
                break;

            case ALREADY_JOINED:
            case ALREADY_REQUESTED:
            case INVALID_PARAMETERS:
                redirectAttributes.addFlashAttribute("errorMessage", result.getMessage());
                break;
        }

        return "redirect:/bookclubs/" + bookClubId;
    }
} 
