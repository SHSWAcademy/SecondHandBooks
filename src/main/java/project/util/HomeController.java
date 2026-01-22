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
import javax.servlet.http.HttpServletResponse;

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
	@GetMapping({"/", "/home"})
	public String home(@RequestParam(defaultValue = "1") int page,
					   TradeVO searchVO, Model model,
					   HttpServletRequest request,
					   HttpServletResponse response) {
		int size = 14;  // 한 페이지에 14개

		List<TradeVO> trades = tradeService.searchAllWithPaging(page, size, searchVO);
		int totalCount = tradeService.countAll(searchVO);
		int totalPages = (int) Math.ceil((double) totalCount / size);
		List<TradeVO> category = tradeService.selectCategory();	// 카테고리 조회

		model.addAttribute("totalCount", totalCount);
		model.addAttribute("trades", trades);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("category", category);

		// AJAX 요청이면 fragment만 반환
		if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
			response.setHeader("X-Total-Count", String.valueOf(totalCount));
			return "trade/tradelist";
		}
		return "common/home";
	}
}
