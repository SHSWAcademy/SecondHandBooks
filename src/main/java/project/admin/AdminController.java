package project.admin;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import project.bookclub.vo.BookClubVO;
import project.member.MemberVO;
import project.trade.TradeVO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

    private final AdminService adminService;

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
    public List<MemberVO> getUsers(@RequestParam(required = false) String status,
                                   @RequestParam(required = false) String keyword) {
        return adminService.searchMembers(status, keyword);
    }

    // [API] 회원 액션
    @PatchMapping("/api/users")
    @ResponseBody
    public String updateUserStatus(@RequestBody Map<String, Object> body) {
        Long seq = Long.valueOf(body.get("seq").toString());
        String action = (String) body.get("action");
        adminService.handleMemberAction(seq, action);
        return "ok";
    }

    // [API] 상품 목록
    @GetMapping("/api/trades")
    @ResponseBody
    public List<TradeVO> getTrades(@RequestParam(required = false) String status,
                                   @RequestParam(required = false) String keyword) {
        return adminService.searchTrades(status, keyword);
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

    // [API] 모임 목록
    @GetMapping("/api/clubs")
    @ResponseBody
    public List<BookClubVO> getClubs(@RequestParam(required = false) String keyword) {
        return adminService.searchBookClubs(keyword);
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
    public String loginPage() {
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
            sess.setAttribute("adminSess", admin);
            sess.setMaxInactiveInterval(60 * 60); // 1시간

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
        return "redirect:/admin/login";
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
}