package project.trade;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface TradeMapper {
    TradeVO findBySeq(long trade_seq);  // 상세조회
    List<TradeImageVO> findImgUrl(long trade_seq);    // 이미지 url 조회
    int save(TradeVO tradeVO);  // 판매글 등록
}
