package project.bookclub.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import project.bookclub.vo.BookClubVO;

import java.util.List;

@Mapper
public interface BookClubMapper {
    List<BookClubVO> searchAll();
    List<BookClubVO> searchByKeyword(@Param("tokens") List<String> tokens);

    // 독서모임 상세 조회 (1건)
    BookClubVO selectById(@Param("bookClubSeq") Long bookClubSeq);

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

    // 독서모임의 찜 개수 조회
    int selectWishCount(@Param("bookClubSeq") Long bookClubSeq);

    // 독서모임 게시판 - 최근 원글 10개 조회 (member_info 조인)
    List<project.bookclub.vo.BookClubBoardVO> selectRecentRootBoardsByClub(@Param("bookClubSeq") Long bookClubSeq);
} 
