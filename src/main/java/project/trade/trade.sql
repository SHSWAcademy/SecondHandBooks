

-- 판매글 상세 조회
select
    ,sb.CATEGORY_NM
    ,sb.SALE_TITLE
    ,b.BOOK_TITLE
    ,b.BOOK_AUTHOR
    ,b.BOOK_PUBLISHER
    ,b.BOOK_ORG_PRICE
    ,b.BOOK_IMG
    ,sb.BOOK_DELIVERY_COST
    ,sb.BOOK_ST
    ,sb.SALE_RG
    ,sb.SALE_CONT
    ,sb.SELLER_NM
    ,sb.CRT_DTM
    ,i.IMG_URL
from SB_TRADE_INFO as sb
join BOOK_INFO as b
on sb.BOOK_SEQ = b.BOOK_SEQ
join BOOK_IMAGE as i
on sb.TRADE_SEQ = i.TRADE_SEQ
where sb.TRADE_SEQ = #{tradeSeq}
