
package project.member;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import project.admin.AdminService;
import project.bookclub.vo.BookClubVO;
import project.bookclub.service.BookClubService;
import project.common.LogoutPendingManager;
import project.common.UserType;
import project.util.Const;
import project.util.LoginUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@Slf4j
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;
    private final MailService mailService;
    private final AdminService adminService;
    private final LogoutPendingManager logoutPendingManager;
    private final BookClubService bookClubService;

    // WebClient Bean 주입
    private final WebClient kakaoAuthWebClient; // 토큰 발급용
    private final WebClient kakaoApiWebClient;  // 유저 정보용
    private final WebClient naverAuthWebClient; // 토큰 발급용
    private final WebClient naverApiWebClient;  // 유저 정보용
    // ----------------------------------
    // 카카오 로그인
    // ----------------------------------
    @Value("${api.kakao.client.id}")
    private String kakaoClientId;

    @Value("${api.kakao.redirect.uri}")
    private String kakaoRedirectUri;

    @Value("${api.kakao.client_secret}")
    private String kakaoSecretCode;
    // -----------------------------------

    // -----------------------------------
    // 네이버 로그인
    // -----------------------------------
    @Value("${api.naver.client.id}")
    private String naverClientId;

    @Value("${api.naver.client.secret}")
    private String naverClientSecret;

    @Value("${api.naver.redirect.uri}")
    private String naverRedirectUri;
    // -----------------------------------

    @GetMapping("/login")
    public String login(@RequestParam(required = false) String redirect,
                        Model model, HttpSession session) {      // JSP의 ${kakaoClientId} 등에 전달할 값 설정
        model.addAttribute("kakaoClientId", kakaoClientId);
        model.addAttribute("kakaoRedirectUri", kakaoRedirectUri);

        // 네이버 관련 값 추가
        model.addAttribute("naverClientId", naverClientId);
        model.addAttribute("naverRedirectUri", naverRedirectUri);

        // 로그인 후 리다이렉트할 URL 전달 (일반 로그인용)
        if (redirect != null && LoginUtil.isValidRedirectUrl(redirect)) {
            model.addAttribute("redirect", redirect);
            // OAuth 로그인용으로 세션에도 저장
            session.setAttribute(LoginUtil.REDIRECT_SESSION_KEY, redirect);
        }

        return "member/login";
    }

    @PostMapping("/login")
    public String login(MemberVO vo, Model model,
                        @RequestParam(required = false) String redirect,
                        HttpSession sess, HttpServletRequest request) {
        MemberVO memberVO = memberService.login(vo);
        if (memberVO == null) {
            model.addAttribute("msg", "아이디 또는 비밀번호가 올바르지 않습니다.");
            model.addAttribute("cmd", "back");
            return "common/return";
        } else {
            sess.removeAttribute("adminSess");

            System.out.println("로그인 성공");
            sess.setAttribute("loginSess", memberVO);

            logoutPendingManager.removeForceLogout(UserType.MEMBER, memberVO.getMember_seq());

            boolean logUpdate = memberService.loginLogUpdate(memberVO.getMember_seq());

            // admin 로그 기록
            String loginIp = getClientIP(request);
            adminService.recordMemberLogin(memberVO.getMember_seq(), loginIp);
            if (logUpdate) {
                System.out.println("로그 찍기 성공");
            } else {
                System.out.println("로그 찍기 실패");
            }

            // 세션에 저장된 redirect URL 제거
            sess.removeAttribute(LoginUtil.REDIRECT_SESSION_KEY);

            // 로그인 후 원래 페이지로 리다이렉트
            String redirectUrl = LoginUtil.getRedirectUrl(redirect, "/");
            return "redirect:" + redirectUrl;
        }
    }
