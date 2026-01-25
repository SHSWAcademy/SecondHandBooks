package project.payment;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import static org.assertj.core.api.Assertions.assertThat;

import org.springframework.test.context.web.WebAppConfiguration;
import project.address.AddressVO;
import project.member.MemberVO;
import project.trade.TradeService;
import project.trade.TradeVO;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@WebAppConfiguration
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
        "file:src/main/webapp/WEB-INF/spring/root-context.xml",
        "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
class PaymentServiceTest {

    @Autowired
    private PaymentService paymentService;
    @Autowired
    private TradeService tradeService;

    // member_seller_seq 기준으로 address_info 테이블 select
    @Test
    void test() {
        // given
        MemberVO memberVO = new MemberVO();
        memberVO.setMember_seq(5);
        Long member_seller_seq = memberVO.getMember_seq();

        // when
        List<AddressVO> findList = paymentService.findAddress(member_seller_seq);

        // then
        for (AddressVO address : findList) {
            assertThat(address.getMember_seq()).isEqualTo(5);
        }
    }

    // trade_seq 기준으로 sb_trade_info 테이블의 book_title, book_img, book_author, sale_price, delivery_cost 조회
    @Test
    void test1() {
        // given
        Long trade_seq = 62L;
        // when
        TradeVO tradeVO = tradeService.search(trade_seq);

        // then
        assertThat(tradeVO.getMember_seller_seq()).isEqualTo(75);
        assertThat(tradeVO.getBook_title()).isEqualTo("개미대학 세력의 매집원가 구하기");
        assertThat(tradeVO.getBook_img()).isEqualTo("https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1669864%3Ftimestamp%3D20250422114253");
        assertThat(tradeVO.getBook_author()).isEqualTo("전석");
        assertThat(tradeVO.getSale_price()).isEqualTo(3000);
        assertThat(tradeVO.getDelivery_cost()).isEqualTo(3000);
        // assertThat().isEqualTo();

    }
}