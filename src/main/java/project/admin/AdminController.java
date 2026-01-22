package project.admin;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import project.bookclub.vo.BookClubVO;
import project.member.MemberVO;
import project.trade.TradeVO;

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

    // 로그인/로그아웃 로직 (기존 유지)
    @GetMapping("/login")
    public String loginPage() { return "admin/adminLogin"; }

    @PostMapping("/loginProcess")
    public String loginProcess(@RequestParam String id, @RequestParam String pwd, HttpSession sess) {
        AdminVO admin = adminService.login(id, pwd);
        if (admin != null) {
            sess.setAttribute("adminSess", admin);
            sess.setMaxInactiveInterval(3600);
            return "redirect:/admin";
        }
        return "redirect:/admin/login?error=true";
    }

    @GetMapping("/logout")
    public String logout(HttpSession sess) {
        sess.invalidate();
        return "redirect:/admin/login";
    }
}