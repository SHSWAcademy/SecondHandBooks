package project.trade;

import lombok.Data;
import org.springframework.cglib.core.Local;
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
    private String addrH; //
    private String addrD; //
    private String recipentTel;
    private String recipentName;
    private LocalDateTime saleCreatedAt;
    private LocalDateTime saleUpdatedAt;
    private PaymentType paymentType;
}
