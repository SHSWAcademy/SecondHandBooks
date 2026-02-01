package project.presentation;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/presentation")
public class PresentationController {

    @GetMapping
    public String intro() {
        return "presentation/intro";
    }

    @GetMapping("/api/stats")
    @ResponseBody
    public Map<String, Object> getProjectStats() {
        // 간단한 AJAX 데이터 제공 예시 (실제 DB 연동 가능)
        Map<String, Object> stats = new HashMap<>();
        stats.put("members", 1250);
        stats.put("books", 5430);
        stats.put("clubs", 82);
        return stats;
    }
}
