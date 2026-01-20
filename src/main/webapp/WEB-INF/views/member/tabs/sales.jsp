<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="space-y-4">
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-bold text-gray-900">판매 내역</h2>

        <select onchange="location.href='/mypage/sales?status=' + this.value"
                class="text-sm border border-gray-300 rounded px-3 py-2 outline-none focus:border-primary-500">
            <option value="all" ${selectedStatus == 'all' ? 'selected' : ''}>전체</option>
            <option value="SELLING" ${selectedStatus == 'SELLING' ? 'selected' : ''}>판매중</option>
            <option value="RESERVED" ${selectedStatus == 'RESERVED' ? 'selected' : ''}>예약중</option>
            <option value="SOLD" ${selectedStatus == 'SOLD' ? 'selected' : ''}>판매완료</option>
        </select>
    </div>

    <c:if test="${empty salesList}">
        <div class="text-center py-12 bg-white border border-gray-200 border-dashed rounded-lg">
            <i data-lucide="package" class="w-16 h-16 text-gray-300 mx-auto mb-3"></i>
            <p class="text-gray-500 text-sm">판매 내역이 없습니다.</p>
        </div>
    </c:if>

    <c:forEach var="trade" items="${salesList}">
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
                    <span class="text-xs font-bold px-2 py-0.5 rounded bg-gray-800 text-white">
                        ${trade.trade_status}
                    </span>
                </div>
                <h3 class="font-bold text-gray-900 mb-1">${trade.product_title}</h3>
                <p class="text-sm text-gray-700">
                    <fmt:formatNumber value="${trade.trade_price}" pattern="#,###" />원
                </p>
            </div>

            <button onclick="location.href='/trade/${trade.trade_seq}'"
                    class="text-xs border border-gray-300 px-3 py-2 rounded font-bold hover:bg-gray-50">상세보기</button>
        </div>
    </c:forEach>
</div>

<script>
    lucide.createIcons();
</script>