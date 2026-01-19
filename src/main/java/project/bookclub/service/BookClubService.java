package project.bookclub.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import project.bookclub.dto.BookClubCreateDTO;
import project.bookclub.mapper.BookClubMapper;
import project.bookclub.vo.BookClubVO;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
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

    @Transactional
    public void createBookClubs(BookClubVO vo) {
        // 1. 값 들어왔는지 확인
        log.info("service create vo = {}", vo);
        log.info("leader_seq = {}", vo.getBook_club_leader_seq());

        // 2. 중복 모임명 체크
        int count = bookClubMapper.countByName(vo.getBook_club_name());
        if (count > 0) {
            throw new IllegalStateException("이미 존재하는 모임명입니다.");
        }

        // 3. 모임 이름 중복 체크
        boolean duplicated = isDuplicateForLeader(vo.getBook_club_leader_seq(), vo.getBook_club_name());
        if(duplicated) {
            throw new IllegalArgumentException("이미 같은 이름의 독서 모임이 존재합니다.");
        }
        // 2. 서버에서 관리하는 기본값만 세팅
//        vo.setCrt_dtm(java.time.LocalDateTime.now());
//        vo.setUpd_dtm(java.time.LocalDateTime.now()); // null이어도 됨. 수정했을 때 반영
        // TODO: 로그인 연동 후 세션에서 사용자 ID 가져오도록 수정
//        if (vo.getBook_club_leader_seq() == null) {
//            vo.setBook_club_leader_seq(1L); // 임시 기본값
//        }

        // 3. DB 저장은 다음 단계
        bookClubMapper.insertBookClub(vo);
    }

    public boolean isDuplicateForLeader(Long leaderSeq, String name) {
        return bookClubMapper.countByLeaderAndName(leaderSeq, name) > 0;
    }
}
