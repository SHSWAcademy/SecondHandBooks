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

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@Slf4j
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

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
    public String login(Model model) {
        // JSP의 ${kakaoClientId} 등에 전달할 값 설정
        model.addAttribute("kakaoClientId", kakaoClientId);
        model.addAttribute("kakaoRedirectUri", kakaoRedirectUri);

        // 네이버 관련 값 추가
        model.addAttribute("naverClientId", naverClientId);
        model.addAttribute("naverRedirectUri", naverRedirectUri);

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

    // --- 카카오 로그인 콜백 ---
    @GetMapping("/auth/kakao/callback")
    public String kakaoCallBack(@RequestParam String code, HttpSession sess, Model model) {
        log.info("Kakao Login Code: {}", code); // 1. 코드 수신 확인

        // 1. 엑세스 토큰 받기
        String accessToken = getKakaoAccessToken(code);
        if (accessToken == null || accessToken.isEmpty()) {
            log.error("Failed to get Kakao Access Token"); // 에러 로그
            model.addAttribute("msg", "카카오 토큰 발급에 실패했습니다.");
            model.addAttribute("cmd", "back");
            return "common/return";
        }

        // 2. 사용자 정보 받기
        Map<String, Object> kakaoUserInfo = getKakaoUserInfo(accessToken);
        if (kakaoUserInfo == null || kakaoUserInfo.isEmpty()) {
            log.error("Failed to get Kakao User Info"); // 에러 로그
            model.addAttribute("msg", "카카오 사용자 정보를 가져오지 못했습니다.");
            model.addAttribute("cmd", "back");
            return "common/return";
        }

        // 3. 서비스 호출
        try {
            MemberVO loginUser = memberService.processSocialLogin(kakaoUserInfo);
            sess.setAttribute("loginSess", loginUser);
            return "redirect:/";
        } catch (Exception e) {
            log.error("Kakao Login Error", e); // 스택트레이스 출력
            return "error/500"; // 에러 페이지로 이동
        }
    }

    // [Helper] 카카오 토큰 발급 (디버깅 강화)
    private String getKakaoAccessToken(String code) {
        String tokenUrl = "https://kauth.kakao.com/oauth/token";
        RestTemplate rt = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", kakaoClientId);
        params.add("redirect_uri", kakaoRedirectUri);
        params.add("code", code);
        params.add("client_secret", kakaoSecretCode);

        HttpEntity<MultiValueMap<String, String>> kakaoTokenRequest = new HttpEntity<>(params, headers);

        try {
            // 요청 전송
            ResponseEntity<String> response = rt.exchange(tokenUrl, HttpMethod.POST, kakaoTokenRequest, String.class);

            // 성공 시 토큰 파싱
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode jsonNode = objectMapper.readTree(response.getBody());
            return jsonNode.get("access_token").asText();

        } catch (org.springframework.web.client.HttpClientErrorException e) {
            // ★ 여기가 핵심입니다 ★
            // 카카오가 400/401 에러를 냈을 때 이유를 로그로 출력합니다.
            log.error("Kakao Token Error: {}", e.getResponseBodyAsString());
            e.printStackTrace();
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // [Helper] 사용자 정보 조회 (Map 반환)
    private Map<String, Object> getKakaoUserInfo(String accessToken) {
        String userInfoUrl = "https://kapi.kakao.com/v2/user/me";
        RestTemplate rt = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        HttpEntity<MultiValueMap<String, String>> kakaoProfileRequest = new HttpEntity<>(headers);
        ResponseEntity<String> response = rt.exchange(userInfoUrl, HttpMethod.POST, kakaoProfileRequest, String.class);

        // 결과 담을 Map
        Map<String, Object> userInfo = new HashMap<>();
        ObjectMapper objectMapper = new ObjectMapper();

        try {
            JsonNode root = objectMapper.readTree(response.getBody());

            // 고유 ID (provider_id)
            String id = root.get("id").asText();

            // 닉네임, 이메일
            String nickname = root.path("kakao_account").path("profile").path("nickname").asText();
            String email = root.path("kakao_account").path("email").asText();

            userInfo.put("provider_id", id);
            userInfo.put("provider", "KAKAO"); // 고정값
            userInfo.put("nickname", nickname);
            userInfo.put("email", email);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return userInfo;
    }

    // --- 네이버 로그인 콜백 ---
    @GetMapping("/auth/naver/callback")
    public String naverCallBack(@RequestParam String code, @RequestParam String state, HttpSession sess, Model model) {
        // 1. 액세스 토큰 받기
        String accessToken = getNaverAccessToken(code, state);
        if (accessToken == null) {
            model.addAttribute("msg", "네이버 토큰 발급 실패");
            model.addAttribute("cmd", "back");
            return "common/return";
        }

        // 2. 사용자 정보 받기
        Map<String, Object> naverUserInfo = getNaverUserInfo(accessToken);

        // 3. 서비스 호출 (기존 카카오에서 쓴 메서드를 재사용하거나 새로 만듭니다)
        try {
            // provider를 "NAVER"로 넘겨서 구분합니다.
            MemberVO loginUser = memberService.processSocialLogin(naverUserInfo);
            sess.setAttribute("loginSess", loginUser);
            return "redirect:/";
        } catch (Exception e) {
            log.error("Naver Login Error", e);
            return "error/500";
        }
    }

    // [Helper] 네이버 토큰 발급
    private String getNaverAccessToken(String code, String state) {
        String tokenUrl = "https://nid.naver.com/oauth2.0/token";
        RestTemplate rt = new RestTemplate();

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", naverClientId);
        params.add("client_secret", naverClientSecret);
        params.add("code", code);

        try {
            ResponseEntity<Map> response = rt.postForEntity(tokenUrl, params, Map.class);
            return (String) response.getBody().get("access_token");
        } catch (Exception e) {
            log.error("Naver Token Error", e);
            return null;
        }
    }

    // [Helper] 네이버 정보 가져오기
    private Map<String, Object> getNaverUserInfo(String accessToken) {
        String userInfoUrl = "https://openapi.naver.com/v1/nid/me";
        RestTemplate rt = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(headers);
        ResponseEntity<Map> response = rt.exchange(userInfoUrl, HttpMethod.GET, request, Map.class);

        // 네이버는 응답 구조가 "response" 안에 데이터가 있음
        Map<String, Object> responseBody = (Map<String, Object>) response.getBody().get("response");

        Map<String, Object> userInfo = new HashMap<>();
        userInfo.put("provider_id", responseBody.get("id"));
        userInfo.put("provider", "NAVER");
        userInfo.put("nickname", responseBody.get("nickname"));
        userInfo.put("email", responseBody.get("email"));

        return userInfo;
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
