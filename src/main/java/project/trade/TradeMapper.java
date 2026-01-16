package project.trade;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface TradeMapper {

    List<TradeVO> findAll(); // 전체조회
    List<TradeVO> findAllWithPaging(@Param("limit") int limit, @Param("offset") int offset);
    int countAll();

    TradeVO findBySeq(long trade_seq);  // 상세조회
    List<TradeImageVO> findImgUrl(long trade_seq);    // 이미지 url 조회
    int save(TradeVO tradeVO);  // 판매글 등록
    int update(TradeVO tradeVO); // 판매글 수정
    int delete(@Param("trade_seq") Long tradeSeq);


}