<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

<div class="max-w-6xl mx-auto py-8">
    <div class="text-xs text-gray-500 mb-4 flex items-center gap-2">
        <a href="/" class="cursor-pointer hover:text-gray-900">홈</a>
        <span>&gt;</span>
        <span class="cursor-pointer hover:text-gray-900">도서</span>
        <span>&gt;</span>
        <span class="cursor-pointer hover:text-gray-900">${trade.category_nm}</span>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
        <div class="space-y-4 select-none">
            <div class="aspect-[1/1.2] bg-gray-100 rounded-lg overflow-hidden border border-gray-200 relative group">

                <c:choose>
                    <c:when test="${not empty trade.trade_img && trade.trade_img.size() > 0}">
                        <c:set var="firstImg" value="${trade.trade_img[0].img_url}" />
                        <img id="mainImage"
                             src="${firstImg.startsWith('http') ? firstImg : pageContext.request.contextPath.concat('/img/').concat(firstImg)}"
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

                <c:if test="${not empty trade.trade_img && trade.trade_img.size() > 1}">
                    <button onclick="prevImage()" class="absolute left-2 top-1/2 -translate-y-1/2 bg-white/80 p-2 rounded-full shadow-md opacity-0 group-hover:opacity-100 transition-opacity">
                        ◀
                    </button>
                    <button onclick="nextImage()" class="absolute right-2 top-1/2 -translate-y-1/2 bg-white/80 p-2 rounded-full shadow-md opacity-0 group-hover:opacity-100 transition-opacity">
                        ▶
                    </button>
                    <div id="imageIndicator" class="absolute bottom-4 left-1/2 -translate-x-1/2 bg-black/50 text-white px-3 py-1 rounded-full text-xs">
                        1 / ${trade.trade_img.size()}
                    </div>
                </c:if>
            </div>

            <c:if test="${not empty trade.trade_img && trade.trade_img.size() > 1}">
                <div class="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
                    <c:forEach var="img" items="${trade.trade_img}" varStatus="status">
                        <div onclick="setImage(${status.index})"
                             id="thumb-${status.index}"
                             class="w-20 h-20 border-2 cursor-pointer transition-all ${status.index == 0 ? 'border-blue-500' : 'border-transparent'}">
                            <img src="${img.img_url.startsWith('http') ? img.img_url : pageContext.request.contextPath.concat('/img/').concat(img.img_url)}"
                                 class="w-full h-full object-cover"/>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>

        <div>
            <h1 class="text-2xl font-bold mb-4">${trade.sale_title}</h1>

            <div class="text-sm text-gray-600 mb-4">
                <b>${trade.book_title}</b> | ${trade.book_author} | ${trade.book_publisher}
            </div>

            <div class="mb-4 space-y-1">
                <c:if test="${trade.book_org_price > 0}">
                    <fmt:parseNumber var="discountRate" value="${((trade.book_org_price - trade.sale_price) * 100) / trade.book_org_price}" integerOnly="true" />
                    <div class="flex items-end gap-3">
                        <div class="text-3xl font-bold text-gray-900"><fmt:formatNumber value="${trade.sale_price}" pattern="#,###" /> 원</div>
                        <div class="text-sm font-bold text-red-500">${discountRate}%</div>
                        <div class="text-lg text-gray-400 line-through"><fmt:formatNumber value="${trade.book_org_price}" pattern="#,###" /> 원</div>
                    </div>
                </c:if>
                <c:if test="${trade.book_org_price <= 0}">
                    <div class="text-3xl font-bold text-gray-900"><fmt:formatNumber value="${trade.sale_price}" pattern="#,###" /> 원</div>
                </c:if>
            </div>

            <div class="text-sm text-gray-600 space-y-2 border-b pb-6">
                <div>배송비 : <c:choose><c:when test="${trade.delivery_cost > 0}"><fmt:formatNumber value="${trade.delivery_cost}" pattern="#,###" /> 원</c:when><c:otherwise>무료</c:otherwise></c:choose></div>
                <div>상태 : <b>
                    <c:choose>
                        <c:when test="${trade.book_st eq 'LIKE_NEW'}">거의 새책</c:when>
                        <c:when test="${trade.book_st eq 'GOOD'}">좋음</c:when>
                        <c:when test="${trade.book_st eq 'USED'}">사용됨</c:when>
                        <c:when test="${trade.book_st eq 'NEW'}">새책</c:when>
                        <c:otherwise>상태정보 없음</c:otherwise>
                    </c:choose></b>
                </div>
                <div>거래지역 : ${trade.sale_rg}</div>
            </div>

            <div class="mt-6">
                <h3 class="font-bold mb-2">상품 설명</h3>
                <p class="whitespace-pre-wrap text-gray-700 leading-relaxed">${trade.sale_cont}</p>
            </div>

            <div class="mt-8 border-t pt-6">
                <h3 class="font-bold mb-3 text-lg text-gray-800">판매자 정보</h3>
                <c:choose>
                    <c:when test="${not empty seller_info}">
                        <div class="flex items-center gap-4 bg-gray-50 p-4 rounded-xl">
                           <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center font-bold text-blue-600">
                               ${seller_info.member_nicknm.substring(0,1)}
                           </div>
                            <div class="text-sm">
                                <div class="text-gray-400 text-xs">판매자</div>
                                <div class="font-bold text-gray-800">${seller_info.member_nicknm}</div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-sm text-gray-400 italic">판매자 정보를 불러올 수 없습니다.</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty sessionScope.loginSess and trade.member_seller_seq != sessionScope.loginSess.member_seq}">
                <div class="mt-6 flex gap-3">
                    <form action="/chatrooms" method="post" class="flex-[3]">
                        <input type="hidden" name="trade_seq" value="${trade.trade_seq}">
                        <input type="hidden" name="member_seller_seq" value="${trade.member_seller_seq}">
                        <input type="hidden" name="sale_title" value="${trade.sale_title}">
                        <button type="submit" class="w-full px-6 py-3.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-bold transition-all shadow-sm flex items-center justify-center gap-2">
                            채팅하기
                        </button>
                    </form>
                    <form id="wishForm-${trade.trade_seq}" class="flex-1">
                        <input type="hidden" name="trade_seq" value="${trade.trade_seq}" />
                        <button type="button" onclick="toggleWish(${trade.trade_seq})"
                                class="w-full px-4 py-3.5 border-2 rounded-xl transition-all flex items-center justify-center gap-2 ${wished ? 'border-red-200 bg-red-50 text-red-500' : 'border-gray-200 bg-white text-gray-400 hover:bg-red-50 hover:text-red-500'}">
                            <span id="wishCount-${trade.trade_seq}" class="text-sm font-bold">${wishCount}</span>
                        </button>
                    </form>
                </div>
            </c:if>

            <c:if test="${trade.sale_st ne 'SOLD' and ((not empty sessionScope.loginSess and sessionScope.loginSess.member_seq == trade.member_seller_seq) or (not empty sessionScope.adminSess))}">
                <div class="mt-6 flex gap-3 pt-6 border-t border-gray-100">
                    <a href="/trade/modify/${trade.trade_seq}"
                       class="flex-1 px-6 py-2.5 bg-gray-100 text-gray-600 text-center rounded-lg hover:bg-gray-200 transition font-bold text-sm">
                        수정하기
                    </a>
                    <form action="${pageContext.request.contextPath}/trade/delete/${trade.trade_seq}" method="post" class="flex-1"
                          onsubmit="return confirm('정말 삭제하시겠습니까?');">
                        <button type="submit"
                                class="w-full px-6 py-2.5 bg-white text-red-500 border border-red-100 rounded-lg hover:bg-red-50 transition font-bold text-sm">
                            삭제하기
                        </button>
                    </form>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
