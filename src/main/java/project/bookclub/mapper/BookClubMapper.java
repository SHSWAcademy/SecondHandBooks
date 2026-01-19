package project.bookclub.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import project.bookclub.vo.BookClubVO;

import java.util.List;

@Mapper
public interface BookClubMapper {
    List<BookClubVO> searchAll();
    List<BookClubVO> searchByKeyword(@Param("tokens") List<String> tokens);

    void insertBookClub(BookClubVO vo);
    int countByName(String book_club_name);
    int countByLeaderAndName(
            @Param("leaderSeq") Long leaderSeq,
            @Param("name") String name
    );
}
