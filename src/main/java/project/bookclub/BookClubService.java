package project.bookclub;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class BookClubService {
    private final BookClubMapper bookClubMapper;

    public List<BookClubVO> getMyBookClubs(long member_seq) {
        return bookClubMapper.selectMyBookClubs(member_seq);
    }
}
