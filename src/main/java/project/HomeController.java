package project;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import project.trade.TradeService;
import project.trade.TradeVO;

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

	@GetMapping({"/", "/home"})
	public String home(Model model) {
		List<TradeVO> trades = tradeService.searchAll();
		model.addAttribute("trades", trades);
		return "/common/home";
	}
	
}
