package project.mypage;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import project.address.AddressService;
import project.bookclub.BookClubService; // [추가] 서비스 임포트
import project.bookclub.BookClubVO;
import project.member.MemberVO;
import project.trade.TradeService;
import project.trade.TradeVO;
import project.util.Const;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@Slf4j
@RequiredArgsConstructor
public class MypageController {

    private final TradeService tradeService;
    private final BookClubService bookClubService; // [추가] 모임 서비스 주입
    private final AddressService addressService;

    @GetMapping("/mypage")
    public String mypage(HttpSession sess, Model model) {
        MemberVO loginSess = (MemberVO) sess.getAttribute(Const.SESSION);
        if (loginSess == null) {
            return "redirect:/login";
        }

        model.addAttribute("currentTab", "profile");
        return "member/mypage";
    }

    @GetMapping("/mypage/tab/{tab}")
    public String loadTab(@PathVariable String tab,
                          @RequestParam(required = false) String status,
                          HttpSession sess,
                          Model model
    ) {
        log.info("=========loadTab 호출됨: tab={}, status={}", tab, status);
        // 로그인 체크
        MemberVO loginSess = (MemberVO) sess.getAttribute(Const.SESSION);
        if(loginSess == null) {
            return "error/401";
        }

        Long memberSeq = loginSess.getMember_seq();
        // 탭별 초기 데이터 로드 (SSR이 필요한 경우 여기서 처리)
        // 현재 대부분 AJAX로 처리하므로 비워두거나 기본값만 설정
        switch (tab) {
            case "profile" :
                log.info("profile 탭로드");
                break;
            case "purchases" :
                log.info("purchases 탭 로드, status={}", status);
                String purchaseStatus = status != null ? status : "all";
                List<TradeVO> purchaseList = new ArrayList<>();
                model.addAttribute("purchaseList", purchaseList);
                model.addAttribute("selectedStatus", status != null ? status : "all");
                break;
            case "sales" :
                log.info("sales 탭 로드, status={}", status);
                String salesStatus = status != null ? status : "all";
                List<TradeVO> salesList = new ArrayList<>();
                model.addAttribute("salesList", salesList);
                model.addAttribute("selectedStatus", status != null ? status : "all");
                break;
            case "wishlist" :
                break;
            case "groups" :
                // 내 모임은 groups.jsp에서 AJAX로 로딩하므로 여기선 처리 없음
                break;
            case "addresses" :
                break;
            default:
                return "redirect:/mypage/profile";
        }
        log.info("반환 JSP: member/tabs/{}", tab);
        return "member/tabs/" + tab;
    }

    // ---------------------------------------------------------
    // AJAX 요청 처리 메서드 (JSP의 $.ajax URL과 매핑)
    // ---------------------------------------------------------

    // [AJAX] 내 모임 데이터 조회
    @GetMapping("/profile/bookclub/list")
    @ResponseBody
    public List<BookClubVO> getMyBookClubs(HttpSession sess) {
        MemberVO user = (MemberVO) sess.getAttribute(Const.SESSION);
        if (user == null) return null;

        // BookClubService를 통해 데이터 조회
        return bookClubService.getMyBookClubs(user.getMember_seq());
    }
}