package project.bookclub.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import project.bookclub.mapper.BookClubMapper;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class BookClubServiceImpl implements BookClubService {
    private final BookClubMapper bookClubMapper;
}