//    @GetMapping("/logout")
//    public String logout(HttpSession sess) {
//        // 세션에 저장된 모든 데이터 삭제 (loginSess 포함)
//        sess.invalidate();
//
//        log.info("로그아웃 성공 - 세션 만료됨");
//
//        // 메인 화면으로 리다이렉트
//        return "redirect:/";
//    }
    @GetMapping("/logout")
    public String logout(HttpSession sess, Model model, HttpServletRequest request) {

        MemberVO memberVO = (MemberVO) sess.getAttribute(Const.SESSION);

        if (memberVO != null) {
            String logoutIp = getClientIP(request);
            adminService.recordMemberLogout(memberVO.getMember_seq(), logoutIp);
        }
        // 1. 세션 삭제
        sess.invalidate();

        // 2. 알림창 메시지와 이동할 주소 설정
        model.addAttribute("msg", "로그아웃 되었습니다.");
        model.addAttribute("url", "/");
        model.addAttribute("cmd", "move");

        return "common/return";
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

    // --- 카카오 로그인 콜백 (WebClient 적용) ---
    @GetMapping("/auth/kakao/callback")
    public String kakaoCallBack(@RequestParam String code, HttpSession sess,
                                Model model, HttpServletRequest request) {
        log.info("Kakao Login Code: {}", code); // kakao login

        // 1. 액세스 토큰 받기 (WebClient)
        String accessToken = getKakaoAccessTokenWebClient(code);

        if (accessToken == null || accessToken.isEmpty()) {
            model.addAttribute("msg", "카카오 토큰 발급 실패");
            model.addAttribute("cmd", "back");
            return "common/return";
        }

        // 2. 사용자 정보 받기 (WebClient)
        Map<String, Object> kakaoUserInfo = getKakaoUserInfoWebClient(accessToken);
        if (kakaoUserInfo == null) {
            model.addAttribute("msg", "카카오 사용자 정보 조회 실패");
            model.addAttribute("cmd", "back");
            return "common/return";
        }

        // 3. 서비스 처리 (공통)
        return processSocialLoginCommon(kakaoUserInfo, sess, model, request);
    }

    // [Helper] 카카오 토큰 발급 (WebClient)
    private String getKakaoAccessTokenWebClient(String code) {
        try {
            // WebClient는 불변 객체이므로 mutate()나 기존 설정을 활용
            // kakaoAuthWebClient는 baseUrl이 https://kauth.kakao.com 으로 설정됨
            String responseBody = kakaoAuthWebClient.post()
                    .uri("/oauth/token")
                    .body(BodyInserters.fromFormData("grant_type", "authorization_code")
                            .with("client_id", kakaoClientId)
                            .with("redirect_uri", kakaoRedirectUri)
                            .with("code", code)
                            .with("client_secret", kakaoSecretCode))
                    .retrieve()
                    .bodyToMono(String.class)
                    .block(); // 동기 처리

            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode jsonNode = objectMapper.readTree(responseBody);
            return jsonNode.get("access_token").asText();

        } catch (Exception e) {
            log.error("Kakao Token WebClient Error", e);
            return null;
        }
    }

    // [Helper] 카카오 유저 정보 (WebClient)
    private Map<String, Object> getKakaoUserInfoWebClient(String accessToken) {
        try {
            // kakaoApiWebClient는 baseUrl이 https://kapi.kakao.com 으로 설정됨
            String responseBody = kakaoApiWebClient.post()
                    .uri("/v2/user/me")
                    .header("Authorization", "Bearer " + accessToken)
                    // Content-Type은 Config에서 defaultHeader로 설정됨
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();

            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode root = objectMapper.readTree(responseBody);

            String id = root.get("id").asText();
            String nickname = root.path("kakao_account").path("profile").path("nickname").asText();
            String email = root.path("kakao_account").path("email").asText();

            Map<String, Object> userInfo = new HashMap<>();
            userInfo.put("provider_id", id);
            userInfo.put("provider", "KAKAO");
            userInfo.put("nickname", nickname);
            userInfo.put("email", email);

            return userInfo;

        } catch (Exception e) {
            log.error("Kakao UserInfo WebClient Error", e);
            return null;
        }
    }

    // --- 네이버 로그인 콜백 (WebClient 적용) ---
    @GetMapping("/auth/naver/callback")
    public String naverCallBack(
            @RequestParam(required = false) String code,
            @RequestParam(required = false) String state,
            @RequestParam(required = false) String error,
            @RequestParam(required = false) String error_description,
            HttpSession sess, Model model, HttpServletRequest request) {

        if ("access_denied".equals(error)) {
            model.addAttribute("msg", "네이버 로그인 취소");
            model.addAttribute("url", "/login");
            model.addAttribute("cmd", "move");
            return "common/return";
        }

        // 1. 액세스 토큰 받기 (WebClient)
        String accessToken = getNaverAccessTokenWebClient(code, state);
        if (accessToken == null) {
            model.addAttribute("msg", "네이버 토큰 발급 실패");
            model.addAttribute("cmd", "back");
            return "common/return";
        }

        // 2. 사용자 정보 받기 (WebClient)
        Map<String, Object> naverUserInfo = getNaverUserInfoWebClient(accessToken);
        if (naverUserInfo == null) {
            model.addAttribute("msg", "네이버 사용자 정보 조회 실패");
            model.addAttribute("cmd", "back");
            return "common/return";
        }

        // 3. 서비스 처리 (공통)
        return processSocialLoginCommon(naverUserInfo, sess, model, request);
    }

    // [Helper] 네이버 토큰 발급 (WebClient)
    private String getNaverAccessTokenWebClient(String code, String state) {
        try {
            // naverAuthWebClient는 baseUrl이 https://nid.naver.com 으로 설정됨
            // 네이버 토큰 발급은 GET 방식도 가능하지만 POST 권장 시 폼 데이터 사용 가능.
            // 여기서는 쿼리 파라미터로 전송 (네이버 가이드 기준)

            String responseBody = naverAuthWebClient.get()
                    .uri(uriBuilder -> uriBuilder
                            .path("/oauth2.0/token")
                            .queryParam("grant_type", "authorization_code")
                            .queryParam("client_id", naverClientId)
                            .queryParam("client_secret", naverClientSecret)
                            .queryParam("code", code)
                            .queryParam("state", state)
                            .build())
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();

            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode jsonNode = objectMapper.readTree(responseBody);
            return jsonNode.get("access_token").asText();

        } catch (Exception e) {
            log.error("Naver Token WebClient Error", e);
            return null;
        }
    }

    // [Helper] 네이버 유저 정보 (WebClient)
    private Map<String, Object> getNaverUserInfoWebClient(String accessToken) {
        try {
            // naverApiWebClient는 baseUrl이 https://openapi.naver.com 으로 설정됨
            String responseBody = naverApiWebClient.get()
                    .uri("/v1/nid/me")
                    .header("Authorization", "Bearer " + accessToken)
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();

            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode root = objectMapper.readTree(responseBody);
            JsonNode responseNode = root.get("response");

            Map<String, Object> userInfo = new HashMap<>();
            userInfo.put("provider_id", responseNode.get("id").asText());
            userInfo.put("provider", "NAVER");
            userInfo.put("nickname", responseNode.get("nickname").asText());
            userInfo.put("email", responseNode.get("email").asText());

            return userInfo;

        } catch (Exception e) {
            log.error("Naver UserInfo WebClient Error", e);
            return null;
        }
    }

    // [Common] 소셜 로그인 후처리 로직 공통화
    private String processSocialLoginCommon(Map<String, Object> userInfo, HttpSession sess, Model model, HttpServletRequest request) {
        try {
            MemberVO memberVO = memberService.processSocialLogin(userInfo);

            if (memberVO == null) {
                // 탈퇴 회원인 경우 (서비스 로직에 따라 null 반환 시)
                model.addAttribute("msg", "탈퇴한 유저입니다. 재가입이 불가능합니다.");
                model.addAttribute("url", "/login");
                model.addAttribute("cmd", "move");
                return "common/return";
            }

            // 로그인 성공 처리
            sess.setAttribute("loginSess", memberVO);
            logoutPendingManager.removeForceLogout(UserType.MEMBER, memberVO.getMember_seq());
            memberService.loginLogUpdate(memberVO.getMember_seq());

            // 관리자 로그 기록
            String loginIp = getClientIP(request);
            adminService.recordMemberLogin(memberVO.getMember_seq(), loginIp);


            // 세션에 저장된 redirect URL로 리다이렉트
            String redirect = (String) sess.getAttribute(LoginUtil.REDIRECT_SESSION_KEY);
            sess.removeAttribute(LoginUtil.REDIRECT_SESSION_KEY);
            String redirectUrl = LoginUtil.getRedirectUrl(redirect, "/");
            return "redirect:" + redirectUrl;

        } catch (Exception e) {
            log.error("Social Login Process Error", e);
            return "error/500";
        }
    }

    @GetMapping("/auth/ajax/sendEmail")
    @ResponseBody
    public String sendEmail(@RequestParam String email) {
        boolean isSent = mailService.sendAuthEmail(email);
        return isSent ? "success" : "fail";
    }

    @GetMapping("/auth/ajax/checkEmailCode")
    @ResponseBody
    public boolean checkEmailCode(@RequestParam String email, @RequestParam String code) {
        return mailService.verifyEmailCode(email, code);
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

    // 프로필 페이지 기능
    // 회원 정보 수정
    @PostMapping("/member/update")
    public String updateMember(MemberVO vo, HttpSession sess, Model model) {
        // 1. 세션에서 로그인 중인 유저 정보 가져오기
        MemberVO loginUser = (MemberVO) sess.getAttribute("loginSess");

        if (loginUser == null) {
            return LoginUtil.redirectToLogin();
        }

        // 2. pk(seq) 설정
        vo.setMember_seq(loginUser.getMember_seq());

        vo.setMember_email(loginUser.getMember_email()); // 이메일 수정 방지
        // 3. DB 업데이트
        boolean result = memberService.updateMember(vo);
        if (result) {
            // 4. 업데이트 성공 시 세션 정보도 최신화
            loginUser.setMember_nicknm(vo.getMember_nicknm());
//          loginUser.setMember_email(vo.getMember_email()); // 이메일은 변경되지 않았으므로 그대로 두기
            loginUser.setMember_tel_no(vo.getMember_tel_no());
            sess.setAttribute("loginSess", loginUser); // 세션 갱신

            model.addAttribute("msg", "회원 정보가 수정되었습니다.");
            model.addAttribute("url", "/mypage");
            model.addAttribute("cmd", "move");
        } else {
            model.addAttribute("msg", "정보 수집에 실패했습니다.");
            model.addAttribute("cmd", "back");
        }
        return "common/return";
    }

    // 회원 탈퇴 처리
    @GetMapping("/member/delete")
    public String deleteMember(HttpSession sess, Model model) {
        MemberVO loginUser = (MemberVO) sess.getAttribute("loginSess");

        if (loginUser == null) {
            return LoginUtil.redirectToLogin();
        }

        // SOFT DELETE 수행
        boolean result = memberService.deleteMember(loginUser.getMember_seq());

        if (result) {
            sess.invalidate(); // 탈퇴 성공 시 세션 전체 삭제 (로그아웃)
            model.addAttribute("msg", "회원 탈퇴가 완료되었습니다.");
            model.addAttribute("url", "/");
            model.addAttribute("cmd", "move");
        } else {
            model.addAttribute("msg", "탈퇴 처리에 실패했습니다.");
            model.addAttribute("cmd", "back");
        }
        return "common/return";
    }

    // Address 보여주기
    @GetMapping("/profile/tab/addresses")
    public String tabAddresses() {
        return "member/tabs/addresses";
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

    @GetMapping("/findAccount")
    public String findAccountPage() {
        return "member/findAccount";
    }

    // 세션 체크 API (로그인 페이지 뒤로가기 처리용)
    @GetMapping("/api/session-check")
    @ResponseBody
    public Map<String, Object> sessionCheck(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        MemberVO member = (MemberVO) session.getAttribute("loginSess");
        result.put("loggedIn", member != null);
        return result;
    }

    // [AJAX] 아이디 찾기 (전화번호 이용)
    @PostMapping("/auth/ajax/findId")
    @ResponseBody
    public String findId(@RequestParam String member_tel_no) {
        String foundId = memberService.findIdByTel(member_tel_no);
        return (foundId != null) ? foundId : "fail";
    }

    // [AJAX] 비밀번호 찾기 - 인증번호 전송
    @PostMapping("/auth/ajax/sendPwdAuth")
    @ResponseBody
    public String sendPwdAuth(@RequestParam String login_id, @RequestParam String member_email) {
        // 1. 해당 아이디와 이메일이 일치하는 회원이 있는지 확인
        boolean exists = memberService.checkUserByIdAndEmail(login_id, member_email);

        if (exists) {
            // 2. 존재하면 메일 전송
            boolean sent = mailService.sendPwdResetEmail(member_email);
            return sent ? "success" : "fail";
        } else {
            return "fail";
        }
    }

    // [AJAX] 비밀번호 찾기 - 인증번호 검증
    @PostMapping("/auth/ajax/verifyPwdAuth")
    @ResponseBody
    public boolean verifyPwdAuth(@RequestParam String member_email, @RequestParam String auth_code) {
        return mailService.verifyEmailCode(member_email, auth_code);
    }

    // [AJAX] 비밀번호 재설정
    @PostMapping("/auth/ajax/resetPassword")
    @ResponseBody
    public String resetPassword(@RequestParam String login_id, @RequestParam String new_pwd) {
        return memberService.resetPassword(login_id, new_pwd);
    }

}

