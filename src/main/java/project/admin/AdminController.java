package project.admin;

import lombok.RequiredArgsConstructor;
import lombok.extern.java.Log;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import project.admin.notice.NoticeVO;
import project.bookclub.service.BookClubService;
import project.bookclub.vo.BookClubVO;
import project.common.LogoutPendingManager;
import project.common.UserType;
import project.member.MemberVO;
import project.trade.TradeService;
import project.trade.TradeVO;
import project.util.paging.PageResult;
import project.util.paging.SearchVO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

    private final AdminService adminService;
    private final BookClubService bookClubService;
    private final TradeService tradeService;
    private final LogoutPendingManager logoutPendingManager;

    // 대시보드 뷰
    @GetMapping("")
    public String dashboard(HttpSession sess, Model model) {

        try {
            AdminVO admin = (AdminVO) sess.getAttribute("adminSess");
            if (admin == null) return "redirect:/admin/login";

            model.addAttribute("memberCount", adminService.countAllMembers());
            model.addAttribute("tradeCount", adminService.countAllTrades());
            model.addAttribute("clubCount", adminService.countAllBookClubs());

            // 2. 목록 (테이블 데이터)
            model.addAttribute("members", adminService.getRecentMembers());
            model.addAttribute("trades", adminService.getRecentTrades());
            model.addAttribute("clubs", adminService.getRecentBookClubs());

            // 3. 로그 데이터
            model.addAttribute("userLogs", adminService.getMemberLoginLogs());
            model.addAttribute("adminLogs", adminService.getAdminLoginLogs());

            // 4. 공지사항 목록 추가
            model.addAttribute("notices", adminService.selectNotices());

            // 5. 안전결제 데이터 추가
            model.addAttribute("safePayList", tradeService.safePayList());
            return "admin/dashboard";
        } catch (Exception e) {
            e.printStackTrace();
            return "500";
        }
    }

    // [API] 차트 데이터 (NEW)
    @GetMapping("/api/stats")
    @ResponseBody
    public Map<String, Object> getStats() {
        return adminService.getChartData();
    }

    // [API] 회원 목록
    @GetMapping("/api/users")
    @ResponseBody
    public PageResult<MemberVO> getUsers(SearchVO searchVO) {
        List<MemberVO> list = adminService.searchMembers(searchVO);

        int total = adminService.countAllMembersBySearch(searchVO);
        return new PageResult<>(list, total, searchVO.getPage(), searchVO.getSize());
    }

