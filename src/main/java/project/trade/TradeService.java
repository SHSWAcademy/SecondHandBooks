package project.trade;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import project.util.book.BookService;
import project.util.book.BookVO;
import project.util.exception.TradeNotFoundException;

import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class TradeService {
    private final TradeMapper tradeMapper;
    private final BookService bookService;

    // 판매글 상세조회
    public TradeVO findBySeq(long trade_seq) {
        TradeVO findTrade = tradeMapper.findBySeq(trade_seq);

        if (findTrade == null) {
            throw new TradeNotFoundException("Cannot find trade_seq=" + trade_seq);
        }

        List<String> imgUrl = tradeMapper.findImgUrl(trade_seq); // imgUrl은 null 이어도 된다 (썸네일 이미지만 보여진다)
        findTrade.setImgUrls(imgUrl);

        return findTrade;
    }

    // 판매글 등록
    public void process(TradeVO tradeVO) {
        BookVO bookVO = processBook(tradeVO.generateBook());

    }

    // 책 정보 조회 (없으면 insert)
    private BookVO processBook(BookVO bookVO) {
        BookVO findBook = bookService.findByIsbn(bookVO.getIsbn());

        if (findBook == null) {
            BookVO savedBook = bookService.saveBook(bookVO);
            log.info("new book : {}", savedBook);
            return savedBook;
        } else {
            log.info("find book : {}", findBook);
            return findBook;
        }
    }


}
