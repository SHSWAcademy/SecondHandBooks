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
public class TradeService {
    private final TradeMapper tradeMapper;

    public TradeVO findBySeq(long trade_seq) {
        TradeVO findTrade = tradeMapper.findBySeq(trade_seq);

        if (findTrade == null) {
            throw new TradeNotFoundException("Cannot find trade_seq=" + trade_seq);
        }

        List<String> imgUrl = tradeMapper.findImgUrl(trade_seq); // imgUrl은 null 이어도 된다 (썸네일 이미지만 보여진다)
        findTrade.setImgUrls(imgUrl);

        return findTrade;
    }
}
