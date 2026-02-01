<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="space-y-5 animate-[fadeIn_0.3s_ease-out]"> <div class="flex justify-between items-center mb-1 px-1">
    <h2 class="text-2xl font-black text-gray-900 tracking-tight flex items-center gap-2">
        판매 내역 <span class="text-sm font-bold text-gray-500 bg-gray-100 px-2.5 py-0.5 rounded-full">${salesList != null ? salesList.size() : 0}건</span>
    </h2>
</div>

    <c:if test="${empty salesList}">
        <div class="py-24 text-center border-2 border-dashed border-gray-200 rounded-[2rem] bg-gray-50/50">
            <div class="w-16 h-16 bg-white rounded-full flex items-center justify-center mx-auto mb-4 text-gray-300 shadow-sm">
                <i data-lucide="package-open" class="w-8 h-8"></i>
            </div>
            <p class="text-base text-gray-500 font-bold">판매 내역이 없습니다.</p>
        </div>
    </c:if>

    <div class="space-y-4">
        <c:forEach var="trade" items="${salesList}">
            <div class="bg-white p-5 rounded-3xl border border-gray-100 hover:border-gray-200 hover:shadow-lg transition-all duration-300 flex gap-5 items-center relative group">

                <div class="w-20 h-24 bg-gray-50 rounded-2xl border border-gray-100 flex-shrink-0 overflow-hidden shadow-inner">
                    <c:choose>
                        <c:when test="${not empty trade.book_img}">
                            <img src="${trade.book_img}" alt="${trade.sale_title}"
                                 class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                                 onerror="this.src='https://placehold.co/200x300?text=No+Image'"/>
                        </c:when>
                        <c:otherwise>
                            <div class="w-full h-full flex items-center justify-center text-gray-300"><i data-lucide="book" class="w-8 h-8"></i></div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="flex-1 min-w-0 py-0.5"> <div class="flex items-center gap-2 mb-1.5"> <span class="text-[10px] font-bold text-gray-400 bg-gray-100 px-2 py-0.5 rounded-md date-format" data-date="${trade.sale_st_dtm}"></span>
                    <c:choose>
                        <c:when test="${trade.sale_st == 'SALE'}">
                            <span class="text-[10px] font-bold text-blue-600 bg-blue-50 px-2 py-0.5 rounded-md">판매중</span>
                        </c:when>
                        <c:when test="${trade.sale_st == 'SOLD'}">
                            <span class="text-[10px] font-bold text-gray-600 bg-gray-100 px-2 py-0.5 rounded-md">판매완료</span>
                        </c:when>
                        <c:otherwise>
                            <span class="text-[10px] font-bold text-orange-600 bg-orange-50 px-2 py-0.5 rounded-md">예약중</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                    <h3 class="font-bold text-gray-900 text-base mb-1 truncate group-hover:text-primary-600 transition-colors">${trade.sale_title}</h3>

                    <div class="mb-2"> <p class="text-sm font-medium text-gray-500">
                        <fmt:formatNumber value="${trade.sale_price}" pattern="#,###" /><span class="text-xs font-normal ml-0.5">원</span>
                    </p>
                    </div>

                    <div class="p-2 bg-gray-50/80 rounded-lg border border-gray-100/80"> <c:choose>
                        <c:when test="${not empty trade.post_no}">
                            <div class="flex items-center gap-2"> <span class="text-[10px] font-bold bg-blue-100 text-blue-600 px-1.5 py-0.5 rounded shrink-0">배송지</span>

                                <c:set var="fullAddr" value="${trade.addr_h} ${trade.addr_d}" />
                                <p class="text-[11px] text-gray-600 leading-tight truncate" title="${fullAddr}">
                                    <c:choose>
                                        <c:when test="${fn:length(fullAddr) > 50}">
                                            ${fn:substring(fullAddr, 0, 50)}...
                                        </c:when>
                                        <c:otherwise>
                                            ${fullAddr}
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="flex items-center gap-1.5 text-orange-600">
                                <i data-lucide="info" class="w-3 h-3 shrink-0"></i>
                                <p class="text-[11px] font-medium leading-tight truncate">
                                    직거래/반값택배 판매 내역입니다.
                                </p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    </div>
                </div>

                <div class="flex flex-col gap-2 min-w-[90px] justify-center h-full">
                    <button onclick="location.href='/trade/${trade.trade_seq}'"
                            class="px-4 py-2 bg-gray-50 text-gray-600 rounded-xl text-xs font-bold hover:bg-gray-100 hover:text-gray-900 transition w-full border border-transparent hover:border-gray-200">
                        상세보기
                    </button>
                    <c:if test="${trade.sale_st == 'SALE'}">
                        <button type="button"
                                class="px-4 py-2 bg-blue-600 text-white rounded-xl text-xs font-bold hover:bg-blue-700 transition shadow-md hover:shadow-lg w-full"
                                onclick="SalesTab.completeSale(${trade.trade_seq})">
                            판매 완료
                        </button>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
<script>
    (function(){
        const SalesTab = {
            init: function() {
                this.formatDates();
                if(window.lucide) lucide.createIcons();
            },

            formatDates: function() {
                document.querySelectorAll('.date-format').forEach(el => {
                    const dateStr = el.dataset.date;
                    if(dateStr) {
                        const date = dateStr.includes('T') ? dateStr.split('T')[0].replace(/-/g, '.') : dateStr.replace(/-/g, '.');
                        el.textContent = date;
                    }
                });
            },

            completeSale: function(tradeSeq) {
                if(!confirm('정말 판매 완료 처리하시겠습니까?\n이후로는 상태를 변경할 수 없습니다.')) return;

                fetch('/trade/sold', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'trade_seq=' + encodeURIComponent(tradeSeq),
                    credentials: 'same-origin'
                })
                .then(res => res.json())
                .then(data => {
                    if(data.success) {
                        alert('판매 완료 처리되었습니다.');
                        if(typeof loadTab === 'function') loadTab(null, 'sales');
                        else location.reload();
                    } else {
                        alert('처리 중 오류: ' + (data.message || '알 수 없는 오류'));
                        console.error('판매 완료 실패:', data);
                    }
                })
                .catch(err => {
                    console.error('네트워크/서버 오류:', err);
                    alert('네트워크 오류가 발생했습니다.');
                });
            }
        };

        // 전역에 노출
        window.SalesTab = SalesTab;

        // 초기화
        SalesTab.init();
    })();
</script>
