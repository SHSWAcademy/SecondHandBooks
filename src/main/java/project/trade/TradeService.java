package project.trade;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Slf4j
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class TradeService {
    private final TradeMapper tradeMapper;

    public TradeVO findBySeq(long trade_seq) {
        TradeVO findTrade = tradeMapper.findBySeq(trade_seq);
        findTrade.setImgUrls(tradeMapper.findImgUrl(trade_seq));
        return findTrade;
    }
}
