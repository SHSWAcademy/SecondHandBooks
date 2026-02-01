<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/resources/js/paging/paging.js"></script>

<div class="bg-white rounded-[2rem] border border-gray-100 shadow-[0_10px_30px_-10px_rgba(0,0,0,0.05)] overflow-hidden">

    <div class="p-8 border-b border-gray-100 flex flex-col md:flex-row md:items-center justify-between gap-6 bg-white/50 backdrop-blur-sm">
        <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-blue-50 to-blue-100 flex items-center justify-center shadow-inner">
                <i data-lucide="book-open" class="w-6 h-6 text-blue-600"></i>
            </div>
            <div>
                <h3 class="text-xl font-black text-gray-900 tracking-tight">상품 관리</h3>
                <p class="text-sm font-medium text-gray-500 mt-0.5">등록된 중고 도서 목록을 관리합니다.</p>
            </div>
        </div>

        <div class="flex items-center gap-2 bg-gray-50 p-1.5 rounded-2xl border border-gray-200 shadow-sm w-full md:w-auto">
            <select id="bookSearchType" class="bg-white border border-gray-200 text-gray-700 text-xs font-bold rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-blue-100 transition-shadow">
                <option value="all">전체</option>
                <option value="sale_title">제목</option>
                <option value="bookName">상품명</option>
                <option value="region">지역</option>
            </select>

            <div class="relative flex-1 md:w-64">
                <input type="text"
                       id="bookSearchKeyword"
                       placeholder="검색어 입력"
                       class="w-full pl-9 pr-4 py-2.5 bg-transparent text-sm font-medium placeholder-gray-400 focus:outline-none"
                       onkeypress="if(event.keyCode === 13) searchBooks()">
                <i data-lucide="search" class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
            </div>

            <button onclick="searchBooks()" class="p-2.5 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors shadow-md shadow-blue-200">
                <i data-lucide="arrow-right" class="w-4 h-4"></i>
            </button>

            <button onclick="books_resetSearch()" class="p-2.5 text-gray-400 hover:text-gray-600 hover:bg-gray-200/50 rounded-xl transition-colors" title="초기화">
                <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
            </button>
        </div>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full">
            <thead>
                <tr class="border-b border-gray-100 bg-gray-50/30 text-left">
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider w-[40%]">상품정보</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">가격</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">지역</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">상태</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">등록일</th>
                </tr>
            </thead>
            <tbody id="tradeTableBody" class="divide-y divide-gray-50">
                </tbody>
        </table>
    </div>

    <div class="px-8 py-6 border-t border-gray-100 bg-gray-50/30 flex items-center justify-center">
        <div id="bookPaginationButtons" class="flex gap-2"></div>
    </div>
</div>

<script>
    function searchBooks(page) {
        const p = page || 1;
        const searchType = document.getElementById('bookSearchType').value;
        const keyword = document.getElementById('bookSearchKeyword').value;

        const url = '/admin/api/trades?page=' + p
                  + '&size=10'
                  + '&keyword=' + encodeURIComponent(keyword)
                  + '&searchType=' + searchType
                  + '&status=all';
        fetch(url)
            .then(res => res.json())
            .then(data => {
                renderBookTable(data.list);
                renderCommonPagination('bookPaginationButtons', data.total, data.curPage, data.size, 'searchBooks');
            })
            .catch(err => console.error('Error:', err));
    }

    function renderBookTable(books) {
        const tbody = document.getElementById('tradeTableBody');
        tbody.innerHTML = '';

        if (!books || books.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="5" class="px-8 py-24 text-center">
                        <div class="flex flex-col items-center justify-center text-gray-400">
                            <i data-lucide="book-x" class="w-12 h-12 mb-3 opacity-20"></i>
                            <p class="text-sm font-medium">검색 결과가 없습니다.</p>
                        </div>
                    </td>
                </tr>`;
            if(window.lucide) lucide.createIcons();
            return;
        }

        books.forEach(t => {
            const tr = document.createElement('tr');
            tr.className = 'group hover:bg-gray-50/50 transition-colors duration-200 cursor-pointer';
            tr.onclick = () => window.location.href = '/trade/' + t.trade_seq; // 관리자도 일반 상세페이지로 이동하도록 수정 (필요시 /admin/trade/ 로 변경)

            // 1. 상품정보
            const tdTitle = document.createElement('td');
            tdTitle.className = 'px-8 py-5';
            tdTitle.innerHTML = `
                <div class="flex flex-col">
                    <span class="text-sm font-bold text-gray-900 line-clamp-1 group-hover:text-blue-600 transition-colors">\${t.sale_title}</span>
                    <span class="text-xs text-gray-400 mt-0.5 line-clamp-1">\${t.book_title}</span>
                </div>`;

            // 2. 가격
            const tdPrice = document.createElement('td');
            tdPrice.className = 'px-8 py-5';
            tdPrice.innerHTML = `<span class="text-sm font-black text-gray-900">\${Number(t.sale_price).toLocaleString()}원</span>`;

            // 3. 지역
            const tdRegion = document.createElement('td');
            tdRegion.className = 'px-8 py-5 text-xs font-medium text-gray-500';
            tdRegion.innerText = t.sale_rg || '-';

            // 4. 상태 (뱃지)
            const tdStatus = document.createElement('td');
            tdStatus.className = 'px-8 py-5';
            let badgeClass = 'bg-gray-100 text-gray-500 border-gray-200';
            if (t.sale_st === 'SALE') badgeClass = 'bg-blue-50 text-blue-600 border-blue-100';
            else if (t.sale_st === 'SOLD') badgeClass = 'bg-gray-900 text-white border-gray-900';
            else if (t.sale_st === 'RESERVED') badgeClass = 'bg-orange-50 text-orange-600 border-orange-100';

            tdStatus.innerHTML = `
                <span class="inline-flex items-center px-2.5 py-1 rounded-full text-[10px] font-bold border \${badgeClass}">
                    \${t.sale_st}
                </span>`;

            // 5. 등록일
            const tdDate = document.createElement('td');
            tdDate.className = 'px-8 py-5 text-xs text-gray-400 font-mono';
            tdDate.innerText = t.crt_dtm ? t.crt_dtm.substring(0, 10) : '-';

            tr.append(tdTitle, tdPrice, tdRegion, tdStatus, tdDate);
            tbody.appendChild(tr);
        });

        if(window.lucide) lucide.createIcons();
    }

    function books_resetSearch() {
        document.getElementById('bookSearchKeyword').value = '';
        document.getElementById('bookSearchType').value = 'all';
        searchBooks(1);
    }

    searchBooks(1);
</script>