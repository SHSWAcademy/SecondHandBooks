package project.trade;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import project.util.exception.TradeNotFoundException;

import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class TradeService {
    private final TradeMapper tradeMapper;
    private final BookImgMapper bookImgMapper;

    // 판매글 상세조회
    public TradeVO search(long trade_seq) {
        TradeVO findTrade = tradeMapper.findBySeq(trade_seq);

        if (findTrade == null) {
            log.info("데이터 조회 실패 : DB에서 데이터를 조회하지 못했습니다.");
            throw new TradeNotFoundException("Cannot find trade_seq=" + trade_seq);
        }

        List<String> imgUrl = tradeMapper.findImgUrl(trade_seq); // imgUrl은 null 이어도 된다 (썸네일 이미지만 보여진다)
        findTrade.setImgUrls(imgUrl);

        return findTrade;
    }

    // 판매글 등록
    @Transactional
    public boolean upload(TradeVO tradeVO) {

        int result = tradeMapper.save(tradeVO);
        log.info("Saved result count = {}", result);
        log.info("trade_seq after save = {}", tradeVO.getTrade_seq());
        log.info("imgUrls in service = {}", tradeVO.getImgUrls());

        if (tradeVO.getImgUrls() != null && !tradeVO.getImgUrls().isEmpty()) {
            for (String imgUrl : tradeVO.getImgUrls()) {
                log.info("Saving image: {} for trade_seq: {}", imgUrl, tradeVO.getTrade_seq());
                bookImgMapper.save(imgUrl, tradeVO.getTrade_seq());
            }
        }
        return result > 0;
    }

}
