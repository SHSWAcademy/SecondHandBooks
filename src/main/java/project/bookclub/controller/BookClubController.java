package project.bookclub.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import project.bookclub.ENUM.JoinRequestResult;
import project.bookclub.service.BookClubService;
import project.bookclub.vo.BookClubBoardVO;
import project.bookclub.vo.BookClubVO;
import project.member.MemberVO;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bookclubs")
public class BookClubController {

    private final BookClubService bookClubService;

    @Value("${file.dir}")
    private String uploadPath;

    /**
     * 독서모임 상세 페이지 공통 model 세팅 (조회 로직 재사용)
     * - fragment 엔드포인트에서도 동일한 model 데이터 필요
     * - 비즈니스 로직 변경 없이 조회 로직만 재사용
     */
    private void loadBookClubDetailModel(Long bookClubId, HttpSession session, Model model) {
        // 1. 모임 조회
        BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);

        // 2. 조회 결과 없음 또는 삭제된 모임 처리
        if (bookClub == null || bookClub.getBook_club_deleted_dt() != null) {
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

            // 4-2. 멤버 여부 판단 (JOINED 상태)
            boolean isMember = bookClubService.isMemberJoined(bookClubId, loginMemberSeq);
            model.addAttribute("isMember", isMember);

            // 4-3. 대기중인 가입 신청 여부 판단
            boolean hasPendingRequest = bookClubService.hasPendingRequest(bookClubId, loginMemberSeq);
            model.addAttribute("hasPendingRequest", hasPendingRequest);

            // 4-4. 거절된 가입 신청 여부 판단
            boolean hasRejectedRequest = bookClubService.hasRejectedRequest(bookClubId, loginMemberSeq);
            model.addAttribute("hasRejectedRequest", hasRejectedRequest);

            // 4-5. CTA 상태 계산 (우선순위: JOINED > WAIT > REJECTED > 신청 가능)
            // - isLeader는 별도로 "모임 관리하기" 버튼 표시에 사용 가능
            // - CTA는 가입/탈퇴/대기/재신청 상태를 나타냄
            String ctaStatus;
            if (isMember) {
                ctaStatus = "JOINED"; // 탈퇴하기 버튼
            } else if (hasPendingRequest) {
                ctaStatus = "WAIT"; // 승인 대기중 문구 (버튼 비활성)
            } else if (hasRejectedRequest) {
                ctaStatus = "REJECTED"; // 다시 신청하기 버튼
            } else {
                ctaStatus = "NONE"; // 가입 신청하기 버튼
            }
            model.addAttribute("ctaStatus", ctaStatus);
        } else {
            // 비로그인 시 기본값 설정
            model.addAttribute("isLeader", false);
            model.addAttribute("isMember", false);
            model.addAttribute("hasPendingRequest", false);
            model.addAttribute("hasRejectedRequest", false);
            model.addAttribute("ctaStatus", "NONE"); // 비로그인은 가입 신청하기만 표시
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
    public Map<String, Object> createBookClubs(
            @ModelAttribute BookClubVO vo,
            @RequestParam(value = "banner_img", required = false) MultipartFile bannerImg,
            HttpSession session) {

        log.info("vo = {}", vo);
        log.info("banner_img = {}", vo.getBanner_img_url());

        MemberVO loginUser = (MemberVO) session.getAttribute("loginSess");

        if (loginUser == null) {
            return Map.of(
                    "status", "fail",
                    "message", "LOGIN_REQUIRED");
        }

        vo.setBook_club_leader_seq(loginUser.getMember_seq());

        // 이미지 파일 처리
        if (bannerImg != null && !bannerImg.isEmpty()) {
            try {
                String savedFileName = saveFile(bannerImg);
                vo.setBanner_img_url("/img/" + savedFileName);
                log.info("Banner image saved: {}", savedFileName);
            } catch (IOException e) {
                log.error("Failed to save banner image", e);
                return Map.of(
                        "status", "fail",
                        "message", "이미지 업로드에 실패했습니다.");
            }
        }

        try {
            bookClubService.createBookClub(vo);
            return Map.of("status", "ok");
        } catch (IllegalStateException e) {
            return Map.of(
                    "status", "fail",
                    "message", e.getMessage());
        }
    }

    /**
     * 독서모임 상세 페이지 (2단계: 버튼 분기/상태 계산)
     * GET /bookclubs/{bookClubId}
     * - 모임 1건 조회 + JSP 출력
     * - 로그인 여부, 모임장/멤버 판단 로직 추가
     * - JSP에서 버튼 분기 처리 가능하도록 model 데이터 제공
     */
    @GetMapping("/{bookClubId}")
    public String getBookClubDetail(
            @PathVariable("bookClubId") Long bookClubId,
            HttpSession session,
            Model model) {
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
     *
     * [권한 가드]
     * - 비로그인: forbidden fragment 반환 (redirect 금지)
     * - 로그인했지만 JOINED 아님 또는 WAIT 상태: forbidden fragment 반환
     * - 모임장 또는 JOINED 멤버: 게시판 목록 정상 반환
     */
    @GetMapping("/{bookClubId}/board-fragment")
    public String getBoardFragment(
            @PathVariable("bookClubId") Long bookClubId,
            HttpSession session,
            Model model) {

        model.addAttribute("bookClubId", bookClubId);

        // 1. 로그인 여부 확인
        MemberVO loginMember = (MemberVO) session.getAttribute("loginSess");
        if (loginMember == null) {
            // fragment에서는 redirect 불가 → forbidden 처리
            return "bookclub/bookclub_board_forbidden";
        }

        Long loginMemberSeq = loginMember.getMember_seq();

        // 2. 모임 조회
        BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);
        if (bookClub == null || bookClub.getBook_club_deleted_dt() != null) {
            log.warn("종료된 모임 게시판 fragment 접근: bookClubId={}, memberSeq={}", bookClubId, loginMemberSeq);
            // 종료된 모임 전용 fragment 반환
            return "bookclub/bookclub_closed_fragment";
        }

        // 3. 권한 판정 (모임장 또는 JOINED 멤버만)
        boolean isLeader = bookClub.getBook_club_leader_seq().equals(loginMemberSeq);
        boolean isMember = bookClubService.isMemberJoined(bookClubId, loginMemberSeq);

        if (!isLeader && !isMember) {
            // 권한 없음 - forbidden fragment 반환
            model.addAttribute("isLogin", true);
            return "bookclub/bookclub_board_forbidden";
        }

        // 4. 권한 있음: 공통 model 세팅 + 게시판 목록 조회
        loadBookClubDetailModel(bookClubId, session, model);

        // 게시판 목록 조회 (최근 원글 10개)
        List<BookClubBoardVO> boards = bookClubService.getRecentBoards(bookClubId);
        model.addAttribute("boards", boards);

        return "bookclub/bookclub_detail_board";
    }

    /**
     * 권한 검증 공통 메서드
     *
     * @return 권한 있으면 null, 없으면 forbidden view 이름
     */
    private String checkBoardAccessPermission(Long bookClubId, HttpSession session, Model model) {
        model.addAttribute("bookClubId", bookClubId);

        // 1. 로그인 여부 확인
        MemberVO loginMember = (MemberVO) session.getAttribute("loginSess");
        if (loginMember == null) {
            return "redirect:/login";
        }

        Long loginMemberSeq = loginMember.getMember_seq();

        // 2. 모임 조회
        BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);
        if (bookClub == null || bookClub.getBook_club_deleted_dt() != null) {
            model.addAttribute("errorMessage", "존재하지 않거나 삭제된 모임입니다.");
            return "bookclub/bookclub_post_forbidden";
        }

        // 3. 권한 판정
        boolean isLeader = bookClub.getBook_club_leader_seq().equals(loginMemberSeq);
        boolean isMember = bookClubService.isMemberJoined(bookClubId, loginMemberSeq);
        boolean hasPendingRequest = bookClubService.hasPendingRequest(bookClubId, loginMemberSeq);

        boolean allow = (isLeader || isMember) && !hasPendingRequest;

        // model에 권한 정보 담기
        model.addAttribute("isLogin", true);
        model.addAttribute("loginMemberSeq", loginMemberSeq);
        model.addAttribute("isLeader", isLeader);
        model.addAttribute("isMember", isMember);
        model.addAttribute("canWriteComment", allow);

        return allow ? null : "bookclub/bookclub_post_forbidden";
    }

