package project.bookclub.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import project.bookclub.mapper.BookClubMapper;
import project.bookclub.vo.BookClubVO;

import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BookClubService {

    private final BookClubMapper bookClubMapper;
    /*
    * #1. 독서모임 메인 페이지
    */
    // #1-1. 전체 독서모임 리스트 조회
    List<BookClubVO> getBookClubList() {
        return bookClubMapper.searchAll();
    }
 
    // #1-2. 독서모임 검색
    public List<BookClubVO> searchBookClubs(String keyword) {
        // 키워드 없으면 전체 검색
        if (keyword == null || keyword.isBlank()) {
            return bookClubMapper.searchAll();
        }
        List<String> tokens = Arrays.stream(keyword.split("\\s+"))
                                    .filter(StringUtils::hasText)
                                    .toList();

        // 키워드 검색 SQL
        return bookClubMapper.searchByKeyword(tokens);
    }

    // #1-3. 독서모임 생성 가능 여부 : 로그인 여부, (추후) 생성 개수 제한, 권한
    public boolean canCreateBookClub(Long memberId) {
        // 비로그인 시 생성 불가
        return memberId != null;
    }

    /*
     * #2. 독서모임 상세 페이지
     */
    // #2-1. 독서모임 1건 조회 (상세 페이지)
    public BookClubVO getBookClubById(Long bookClubSeq) {
        return bookClubMapper.selectById(bookClubSeq);
    }
}
