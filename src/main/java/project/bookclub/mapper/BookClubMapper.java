package project.bookclub.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import project.bookclub.vo.BookClubVO;

import java.util.List;

@Mapper
public interface BookClubMapper {
    List<BookClubVO> searchAll();
    List<BookClubVO> searchByKeyword(@Param("tokens") List<String> tokens);
}
