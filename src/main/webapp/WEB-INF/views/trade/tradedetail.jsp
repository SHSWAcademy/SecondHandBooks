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
            <div class="mb-4 space-y-1">

                <c:if test="${trade.book_org_price > 0}">
                    <!-- 할인율 계산 -->
                    <fmt:parseNumber var="discountRate"
                        value="${((trade.book_org_price - trade.sale_price) * 100) / trade.book_org_price}"
                        integerOnly="true" />

                    <div class="flex items-end gap-3">
                        <!-- 판매가 -->
                        <div class="text-3xl font-bold text-gray-900">
                            <fmt:formatNumber value="${trade.sale_price}" pattern="#,###" /> 원
                        </div>

                        <!-- 할인율 -->
                        <div class="text-sm font-bold text-red-500">
                            ${discountRate}%
                        </div>

                        <!-- 정가 (취소선) -->
                        <div class="text-lg text-gray-400 line-through">
                            <fmt:formatNumber value="${trade.book_org_price}" pattern="#,###" /> 원
                        </div>
                    </div>
                </c:if>

                <!-- 정가 없을 때 -->
                <c:if test="${trade.book_org_price <= 0}">
                    <div class="text-3xl font-bold text-gray-900">
                        <fmt:formatNumber value="${trade.sale_price}" pattern="#,###" /> 원
                    </div>
                </c:if>

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
                    상태 :
                    <b>
                        <c:choose>
                            <c:when test="${trade.book_st eq 'LIKE_NEW'}">거의 새책</c:when>
                            <c:when test="${trade.book_st eq 'GOOD'}">좋음</c:when>
                            <c:when test="${trade.book_st eq 'USED'}">사용됨</c:when>
                            <c:when test="${trade.book_st eq 'NEW'}">새책</c:when>
                            <c:otherwise>상태정보 없음</c:otherwise>
                        </c:choose>
                    </b>
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

            <!-- 판매자 정보 -->
            <div class="mt-8 border-t pt-6">
                <h3 class="font-bold mb-3 text-lg">판매자 정보</h3>

                <c:choose>
                    <c:when test="${not empty seller_info}">
                        <div class="flex items-center gap-4">
                           <div class="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center font-bold text-gray-600">

                           </div>
                            <div class="text-sm space-y-1">
                                <div>
                                    닉네임 :
                                    <b>${seller_info.member_nicknm}</b>
                                </div>
                            </div>

                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="text-sm text-gray-400">
                            판매자 정보를 불러올 수 없습니다.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>


            <c:if test="${not empty sessionScope.loginSess and trade.member_seller_seq != sessionScope.loginSess.member_seq}">
                <div class="mt-6 flex items-center gap-4">

                    <!-- 채팅하기 버튼 -->
                    <form action="/chatrooms" method="post" class="flex-1">
                        <input type="hidden" name="trade_seq" value="${trade.trade_seq}">
                        <input type="hidden" name="member_seller_seq" value="${trade.member_seller_seq}">
                        <input type="hidden" name="sale_title" value="${trade.sale_title}">

                        <button type="submit"
                                class="w-full px-6 py-3 rounded-lg font-bold text-white transition flex items-center justify-center gap-2"
                                style="background-color:#0036cc;">
                            <!-- 채팅 아이콘 -->
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                 viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                            </svg>
                            채팅하기
                        </button>
                    </form>

                    <!-- 찜하기 -->
                    <form id="wishForm-${trade.trade_seq}" class="flex items-center gap-1">
                        <input type="hidden" name="trade_seq" value="${trade.trade_seq}" />

                        <button type="button"
                                onclick="toggleWish(${trade.trade_seq})"
                                class="text-2xl transition ${wished ? 'text-red-500 active' : 'text-gray-400'}"
                                title="찜하기">
                            ♥
                        </button>

                        <span id="wishCount-${trade.trade_seq}" class="text-sm text-gray-600">
                            ${wishCount}
                        </span>
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

function toggleWish(tradeSeq) {
    const form = document.getElementById(`wishForm-${tradeSeq}`);
    if (!form) return;

    const btn = form.querySelector("button");
    const countSpan = document.getElementById(`wishCount-${tradeSeq}`);
    if (!btn || !countSpan) return;

    const formData = new FormData(form);

    fetch("/trade/like", {
        method: "POST",
        body: formData,
        headers: {
            "X-Requested-With": "XMLHttpRequest"
        }
    })
    .then(async res => {
        const text = await res.text();
        try {
            return JSON.parse(text);
        } catch (e) {
            throw new Error("서버 응답이 JSON이 아닙니다:\n" + text);
        }
    })
    .then(data => {
        if (!data.success) {
            alert(data.message || "찜 처리 실패");
            return;
        }

        // 버튼 상태 반영
        if (data.wished) {
            btn.classList.add("active", "text-red-500");
            btn.classList.remove("text-gray-400");
            countSpan.textContent = parseInt(countSpan.textContent) + 1;
        } else {
            btn.classList.remove("active", "text-red-500");
            btn.classList.add("text-gray-400");
            countSpan.textContent = parseInt(countSpan.textContent) - 1;
        }
    })
    .catch(err => {
        console.error(err);
        alert("네트워크 오류 또는 서버 오류 발생");
    });
}




</script>

<jsp:include page="../common/footer.jsp" />
