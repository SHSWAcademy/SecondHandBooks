package project.member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
@Slf4j
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    @GetMapping("/login/signup")
    public void signup() {

    }

    @PostMapping("/auth/signup")
    public String signUp(MemberVO vo, Model model) {
        boolean result = memberService.signUp(vo);


        return null;
    }
}
