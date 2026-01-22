package project.bookclub.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import project.bookclub.vo.BookClubVO;

@Mapper
public interface BookClubMapper {
    // 독서모임 검색
    List<BookClubVO> searchAll();

    List<BookClubVO> searchByKeyword(@Param("tokens") List<String> tokens);

    // 독서모임 상세 조회 (1건)
    BookClubVO selectById(@Param("bookClubSeq") Long bookClubSeq);

    // 독서모임 생성
    void insertBookClub(BookClubVO vo);

    // 독서모임 이름 중복 체크
    int countByName(String book_club_name);

    int countByLeaderAndName(
            @Param("leaderSeq") Long leaderSeq,
            @Param("name") String name);

    // 멤버십 관련
    // 특정 멤버가 JOINED 상태로 가입되어 있는지 확인 (count 반환)
    int selectJoinedMemberCount(@Param("bookClubSeq") Long bookClubSeq,
                                @Param("memberSeq") Long memberSeq);

    // 독서모임의 전체 JOINED 멤버 수 조회
    int getTotalJoinedMemberCount(@Param("bookClubSeq") Long bookClubSeq);

    // 특정 멤버의 대기중인 가입 신청 확인 (request_st='WAIT')
    int selectPendingRequestCount(@Param("bookClubSeq") Long bookClubSeq,
                                  @Param("memberSeq") Long memberSeq);

    // 가입 신청 INSERT
    void insertJoinRequest(@Param("bookClubSeq") Long bookClubSeq,
                           @Param("memberSeq") Long memberSeq,
                           @Param("requestCont") String requestCont);

    // 찜 관련
    // 독서모임의 찜 개수 조회
    int selectWishCount(@Param("bookClubSeq") Long bookClubSeq);

    // 게시판 관련
    // 독서모임 게시판 - 최근 원글 10개 조회 (member_info 조인)
    List<project.bookclub.vo.BookClubBoardVO> selectRecentRootBoardsByClub(@Param("bookClubSeq") Long bookClubSeq);

    // 독서모임 게시글 단건 조회 (상세 페이지용)
    project.bookclub.vo.BookClubBoardVO selectBoardDetail(@Param("bookClubSeq") Long bookClubSeq,
                                                          @Param("postId") Long postId);

    // 독서모임 게시글의 댓글 목록 조회 (오래된 순)
    List<project.bookclub.vo.BookClubBoardVO> selectBoardComments(@Param("bookClubSeq") Long bookClubSeq,
                                                                  @Param("postId") Long postId);

    // 부모글(원글) 존재 여부 확인 (우회 방지용)
    int existsRootPost(@Param("bookClubSeq") Long bookClubSeq, @Param("postId") Long postId);

    // 댓글 INSERT
    int insertBoardComment(@Param("bookClubSeq") Long bookClubSeq,
                           @Param("postId") Long postId,
                           @Param("memberSeq") Long memberSeq,
                           @Param("commentCont") String commentCont);

    // 댓글 UPDATE
    int updateBoardComment(@Param("commentId") Long commentId,
                           @Param("commentCont") String commentCont);

    // 댓글 DELETE (soft delete)
    int deleteBoardComment(@Param("commentId") Long commentId);

    // 댓글 단건 조회 (권한 확인용)
    project.bookclub.vo.BookClubBoardVO selectBoardCommentById(@Param("commentId") Long commentId);

    // 게시글(원글) INSERT
    void insertBoardPost(project.bookclub.vo.BookClubBoardVO boardVO);

    // 게시글 수정
    int updateBoardPost(project.bookclub.vo.BookClubBoardVO boardVO);

    // 게시글 삭제 (soft delete)
    int deleteBoardPost(@Param("bookClubSeq") Long bookClubSeq,
                        @Param("postId") Long postId);

    List<BookClubVO> selectMyBookClubs(long member_seq); // 내 모임 조회 추가
    List<BookClubVO> selectWishBookClubs(long member_seq);

    // 관리 페이지 - JOINED 멤버 목록 조회 (member_info 조인)
    List<project.bookclub.dto.BookClubManageMemberDTO> selectJoinedMembersForManage(@Param("bookClubSeq") Long bookClubSeq);

    // 관리 페이지 - WAIT 상태 가입 신청 목록 조회 (member_info 조인)
    List<project.bookclub.dto.BookClubJoinRequestDTO> selectPendingRequestsForManage(@Param("bookClubSeq") Long bookClubSeq);
}
