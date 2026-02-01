<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/resources/js/paging/paging.js"></script>

<div class="bg-white rounded-[2rem] border border-gray-100 shadow-[0_10px_30px_-10px_rgba(0,0,0,0.05)] overflow-hidden">

    <div class="p-8 border-b border-gray-100 flex flex-col md:flex-row md:items-center justify-between gap-6 bg-white/50 backdrop-blur-sm">
        <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-gray-100 to-gray-200 flex items-center justify-center shadow-inner">
                <i data-lucide="shield" class="w-6 h-6 text-gray-600"></i>
            </div>
            <div>
                <h3 class="text-xl font-black text-gray-900 tracking-tight">관리자 활동 로그</h3>
                <p class="text-sm font-medium text-gray-500 mt-0.5">시스템 관리자의 접속 및 활동 이력을 모니터링합니다.</p>
            </div>
        </div>

        <div class="flex items-center gap-2 bg-gray-50 p-1.5 rounded-2xl border border-gray-200 shadow-sm w-full md:w-auto">
            <select id="adminLogSearchType" class="bg-white border border-gray-200 text-gray-700 text-xs font-bold rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-gray-200 transition-shadow">
                <option value="all">전체</option>
                <option value="nickname">관리자ID</option>
                <option value="ip">IP주소</option>
            </select>

            <div class="relative flex-1 md:w-64">
                <input type="text"
                       id="adminLogSearchKeyword"
                       placeholder="검색어 입력"
                       class="w-full pl-9 pr-4 py-2.5 bg-transparent text-sm font-medium placeholder-gray-400 focus:outline-none"
                       onkeypress="if(event.keyCode === 13) searchAdminLog()">
                <i data-lucide="search" class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
            </div>

            <button onclick="searchAdminLog()" class="p-2.5 bg-gray-900 text-white rounded-xl hover:bg-black transition-colors shadow-md">
                <i data-lucide="arrow-right" class="w-4 h-4"></i>
            </button>

            <button onclick="adminLog_resetSearch()" class="p-2.5 text-gray-400 hover:text-gray-600 hover:bg-gray-200/50 rounded-xl transition-colors" title="초기화">
                <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
            </button>
        </div>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full">
            <thead>
                <tr class="border-b border-gray-100 bg-gray-50/30 text-left">
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider w-1/4">관리자 계정</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider w-1/4">접속 IP</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider w-1/4">로그인 시간</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider w-1/4">로그아웃 시간</th>
                </tr>
            </thead>
            <tbody id="adminLogTableBody" class="divide-y divide-gray-50">
                </tbody>
        </table>
    </div>

    <div class="px-8 py-6 border-t border-gray-100 bg-gray-50/30 flex items-center justify-center">
        <div id="adminLogPaginationButtons" class="flex gap-2"></div>
    </div>
</div>

<script>
    function searchAdminLog(page) {
        const p = page || 1;
        const searchType = document.getElementById('adminLogSearchType').value;
        const keyword = document.getElementById('adminLogSearchKeyword').value;

        const url = '/admin/api/adminLogs?page=' + p
                  + '&size=10'
                  + '&keyword=' + encodeURIComponent(keyword)
                  + '&searchType=' + searchType;

        fetch(url)
            .then(res => res.json())
            .then(data => {
                renderAdminLogTable(data.list);
                renderCommonPagination(
                    'adminLogPaginationButtons',
                    data.total,
                    data.curPage,
                    data.size,
                    'searchAdminLog'
                );
            })
            .catch(err => console.error('Error:', err));
    }

    function renderAdminLogTable(logs) {
        const tbody = document.getElementById('adminLogTableBody');
        tbody.innerHTML = '';

        if (!logs || logs.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="4" class="px-8 py-24 text-center">
                        <div class="flex flex-col items-center justify-center text-gray-400">
                            <i data-lucide="file-x" class="w-12 h-12 mb-3 opacity-20"></i>
                            <p class="text-sm font-medium">검색 결과가 없습니다.</p>
                        </div>
                    </td>
                </tr>`;
            if(window.lucide) lucide.createIcons();
            return;
        }

        logs.forEach(log => {
            const tr = document.createElement('tr');
            tr.className = 'group hover:bg-gray-50/50 transition-colors duration-200';

            // 1. 관리자 정보
            const tdAdmin = document.createElement('td');
            tdAdmin.className = 'px-8 py-5';
            tdAdmin.innerHTML = `
                <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center text-xs font-bold text-gray-600 border border-gray-200">
                        \${(log.admin_login_id || 'A').substring(0, 1).toUpperCase()}
                    </div>
                    <span class="font-bold text-sm text-gray-900">\${log.admin_login_id}</span>
                </div>`;

            // 2. IP 주소
            const tdIp = document.createElement('td');
            tdIp.className = 'px-8 py-5';
            tdIp.innerHTML = `
                <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md bg-blue-50 text-blue-700 text-xs font-mono font-medium border border-blue-100/50">
                    <i data-lucide="globe" class="w-3 h-3"></i>
                    \${log.login_ip}
                </span>`;

            // 3. 로그인 시간
            const tdLogin = document.createElement('td');
            tdLogin.className = 'px-8 py-5 text-sm text-gray-600 font-medium';
            tdLogin.innerText = log.formattedLoginDtm || '-';

            // 4. 로그아웃 시간 (상태 표시)
            const tdLogout = document.createElement('td');
            tdLogout.className = 'px-8 py-5';

            if (log.formattedLogoutDtm) {
                tdLogout.innerHTML = `<span class="text-sm text-gray-400 font-medium">\${log.formattedLogoutDtm}</span>`;
            } else {
                tdLogout.innerHTML = `
                    <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-green-50 text-green-600 text-[10px] font-bold border border-green-100 animate-pulse">
                        <span class="w-1.5 h-1.5 rounded-full bg-green-500"></span> 접속중
                    </span>`;
            }

            tr.append(tdAdmin, tdIp, tdLogin, tdLogout);
            tbody.appendChild(tr);
        });

        if(window.lucide) lucide.createIcons();
    }

    function adminLog_resetSearch() {
        document.getElementById('adminLogSearchKeyword').value = '';
        document.getElementById('adminLogSearchType').value = 'all';
        searchAdminLog(1);
    }

    // Init
    searchAdminLog(1);
</script>