package project.util;

import java.util.List;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import project.trade.TradeService;
import project.trade.TradeVO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
// 주석
/**
 * Handles requests for the application home page.
 */
@Controller
@Slf4j
@RequiredArgsConstructor
public class HomeController {

	/**
	 * Simply selects the home view to render by returning its name.
	 */
	private final TradeService tradeService;

	/*
	@GetMapping({"/", "/home"})
	public String home(Model model) {
		List<TradeVO> trades = tradeService.searchAll();
		model.addAttribute("trades", trades);
		return "/common/home";
	}
	 */
	@GetMapping("/profile")
	public String profile(HttpSession sess, Model model) {
		// 로그인 안 되어 있으면 로그인 페이지로
		if (sess.getAttribute("loginSess") == null) {
			model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
			model.addAttribute("url", "/login");
			model.addAttribute("cmd", "move");
			return "common/return";
		}

		// 여기에 실제로는 DB에서 구매내역(orders), 판매내역(sales) 등을 조회해서 model에 담아야 합니다.
		// 현재는 UI 구현이 목적이므로 JSP에서 하드코딩된 예시 데이터를 보여줍니다.

		return "member/profile";
	}
	@GetMapping({"/", "/home"})
	public String home(@RequestParam(defaultValue = "1") int page,
					   TradeVO searchVO, Model model,
					   HttpServletRequest request) {
		int size = 14;  // 한 페이지에 14개

		List<TradeVO> trades = tradeService.searchAllWithPaging(page, size, searchVO);
		int totalCount = tradeService.countAll(searchVO);
		int totalPages = (int) Math.ceil((double) totalCount / size);
		List<TradeVO> category = tradeService.selectCategory();	// 카테고리 조회

		model.addAttribute("trades", trades);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("category", category);

		// AJAX 요청이면 fragment만 반환
		if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
			return "trade/tradeList";
		}
		return "common/home";
	}
}
