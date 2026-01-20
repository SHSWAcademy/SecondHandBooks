package project.bookclub.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import project.bookclub.service.BookClubService;
import project.bookclub.vo.BookClubVO;
import project.member.MemberVO;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bookclubs")
public class BookClubController {

    private final BookClubService bookClubService;

    @Value("${upload.path}")
    private String uploadPath;

    /*
    * 독서모임 메인
    * getBookClubs : keyword 없이 모임 전체 조회
    * searchBookClubs : keyword로 모임 검색
    */

    @GetMapping
    public String getBookClubs(Model model) {
        List<BookClubVO> bookClubs = bookClubService.getBookClubList();
        model.addAttribute("bookclubList", bookClubs);
        return "bookclub/bookclub_list";
    }

    @GetMapping("/search")
    @ResponseBody
    public List<BookClubVO> searchBookClubs(@RequestParam(required = false) String keyword) {
        return bookClubService.searchBookClubs(keyword);
    }

    @PostMapping
    @ResponseBody
    public Map<String, Object> createBookClubs(
            @ModelAttribute BookClubVO vo,
            @RequestParam(value = "banner_img", required = false) MultipartFile bannerImg,
            HttpSession session) {

        log.info("vo = {}", vo);
        log.info("banner_img = {}", vo.getBanner_img_url());

        MemberVO loginUser = (MemberVO) session.getAttribute("loginSess");

        if (loginUser == null) {
            return Map.of(
                    "status", "fail",
                    "message", "LOGIN_REQUIRED"
            );
        }

        vo.setBook_club_leader_seq(loginUser.getMember_seq());

        // 이미지 파일 처리
        if (bannerImg != null && !bannerImg.isEmpty()) {
            try {
                String savedFileName = saveFile(bannerImg);
                vo.setBanner_img_url("/img/" + savedFileName);
                log.info("Banner image saved: {}", savedFileName);
            } catch (IOException e) {
                log.error("Failed to save banner image", e);
                return Map.of(
                        "status", "fail",
                        "message", "이미지 업로드에 실패했습니다."
                );
            }
        }

        try {
            bookClubService.createBookClubs(vo);
            return Map.of("status", "ok");
        } catch (IllegalStateException e) {
            return Map.of(
                    "status", "fail",
                    "message", e.getMessage()
            );
        }
    }

    /**
     * 파일 저장 (설정된 uploadPath에 저장)
     */
    private String saveFile(MultipartFile file) throws IOException {
        // 폴더가 없으면 생성
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
            log.info("Upload directory created: {}", uploadPath);
        }

        // 고유한 파일명 생성 (UUID + 원본 확장자)
        String originalFileName = file.getOriginalFilename();
        String extension = "";
        if (originalFileName != null && originalFileName.contains(".")) {
            extension = originalFileName.substring(originalFileName.lastIndexOf("."));
        }
        String savedFileName = UUID.randomUUID().toString() + extension;

        // 파일 저장
        File destFile = new File(uploadPath + savedFileName);
        file.transferTo(destFile);

        log.info("File saved to: {}", destFile.getAbsolutePath());
        return savedFileName;
    }
}
