<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="bg-white rounded-[2rem] border border-gray-100 shadow-[0_10px_30px_-10px_rgba(0,0,0,0.05)] overflow-hidden">

    <div class="p-8 border-b border-gray-100 flex flex-col md:flex-row md:items-center justify-between gap-6 bg-white/50 backdrop-blur-sm">
        <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-green-50 to-green-100 flex items-center justify-center shadow-inner">
                <i data-lucide="users" class="w-6 h-6 text-green-600"></i>
            </div>
            <div>
                <h3 class="text-xl font-black text-gray-900 tracking-tight">모임 관리</h3>
                <p class="text-sm font-medium text-gray-500 mt-0.5">개설된 독서 모임 현황을 확인합니다.</p>
            </div>
        </div>

        <div class="flex items-center gap-2 bg-gray-50 p-1.5 rounded-2xl border border-gray-200 shadow-sm w-full md:w-auto">
            <select id="groupSearchType" class="bg-white border border-gray-200 text-gray-700 text-xs font-bold rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-green-100 transition-shadow">
                <option value="all">전체</option>
                <option value="groupName">모임명</option>
                <option value="region">지역</option>
            </select>

            <div class="relative flex-1 md:w-64">
                <input type="text"
                       id="groupSearchKeyword"
                       placeholder="검색어 입력"
                       class="w-full pl-9 pr-4 py-2.5 bg-transparent text-sm font-medium placeholder-gray-400 focus:outline-none"
                       onkeypress="if(event.keyCode === 13) searchGroups()">
                <i data-lucide="search" class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
            </div>

            <button onclick="searchGroups()" class="p-2.5 bg-green-600 text-white rounded-xl hover:bg-green-700 transition-colors shadow-md shadow-green-200">
                <i data-lucide="arrow-right" class="w-4 h-4"></i>
            </button>

            <button onclick="groups_resetSearch()" class="p-2.5 text-gray-400 hover:text-gray-600 hover:bg-gray-200/50 rounded-xl transition-colors" title="초기화">
                <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
            </button>
        </div>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full">
            <thead>
                <tr class="border-b border-gray-100 bg-gray-50/30 text-left">
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider w-[35%]">모임명</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">지역</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">정원</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">일정</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">개설일</th>
                </tr>
            </thead>
            <tbody id="groupTableBody" class="divide-y divide-gray-50">
                </tbody>
        </table>
    </div>

    <div class="px-8 py-6 border-t border-gray-100 bg-gray-50/30 flex items-center justify-center">
        <div id="groupPaginationButtons" class="flex gap-2"></div>
    </div>
</div>

<script>
    function searchGroups(page) {
        const p = page || 1;
        const searchType = document.getElementById('groupSearchType').value;
        const keyword = document.getElementById('groupSearchKeyword').value;

        const url = '/admin/api/clubs?page=' + p
                  + '&size=10'
                  + '&keyword=' + encodeURIComponent(keyword)
                  + '&searchType=' + searchType;
        fetch(url)
            .then(res => res.json())
            .then(data => {
                renderGroupTable(data.list);
                renderCommonPagination('groupPaginationButtons', data.total, data.curPage, data.size, 'searchGroups');
            })
            .catch(err => console.error('Error:', err));
    }

    function renderGroupTable(groups) {
        const tbody = document.getElementById('groupTableBody');
        tbody.innerHTML = '';

        if (!groups || groups.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="5" class="px-8 py-24 text-center">
                        <div class="flex flex-col items-center justify-center text-gray-400">
                            <i data-lucide="users" class="w-12 h-12 mb-3 opacity-20"></i>
                            <p class="text-sm font-medium">검색 결과가 없습니다.</p>
                        </div>
                    </td>
                </tr>`;
            if(window.lucide) lucide.createIcons();
            return;
        }

        groups.forEach(g => {
            const tr = document.createElement('tr');
            tr.className = 'group hover:bg-gray-50/50 transition-colors duration-200 cursor-pointer';
            tr.onclick = () => window.location.href = '/bookclubs/' + g.book_club_seq; // 상세 이동

            // 1. 모임명
            const tdTitle = document.createElement('td');
            tdTitle.className = 'px-8 py-5';
            tdTitle.innerHTML = `<span class="text-sm font-bold text-gray-900 group-hover:text-green-600 transition-colors">\${g.book_club_name}</span>`;

            // 2. 지역
            const tdRegion = document.createElement('td');
            tdRegion.className = 'px-8 py-5';
            tdRegion.innerHTML = `
                <div class="flex items-center gap-1.5 text-xs font-medium text-gray-500">
                    <i data-lucide="map-pin" class="w-3.5 h-3.5 text-gray-400"></i>
                    \${g.book_club_rg || '-'}
                </div>`;

            // 3. 정원
            const tdMax = document.createElement('td');
            tdMax.className = 'px-8 py-5';
            tdMax.innerHTML = `<span class="text-xs font-bold text-green-600 bg-green-50 px-2 py-1 rounded-md border border-green-100">\${g.book_club_max_member}명</span>`;

            // 4. 일정
            const tdSchedule = document.createElement('td');
            tdSchedule.className = 'px-8 py-5 text-xs text-gray-500 font-medium truncate max-w-[150px]';
            tdSchedule.innerText = g.book_club_schedule || '-';

            // 5. 개설일
            const tdDate = document.createElement('td');
            tdDate.className = 'px-8 py-5 text-xs text-gray-400 font-mono';
            tdDate.innerText = g.crt_dtm ? g.crt_dtm.substring(0, 10) : '-';

            tr.append(tdTitle, tdRegion, tdMax, tdSchedule, tdDate);
            tbody.appendChild(tr);
        });

        if(window.lucide) lucide.createIcons();
    }

    function groups_resetSearch() {
        document.getElementById('groupSearchKeyword').value = '';
        document.getElementById('groupSearchType').value = 'all';
        searchGroups(1);
    }

    searchGroups(1);
</script>