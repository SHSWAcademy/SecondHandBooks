package project.trade;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import project.util.exception.TradeNotFoundException;
import java.util.Arrays;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TradeServiceTest {

    @Mock
    private TradeMapper tradeMapper;

    @Mock
    private BookImgMapper bookImgMapper;

    @InjectMocks
    private TradeService tradeService;

    private TradeVO tradeVO;

    @BeforeEach
    void setUp() {
        tradeVO = new TradeVO();
        tradeVO.setTrade_seq(1L);
        tradeVO.setSale_title("테스트 판매글");
        tradeVO.setBook_title("테스트 책");
    }


    @Test
    @DisplayName("판매글 상세조회 성공 - 이미지 URL이 있는 경우")
    void findBySeq_WithImgUrls_Success() {
        // given
        long tradeSeq = 1L;

        TradeVO mockTradeVO = new TradeVO();
        mockTradeVO.setTrade_seq(tradeSeq);
        mockTradeVO.setSale_title("테스트 판매글");
        mockTradeVO.setBook_title("테스트 책");

        List<String> imgUrls = Arrays.asList("img1.jpg", "img2.jpg", "img3.jpg");

        when(tradeMapper.findBySeq(tradeSeq)).thenReturn(mockTradeVO);
        when(bookImgMapper.findImgUrl(tradeSeq)).thenReturn(imgUrls);

        // when
        TradeVO result = tradeService.search(tradeSeq);

        // then
        assertNotNull(result);
        assertEquals(tradeSeq, result.getTrade_seq());
        assertEquals("테스트 판매글", result.getSale_title());
        assertEquals("테스트 책", result.getBook_title());

        assertNotNull(result.getImgUrls());
        assertEquals(3, result.getImgUrls().size());
        assertEquals("img1.jpg", result.getImgUrls().get(0));
        assertEquals("img2.jpg", result.getImgUrls().get(1));
        assertEquals("img3.jpg", result.getImgUrls().get(2));

        verify(tradeMapper, times(1)).findBySeq(tradeSeq);
        verify(tradeMapper, times(1)).findImgUrl(tradeSeq);
    }

    @Test
    @DisplayName("판매글 상세조회 성공 - 이미지 URL이 없는 경우")
    void findBySeq_WithoutImgUrls_Success() {
        // given
        long tradeSeq = 2L;

        TradeVO mockTradeVO = new TradeVO();
        mockTradeVO.setTrade_seq(tradeSeq);
        mockTradeVO.setSale_title("이미지 없는 판매글");

        when(tradeMapper.findBySeq(tradeSeq)).thenReturn(mockTradeVO);
        when(tradeMapper.findImgUrl(tradeSeq)).thenReturn(null);

        // when
        TradeVO result = tradeService.search(tradeSeq);

        // then
        assertNotNull(result);
        assertEquals(tradeSeq, result.getTrade_seq());
        assertEquals("이미지 없는 판매글", result.getSale_title());

        verify(tradeMapper, times(1)).findBySeq(tradeSeq);
        verify(tradeMapper, times(1)).findImgUrl(tradeSeq);
    }

    @Test
    @DisplayName("판매글 상세조회 실패 - 존재하지 않는 trade_seq")
    void findBySeq_NotFound_ThrowsException() {
        // given
        long nonExistentSeq = 999L;
        when(tradeMapper.findBySeq(nonExistentSeq)).thenReturn(null);

        // when & then
        TradeNotFoundException exception = assertThrows(
                TradeNotFoundException.class,
                () -> tradeService.search(nonExistentSeq)
        );

        assertEquals("Cannot find trade_seq=" + nonExistentSeq, exception.getMessage());
        verify(tradeMapper, times(1)).findBySeq(nonExistentSeq);
        verify(tradeMapper, never()).findImgUrl(anyLong());
    }



    @Test
    @DisplayName("판매글 저장 성공 - 이미지 URL이 있는 경우")
    void save_WithImgUrls_Success() {
        // given
        List<String> imgUrls = Arrays.asList("img1.jpg", "img2.jpg", "img3.jpg");
        tradeVO.setImgUrls(imgUrls);

        when(tradeMapper.save(tradeVO)).thenReturn(1);
        when(bookImgMapper.save(anyString(), anyLong())).thenReturn(1);

        // when
        boolean result = tradeService.upload(tradeVO);

        // then
        assertTrue(result);
        verify(tradeMapper, times(1)).save(tradeVO);
        verify(bookImgMapper, times(3)).save(anyString(), eq(1L));
        verify(bookImgMapper).save("img1.jpg", 1L);
        verify(bookImgMapper).save("img2.jpg", 1L);
        verify(bookImgMapper).save("img3.jpg", 1L);
    }

    @Test
    @DisplayName("판매글 저장 성공 - 이미지 URL이 null인 경우")
    void save_WithoutImgUrls_Success() {
        // given
        tradeVO.setImgUrls(null);
        when(tradeMapper.save(tradeVO)).thenReturn(1);

        // when
        boolean result = tradeService.upload(tradeVO);

        // then
        assertTrue(result);
        verify(tradeMapper, times(1)).save(tradeVO);
        verify(bookImgMapper, never()).save(anyString(), anyLong());
    }

    @Test
    @DisplayName("판매글 저장 성공 - 이미지 URL 리스트가 비어있는 경우")
    void save_WithEmptyImgUrls_Success() {
        // given
        tradeVO.setImgUrls(Arrays.asList());
        when(tradeMapper.save(tradeVO)).thenReturn(1);

        // when
        boolean result = tradeService.upload(tradeVO);

        // then
        assertTrue(result);
        verify(tradeMapper, times(1)).save(tradeVO);
        verify(bookImgMapper, never()).save(anyString(), anyLong());
    }

    @Test
    @DisplayName("판매글 저장 실패 - tradeMapper.save()가 0을 반환")
    void save_TradeMapperReturnsZero_Failure() {
        // given
        List<String> imgUrls = Arrays.asList("img1.jpg");
        tradeVO.setImgUrls(imgUrls);
        when(tradeMapper.save(tradeVO)).thenReturn(0);
        when(bookImgMapper.save(anyString(), anyLong())).thenReturn(1);

        // when
        boolean result = tradeService.upload(tradeVO);

        // then
        assertFalse(result);
        verify(tradeMapper, times(1)).save(tradeVO);
        // tradeMapper가 실패해도 imgUrls는 처리된다 (현재 코드 로직)
        verify(bookImgMapper, times(1)).save("img1.jpg", 1L);
    }
}