    /**
     * 독서모임 게시글 상세 페이지
     * GET /bookclubs/{bookClubId}/posts/{postId}
     * - 게시글 단건 조회 (본문 렌더링)
     * - 댓글 목록 조회 추가 (SELECT만)
     *
     * [권한 가드]
     * - 비로그인: /login으로 redirect
     * - 로그인했지만 JOINED 아님 또는 WAIT 상태: forbidden 풀 페이지
     * - 모임장 또는 JOINED 멤버: 게시글 상세 정상 반환
     */
    @GetMapping("/{bookClubId}/posts/{postId}")
    public String getPostDetail(
            @PathVariable("bookClubId") Long bookClubId,
            @PathVariable("postId") Long postId,
            HttpSession session,
            Model model) {

        // 권한 검증 (공통 메서드 재사용)
        String permissionCheckResult = checkBoardAccessPermission(bookClubId, session, model);
        if (permissionCheckResult != null) {
            return permissionCheckResult;
        }

        // 권한 있음: 게시글 + 댓글 조회
        BookClubBoardVO post = bookClubService.getBoardDetail(bookClubId, postId);

        // 게시글 없음 처리
        if (post == null) {
            model.addAttribute("errorMessage", "게시글을 찾을 수 없거나 삭제되었습니다.");
            return "error/404";
        }

        // 댓글 목록 조회
        List<BookClubBoardVO> comments = bookClubService.getBoardComments(bookClubId, postId);

        // model에 데이터 담기
        model.addAttribute("post", post);
        model.addAttribute("comments", comments);

        return "bookclub/bookclub_post_detail";
    }

