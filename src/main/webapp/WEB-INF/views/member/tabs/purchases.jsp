<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="space-y-4">
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-bold text-gray-900">구매 내역</h2>

        <!-- ⭐ href만 수정 -->
        <select onchange="location.href='/mypage/purchases?status=' + this.value"
                class="text-sm border border-gray-300 rounded px-3 py-2 outline-none focus:border-primary-500">
            <option value="all" ${selectedStatus == 'all' ? 'selected' : ''}>전체</option>
            <option value="PENDING" ${selectedStatus == 'PENDING' ? 'selected' : ''}>결제대기</option>
            <option value="SHIPPING" ${selectedStatus == 'SHIPPING' ? 'selected' : ''}>배송중</option>
            <option value="COMPLETED" ${selectedStatus == 'COMPLETED' ? 'selected' : ''}>구매확정</option>
            <option value="CANCELLED" ${selectedStatus == 'CANCELLED' ? 'selected' : ''}>취소/환불</option>
        </select>
    </div>

    <!-- ⭐ 데이터가 없을 때 -->
    <c:if test="${empty purchaseList}">
        <div class="text-center py-12 bg-white border border-gray-200 border-dashed rounded-lg">
            <i data-lucide="shopping-bag" class="w-16 h-16 text-gray-300 mx-auto mb-3"></i>
            <p class="text-gray-500 text-sm">구매 내역이 없습니다.</p>
        </div>
    </c:if>

    <!-- ⭐ 데이터가 있을 때 (기존 디자인) -->
    <c:forEach var="trade" items="${purchaseList}">
        <div class="bg-white p-5 rounded-lg border border-gray-200 flex gap-4 items-center">
            <div class="w-16 h-20 bg-gray-100 rounded border border-gray-100 flex items-center justify-center text-gray-400">
                <c:choose>
                    <c:when test="${not empty trade.product_img_url}">
                        <img src="${trade.product_img_url}" alt="${trade.product_title}"
                             class="w-full h-full object-cover rounded" />
                    </c:when>
                    <c:otherwise>
                        <i data-lucide="book" class="w-6 h-6"></i>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="flex-1">
                <div class="flex justify-between mb-1">
                    <span class="text-xs font-bold text-gray-500">
                        <fmt:formatDate value="${trade.trade_dtm}" pattern="yyyy.MM.dd" />
                    </span>
                    <span class="text-xs font-bold px-2 py-0.5 rounded bg-primary-50 text-primary-600">
                        ${trade.trade_status}
                    </span>
                </div>
                <h3 class="font-bold text-gray-900 mb-1">${trade.product_title}</h3>
                <p class="text-sm text-gray-700">
                    <fmt:formatNumber value="${trade.trade_price}" pattern="#,###" />원
                </p>
            </div>

            <button onclick="location.href='/trade/${trade.trade_seq}'"
                    class="text-xs bg-primary-600 text-white px-3 py-2 rounded font-bold hover:bg-primary-700">상세보기</button>
        </div>
    </c:forEach>
</div>

<script>
    // Lucide 아이콘 다시 초기화
    lucide.createIcons();
</script>