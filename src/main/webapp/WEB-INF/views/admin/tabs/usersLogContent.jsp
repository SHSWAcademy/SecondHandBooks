<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/resources/js/paging/paging.js"></script>

<div class="bg-white rounded-[2rem] border border-gray-100 shadow-[0_10px_30px_-10px_rgba(0,0,0,0.05)] overflow-hidden">

    <div class="p-8 border-b border-gray-100 flex flex-col md:flex-row md:items-center justify-between gap-6 bg-white/50 backdrop-blur-sm">
        <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-violet-50 to-violet-100 flex items-center justify-center shadow-inner">
                <i data-lucide="history" class="w-6 h-6 text-violet-600"></i>
            </div>
            <div>
                <h3 class="text-xl font-black text-gray-900 tracking-tight">회원 접속 기록</h3>
                <p class="text-sm font-medium text-gray-500 mt-0.5">회원들의 로그인/로그아웃 이력을 조회합니다.</p>
            </div>
        </div>

        <div class="flex items-center gap-2 bg-gray-50 p-1.5 rounded-2xl border border-gray-200 shadow-sm w-full md:w-auto">
            <select id="usersLogSearchType" class="bg-white border border-gray-200 text-gray-700 text-xs font-bold rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-violet-100 transition-shadow">
                <option value="all">전체</option>
                <option value="nickname">닉네임</option>
                <option value="ip">IP주소</option>
            </select>

            <div class="relative flex-1 md:w-64">
                <input type="text"
                       id="usersLogSearchKeyword"
                       placeholder="검색어 입력"
                       class="w-full pl-9 pr-4 py-2.5 bg-transparent text-sm font-medium placeholder-gray-400 focus:outline-none"
                       onkeypress="if(event.keyCode === 13) searchUsersLog()">
                <i data-lucide="search" class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
            </div>

            <button onclick="searchUsersLog()" class="p-2.5 bg-violet-600 text-white rounded-xl hover:bg-violet-700 transition-colors shadow-md shadow-violet-200">
                <i data-lucide="arrow-right" class="w-4 h-4"></i>
            </button>

            <button onclick="usersLog_resetSearch()" class="p-2.5 text-gray-400 hover:text-gray-600 hover:bg-gray-200/50 rounded-xl transition-colors" title="초기화">
                <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
            </button>
        </div>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full">
            <thead>
                <tr class="border-b border-gray-100 bg-gray-50/30 text-left">
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider w-[30%]">회원 정보</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider w-[25%]">접속 IP</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">로그인 시간</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">로그아웃 시간</th>
                </tr>
            </thead>
            <tbody id="usersLogTableBody" class="divide-y divide-gray-50">
                </tbody>
        </table>
    </div>

    <div class="px-8 py-6 border-t border-gray-100 bg-gray-50/30 flex items-center justify-center">
        <div id="usersLogPaginationButtons" class="flex gap-2"></div>
    </div>
</div>

<script>
    function searchUsersLog(page) {
        const p = page || 1;
        const searchType = document.getElementById('usersLogSearchType').value;
        const keyword = document.getElementById('usersLogSearchKeyword').value;

        const url = '/admin/api/userLogs?page=' + p
                  + '&size=10'
                  + '&keyword=' + encodeURIComponent(keyword)
                  + '&searchType=' + searchType;
        fetch(url)
            .then(res => res.json())
            .then(data => {
                renderUsersLogTable(data.list);
                renderCommonPagination('usersLogPaginationButtons', data.total, data.curPage, data.size, 'searchUsersLog');
            })
            .catch(err => console.error('Error:', err));
    }

    function renderUsersLogTable(logs) {
        const tbody = document.getElementById('usersLogTableBody');
        tbody.innerHTML = '';

        if (!logs || logs.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="4" class="px-8 py-24 text-center">
                        <div class="flex flex-col items-center justify-center text-gray-400">
                            <i data-lucide="history" class="w-12 h-12 mb-3 opacity-20"></i>
                            <p class="text-sm font-medium">기록이 없습니다.</p>
                        </div>
                    </td>
                </tr>`;
            if(window.lucide) lucide.createIcons();
            return;
        }

        logs.forEach(log => {
            const tr = document.createElement('tr');
            tr.className = 'group hover:bg-gray-50/50 transition-colors duration-200';

            // 1. 회원 정보
            const tdUser = document.createElement('td');
            tdUser.className = 'px-8 py-4';
            tdUser.innerHTML = `
                <div class="flex items-center gap-3">
                    <span class="font-bold text-sm text-gray-900">\${log.member_nicknm || 'Unknown'}</span>
                    <span class="text-xs text-gray-400">\${log.member_email || ''}</span>
                </div>`;

            // 2. IP
            const tdIp = document.createElement('td');
            tdIp.className = 'px-8 py-4';
            tdIp.innerHTML = `<span class="text-xs font-mono text-gray-500 bg-gray-100 px-2 py-1 rounded">\${log.login_ip || '-'}</span>`;

            // 3. 로그인 시간
            const tdLogin = document.createElement('td');
            tdLogin.className = 'px-8 py-4 text-sm text-gray-600';
            tdLogin.innerText = log.formattedLoginDtm || '-';

            // 4. 로그아웃 시간
            const tdLogout = document.createElement('td');
            tdLogout.className = 'px-8 py-4 text-sm text-gray-400';
            tdLogout.innerText = log.formattedLogoutDtm || '-';

            tr.append(tdUser, tdIp, tdLogin, tdLogout);
            tbody.appendChild(tr);
        });

        if(window.lucide) lucide.createIcons();
    }

    function usersLog_resetSearch() {
        document.getElementById('usersLogSearchKeyword').value = '';
        document.getElementById('usersLogSearchType').value = 'all';
        searchUsersLog(1);
    }

    searchUsersLog(1);
</script>