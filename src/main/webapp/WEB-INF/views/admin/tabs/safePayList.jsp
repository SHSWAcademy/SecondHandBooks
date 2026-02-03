<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/resources/js/paging/paging.js"></script>

<div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
  <div class="p-6 border-b border-gray-100 bg-gray-50/50"><h3 class="font-bold text-lg text-gray-900">안전결제 내역</h3></div>
   <!-- 검색 영역 -->
    <div class="px-6 py-5 bg-gray-50/50 border-b border-gray-100">
      <div class="flex items-center gap-3">
        <!-- 검색 타입 -->
        <select
          id="paySearchType"
          class="px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition">
          <option value="all">전체</option>
          <option value="sale_title">제목</option>
          <option value="bookName">상품명</option>
          <option value="member_seller">판매자</option>
          <option value="member_buyer">구매자</option>
        </select>

        <!-- 검색 입력창 -->
        <div class="flex-1 relative">
          <input
            type="text"
            id="paySearchKeyword"
            placeholder="검색어를 입력하세요..."
            class="w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition pl-10"
            onkeypress="if(event.keyCode === 13) searchPay()">
          <i data-lucide="search" class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
        </div>

        <!-- 버튼 그룹 -->
        <div class="flex gap-2">
          <button
            onclick="searchPay()"
            class="px-5 py-2.5 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-all flex items-center gap-2 shadow-sm hover:shadow">
            <i data-lucide="search" class="w-4 h-4"></i>
            검색
          </button>
          <button
            onclick="pay_resetSearch()"
            class="px-5 py-2.5 bg-white border border-gray-300 text-gray-700 text-sm font-medium rounded-lg hover:bg-gray-50 transition-all flex items-center gap-2">
            <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
            초기화
          </button>
        </div>
      </div>
    </div>
  <table class="w-full">
    <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
    <tr>
        <th class="px-6 py-4 text-left">상품명</th>
        <th class="px-6 py-4 text-left">상품 가격</th>
        <th class="px-6 py-4 text-left">배송비</th>
        <th class="px-6 py-4 text-left">수수료 (1%)</th>
        <th class="px-6 py-4 text-left">총 금액</th>
        <th class="px-6 py-4 text-left">판매자</th>
        <th class="px-6 py-4 text-left">구매자</th>
        <th class="px-6 py-4 text-left">구매확정일</th>
    </tr>
    </thead>
    <tbody id="payTableBody" class="divide-y divide-gray-50">
    <c:forEach var="t" items="${safePayList}">
      <tr class="hover:bg-gray-50/50 transition-colors">
        <td class="px-6 py-4"><p class="text-sm font-bold text-gray-900 w-55 truncate">${t.sale_title}</p><p class="text-[10px] text-gray-400">${t.book_title}</p></td>
        <td class="px-6 py-4 text-sm font-black text"><fmt:formatNumber value="${t.sale_price}" pattern="#,###" />원</td>
        <td class="px-6 py-4 text-sm font-black text"><fmt:formatNumber value="${t.delivery_cost}" pattern="#,###" />원</td>
        <td class="px-6 py-4 text-sm font-black text"><fmt:formatNumber value="${(t.sale_price + t.delivery_cost) * 0.01}" pattern="#,###" />원</td>
        <td class="px-6 py-4 text-sm font-black text-primary-600"><fmt:formatNumber value="${(t.sale_price + t.delivery_cost) - ((t.sale_price + t.delivery_cost) * 0.01)}" pattern="#,###" />원</td>
        <td class="px-6 py-4 text-xs text-gray-500">${t.member_seller_nm}</td>
        <td class="px-6 py-4 text-xs text-gray-500">${t.member_buyer_nm}</td>
        <td class="px-6 py-4 text-xs text-gray-500 font-mono">${fn:substring(t.sale_st_dtm, 0, 10)}</td>
      </tr>
    </c:forEach>
    </tbody>
  </table>

  <div class="px-6 py-4 bg-gray-50/50 border-t border-gray-100 flex items-center justify-center">
      <div id="payPaginationButtons" class="flex gap-1"></div>
  </div>

</div>

