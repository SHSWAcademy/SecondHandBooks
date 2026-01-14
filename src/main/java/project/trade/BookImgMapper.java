package project.trade;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import project.util.book.BookVO;

@Mapper
public interface BookImgMapper {
    int save(@Param("imgUrl") String imgUrl, @Param("trade_seq") long trade_seq);
}
