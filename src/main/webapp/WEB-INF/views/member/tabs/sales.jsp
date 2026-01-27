<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="space-y-6">
    <div class="flex justify-between items-end mb-4 border-b border-gray-100 pb-4">
        <div>
            <h2 class="text-xl font-bold text-gray-900 tracking-tight">판매 내역</h2>
            <p class="text-xs text-gray-500 mt-1">등록한 상품의 판매 상태와 정산 내역을 관리합니다.</p>
        </div>

        <div class="relative">
            <select id="status-filter"
                    class="appearance-none pl-3 pr-8 py-2 text-sm border border-gray-300 rounded-md bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-shadow cursor-pointer">
                <option value="all" ${selectedStatus == 'all' ? 'selected' : ''}>전체 상태</option>
                <option value="PENDING" ${selectedStatus == 'SALES' ? 'selected' : ''}>판매중</option>
                <option value="SHIPPING" ${selectedStatus == 'RESERVE' ? 'selected' : ''}>예약중</option>
                <option value="COMPLETED" ${selectedStatus == 'SOLD' ? 'selected' : ''}>판매완료</option>
            </select>
            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-500">
                <i data-lucide="chevron-down" class="w-4 h-4"></i>
            </div>
        </div>
    </div>

    <c:if test="${empty salesList}">
        <div class="flex flex-col items-center justify-center py-16 bg-gray-50 border border-gray-200 border-dashed rounded-xl">
            <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-4 text-gray-400">
                <i data-lucide="shopping-bag" class="w-8 h-8"></i>
            </div>
            <p class="text-gray-900 font-medium mb-1">판매 내역이 없습니다.</p>
            <p class="text-gray-500 text-sm">새로운 상품을 등록하여 판매를 시작해보세요.</p>
        </div>
    </c:if>

    <div class="flex flex-col gap-4">
        <c:forEach var="trade" items="${salesList}">
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
                        <c:if test="${trade.sale_st ne 'SALE'}">
                            <div class="absolute inset-0 bg-black/40 flex items-center justify-center">
                                <span class="text-white text-xs font-bold px-2 py-1 border border-white/50 rounded-sm">판매완료</span>
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
                                <c:when test="${trade.sale_st eq 'SALE'}">
                                    <span class="inline-flex items-center gap-1 px-2 py-1 rounded bg-green-50 text-green-700 text-xs font-bold border border-green-100">
                                        <div class="w-1.5 h-1.5 rounded-full bg-green-500"></div> 판매중
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="inline-flex items-center gap-1 px-2 py-1 rounded bg-gray-100 text-gray-600 text-xs font-bold border border-gray-200">
                                        판매완료
                                    </span>
                                </c:otherwise>
                            </c:choose>

                            <c:if test="${trade.confirm_purchase}">
                                <span class="inline-flex items-center px-2 py-1 rounded bg-blue-50 text-blue-600 text-xs font-bold border border-blue-100">
                                    구매확정
                                </span>
                            </c:if>

                            <c:if test="${trade.is_settled}">
                                <button type="button"
                                        class="text-xs text-gray-500 underline hover:text-gray-800 ml-1"
                                        onclick="toggleSettlementPopup(${trade.trade_seq})">
                                    정산내역 확인
                                </button>
                            </c:if>
                        </div>
                    </div>

                    <div class="flex flex-col justify-center gap-2 w-24 flex-shrink-0 border-l border-gray-100 pl-5">
                        <button onclick="location.href='/trade/${trade.trade_seq}'"
                                class="w-full py-2 rounded-lg border border-gray-300 text-xs font-bold text-gray-700 hover:bg-gray-50 hover:text-gray-900 transition-colors bg-white">
                            상세보기
                        </button>

                        <c:if test="${trade.sale_st eq 'SALE'}">
                            <button type="button"
                                    class="w-full py-2 rounded-lg bg-primary-600 text-xs font-bold text-white hover:bg-primary-700 shadow-sm hover:shadow transition-all"
                                    onclick="postTrade(${trade.trade_seq})">
                                판매처리
                            </button>
                        </c:if>
                    </div>
                </div>

                <div id="settlement-popup-${trade.trade_seq}"
                     class="hidden absolute z-50 mt-2 right-0 w-72 bg-white rounded-xl shadow-xl border border-gray-200 p-5 animate-in fade-in zoom-in-95 duration-200"
                     style="left: 50%; top: 50%; transform: translate(-50%, -50%); position: fixed;">

                    <div class="flex justify-between items-center mb-4">
                        <h4 class="font-bold text-gray-900 text-sm">정산 상세 내역</h4>
                        <button onclick="toggleSettlementPopup(${trade.trade_seq})" class="text-gray-400 hover:text-gray-600">
                            <i data-lucide="x" class="w-4 h-4"></i>
                        </button>
                    </div>

                    <div class="space-y-3 text-sm">
                        <!-- 상품금액 -->
                        <div class="flex justify-between">
                            <span class="text-gray-500">상품금액</span>
                            <span class="font-medium text-gray-900">
                                <fmt:formatNumber value="${trade.sale_price}" pattern="#,###" />원
                            </span>
                        </div>

                        <!-- 배송비 -->
                        <div class="flex justify-between">
                            <span class="text-gray-500">배송비</span>
                            <span class="font-medium text-gray-900">
                                <fmt:formatNumber value="${trade.delivery_cost}" pattern="#,###" />원
                            </span>
                        </div>

                        <!-- 수수료 (총 금액의 1%) -->
                        <div class="flex justify-between">
                            <span class="text-gray-500">수수료 (1%)</span>
                            <span class="font-medium text-red-500">
                                <fmt:formatNumber value="${(trade.sale_price + trade.delivery_cost) * 0.01}" pattern="#,###" />원
                            </span>
                        </div>

                        <div class="h-px bg-gray-100 my-1"></div>

                        <!-- 총금액 -->
                        <div class="flex justify-between items-center">
                            <span class="font-bold text-gray-900">총금액</span>
                            <span class="font-bold text-primary-600 text-lg">
                                <fmt:formatNumber value="${(trade.sale_price + trade.delivery_cost) - ((trade.sale_price + trade.delivery_cost) * 0.01)}" pattern="#,###" />원
                            </span>
                        </div>

                        <!-- 정산일 -->
                        <div class="flex justify-between items-center">
                            <span class="text-gray-500">정산일</span>
                            <span data-date="${trade.sale_st_dtm}"></span>
                        </div>
                    </div>

                    <div class="mt-4 pt-3 border-t border-gray-100 text-center">
                        <span class="text-xs text-blue-500 bg-blue-50 px-2 py-1 rounded-full font-medium">정산 완료</span>
                    </div>
                </div>

                <div id="settlement-backdrop-${trade.trade_seq}"
                     class="hidden fixed inset-0 bg-black/20 z-40"
                     onclick="toggleSettlementPopup(${trade.trade_seq})">
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    // 날짜 포맷팅
    document.querySelectorAll('[data-date]').forEach(el => {
        const dateStr = el.getAttribute('data-date');
        if (dateStr) {
            // "2023-10-25T..." -> "2023.10.25"
            const date = dateStr.split('T')[0].replace(/-/g, '.');
            el.textContent = date;
        }
    });

    // 아이콘 초기화
    if (window.lucide) {
        lucide.createIcons();
    }

    // 판매 상태 업데이트
    function postTrade(trade_seq) {
        const confirmed = confirm('정말 판매완료 처리 하시겠습니까?\n처리 후에는 상태 변경이 불가능합니다.');
        if (!confirmed) return;

        fetch('/trade/statusUpdate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'trade_seq=' + encodeURIComponent(trade_seq)
        })
        .then(res => {
            if (res.ok) {
                // 페이지 새로고침 또는 탭 리로드
                location.reload();
            } else {
                alert('상태 업데이트에 실패했습니다.');
            }
        })
        .catch(err => {
            console.error('Network Error:', err);
            alert('오류가 발생했습니다.');
        });
    }

    // 정산 팝업 토글 함수
    function toggleSettlementPopup(id) {
        const popup = document.getElementById('settlement-popup-' + id);
        const backdrop = document.getElementById('settlement-backdrop-' + id);

        if (popup && backdrop) {
            const isHidden = popup.classList.contains('hidden');
            if (isHidden) {
                popup.classList.remove('hidden');
                backdrop.classList.remove('hidden');
            } else {
                popup.classList.add('hidden');
                backdrop.classList.add('hidden');
            }
        }
    }
</script>