<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="space-y-6">
    <div class="flex justify-between items-end mb-4 border-b border-gray-100 pb-4">
        <div>
            <h2 class="text-xl font-bold text-gray-900 tracking-tight">구매 내역</h2>
            <p class="text-xs text-gray-500 mt-1">구매한 상품의 내역 확인 및 구매 확정을 할 수 있습니다.</p>
        </div>

        <div class="relative">
            <select id="purchase-status-filter"
                    class="appearance-none pl-3 pr-8 py-2 text-sm border border-gray-300 rounded-md bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-shadow cursor-pointer">
                <option value="all" ${selectedStatus == 'all' ? 'selected' : ''}>전체 상태</option>
                <option value="ING" ${selectedStatus == 'ING' ? 'selected' : ''}>거래진행중</option>
                <option value="COMPLETED" ${selectedStatus == 'COMPLETED' ? 'selected' : ''}>구매확정</option>
            </select>
            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-500">
                <i data-lucide="chevron-down" class="w-4 h-4"></i>
            </div>
        </div>
    </div>

    <c:if test="${empty purchaseList}">
        <div class="flex flex-col items-center justify-center py-16 bg-gray-50 border border-gray-200 border-dashed rounded-xl">
            <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-4 text-gray-400">
                <i data-lucide="shopping-cart" class="w-8 h-8"></i>
            </div>
            <p class="text-gray-900 font-medium mb-1">구매 내역이 없습니다.</p>
            <p class="text-gray-500 text-sm">마음에 드는 책을 찾아보세요!</p>
            <a href="/trade" class="mt-4 px-5 py-2.5 bg-primary-600 text-white text-sm font-bold rounded-lg hover:bg-primary-700 transition">
                상품 둘러보기
            </a>
        </div>
    </c:if>

    <div class="flex flex-col gap-4">
        <c:forEach var="trade" items="${purchaseList}">
            <div class="group bg-white p-5 rounded-xl border border-gray-200 shadow-sm hover:shadow-md hover:border-primary-100 transition-all duration-200">
                <div class="flex gap-5">
                    <div class="w-20 h-28 flex-shrink-0 bg-gray-100 rounded-lg overflow-hidden border border-gray-100 relative">
                        <c:choose>
                            <c:when test="${not empty trade.book_img}">
                                <img src="${trade.book_img}" alt="${trade.sale_title}" class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105" />
                            </c:when>
                            <c:otherwise>
                                <div class="w-full h-full flex items-center justify-center text-gray-300">
                                    <i data-lucide="book" class="w-8 h-8"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <c:if test="${trade.confirm_purchase}">
                            <div class="absolute inset-0 bg-black/10 flex items-center justify-center">
                                <span class="bg-white/90 text-gray-800 text-[10px] font-bold px-1.5 py-0.5 rounded-sm border border-gray-200">확정됨</span>
                            </div>
                        </c:if>
                    </div>

                    <div class="flex-1 flex flex-col justify-between min-w-0">
                        <div>
                            <div class="flex items-center gap-2 mb-2">
                                <span class="text-[11px] text-gray-400 font-mono flex items-center gap-1">
                                    <i data-lucide="calendar" class="w-3 h-3"></i>
                                    <span data-date="${trade.sale_st_dtm}"></span>
                                </span>
                                <div class="h-2.5 w-px bg-gray-200"></div>
                                <span class="text-[11px] text-gray-400">No. ${trade.trade_seq}</span>
                            </div>

                            <h3 class="text-base font-bold text-gray-900 leading-tight truncate mb-1 group-hover:text-primary-600 transition-colors">
                                ${trade.sale_title}
                            </h3>

                            <p class="text-lg font-bold text-gray-900">
                                <fmt:formatNumber value="${trade.sale_price}" pattern="#,###" /><span class="text-sm font-normal text-gray-500 ml-0.5">원</span>
                            </p>
                        </div>

                        <div class="flex items-center gap-2 mt-3">
                            <c:choose>
                                <%-- 구매확정 상태 --%>
                                <c:when test="${trade.confirm_purchase}">
                                    <span class="inline-flex items-center gap-1 px-2 py-1 rounded bg-blue-50 text-blue-700 text-xs font-bold border border-blue-100">
                                        <i data-lucide="check-circle" class="w-3 h-3"></i> 구매확정
                                    </span>
                                </c:when>
                                <%-- 그 외 (거래 중) --%>
                                <c:otherwise>
                                    <span class="inline-flex items-center gap-1 px-2 py-1 rounded bg-orange-50 text-orange-700 text-xs font-bold border border-orange-100">
                                        <div class="w-1.5 h-1.5 rounded-full bg-orange-500 animate-pulse"></div> 거래진행중
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="flex flex-col justify-center gap-2 w-24 flex-shrink-0 border-l border-gray-100 pl-5">

                        <button onclick="location.href='/trade/${trade.trade_seq}'"
                                class="w-full py-2 rounded-lg border border-gray-300 text-xs font-bold text-gray-700 hover:bg-gray-50 hover:text-gray-900 transition-colors bg-white">
                            상세보기
                        </button>

                        <c:if test="${!trade.confirm_purchase}">
                             <button type="button"
                                    onclick="confirmPurchase(${trade.trade_seq})"
                                    class="w-full py-2 rounded-lg bg-gray-800 text-xs font-bold text-white hover:bg-gray-900 shadow-sm hover:shadow transition-all">
                                구매확정
                            </button>
                        </c:if>

                        <c:if test="${trade.confirm_purchase}">
                            <span class="text-[11px] font-bold text-blue-600 text-center block mt-1">
                                <i data-lucide="check" class="w-3 h-3 inline-block mr-0.5"></i>확정됨
                            </span>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    // 1. 날짜 포맷팅 (공통 로직)
    document.querySelectorAll('[data-date]').forEach(el => {
        const dateStr = el.getAttribute('data-date');
        if (dateStr) {
            const date = dateStr.split('T')[0].replace(/-/g, '.');
            el.textContent = date;
        }
    });

    // 2. 아이콘 초기화
    if (window.lucide) {
        lucide.createIcons();
    }

    // 3. 구매 확정 로직 (AJAX 아님 -> Form Submit 방식)
    function confirmPurchase(tradeSeq) {
        if(!confirm('구매를 확정하시겠습니까?\n확정 후에는 취소가 불가능합니다.')) return;

        fetch('/trade/confirm/' + tradeSeq, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: new URLSearchParams({ trade_seq: tradeSeq })
        })
        .then(res => res.json())
        .then(result => {
            if(result.success) {
                // 성공 시 맨 위 "구매 내역" 버튼 클릭 효과
                const topBtn = document.querySelector('a[data-tab="purchases"]');
                if(topBtn) topBtn.click();
                alert('구매 확정 완료!');
            } else {
                alert('구매 확정 실패');
            }
        })
        .catch(err => {
            console.error(err);
            alert('서버 요청 중 오류 발생');
        });
    }

</script>