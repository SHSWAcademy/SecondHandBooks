package project.notice;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import project.admin.AdminService;
import project.admin.notice.NoticeVO;

import java.util.List;

@Controller
@Slf4j
@RequiredArgsConstructor
public class noticeController {

    private final AdminService adminService;

    @GetMapping("/notice")
    public String userNoticeList(Model model) {

        List<NoticeVO> list = adminService.selectActiveNotices();
        log.info("리스트 사이즈: {}", list.size());

        model.addAttribute("notices", adminService.selectActiveNotices());
        return "userNotice/userNoticeList";
    }

    // 2. 유저용 공지사항 상세 보기 페이지로 이동
    @GetMapping("/notice/view")
    public String userNoticeView(@RequestParam Long notice_seq, Model model) {
        // 조회수 증가
        adminService.increaseViewCount(notice_seq);

        // 데이터 조회
        NoticeVO noticeVO = adminService.selectNotice(notice_seq);
        model.addAttribute("notice", noticeVO);

        return "userNotice/noticeDetail";
    }
}
