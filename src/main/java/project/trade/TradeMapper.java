package project.trade;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface TradeMapper {
    TradeVO findBySeq(long trade_seq);
    List<String> findImgUrl(long trade_seq);
}
