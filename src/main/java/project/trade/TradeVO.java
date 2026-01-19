package project.trade;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;
import project.trade.ENUM.BookStatus;
import project.trade.ENUM.PaymentType;
import project.trade.ENUM.SaleStatus;
import project.util.book.BookVO;
import java.time.LocalDateTime;
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

    private String sale_title;      //책 제목
    private BookStatus book_st;     // DB: book_st_enum 매핑
    private String sale_cont;       // 상세설명
    private int sale_price;         // 판매가격
    private int delivery_cost; // 배송비
    private String sale_rg;         // 수정: book_sale_region -> sale_rg
    private SaleStatus sale_st;     // DB: sale_st_enum 매핑
    private LocalDateTime sale_st_dtm;  // 상품상태 변경 시간
    private long views;             // 조회수
    private long wish_cnt;          // 찜수
    private LocalDateTime book_sale_dtm;    //판매완료 시간
    private String post_no;         // 우편번호
    private String addr_h;          // 수정: address_h -> addr_h
    private String addr_d;          // 수정: address_d -> addr_d
    private String recipient_ph;    // 구매자 전화번호
    private String recipient_nm;    // 구매자 이름
    private LocalDateTime crt_dtm;  // 완료일자
    private LocalDateTime upd_dtm;  // 업데이트 일자
    private PaymentType payment_type; // 거래방법
    private String category_nm; // 카테고리 이름

    // Book 관련 (Join 결과 매핑용)
    private String isbn;            // 책 고유번호
    private String book_title;      // 책 제목
    private String book_author;     // 저자
    private String book_publisher;  // 출판사
    private String book_img;        // 썸네일 이미지 url
    private int book_org_price;     // 책 원가

    // 이미지 리스트
    private List<MultipartFile> uploadFiles; // form 에서 받아오는 데이터
    private List<String> imgUrls; // db에 저장할 데이터
    private List<TradeImageVO> trade_img; // 화면 출력용

    // 검색용
    private String search_word;

    public boolean checkTradeVO(
    ) {
        return sale_title != null && !sale_title.equals("") &&
                book_img != null && !book_img.equals("") &&
                book_title != null && !book_title.equals("") &&
                book_author != null && !book_author.equals("") &&
                book_publisher


                        != null && !book_publisher.equals("") &&
                isbn != null && !isbn.equals("") &&
                category_nm != null && !category_nm.equals("") &&
                sale_cont != null && !sale_cont.equals("");
    }

    public BookVO generateBook () {
        return new BookVO(isbn, book_title, book_author, book_publisher, book_img, book_org_price);
    }
}