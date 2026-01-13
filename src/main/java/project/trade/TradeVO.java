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
    private long trade_seq;
    private String sale_title;
    private BookStatus book_st;
    private String sale_cont;
    private int sale_price;
    private int delivery_co;
    private String book_sale_region;
    private SaleStatus sale_st;
    private LocalDateTime sale_st_dtm;
    private long views;
    private long wish_cnt;
    private LocalDateTime book_sale_dtm;
    private String post_no;
    private String address_h;
    private String address_d;
    private String recipient_ph_no; // 구매자 전화번호
    private String recipient_nm; // 구매자 이름
    private LocalDateTime crt_dtm;
    private LocalDateTime upd_dtm;
    private PaymentType payment_type;

    // BookVO
    private String book_title;
    private String book_author;
    private String book_publisher;
    private String book_img;
    private int book_org_price;

    // BookImgVO
    private List<String> imgUrls = new ArrayList<>();
}
