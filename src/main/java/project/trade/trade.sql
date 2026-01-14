

-- 판매글 상세 조회
SELECT
    t.TRADE_SEQ            AS tradeSeq,
    t.SALE_TITLE           AS saleTitle,
    t.BOOK_ST              AS bookSt,
    t.SALE_CONT            AS saleCont,
    t.SALE_PRICE           AS salePrice,
    t.BOOK_DELIVERY_COST   AS bookDeliveryCost,
    t.SALE_RG              AS saleRg,
    t.SALE_ST              AS saleSt,
    t.SALE_ST_DTM          AS saleStDtm,
    t.VIEWS                AS views,
    t.WISH_CNT             AS wishCnt,
    t.BOOK_SALE_DTM        AS bookSaleDtm,
    t.POST_NO              AS postNo,
    t.ADDR_H               AS addressH,
    t.ADDR_D               AS addressD,
    t.RECIPIENT_PH         AS recipientPh,
    t.RECIPIENT_NM         AS recipientNm,
    t.CRT_DTM              AS crtDtm,
    t.UPD_DTM              AS updDtm,
    t.PAYMENT_TYPE         AS paymentType,
    t.CATEGORY_NM          AS categoryNm,
    t.BOOK_TITLE           AS bookTitle,
    t.BOOK_AUTHOR          AS bookAuthor,
    t.BOOK_PUBLISHER       AS bookPublisher,
    t.BOOK_IMG             AS bookImg,
    t.BOOK_ORG_PRICE       AS bookOrgPrice
FROM SB_TRADE_INFO t
WHERE t.TRADE_SEQ = #{?};

-- 이미지 조회
SELECT
    IMG_URL
FROM BOOK_IMAGE
WHERE TRADE_SEQ = #{?}
ORDER BY SORT_SEQ;
