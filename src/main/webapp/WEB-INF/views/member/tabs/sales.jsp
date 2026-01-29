<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="space-y-4">
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-bold text-gray-900">판매 내역</h2>

        <select id="status-filter"
                class="text-sm border border-gray-300 rounded px-3 py-2 outline-none focus:border-primary-500">
            <option value="all" ${selectedStatus == 'all' ? 'selected' : ''}>전체</option>
            <option value="PENDING" ${selectedStatus == 'SALES' ? 'selected' : ''}>판매중</option>
            <option value="SHIPPING" ${selectedStatus == 'RESERVE' ? 'selected' : ''}>예약중</option>
            <option value="COMPLETED" ${selectedStatus == 'SOLD' ? 'selected' : ''}>판매완료</option>
        </select>
    </div>

    <c:if test="${empty salesList}">
        <div class="text-center py-12 bg-white border border-gray-200 border-dashed rounded-lg">
            <i data-lucide="shopping-bag" class="w-16 h-16 text-gray-300 mx-auto mb-3"></i>
            <p class="text-gray-500 text-sm">판매 내역이 없습니다.</p>
        </div>
    </c:if>

    <c:forEach var="trade" items="${salesList}">
        <div class="bg-white p-5 rounded-lg border border-gray-200 flex gap-4 items-center">
            <div class="w-16 h-20 bg-gray-100 rounded border border-gray-100 flex items-center justify-center text-gray-400 shrink-0">
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
                                <span class="text-[10px] font-bold bg-blue-100 text-blue-600 px-1.5 py-0.5 rounded shrink-0">배송지</span>
                                <p class="text-[11px] text-gray-600 leading-tight">
                                    (${trade.post_no}) ${trade.addr_h} ${trade.addr_d}
                                </p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="flex items-center gap-1.5 text-orange-600">
                                <i data-lucide="info" class="w-3 h-3 shrink-0"></i>
                                <p class="text-[11px] font-medium leading-tight">
                                    직거래/반값택배 판매 내역입니다. 채팅으로 장소를 조율하세요.
                                </p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="flex flex-col gap-2 shrink-0">
                <button onclick="location.href='/trade/${trade.trade_seq}'"
                        class="text-xs bg-primary-600 text-white px-3 py-2 rounded font-bold hover:bg-primary-700 transition-colors">상세보기</button>
                <c:if test="${trade.sale_st == 'SALE'}">
                    <button type="button"
                            class="text-xs bg-blue-500 text-white px-3 py-2 rounded hover:bg-blue-600 transition-colors"
                            data-trade-seq="${trade.trade_seq}"
                            onclick="postTrade(${trade.trade_seq})">
                        판매처리
                    </button>
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

    // 판매상태 업데이트
    function postTrade(trade_seq) {
        const confirmed = confirm('정말 판매처리 하시겠습니까? 이후로는 상태 변경 불가합니다.');
        if (!confirmed) return;

        fetch('/trade/statusUpdate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'trade_seq=' + encodeURIComponent(trade_seq)
        })
        .then(res => {
            if (res.ok) {
                const salesTab = document.querySelector('a[data-tab="sales"]');
                if (salesTab) salesTab.click();
            } else {
                console.error('상태 업데이트 실패', res.status);
            }
        })
        .catch(err => console.error('네트워크 오류', err));
    }
</script>