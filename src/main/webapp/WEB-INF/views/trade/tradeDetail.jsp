<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

<div class="max-w-6xl mx-auto py-8">
    <!-- Breadcrumb -->
    <div class="text-xs text-gray-500 mb-4 flex items-center gap-2">
        <a href="/" class="cursor-pointer hover:text-gray-900">홈</a>
        <span>&gt;</span>
        <span class="cursor-pointer hover:text-gray-900">도서</span>
        <span>&gt;</span>
        <span class="cursor-pointer hover:text-gray-900">${trade.category_nm}</span>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
        <!-- Left: Images -->
        <div class="space-y-4 select-none">
            <div class="aspect-[1/1.2] bg-gray-100 rounded-lg overflow-hidden border border-gray-200 relative group">

                <!-- 대표 이미지 -->
                <c:choose>
                    <c:when test="${not empty trade.trade_img && trade.trade_img.size() > 0}">
                        <img id="mainImage"
                             src="${pageContext.request.contextPath}/img/${trade.trade_img[0].img_url}"
                             alt="${trade.book_title}"
                             class="w-full h-full object-contain p-4 bg-white" />
                    </c:when>
                    <c:otherwise>
                        <img id="mainImage"
                             src="${trade.book_img}"
                             alt="${trade.book_title}"
                             class="w-full h-full object-contain p-4 bg-white" />
                    </c:otherwise>
                </c:choose>

                <!-- 이미지 슬라이더 -->
                <c:if test="${not empty trade.trade_img && trade.trade_img.size() > 1}">
                    <button onclick="prevImage()" class="absolute left-2 top-1/2 -translate-y-1/2 bg-white/80 p-2 rounded-full shadow-md opacity-0 group-hover:opacity-100">
                        ◀
                    </button>
                    <button onclick="nextImage()" class="absolute right-2 top-1/2 -translate-y-1/2 bg-white/80 p-2 rounded-full shadow-md opacity-0 group-hover:opacity-100">
                        ▶
                    </button>
                    <div id="imageIndicator" class="absolute bottom-4 left-1/2 -translate-x-1/2 bg-black/50 text-white px-3 py-1 rounded-full text-xs">
                        1 / ${trade.trade_img.size()}
                    </div>
                </c:if>
            </div>

            <!-- Thumbnail -->
            <c:if test="${not empty trade.trade_img && trade.trade_img.size() > 1}">
                <div class="flex gap-2 overflow-x-auto">
                    <c:forEach var="img" items="${trade.trade_img}" varStatus="status">
                        <div onclick="setImage(${status.index})"
                             id="thumb-${status.index}"
                             class="w-20 h-20 border-2 ${status.index == 0 ? 'border-blue-500' : 'border-transparent'}">
                            <img src="${pageContext.request.contextPath}/img/${img.img_url}" class="w-full h-full object-cover"/>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>

        <!-- Right -->
        <div>
            <h1 class="text-2xl font-bold mb-4">
                ${trade.sale_title}
            </h1>

            <!-- 도서 정보 -->
            <div class="text-sm text-gray-600 mb-4">
                <b>${trade.book_title}</b> |
                ${trade.book_author} |
                ${trade.book_publisher}
            </div>

            <!-- 가격 -->
            <div class="text-3xl font-bold mb-4">
                <fmt:formatNumber value="${trade.sale_price}" pattern="#,###" /> 원
            </div>

            <!-- 배송 / 상태 -->
            <div class="text-sm text-gray-600 space-y-2">
                <div>
                    배송비 :
                    <c:choose>
                        <c:when test="${trade.delivery_cost > 0}">
                            <fmt:formatNumber value="${trade.delivery_cost}" pattern="#,###" /> 원
                        </c:when>
                        <c:otherwise>무료</c:otherwise>
                    </c:choose>
                </div>

                <div>
                    상태 : <b>${trade.book_st}</b>
                </div>

                <div>
                    거래지역 : ${trade.sale_rg}
                </div>
            </div>

            <!-- 설명 -->
            <div class="mt-6">
                <h3 class="font-bold mb-2">상품 설명</h3>
                <p class="whitespace-pre-wrap">${trade.sale_cont}</p>
            </div>

            <!-- 채팅하기 버튼 (로그인 & 본인 아닐 때만) -->
            <c:if test="${not empty sessionScope.loginSess && sessionScope.loginSess.member_seq != trade.member_seller_seq}">
                <form action="/chatrooms" method="post">
                    <input type="hidden" name="trade_seq" value="${trade.trade_seq}">
                    <input type="hidden" name="member_seller_seq" value="${trade.member_seller_seq}">
                    <button type="submit" class="w-full px-6 py-3 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600 transition font-bold">
                        채팅하기
                    </button>
                </form>
            </c:if>

            <!-- 수정/삭제 버튼 -->
            <c:if test="${not empty sessionScope.loginSess and sessionScope.loginSess.member_seq == trade.member_seller_seq}">
                <div class="mt-6 flex gap-3">
                    <a href="/trade/modify/${trade.trade_seq}"
                       class="flex-1 px-6 py-3 bg-primary-500 text-white text-center rounded-lg hover:bg-primary-600 transition font-bold">
                        수정
                    </a>
                    <form action="${pageConQtext.request.contextPath}/trade/delete/${trade.trade_seq}" method="post" class="flex-1"
                          onsubmit="return confirm('정말 삭제하시겠습니까?');">
                        <button type="submit"
                                class="w-full px-6 py-3 bg-red-500 text-white rounded-lg hover:bg-red-600 transition font-bold">
                            삭제
                        </button>
                    </form>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
const images = [
<c:choose>
    <c:when test="${not empty trade.trade_img}">
        <c:forEach var="img" items="${trade.trade_img}" varStatus="s">
            "${img.img_url}"<c:if test="${!s.last}">,</c:if>
        </c:forEach>
    </c:when>
    <c:otherwise>
        "${trade.book_img}"
    </c:otherwise>
</c:choose>
];

let idx = 0;

function setImage(i) {
    idx = i;
    update();
}
function prevImage() {
    idx = (idx - 1 + images.length) % images.length;
    update();
}
function nextImage() {
    idx = (idx + 1) % images.length;
    update();
}
function update() {
    document.getElementById("mainImage").src = "/img/" + images[idx];

    const ind = document.getElementById("imageIndicator");
    if (ind) ind.innerText = (idx + 1) + " / " + images.length;

    // 썸네일 테두리 업데이트 (선택사항이지만 추천)
    images.forEach((_, i) => {
        const t = document.getElementById("thumb-" + i);
        if (t) {
            t.classList.toggle("border-blue-500", i === idx);
            t.classList.toggle("border-transparent", i !== idx);
        }
    });
}
</script>

<jsp:include page="../common/footer.jsp" />
