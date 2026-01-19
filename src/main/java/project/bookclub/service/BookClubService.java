package project.bookclub.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import project.bookclub.ENUM.JoinRequestResult;
import project.bookclub.mapper.BookClubMapper;
import project.bookclub.vo.BookClubBoardVO;
import project.bookclub.vo.BookClubVO;

import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
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

    // #2-2. 특정 멤버가 JOINED 상태로 가입되어 있는지 확인
    public boolean isMemberJoined(Long bookClubSeq, Long memberSeq) {
        if (bookClubSeq == null || memberSeq == null) {
            return false;
        }
        int count = bookClubMapper.selectJoinedMemberCount(bookClubSeq, memberSeq);
        return count > 0;
    }

    // #2-3. 독서모임의 전체 JOINED 멤버 수 조회
    public int getTotalJoinedMemberCount(Long bookClubSeq) {
        if (bookClubSeq == null) {
            return 0;
        }
        return bookClubMapper.getTotalJoinedMemberCount(bookClubSeq);
    }

    // #2-4. 특정 멤버가 대기중인 가입 신청이 있는지 확인
    public boolean hasPendingRequest(Long bookClubSeq, Long memberSeq) {
        if (bookClubSeq == null || memberSeq == null) {
            return false;
        }
        int count = bookClubMapper.selectPendingRequestCount(bookClubSeq, memberSeq);
        return count > 0;
    }

    // #2-5. 가입 신청 생성 (개선판: 예외를 enum 결과로 변환)
    /**
     * 독서모임 가입 신청 생성
     *
     * 검증 순서:
     * 1. 파라미터 null 체크 → INVALID_PARAMETERS
     * 2. book_club_member.join_st='JOINED' 확인 → ALREADY_JOINED
     * 3. book_club_request.request_st='WAIT' 확인 → ALREADY_REQUESTED
     * 4. book_club_request INSERT → SUCCESS
     *
     * 참고:
     * - book_club_request 테이블에는 UNIQUE(book_club_seq, request_member_seq) 제약이 없음
     * - 따라서 DB 레벨에서 중복 신청을 막을 수 없음 (hasPendingRequest로 비즈니스 로직 검증 필수)
     *
     * @param bookClubSeq 독서모임 ID
     * @param memberSeq 신청 멤버 ID
     * @param requestCont 신청 메시지 (nullable)
     * @return JoinRequestResult enum (성공/실패 사유)
     */
    public JoinRequestResult createJoinRequest(Long bookClubSeq, Long memberSeq, String requestCont) {
        // 1. 파라미터 검증
        if (bookClubSeq == null || memberSeq == null) {
            log.warn("가입 신청 실패: 잘못된 파라미터 - bookClubSeq={}, memberSeq={}", bookClubSeq, memberSeq);
            return JoinRequestResult.INVALID_PARAMETERS;
        }

        // 2. 이미 JOINED 상태인지 확인 (book_club_member 테이블)
        //    - UNIQUE 제약: (book_club_seq, member_seq) 존재 (bookclubDDL.md line 99)
        if (isMemberJoined(bookClubSeq, memberSeq)) {
            log.info("가입 신청 실패: 이미 가입된 멤버 (join_st=JOINED) - bookClubSeq={}, memberSeq={}",
                    bookClubSeq, memberSeq);
            return JoinRequestResult.ALREADY_JOINED;
        }

        // 3. 이미 WAIT 상태로 신청했는지 확인 (book_club_request 테이블)
        //    - book_club_request에는 UNIQUE 제약이 없으므로 비즈니스 로직으로 검증
        if (hasPendingRequest(bookClubSeq, memberSeq)) {
            log.info("가입 신청 실패: 이미 신청 대기중 (request_st=WAIT) - bookClubSeq={}, memberSeq={}",
                    bookClubSeq, memberSeq);
            return JoinRequestResult.ALREADY_REQUESTED;
        }

        // 4. INSERT 시도
        try {
            bookClubMapper.insertJoinRequest(bookClubSeq, memberSeq, requestCont);
            log.info("가입 신청 성공: bookClubSeq={}, memberSeq={}", bookClubSeq, memberSeq);
            return JoinRequestResult.SUCCESS;

        } catch (DataIntegrityViolationException e) {
            // UNIQUE 제약이 추가되었을 경우를 대비한 방어 코드
            // (현재 DDL에는 UNIQUE 제약 없음)
            // DuplicateKeyException은 DataIntegrityViolationException의 서브클래스이므로 함께 처리됨
            log.warn("가입 신청 실패: DB 제약 위반 - bookClubSeq={}, memberSeq={}, error={}",
                    bookClubSeq, memberSeq, e.getMessage());
            return JoinRequestResult.ALREADY_REQUESTED;
        }
    }

    // #2-6. 독서모임의 찜 개수 조회
    public int getWishCount(Long bookClubSeq) {
        if (bookClubSeq == null) {
            return 0;
        }
        return bookClubMapper.selectWishCount(bookClubSeq);
    }

    /*
     * #3. 독서모임 게시판
     */
    // #3-1. 독서모임 게시판 - 최근 원글 10개 조회
    public List<BookClubBoardVO> getRecentBoards(Long bookClubSeq) {
        if (bookClubSeq == null) {
            return List.of();
        }
        return bookClubMapper.selectRecentRootBoardsByClub(bookClubSeq);
    }
}
