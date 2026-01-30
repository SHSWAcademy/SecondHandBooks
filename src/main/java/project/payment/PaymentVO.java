package project.payment;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@Setter
@ToString
public class PaymentVO {

    private Long payment_seq;       // PK
    private Long trade_seq;         // 거래 번호 (FK)
    private Long member_buyer_seq;  // 구매자 회원 번호

    private String payment_key;     // 토스 paymentKey

    private int amount;             // 결제 금액
    private String status;          // 결제 상태 (DONE, CANCELED 등)
    private String method;          // 결제 수단

    private String card_company;    // 카드사
    private String card_number;     // 카드번호 (마스킹)

    private LocalDateTime approved_at;  // 결제 승인 시각
    private LocalDateTime created_at;   // 생성일

    // JSP 출력용 배송 정보 필드 (DB 저장 x)
    private String addr_type;
    private String post_no;
    private String addr_h;
    private String addr_d;
}