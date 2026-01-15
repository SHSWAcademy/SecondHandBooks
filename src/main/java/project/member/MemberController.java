package project.member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

@Controller
@Slf4j
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    @Value("${api.kakao.client.id}")
    private String kakaoClientId;

    @Value("${api.kakao.redirect.uri}")
    private String kakaoRedirectUri;


    @GetMapping("/login")
    public String login() {
        return "member/login";
    }

    @PostMapping("/login")
    public String login(MemberVO vo, Model model, HttpSession sess) {
        MemberVO memberVO = memberService.login(vo);
        if (memberVO == null) {
            model.addAttribute("msg", "아이디 또는 비밀번호가 올바르지 않습니다.");
            model.addAttribute("cmd", "back");
            return "common/return";
        } else {
            System.out.println("로그인 성공");
            sess.setAttribute("loginSess", memberVO);
            return "redirect:/";
        }
    }

    @GetMapping("/signup")
    public String signup() {
        return "member/signup";
    }
    @PostMapping("/auth/signup")
    public String signUp(MemberVO vo, Model model) {
        boolean result = memberService.signUp(vo);
        if (result) {
            model.addAttribute("msg", "회원가입 되었습니다.");
            model.addAttribute("cmd", "move");
            model.addAttribute("url", "/login");
        } else {
            model.addAttribute("msg", "회원가입에 실패했습니다.");
            model.addAttribute("cmd", "back");
        }
        return "common/return";
    }

    @GetMapping("/auth/kakao/callback")
    public String kakaoCallBack(@RequestParam String code, HttpSession sess) {
        // 엑세스 토큰 받기
        String accessToken = getKakaoAccessToken(code);

        // 사용자 정보 받기
        MemberVO kakaoUser = getKakaoUserInfo(accessToken);

        // 로그인/회원가입 처리 서비스 호출 (소셜 ID 포함)
        MemberVO loginUser = memberService.processSocialLogin("KAKAO", kakaoUser.getLogin_id(), kakaoUser);

        // 세션 저장 및 이동
        sess.setAttribute("loginSess", loginUser);
        return "redirect:/";
    }

    @GetMapping("/auth/ajax/idCheck")
    @ResponseBody
    public int idCheck(@RequestParam String login_id) {
        return memberService.idCheck(login_id);
    }

    @GetMapping("/auth/ajax/emailCheck")
    @ResponseBody
    public int emailCheck(@RequestParam String member_email) {
        return memberService.emailCheck(member_email);
    }

    @GetMapping("/auth/ajax/nicknmCheck")
    @ResponseBody
    public int nicknmCheck(@RequestParam String member_nicknm) {
        return memberService.nickNmCheck(member_nicknm);
    }
}
