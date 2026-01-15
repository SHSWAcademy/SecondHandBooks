package project.bookclub.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import project.bookclub.mapper.BookClubMapper;
import project.bookclub.vo.BookClubVO;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

@Service
@RequiredArgsConstructor
public class BookClubService {

    private final BookClubMapper bookClubMapper;
    /*
    * #1. 독서모임 메인 페이지
    */
    // #1-1. 전체 독서모임 리스트 조회
    public List<BookClubVO> getBookClubList() {
        return bookClubMapper.searchAll();
    }

    // #1-2. 독서모임 검색
    public List<BookClubVO> searchBookClubs(String keyword) {
        // 키워드 없으면 전체 검색
        if (keyword == null || keyword.isBlank()) {
            return bookClubMapper.searchAll();
        }

        List<String> tokens = new ArrayList<>();
        StringTokenizer st = new StringTokenizer(keyword);
        while(st.hasMoreTokens()) {
            tokens.add(st.nextToken());
        }

        if (tokens.isEmpty()) {
            return bookClubMapper.searchAll();
        }

        // 키워드 검색 SQL
        return bookClubMapper.searchByKeyword(tokens);
    }

    // #1-3. 독서모임 생성 가능 여부 : 로그인 여부, (추후) 생성 개수 제한, 권한
    public boolean canCreateBookClub(Long memberId) {
        // 비로그인 시 생성 불가
        return memberId != null;
    }

    public List<BookClubVO> searchAll() {
        return bookClubMapper.searchAll();
    }
}
