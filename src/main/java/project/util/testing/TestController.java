package project.util.testing;
import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/test")
@RequiredArgsConstructor
public class TestController {

    private final TestService service;

    // 전체 목록
    @GetMapping("/list")
    public String list(Model model) {
        List<TestVO> list = service.selectAll();
        model.addAttribute("list", list);
        return "test/list";  // /WEB-INF/views/test/list.jsp
    }

    // 상세보기
    @GetMapping("/view")
    public String view(int no, Model model) {
        TestVO vo = service.selectOne(no);
        model.addAttribute("vo", vo);
        return "test/view";  // /WEB-INF/views/test/view.jsp
    }
}