<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="space-y-4">
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-bold text-gray-900">구매 내역</h2>
    </div>

    <!-- 데이터가 없을 때 -->
    <c:if test="${empty purchaseList}">
        <div class="text-center py-12 bg-white border border-gray-200 border-dashed rounded-lg">
            <i data-lucide="shopping-bag" class="w-16 h-16 text-gray-300 mx-auto mb-3"></i>
            <p class="text-gray-500 text-sm">구매 내역이 없습니다.</p>
        </div>
    </c:if>

    <!-- 데이터가 있을 때 -->
    <c:forEach var="trade" items="${purchaseList}">
        <div class="bg-white p-5 rounded-lg border border-gray-200 flex gap-4 items-center">
            <!-- 이미지 영역 -->
            <div class="w-16 h-20 bg-gray-100 rounded border flex items-center justify-center text-gray-400">
                <c:choose>
                    <c:when test="${not empty trade.trade_img and not empty trade.trade_img[0].img_url}">
                        <img src="${trade.trade_img[0].img_url}" alt="${trade.sale_title}" class="w-full h-full object-cover rounded" />
                    </c:when>
                    <c:when test="${not empty trade.book_img}">
                        <img src="${trade.book_img}" alt="${trade.sale_title}" class="w-full h-full object-cover rounded" />
                    </c:when>
                    <c:otherwise>
                        <i data-lucide="book" class="w-6 h-6"></i>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 내용 영역 -->
            <div class="flex-1">
                <span class="text-xs font-bold text-gray-500 mb-1 block" data-date="${trade.sale_st_dtm}"></span>
                <h3 class="font-bold text-gray-900 mb-1">${trade.sale_title}</h3>
                <p class="text-sm text-gray-700">
                    <fmt:formatNumber value="${trade.sale_price}" pattern="#,###" />원
                </p>
            </div>

            <!-- 버튼 영역 -->
            <div class="flex flex-col gap-2">
                <button onclick="location.href='/trade/${trade.trade_seq}'" class="text-xs bg-primary-600 text-white px-3 py-2 rounded font-bold hover:bg-primary-700">상세보기</button>

                <c:if test="${trade.confirm_purchase == false}">
                    <button onclick="confirmPurchase(${trade.trade_seq})" class="text-xs bg-blue-500 text-white px-3 py-2 rounded hover:bg-blue-600">구매 확정</button>
                </c:if>

                <c:if test="${trade.confirm_purchase == true}">
                    <span class="text-gray-500 text-xs">구매 확정됨</span>
                </c:if>
            </div>
        </div>
    </c:forEach>
</div>

<script>
    // LocalDateTime 포맷팅
    document.querySelectorAll('[data-date]').forEach(el => {
        const dateStr = el.getAttribute('data-date');
        if (dateStr) {
            const date = dateStr.split('T')[0].replace(/-/g, '.');
            el.textContent = date;
        }
    });
    lucide.createIcons();
</script>
