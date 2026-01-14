package project.bookclub.service;

import project.bookclub.vo.BookClubVO;

import java.util.List;

public interface BookClubService {
    // #1. 독서 모임 메인 페이지
    // #1-1. 독서모임 만들기
    List<BookClubVO> searchBookClubs(BookClubSearchCondition condition);

    // #1-2. 독서모임 검색

    // #1-3. 전체 모임 리스트 출력
}