//    // [API] 회원 액션
//    @PatchMapping("/api/users")
//    @ResponseBody
//    public String updateUserStatus(@RequestBody Map<String, Object> body) {
//        Long seq = Long.valueOf(body.get("seq").toString());
//        String action = (String) body.get("action");
//        adminService.handleMemberAction(seq, action);
//        return "ok";
//    }

    // [API] 회원 액션 (BAN / ACTIVE / DELETE)
    @PatchMapping("/api/users")
    @ResponseBody
    public String updateUserStatus(@RequestBody Map<String, Object> body) {
        try {
            Long seq = Long.valueOf(body.get("seq").toString());
            String action = (String) body.get("action");
            adminService.handleMemberAction(seq, action);
            return "ok";
        } catch (Exception e) {
            log.error("회원 상태 변경 오류", e);
            return "error";
        }
    }

    // [API] 상품 목록
    @GetMapping("/api/trades")
    @ResponseBody
    public PageResult<TradeVO> getTrades(SearchVO searchVO) {
        List<TradeVO> list = adminService.searchTrades(searchVO);

        int total = adminService.countAllTradesBySearch(searchVO);
        return new PageResult<>(list, total, searchVO.getPage(), searchVO.getSize());
    }

    // [API] 상품 액션
    @PatchMapping("/api/trades")
    @ResponseBody
    public String updateTradeStatus(@RequestBody Map<String, Object> body) {
        Long seq = Long.valueOf(body.get("seq").toString());
        String action = (String) body.get("action");
        adminService.handleTradeAction(seq, action);
        return "ok";
    }

    // [API] 안전결제 내역
    @GetMapping("/api/safepaylist")
    @ResponseBody
    public PageResult<TradeVO> getSafePayList(SearchVO searchVO) {
        List<TradeVO> list = adminService.searchSafePayList(searchVO);

        int total = adminService.countAllSafePayListBySearch(searchVO);
        return new PageResult<>(list, total, searchVO.getPage(), searchVO.getSize());
    }

    // [API] 모임 목록
    @GetMapping("/api/clubs")
    @ResponseBody
    public PageResult<BookClubVO> getClubs(SearchVO searchVO) {
        List<BookClubVO> list = adminService.searchBookClubs(searchVO);

        int total = adminService.countAllGroupsBySearch(searchVO);

        return new PageResult<>(list, total, searchVO.getPage(), searchVO.getSize());
    }

    // [API] 모임 삭제
    @PatchMapping("/api/clubs")
    @ResponseBody
    public String updateClubStatus(@RequestBody Map<String, Object> body) {
        Long seq = Long.valueOf(body.get("seq").toString());
        String action = (String) body.get("action");
        if ("DELETE".equals(action)) adminService.deleteBookClub(seq);
        return "ok";
    }

    // 2. 로그인 페이지 이동
    @GetMapping("/login")
    public String loginPage(@RequestParam(required = false) String code1,
                            @RequestParam(required = false) String code2,
                            @RequestParam(required = false) String error,
                            Model model) {

        if ("true".equals(error)) {
            model.addAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "admin/adminLogin";
        }
        if (!("qorhqtlrp".equals(code1) && "rptlrhqqo".equals(code2))) {
            return "error/400";
        }

        return "admin/adminLogin";
    }

    // 3. 로그인 처리
    @PostMapping("/loginProcess")
    public String loginProcess(@RequestParam String id,
                               @RequestParam String pwd,
                               HttpSession sess,
                               HttpServletRequest request) {
        AdminVO admin = adminService.login(id, pwd);

        if (admin != null) {
            logoutPendingManager.removeForceLogout(UserType.ADMIN, admin.getAdmin_seq());

            sess.removeAttribute("loginSess");

            sess.setAttribute("adminSess", admin);
            sess.setMaxInactiveInterval(30 * 60); // 1시간

            // 로그인 기록 추가
            String loginIp = getClientIP(request);
            adminService.recordAdminLogin(admin.getAdmin_seq(), loginIp);
            return "redirect:/admin";
        } else {
            return "redirect:/admin/login?error=true";
        }
    }


    // 4. 로그아웃
    @GetMapping("/logout")
    public String logout(HttpSession sess, HttpServletRequest request) {
        AdminVO admin = (AdminVO) sess.getAttribute("adminSess");

        // 로그아웃 기록 추가
        if (admin != null) {
            String logoutIp = getClientIP(request);
            adminService.recordAdminLogout(admin.getAdmin_seq(), logoutIp);
        }
        sess.invalidate();
        return "redirect:/";
    }

    @PostMapping("/logout-beacon")
    @ResponseBody
    public void logoutBeacon(HttpSession sess, HttpServletRequest request) {
        AdminVO adminVO = (AdminVO) sess.getAttribute("adminSess");

        if (adminVO != null) {
            log.info("비콘 수신: 관리자 {} 종료 시도", adminVO.getAdmin_login_id());
            String logoutIp = getClientIP(request);
            adminService.recordAdminLogout(adminVO.getAdmin_seq(), logoutIp);
        }

        sess.invalidate();
        log.info("비콘 처리: 세션 무효화 완료");
    }

    //관리자 로그인 로그 목록
    @GetMapping("/api/adminLogs")
    @ResponseBody
    public PageResult<LoginInfoVO> getAdminLogs(SearchVO searchVO) {
        List<LoginInfoVO> list = adminService.searchAdminLoginLogs(searchVO);

        int total = adminService.countAdminLoginLogsBySearch(searchVO);

        return new PageResult<>(list, total, searchVO.getPage(), searchVO.getSize());
    }

    //사용자 로그인 로그목록
    @GetMapping("/api/userLogs")
    @ResponseBody
    public PageResult<LoginInfoVO> getUserLogs(SearchVO searchVO) {
        List<LoginInfoVO> list = adminService.searchUsersLoginLogs(searchVO);

        int total = adminService.countUsersLoginLogsBySearch(searchVO);

        return new PageResult<>(list, total, searchVO.getPage(), searchVO.getSize());
    }
    // 공지사항 폼 이동
    @GetMapping("notice/create")
    public String noticeWriteForm(HttpSession sess, Model model) {

        AdminVO admin = (AdminVO) sess.getAttribute("adminSess");

        if(admin == null) {
            return "redirect:/admin/login";
        }

        model.addAttribute("adminName", admin.getAdmin_login_id());

        return "admin/noticeWriteForm";
    }

    // IP 추출 메서드
    private String getClientIP(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");

        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }

        if (ip != null && ip.indexOf(",") > 0) {
            ip = ip.substring(0, ip.indexOf(","));
        }
        return ip;
    }

    // [API] 배너 목록 조회
    @GetMapping("/api/banners")
    @ResponseBody
    public List<BannerVO> getBanners() {
        return adminService.getBanners();
    }

    // [API] 배너 저장 (추가/수정)
    @PostMapping("/api/banners")
    @ResponseBody
    public String saveBanner(@RequestBody BannerVO banner) {
        adminService.saveBanner(banner);
        return "ok";
    }

    // [API] 배너 삭제
    @DeleteMapping("/api/banners/{seq}")
    @ResponseBody
    public String deleteBanner(@PathVariable Long seq) {
        adminService.deleteBanner(seq);
        return "ok";
    }

    // [API] 임시 페이지 저장
    @PostMapping("/api/pages")
    @ResponseBody
    public Long saveTempPage(@RequestBody Map<String, String> body) {
        String title = body.get("title");
        String content = body.get("content");
        return adminService.saveTempPage(title, content);
    }

    // 공지사항 등록
    @PostMapping("/notices")
    @ResponseBody
    public Map<String, Object> creatNotice(@RequestParam String notice_title,
                                           @RequestParam(required = false) String is_important,
                                           @RequestParam String active,
                                           @RequestParam String notice_cont,
                                           HttpSession sess
    ) {
        Map<String, Object> response = new HashMap<>();

        try {
            AdminVO adminVO = (AdminVO) sess.getAttribute("adminSess");
            if (adminVO == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            NoticeVO noticeVO = new NoticeVO();
            noticeVO.setAdmin_seq(adminVO.getAdmin_seq());
            noticeVO.setNotice_title(notice_title);
            noticeVO.setNotice_cont(notice_cont);

            int priority = "true".equals(is_important) ? 1 : 0;
            noticeVO.setNotice_priority(priority);

            noticeVO.setActive("true".equals(active));

            adminService.insertNotice(noticeVO);

            response.put("success", true);
            response.put("message", "공지사항이 등록되었습니다.");
        } catch (Exception e) {
            log.error("공지사항 등록 실패", e);
            response.put("success", false);
            response.put("message", "등록 중 오류가 발생했습니다." + e.getMessage());
        }
        return response;
    }

    // 공지사항 목록 조회
    @GetMapping("/api/notices")
    @ResponseBody
    public PageResult<NoticeVO> getNotices(SearchVO searchVO) {
        List<NoticeVO> list = adminService.searchNotices(searchVO);

        int total = adminService.countAllNoticesBySearch(searchVO);
        return new PageResult<>(list, total, searchVO.getPage(), searchVO.getSize());
    }

    @GetMapping("/notices/view")
    public String viewNotice(@RequestParam Long notice_seq, Model model) {
        adminService.increaseViewCount(notice_seq);

        NoticeVO noticeVO = adminService.selectNotice(notice_seq);
        model.addAttribute("notice", noticeVO);

        return "admin/tabs/noticeView";
    }

    @DeleteMapping("/notices/delete/{notice_seq}")
    @ResponseBody
    public Map<String, Object> deleteNotice(@PathVariable Long notice_seq) {
        Map<String, Object> response = new HashMap<>();

        try {
            adminService.deleteNotice(notice_seq);
            response.put("success", true);
        } catch (Exception e) {
            log.error("공지사항 삭제 실패", e);
            response.put("success", false);
            response.put("message", e.getMessage());
        }

        return response;
    }

    @GetMapping("/notices/edit")
    public String noticeEditForm(@RequestParam Long notice_seq, Model model, HttpSession sess) {

        NoticeVO noticeVO = adminService.selectNotice(notice_seq);
        model.addAttribute("notice", noticeVO);
        return "admin/tabs/noticeEditForm";
    }

    // 공지사항 수정 API
    @PostMapping("/notices/{notice_seq}")
    @ResponseBody
    public Map<String, Object> updateNotice(
            @PathVariable Long notice_seq,
            @RequestParam String notice_title,
            @RequestParam(required = false) String is_important,
            @RequestParam String active,
            @RequestParam String notice_cont,
            HttpSession sess
    ) {
        Map<String, Object> response = new HashMap<>();

        try {
            AdminVO admin = (AdminVO) sess.getAttribute("adminSess");
            if (admin == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            NoticeVO noticeVO = new NoticeVO();
            noticeVO.setNotice_seq(notice_seq);
            noticeVO.setNotice_title(notice_title);
            noticeVO.setNotice_cont(notice_cont);
            noticeVO.setNotice_priority("true".equals(is_important) ? 1 : 0);
            noticeVO.setActive("true".equals(active));

            adminService.updateNotice(noticeVO);

            response.put("success", true);
            response.put("message", "공지사항이 수정되었습니다.");

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "수정 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    @GetMapping("/bookclubs/{id}")
    public String viewBookClubAsAdmin(@PathVariable Long id,
                                      HttpSession sess,
                                      Model model) {
        AdminVO admin = (AdminVO) sess.getAttribute("adminSess");
        if (admin == null) return "redirect:/admin/login";

        // 기존 BookClubService 메서드 활용
        BookClubVO bookClub = bookClubService.getBookClubById(id);
        // 필요한 추가 데이터 (멤버 수, 찜 수 등)

        model.addAttribute("bookClub", bookClub);
        model.addAttribute("isAdminView", true);

        return "bookclub/bookclub_detail";  // 기존 JSP 재사용
    }

    @GetMapping("/trade/{id}")
    public String viewTradeAsAdmin(@PathVariable Long id,
                                   HttpSession sess,
                                   Model model) {
        AdminVO admin = (AdminVO) sess.getAttribute("adminSess");
        if (admin == null) return "redirect:/admin/login";

        // 기존 TradeService 메서드 활용
        TradeVO trade = tradeService.search(id);

        model.addAttribute("trade", trade);
        model.addAttribute("isAdminView", true);

        return "trade/tradedetail";  // 기존 JSP 재사용
    }
}