    /**
     * 댓글 작성 (PRG 패턴)
     * POST /bookclubs/{bookClubId}/posts/{postId}/comments
     * - 로그인 필수
     * - 모임장 또는 JOINED 멤버만 작성 가능
     * - 부모글 검증 (우회 방지)
     */
    @PostMapping("/{bookClubId}/posts/{postId}/comments")
    public String createComment(
            @PathVariable("bookClubId") Long bookClubId,
            @PathVariable("postId") Long postId,
            @RequestParam("commentCont") String commentCont,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        String redirectUrl = "redirect:/bookclubs/" + bookClubId + "/posts/" + postId + "#comments";

        // 1. 로그인 확인
        MemberVO loginMember = (MemberVO) session.getAttribute("loginSess");
        if (loginMember == null) {
            return "redirect:/login";
        }

        Long memberSeq = loginMember.getMember_seq();

        // 2. 권한 체크 (모임장 OR JOINED 멤버)
        BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);
        if (bookClub == null || bookClub.getBook_club_deleted_dt() != null) {
            log.warn("종료된 모임 댓글 작성 시도: bookClubId={}, memberSeq={}", bookClubId, memberSeq);
            redirectAttributes.addFlashAttribute("errorMessage", "존재하지 않거나 종료된 모임입니다.");
            return "redirect:/bookclubs";
        }

        boolean isLeader = bookClub.getBook_club_leader_seq().equals(memberSeq);
        boolean isMember = bookClubService.isMemberJoined(bookClubId, memberSeq);

