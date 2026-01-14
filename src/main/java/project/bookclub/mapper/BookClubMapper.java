package project.bookclub.mapper;

import org.apache.ibatis.annotations.Mapper;
import project.bookclub.vo.BookClubVO;

import java.util.List;

@Mapper
public interface BookClubMapper {
    List<BookClubVO> selectAll();
}
