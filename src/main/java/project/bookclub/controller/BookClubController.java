package project.bookclub.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;

@Controller
@Slf4j
@RequiredArgsConstructor
public class BookClubController {
    //주석 테스트
    private final BookClubService bookClubService;
}
