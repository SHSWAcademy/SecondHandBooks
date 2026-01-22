package project.trade;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface TradeMapper {

    List<TradeVO> findAll(); // 전체조회
    List<TradeVO> findAllWithPaging(@Param("limit") int limit, @Param("offset") int offset, @Param("searchVO") TradeVO searchVO);
    int countAll(@Param("searchVO") TradeVO searchVO);

    TradeVO findBySeq(long trade_seq);  // 상세조회
    List<TradeImageVO> findImgUrl(long trade_seq);    // 이미지 url 조회
    int save(TradeVO tradeVO);  // 판매글 등록
    int update(TradeVO tradeVO); // 판매글 수정
    int delete(@Param("trade_seq") Long tradeSeq);
    List<TradeVO> selectCategory(); // 카테고리 조회

    List<TradeVO> selectWishTrades(long member_seq); // 프로필 찜 목록 조회

    List<TradeVO> selectPurchaseTrades(@Param("member_seq") long member_seq); // 구매내역 조회

    List<TradeVO> selectSaleTrades(@Param("member_seq") long member_seq,
                                   @Param("status") String status); // 판매내역 조회


}