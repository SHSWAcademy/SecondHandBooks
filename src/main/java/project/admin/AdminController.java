package project.admin;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

    private final AdminService adminService;

    // 1. 관리자 대시보드 (접근 제한)
    @GetMapping("")
    public String dashboard(HttpSession sess) {
        // 관리자 세션 체크 (adminSess)
        AdminVO admin = (AdminVO) sess.getAttribute("adminSess");

        if (admin == null) {
            // 로그인 안 되어 있으면 로그인 페이지로 리다이렉트
            return "redirect:/admin/login";
        }

        // 로그인 되어 있으면 대시보드 JSP 리턴
        return "admin/dashboard";
    }

    // 2. 로그인 페이지 이동
    @GetMapping("/login")
    public String loginPage() {
        return "admin/adminLogin"; // 로그인 JSP 파일명
    }

    // 3. 로그인 처리 (POST)
    @PostMapping("/loginProcess")
    public String loginProcess(@RequestParam String id,
                               @RequestParam String pwd,
                               HttpSession sess) {

        AdminVO admin = adminService.login(id, pwd);

        if (admin != null) {
            // 로그인 성공 -> 세션에 'adminSess' 저장
            sess.setAttribute("adminSess", admin);
            sess.setMaxInactiveInterval(60 * 60); // 1시간 유지
            return "redirect:/admin";
        } else {
            // 로그인 실패 -> 다시 로그인 페이지로 (에러 파라미터 전달)
            return "redirect:/admin/login?error=true";
        }
    }

    // 4. 로그아웃
    @GetMapping("/logout")
    public String logout(HttpSession sess) {
        sess.invalidate(); // 세션 전체 삭제
        return "redirect:/admin/login";
    }
}