// 이미지 배열 초기화
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

/** * 핵심 업데이트 함수:
 * 이미지 파일명이 http로 시작하면(S3) 그대로 사용하고,
 * 아니면(로컬) 앞에 /img/ 경로를 붙입니다.
 */
function update() {
    const mainImg = document.getElementById("mainImage");
    const currentPath = images[idx];

    if (currentPath.startsWith('http')) {
        mainImg.src = currentPath;
    } else {
        mainImg.src = "${pageContext.request.contextPath}/img/" + currentPath;
    }

    const ind = document.getElementById("imageIndicator");
    if (ind) ind.innerText = (idx + 1) + " / " + images.length;

    images.forEach((_, i) => {
        const t = document.getElementById("thumb-" + i);
        if (t) {
            t.classList.toggle("border-blue-500", i === idx);
            t.classList.toggle("border-transparent", i !== idx);
        }
    });
}

// 찜하기 기능 (기존과 동일)
function toggleWish(tradeSeq) {
    const form = document.getElementById(`wishForm-\${tradeSeq}`);
    if (!form) return;
    const countSpan = document.getElementById(`wishCount-\${tradeSeq}`);
    const formData = new FormData(form);

    fetch("/trade/like", {
        method: "POST",
        body: formData,
        headers: { "X-Requested-With": "XMLHttpRequest" }
    })
    .then(res => res.json())
    .then(data => {
        if (!data.success) { alert(data.message || "찜 실패"); return; }
        location.reload(); // 상태 반영을 위해 간단히 리로드하거나 위 로직대로 클래스 제어
    })
    .catch(err => console.error(err));
}
</script>

<jsp:include page="../common/footer.jsp" />