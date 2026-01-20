package project.mypage;

import com.fasterxml.jackson.annotation.JsonCreator;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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

    @GetMapping("/mypage")
    public String index() {
        return "redirect:/mypage/profile";
    }


    @GetMapping("/mypage/{tab}")
    public String mypag(@PathVariable String tab,
                        @RequestParam(required = false) String status,
                        HttpSession sess,
                        Model model
    ) {

        //로그인 체크
        MemberVO loginSess = (MemberVO) sess.getAttribute(Const.SESSION);
        if(loginSess == null) {
            return "redirect:/login";
        }

        model.addAttribute("currentTab", tab);

        // 탭별 데이터 로드
        switch (tab) {
            case "profile" :

                break;
            case "purchases" :
                List<TradeVO> purchaseList = new ArrayList<>();
                model.addAttribute("purchaseList", purchaseList);
                model.addAttribute("selectedStatus", status != null ? status : "all");

//                String purchasesStatus = status != null ? status : "all";
//                List<TradeVO> purchaseList = tradeService.getMyPuchases(loginSess, purchasesStatus);
//                model.addAttribute("purchaseList", purchaseList);
//                model.addAttribute("purchasesStatus", purchasesStatus);
                break;
            case "sales" :
                List<TradeVO> salesList = new ArrayList<>();
                model.addAttribute("salesList", salesList);
                model.addAttribute("selectedStatus", status != null ? status : "all");

//                String salesStatus = status != null ? status : "all";
//                List<TradeVO> salesList = tradeService.getMySales(loginSess, salesStatus);
//                model.addAttribute("salesList", salesList);
//                model.addAttribute("salesStatus", salesStatus);
                break;
            case "wishlist" :
                break;
            case "groups" :
                break;
            case "addresses" :
                break;

            default:
                return "redirect:/mypage/profile";
        }
        return "member/mypage";
    }

}
