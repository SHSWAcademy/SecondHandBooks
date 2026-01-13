package project.trade;

import lombok.Data;
import project.trade.ENUM.BookStatus;
import project.trade.ENUM.PaymentType;
import project.trade.ENUM.SaleStatus;

import java.time.LocalDateTime;

@Data
public class TradeVO {
    private long tradeSeq;
    private String saleTitle;
    private BookStatus bookStatus;
    private String saleContext;
    private int salePrice;
    private int deliveryCost;
    private String saleRegion;
    private SaleStatus saleStatus;
    private LocalDateTime saleStatusUpdatedAt;
    private long views;
    private long wishCount;
    private LocalDateTime saleCompletedAt;
    private String postNo;
    private String addressHost;
    private String addressDetail;
    private String recipientTel; // 구매자 전화번호
    private String recipientName; // 구매자 이름
    private LocalDateTime saleCreatedAt;
    private LocalDateTime saleUpdatedAt;
    private PaymentType paymentType;
}