<script>
    function searchPay(page) {
        const p = page || 1;
        const searchType = document.getElementById('paySearchType').value;
        const keyword = document.getElementById('paySearchKeyword').value;

        const url = '/admin/api/safepaylist?page=' + p
                  + '&size=10'
                  + '&keyword=' + encodeURIComponent(keyword)
                  + '&searchType=' + searchType
                  + '&status=all';
        fetch(url)
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                renderPayTable(data.list);

                renderCommonPagination(
                'payPaginationButtons',
                data.total,
                data.curPage,
                data.size,
                'searchPay'
                );
            })
            .catch(function(error) {
                console.error('검색 중 오류 발생', error);
            });
    }

    function renderPayTable(list) {
        const tbody = document.querySelector('#payTableBody');
        tbody.innerHTML = '';

        if (!list || list.length === 0) {
            const tr = document.createElement('tr');
            const td = document.createElement('td');
            td.colSpan = 8;
            td.className = 'px-6 py-12 text-center text-gray-500';
            td.textContent = '검색 결과가 없습니다.';
            tr.appendChild(td);
            tbody.appendChild(tr);
            return;
        }

        list.forEach(t => {
            const tr = document.createElement('tr');
            tr.className = 'hover:bg-gray-50/50 transition-colors';

            /* 상품명 */
            const tdTitle = document.createElement('td');
            tdTitle.className = 'px-6 py-4';

            const mainP = document.createElement('p');
            mainP.className = 'text-sm font-bold text-gray-900 w-55 truncate';
            mainP.textContent = t.sale_title;

            const subP = document.createElement('p');
            subP.className = 'text-[10px] text-gray-400';
            subP.textContent = t.book_title || '-';

            tdTitle.appendChild(mainP);
            tdTitle.appendChild(subP);

            /* 상품 가격 */
            const tdSalePrice = document.createElement('td');
            tdSalePrice.className = 'px-6 py-4 text-sm font-black';
            tdSalePrice.textContent =
                Number(t.sale_price).toLocaleString() + '원';

            /* 배송비 */
            const tdDelivery = document.createElement('td');
            tdDelivery.className = 'px-6 py-4 text-sm font-black';
            tdDelivery.textContent =
                Number(t.delivery_cost).toLocaleString() + '원';

            /* 수수료 (1%) */
            const fee = (t.sale_price + t.delivery_cost) * 0.01;
            const tdFee = document.createElement('td');
            tdFee.className = 'px-6 py-4 text-sm font-black';
            tdFee.textContent =
                Math.floor(fee).toLocaleString() + '원';

            /* 총 금액 */
            const total = (t.sale_price + t.delivery_cost) - fee;
            const tdTotal = document.createElement('td');
            tdTotal.className = 'px-6 py-4 text-sm font-black text-primary-600';
            tdTotal.textContent =
                Math.floor(total).toLocaleString() + '원';

            /* 판매자 */
            const tdSeller = document.createElement('td');
            tdSeller.className = 'px-6 py-4 text-xs text-gray-500';
            tdSeller.textContent = t.member_seller_nm || '-';

            /* 구매자 */
            const tdBuyer = document.createElement('td');
            tdBuyer.className = 'px-6 py-4 text-xs text-gray-500';
            tdBuyer.textContent = t.member_buyer_nm || '-';

            /* 구매확정일 */
            const tdDate = document.createElement('td');
            tdDate.className = 'px-6 py-4 text-xs text-gray-500 font-mono';
            console.log('출력확인', t.sale_st_dtm);

            if (t.sale_st_dtm && Array.isArray(t.sale_st_dtm) && t.sale_st_dtm.length >= 6) {
                // 배열: [year, month, day, hour, minute, second, nano?]
                const [year, month, day, hour, minute, second] = t.sale_st_dtm;

                // JS Date는 월이 0부터 시작하므로 month-1
                const dateObj = new Date(year, month - 1, day, hour, minute, second);

                // 원하는 형식으로 변환 (YYYY-MM-DD)
                const formattedDate = dateObj.toISOString().split('T')[0];

                tdDate.textContent = formattedDate;
            } else {
                tdDate.textContent = '-';
            }

            tr.appendChild(tdTitle);
            tr.appendChild(tdSalePrice);
            tr.appendChild(tdDelivery);
            tr.appendChild(tdFee);
            tr.appendChild(tdTotal);
            tr.appendChild(tdSeller);
            tr.appendChild(tdBuyer);
            tr.appendChild(tdDate);

            tbody.appendChild(tr);
        });

        if (window.lucide) {
            lucide.createIcons();
        }
    }

    function pay_resetSearch() {
        document.getElementById('paySearchKeyword').value = '';
        document.getElementById('paySearchType').value = 'all';
        searchPay(1);
    }

    // 페이지 로드 시 자동으로 첫 페이지 데이터와 페이징 버튼을 가져옵니다.
    document.addEventListener('DOMContentLoaded', function() {
        searchPay(1);
    });
    </script>