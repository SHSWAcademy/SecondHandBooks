<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="space-y-4">
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-bold text-gray-900">구매 내역</h2>
    </div>

    <c:if test="${empty purchaseList}">
        <div class="text-center py-12 bg-white border border-gray-200 border-dashed rounded-lg">
            <i data-lucide="shopping-bag" class="w-16 h-16 text-gray-300 mx-auto mb-3"></i>
            <p class="text-gray-500 text-sm">구매 내역이 없습니다.</p>
        </div>
    </c:if>

    <c:forEach var="trade" items="${purchaseList}">
        <div class="bg-white p-5 rounded-lg border border-gray-200 flex gap-4 items-center">
            <div class="w-16 h-20 bg-gray-100 rounded border flex items-center justify-center text-gray-400 shrink-0">
                <c:choose>
                    <c:when test="${not empty trade.book_img}">
                        <img src="${trade.book_img}" alt="${trade.sale_title}" class="w-full h-full object-cover rounded" />
                    </c:when>
                    <c:otherwise>
                        <i data-lucide="book" class="w-6 h-6"></i>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="flex-1 min-w-0">
                <span class="text-xs font-bold text-gray-500 mb-1 block" data-date="${trade.sale_st_dtm}"></span>
                <h3 class="font-bold text-gray-900 mb-1 truncate">${trade.sale_title}</h3>
                <p class="text-sm text-gray-700 font-medium mb-2">
                    <fmt:formatNumber value="${trade.sale_price}" pattern="#,###" />원
                </p>

                <div class="p-2.5 bg-gray-50 rounded-lg border border-gray-100">
                    <c:choose>
                        <c:when test="${not empty trade.post_no}">
                            <div class="flex items-start gap-1.5">
                                <span class="text-[10px] font-bold bg-primary-100 text-primary-600 px-1.5 py-0.5 rounded shrink-0">배송지</span>
                                <p class="text-[11px] text-gray-600 leading-tight">
                                    (${trade.post_no}) ${trade.addr_h} ${trade.addr_d}
                                </p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="flex items-center gap-1.5 text-orange-600">
                                <i data-lucide="info" class="w-3 h-3 shrink-0"></i>
                                <p class="text-[11px] font-medium leading-tight">
                                    직거래/반값택배 구매 내역입니다. 채팅으로 장소를 조율하세요.
                                </p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="flex flex-col gap-2 shrink-0">
                <button onclick="location.href='/trade/${trade.trade_seq}'" class="text-xs bg-primary-600 text-white px-3 py-2 rounded font-bold hover:bg-primary-700 transition-colors">상세보기</button>

                <c:if test="${trade.confirm_purchase == false}">
                    <button onclick="confirmPurchase(${trade.trade_seq})" class="text-xs bg-blue-500 text-white px-3 py-2 rounded hover:bg-blue-600 transition-colors">구매 확정</button>
                </c:if>

                <c:if test="${trade.confirm_purchase == true}">
                    <div class="flex items-center justify-center gap-1 text-gray-400 py-1">
                        <i data-lucide="check-circle-2" class="w-3 h-3"></i>
                        <span class="text-[11px] font-medium">구매 확정됨</span>
                    </div>
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