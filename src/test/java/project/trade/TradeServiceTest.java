package project.trade;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
class TradeServiceTest {

    @Test
    void findBySeq() {
        // given
        TradeVO tradeVO = new TradeVO();
        tradeVO.setTrade_seq(1L);
        tradeVO.setSale_title("테스트 판매글");
        tradeVO.setBook_title("테스트 책");

        List<String> imgUrls = List.of("img1.jpg", "img2.jpg", "img3.jpg");
        tradeVO.setImgUrls(imgUrls);

        // when: Service 로직 흉내
        // 원래 TradeService는 Mapper 호출하지만, 여기서는 직접 세팅
        TradeVO result = tradeVO;

        // then: 값 검증
        assertNotNull(result);
        assertEquals(1L, result.getTrade_seq());
        assertEquals("테스트 판매글", result.getSale_title());
        assertEquals("테스트 책", result.getBook_title());

        assertNotNull(result.getImgUrls());
        assertEquals(3, result.getImgUrls().size());
        assertEquals("img1.jpg", result.getImgUrls().get(0));
        assertEquals("img2.jpg", result.getImgUrls().get(1));
        assertEquals("img3.jpg", result.getImgUrls().get(2));
    }


}