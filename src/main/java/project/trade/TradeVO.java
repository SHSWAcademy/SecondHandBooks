package project.trade;

import lombok.Data;
import project.trade.ENUM.BookStatus;
import project.trade.ENUM.PaymentType;
import project.trade.ENUM.SaleStatus;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
public class TradeVO {
    // DB 컬럼명과 일치시킨 필드들
    private long trade_seq;
    private long member_seller_seq; // 추가
    private long member_buyer_seq;  // 추가
    private long category_seq;      // 추가
    private long book_info_seq;     // 추가
    private long settlement_seq;    // 추가

    private String sale_title;
    private BookStatus book_st;     // DB: book_st_enum 매핑
    private String sale_cont;
    private int sale_price;
    private int book_delivery_cost; // 수정: delivery_co -> book_delivery_cost
    private String sale_rg;         // 수정: book_sale_region -> sale_rg
    private SaleStatus sale_st;     // DB: sale_st_enum 매핑
    private LocalDateTime sale_st_dtm;
    private long views;
    private long wish_cnt;
    private LocalDateTime book_sale_dtm;
    private String post_no;
    private String addr_h;          // 수정: address_h -> addr_h
    private String addr_d;          // 수정: address_d -> addr_d
    private String recipient_ph;
    private String recipient_nm;
    private LocalDateTime crt_dtm;
    private LocalDateTime upd_dtm;
    private PaymentType payment_type; // DB: payment_type_enum 매핑
    private String category_nm;

    // Book 관련 (Join 결과 매핑용)
    private String book_title;
    private String book_author;
    private String book_publisher;
    private String book_img;
    private int book_org_price;

    // 이미지 리스트
    private List<String> imgUrls = new ArrayList<>();
}