        if (!isLeader && !isMember) {
            // 권한 없음 - 모임 상세 페이지로 리다이렉트
            redirectAttributes.addFlashAttribute("errorMessage", "댓글을 작성할 권한이 없습니다.");
            return "redirect:/bookclubs/" + bookClubId;
        }

        // 3. 댓글 내용 검증
        if (commentCont == null || commentCont.isBlank()) {
            redirectAttributes.addFlashAttribute("errorMessage", "댓글 내용을 입력해주세요.");
            return redirectUrl;
        }

        // 4. 부모글 검증 (우회 방지)
        boolean isValidPost = bookClubService.existsRootPost(bookClubId, postId);
        if (!isValidPost) {
            redirectAttributes.addFlashAttribute("errorMessage", "존재하지 않는 게시글입니다.");
            return redirectUrl;
        }

        // 5. 댓글 INSERT
        bookClubService.createBoardComment(bookClubId, postId, memberSeq, commentCont);

        // 6. 성공 시 게시글 상세 페이지로 리다이렉트
        return redirectUrl;
    }

    /**
     * 독서모임 가입 신청 (승인형) - 개선판
     * POST /bookclubs/{bookClubId}/join-requests
     *
     * 개선사항:
     * - Controller에서 비즈니스 검증(isMemberJoined) 제거 → Service로 이동
     * - try-catch 예외 처리 제거 → enum 결과로 통일
     * - Flash 메시지 추가 (enum.getMessage() 활용)
     */
    @PostMapping("/{bookClubId}/join-requests")
    public String createJoinRequest(
            @PathVariable("bookClubId") Long bookClubId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        // 1. 로그인 확인 (Controller 책임 유지)
        MemberVO loginMember = (MemberVO) session.getAttribute("loginSess");
        if (loginMember == null) {
            log.warn("비로그인 상태에서 가입 신청 시도: bookClubId={}", bookClubId);
            return "redirect:/login";
        }

        // 1-1. 종료된 모임 가드
        BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);
        if (bookClub == null || bookClub.getBook_club_deleted_dt() != null) {
            log.warn("종료된 모임 가입 신청 시도: bookClubId={}, memberSeq={}", bookClubId, loginMember.getMember_seq());
            redirectAttributes.addFlashAttribute("errorMessage", "존재하지 않거나 종료된 모임입니다.");
            return "redirect:/bookclubs";
        }

        // 2. Service 호출 → enum 결과 받기 (비즈니스 로직은 Service에 위임)
        JoinRequestResult result = bookClubService.createJoinRequest(
                bookClubId,
                loginMember.getMember_seq(),
                null);

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

    /**
     * 독서모임 가입 신청 (AJAX용)
     * POST /bookclubs/{bookClubId}/join
     */
    @PostMapping("/{bookClubId}/join")
    @ResponseBody
    public Map<String, Object> createJoinRequestAjax(
            @PathVariable("bookClubId") Long bookClubId,
            @RequestBody(required = false) Map<String, String> body,
            HttpSession session) {

        MemberVO loginMember = (MemberVO) session.getAttribute("loginSess");
        if (loginMember == null) {
            return Map.of("status", "fail", "message", "로그인이 필요합니다.");
        }

        // 종료된 모임 가드
        BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);
        if (bookClub == null || bookClub.getBook_club_deleted_dt() != null) {
            log.warn("종료된 모임 가입 시도: bookClubId={}, memberSeq={}", bookClubId, loginMember.getMember_seq());
            return Map.of("status", "fail", "message", "존재하지 않거나 종료된 모임입니다.");
        }

        String reason = (body != null) ? body.get("reason") : null;

        JoinRequestResult result = bookClubService.createJoinRequest(
                bookClubId,
                loginMember.getMember_seq(),
                reason);

        if (result == JoinRequestResult.SUCCESS) {
            return Map.of("status", "ok", "message", result.getMessage());
        } else {
            return Map.of("status", "fail", "message", result.getMessage());
        }
    }

    /**
     * 독서모임 탈퇴 (AJAX용)
     * POST /bookclubs/{bookClubId}/leave
     *
     * 검증 순서:
     * 1. 로그인 확인
     * 2. 모임 존재 여부 확인
     * 3. Service 레이어에서 비즈니스 로직 처리:
     * - 일반 멤버: join_st='LEFT' 업데이트
     * - 모임장: 자동 승계 또는 모임 종료
     *
     * @return JSON {success, message, leaderChanged?, newLeaderSeq?, clubClosed?,
     *         ctaStatus}
     */
    @PostMapping("/{bookClubId}/leave")
    @ResponseBody
    public Map<String, Object> leaveBookClub(
            @PathVariable("bookClubId") Long bookClubId,
            HttpSession session) {

        // 1. 로그인 확인
        MemberVO loginMember = (MemberVO) session.getAttribute("loginSess");
        if (loginMember == null) {
            log.warn("비로그인 상태에서 탈퇴 시도: bookClubId={}", bookClubId);
            return Map.of("success", false, "message", "로그인이 필요합니다.");
        }

        Long loginMemberSeq = loginMember.getMember_seq();

        // 2. 모임 조회
        BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);
        if (bookClub == null || bookClub.getBook_club_deleted_dt() != null) {
            log.warn("종료된 모임 탈퇴 시도: bookClubId={}", bookClubId);
            return Map.of("success", false, "message", "존재하지 않거나 종료된 모임입니다.");
        }

        // 3. Service 호출 (비즈니스 로직 위임)
        try {
            Map<String, Object> result = bookClubService.leaveBookClub(bookClubId, loginMemberSeq);

            log.info("멤버 탈퇴 완료: bookClubId={}, memberSeq={}, result={}",
                    bookClubId, loginMemberSeq, result);

            return result;

        } catch (IllegalStateException | IllegalArgumentException e) {
            log.warn("멤버 탈퇴 실패: bookClubId={}, memberSeq={}, error={}",
                    bookClubId, loginMemberSeq, e.getMessage());
            return Map.of("success", false, "message", e.getMessage());
        }
    }

    /**
     * 파일 저장 (설정된 uploadPath에 저장)
     */
    private String saveFile(MultipartFile file) throws IOException {
        // 폴더가 없으면 생성
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
            log.info("Upload directory created: {}", uploadPath);
        }

        // 고유한 파일명 생성 (UUID + 원본 확장자)
        String originalFileName = file.getOriginalFilename();
        String extension = "";
        if (originalFileName != null && originalFileName.contains(".")) {
            extension = originalFileName.substring(originalFileName.lastIndexOf("."));
        }
        String savedFileName = UUID.randomUUID().toString() + extension;

        // 파일 저장
        File destFile = new File(uploadPath + savedFileName);
        file.transferTo(destFile);

        log.info("File saved to: {}", destFile.getAbsolutePath());
        return savedFileName;
    }

    /**
     * 게시글 작성 폼 페이지
     * GET /bookclubs/{bookClubId}/posts
     * - 로그인 필수
     * - 모임장 또는 JOINED 멤버만 접근 가능
     */
    @GetMapping("/{bookClubId}/posts")
    public String createPostForm(
            @PathVariable("bookClubId") Long bookClubId,
            HttpSession session,
            Model model) {

        // 권한 검증
        String permissionCheckResult = checkBoardAccessPermission(bookClubId, session, model);
        if (permissionCheckResult != null) {
            return permissionCheckResult;
        }

        // 모임 정보 조회
        BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);
        model.addAttribute("bookClub", bookClub);
        model.addAttribute("bookClubId", bookClubId);

        return "bookclub/bookclub_posts";
    }

    /**
     * 게시글 작성 처리 (PRG 패턴)
     * POST /bookclubs/{bookClubId}/posts
     * - 로그인 필수
     * - 모임장 또는 JOINED 멤버만 작성 가능
     * - 제목, 내용 필수 / 이미지, 책 선택은 선택사항
     */
    @PostMapping("/{bookClubId}/posts")
    public String createPost(
            @PathVariable("bookClubId") Long bookClubId,
            @RequestParam("boardTitle") String boardTitle,
            @RequestParam("boardCont") String boardCont,
            @RequestParam(value = "boardImage", required = false) MultipartFile boardImage,
            @RequestParam(value = "isbn", required = false) String isbn,
            @RequestParam(value = "bookTitle", required = false) String bookTitle,
            @RequestParam(value = "bookAuthor", required = false) String bookAuthor,
            @RequestParam(value = "bookImgUrl", required = false) String bookImgUrl,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        // 1. 로그인 확인
        MemberVO loginMember = (MemberVO) session.getAttribute("loginSess");
        if (loginMember == null) {
            return "redirect:/login";
        }

        Long memberSeq = loginMember.getMember_seq();

        // 2. 권한 체크 (모임장 OR JOINED 멤버)
        BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);
        if (bookClub == null || bookClub.getBook_club_deleted_dt() != null) {
            log.warn("종료된 모임 게시글 작성 시도: bookClubId={}, memberSeq={}", bookClubId, memberSeq);
            redirectAttributes.addFlashAttribute("errorMessage", "존재하지 않거나 종료된 모임입니다.");
            return "redirect:/bookclubs";
        }

        boolean isLeader = bookClub.getBook_club_leader_seq().equals(memberSeq);
        boolean isMember = bookClubService.isMemberJoined(bookClubId, memberSeq);

        if (!isLeader && !isMember) {
            redirectAttributes.addFlashAttribute("errorMessage", "게시글을 작성할 권한이 없습니다.");
            return "redirect:/bookclubs/" + bookClubId;
        }

        // 3. 필수 입력값 검증
        if (boardTitle == null || boardTitle.isBlank()) {
            redirectAttributes.addFlashAttribute("errorMessage", "제목을 입력해주세요.");
            return "redirect:/bookclubs/" + bookClubId + "/posts";
        }

        if (boardCont == null || boardCont.isBlank()) {
            redirectAttributes.addFlashAttribute("errorMessage", "내용을 입력해주세요.");
            return "redirect:/bookclubs/" + bookClubId + "/posts";
        }

        // 4. 이미지 파일 처리
        String savedImageUrl = null;
        if (boardImage != null && !boardImage.isEmpty()) {
            try {
                String savedFileName = saveFile(boardImage);
                savedImageUrl = "/img/" + savedFileName;
                log.info("Board image saved: {}", savedFileName);
            } catch (IOException e) {
                log.error("Failed to save board image", e);
                redirectAttributes.addFlashAttribute("errorMessage", "이미지 업로드에 실패했습니다.");
                return "redirect:/bookclubs/" + bookClubId + "/posts";
            }
        }

        // 5. VO 생성 및 INSERT
        BookClubBoardVO boardVO = new BookClubBoardVO();
        boardVO.setBook_club_seq(bookClubId);
        boardVO.setMember_seq(memberSeq);
        boardVO.setBoard_title(boardTitle);
        boardVO.setBoard_cont(boardCont);
        boardVO.setBoard_img_url(savedImageUrl);
        // 책 정보 (선택사항)
        boardVO.setIsbn(isbn);
        boardVO.setBook_title(bookTitle);
        boardVO.setBook_author(bookAuthor);
        boardVO.setBook_img_url(bookImgUrl);

        Long newPostId = bookClubService.createBoardPost(boardVO);

        // 6. 성공 시 게시글 상세 페이지로 리다이렉트
        redirectAttributes.addFlashAttribute("successMessage", "게시글이 등록되었습니다.");
        return "redirect:/bookclubs/" + bookClubId + "/posts/" + newPostId;
    }

    /**
     * 게시글 수정 폼 페이지
     * GET /bookclubs/{bookClubId}/posts/{postId}/edit
     * - 로그인 필수
     * - 작성자만 접근 가능
     */
    @GetMapping("/{bookClubId}/posts/{postId}/edit")
    public String editPostForm(
            @PathVariable("bookClubId") Long bookClubId,
            @PathVariable("postId") Long postId,
            HttpSession session,
            Model model) {

        // 1. 로그인 확인
        MemberVO loginMember = (MemberVO) session.getAttribute("loginSess");
        if (loginMember == null) {
            return "redirect:/login";
        }

        Long memberSeq = loginMember.getMember_seq();

        // 2. 게시글 조회
        BookClubBoardVO post = bookClubService.getBoardDetail(bookClubId, postId);
        if (post == null) {
            model.addAttribute("errorMessage", "게시글을 찾을 수 없거나 삭제되었습니다.");
            return "error/404";
        }

        // 3. 작성자 확인 (수정은 작성자만 가능)
        if (!post.getMember_seq().equals(memberSeq)) {
            model.addAttribute("errorMessage", "수정 권한이 없습니다.");
            return "bookclub/bookclub_post_forbidden";
        }

        // 4. 모임 정보 조회
        BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);
        model.addAttribute("bookClub", bookClub);
        model.addAttribute("bookClubId", bookClubId);
        model.addAttribute("post", post);
        model.addAttribute("isEdit", true);

        return "bookclub/bookclub_posts_edit";
    }

    /**
     * 게시글 수정 처리 (PRG 패턴)
     * POST /bookclubs/{bookClubId}/posts/{postId}/edit
     * - 로그인 필수
     * - 작성자만 수정 가능
     */
    @PostMapping("/{bookClubId}/posts/{postId}/edit")
    public String editPost(
            @PathVariable("bookClubId") Long bookClubId,
            @PathVariable("postId") Long postId,
            @RequestParam("boardTitle") String boardTitle,
            @RequestParam("boardCont") String boardCont,
            @RequestParam(value = "boardImage", required = false) MultipartFile boardImage,
            @RequestParam(value = "keepExistingImage", required = false) String keepExistingImage,
            @RequestParam(value = "isbn", required = false) String isbn,
            @RequestParam(value = "bookTitle", required = false) String bookTitle,
            @RequestParam(value = "bookAuthor", required = false) String bookAuthor,
            @RequestParam(value = "bookImgUrl", required = false) String bookImgUrl,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        // 1. 로그인 확인
        MemberVO loginMember = (MemberVO) session.getAttribute("loginSess");
        if (loginMember == null) {
            return "redirect:/login";
        }

        Long memberSeq = loginMember.getMember_seq();

        // 2. 게시글 조회
        BookClubBoardVO existingPost = bookClubService.getBoardDetail(bookClubId, postId);
        if (existingPost == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "게시글을 찾을 수 없거나 삭제되었습니다.");
            return "redirect:/bookclubs/" + bookClubId;
        }

        // 3. 작성자 확인 (수정은 작성자만 가능)
        if (!existingPost.getMember_seq().equals(memberSeq)) {
            redirectAttributes.addFlashAttribute("errorMessage", "수정 권한이 없습니다.");
            return "redirect:/bookclubs/" + bookClubId + "/posts/" + postId;
        }

        // 4. 필수 입력값 검증
        if (boardTitle == null || boardTitle.isBlank()) {
            redirectAttributes.addFlashAttribute("errorMessage", "제목을 입력해주세요.");
            return "redirect:/bookclubs/" + bookClubId + "/posts/" + postId + "/edit";
        }

        if (boardCont == null || boardCont.isBlank()) {
            redirectAttributes.addFlashAttribute("errorMessage", "내용을 입력해주세요.");
            return "redirect:/bookclubs/" + bookClubId + "/posts/" + postId + "/edit";
        }

        // 5. 이미지 파일 처리
        String savedImageUrl = existingPost.getBoard_img_url(); // 기존 이미지 유지 기본값

        if (boardImage != null && !boardImage.isEmpty()) {
            // 새 이미지 업로드
            try {
                String savedFileName = saveFile(boardImage);
                savedImageUrl = "/img/" + savedFileName;
                log.info("Board image updated: {}", savedFileName);
            } catch (IOException e) {
                log.error("Failed to save board image", e);
                redirectAttributes.addFlashAttribute("errorMessage", "이미지 업로드에 실패했습니다.");
                return "redirect:/bookclubs/" + bookClubId + "/posts/" + postId + "/edit";
            }
        } else if (!"true".equals(keepExistingImage)) {
            // 기존 이미지 삭제 요청 (새 이미지 없고, 기존 유지 체크도 안 한 경우)
            savedImageUrl = null;
        }

        // 6. VO 생성 및 UPDATE
        BookClubBoardVO boardVO = new BookClubBoardVO();
        boardVO.setBook_club_seq(bookClubId);
        boardVO.setBook_club_board_seq(postId);
        boardVO.setBoard_title(boardTitle);
        boardVO.setBoard_cont(boardCont);
        boardVO.setBoard_img_url(savedImageUrl);
        // 책 정보 (선택사항)
        boardVO.setIsbn(isbn);
        boardVO.setBook_title(bookTitle);
        boardVO.setBook_author(bookAuthor);
        boardVO.setBook_img_url(bookImgUrl);

        boolean updated = bookClubService.updateBoardPost(boardVO);

        if (updated) {
            redirectAttributes.addFlashAttribute("successMessage", "게시글이 수정되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "게시글 수정에 실패했습니다.");
        }

        return "redirect:/bookclubs/" + bookClubId + "/posts/" + postId;
    }

    /**
     * 게시글 삭제 처리 (PRG 패턴)
     * POST /bookclubs/{bookClubId}/posts/{postId}/delete
     * - 로그인 필수
     * - 작성자 또는 모임장만 삭제 가능
     */
    @PostMapping("/{bookClubId}/posts/{postId}/delete")
    public String deletePost(
            @PathVariable("bookClubId") Long bookClubId,
            @PathVariable("postId") Long postId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        // 1. 로그인 확인
        MemberVO loginMember = (MemberVO) session.getAttribute("loginSess");
        if (loginMember == null) {
            return "redirect:/login";
        }

        Long memberSeq = loginMember.getMember_seq();

        // 2. 모임 조회
        BookClubVO bookClub = bookClubService.getBookClubById(bookClubId);
        if (bookClub == null || bookClub.getBook_club_deleted_dt() != null) {
            log.warn("종료된 모임 게시글 삭제 시도: bookClubId={}, postId={}, memberSeq={}", bookClubId, postId, memberSeq);
            redirectAttributes.addFlashAttribute("errorMessage", "존재하지 않거나 종료된 모임입니다.");
            return "redirect:/bookclubs";
        }

        // 3. 게시글 조회
        BookClubBoardVO post = bookClubService.getBoardDetail(bookClubId, postId);
        if (post == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "게시글을 찾을 수 없거나 이미 삭제되었습니다.");
            return "redirect:/bookclubs/" + bookClubId;
        }

        // 4. 삭제 권한 확인 (작성자 OR 모임장)
        boolean isAuthor = post.getMember_seq().equals(memberSeq);
        boolean isLeader = bookClub.getBook_club_leader_seq().equals(memberSeq);

        if (!isAuthor && !isLeader) {
            redirectAttributes.addFlashAttribute("errorMessage", "삭제 권한이 없습니다.");
            return "redirect:/bookclubs/" + bookClubId + "/posts/" + postId;
        }

        // 5. 삭제 처리 (soft delete)
        boolean deleted = bookClubService.deleteBoardPost(bookClubId, postId);

        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "게시글이 삭제되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "게시글 삭제에 실패했습니다.");
        }

        // 6. 게시판 목록으로 리다이렉트
        return "redirect:/bookclubs/" + bookClubId;
    }
}
