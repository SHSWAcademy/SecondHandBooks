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
} 
