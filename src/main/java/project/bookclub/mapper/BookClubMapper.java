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
} 
