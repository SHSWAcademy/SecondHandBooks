package project.trade;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import project.util.book.BookVO;

import java.util.List;

@Mapper
public interface BookImgMapper {
    int save(@Param("imgUrl") String imgUrl, @Param("trade_seq") long trade_seq);
    List<String> findImgUrl(long tradeSeq);
}
