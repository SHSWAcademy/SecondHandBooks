package project.util.book;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BookMapper {
    BookVO save(BookVO bookVO);
    BookVO findByIsbn(String isbn);
}
