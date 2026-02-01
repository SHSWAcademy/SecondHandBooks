<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/resources/js/paging/paging.js"></script>

<div id="userActionMenu" class="hidden fixed z-[9999] bg-white rounded-2xl shadow-2xl border border-gray-100 w-40 py-2 overflow-hidden ring-1 ring-black/5 animate-[fadeIn_0.1s_ease-out]">
  <button id="btnActionBan" class="w-full text-left px-5 py-3 text-xs font-bold text-gray-700 hover:bg-red-50 hover:text-red-600 flex items-center gap-2.5 transition-colors">
    <i data-lucide="ban" class="w-3.5 h-3.5"></i> 계정 정지
  </button>
  <button id="btnActionActive" class="w-full text-left px-5 py-3 text-xs font-bold text-gray-700 hover:bg-emerald-50 hover:text-emerald-600 flex items-center gap-2.5 transition-colors">
    <i data-lucide="check-circle" class="w-3.5 h-3.5"></i> 정지 해제
  </button>
  <div class="h-px bg-gray-100 my-1 mx-2"></div>
  <button id="btnActionDelete" class="w-full text-left px-5 py-3 text-xs font-bold text-red-600 hover:bg-red-50 flex items-center gap-2.5 transition-colors">
    <i data-lucide="trash-2" class="w-3.5 h-3.5"></i> 강제 탈퇴
  </button>
</div>

<div class="bg-white rounded-[2rem] border border-gray-100 shadow-[0_10px_30px_-10px_rgba(0,0,0,0.05)] overflow-hidden">

    <div class="p-8 border-b border-gray-100 flex flex-col md:flex-row md:items-center justify-between gap-6 bg-white/50 backdrop-blur-sm">
        <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-indigo-50 to-indigo-100 flex items-center justify-center shadow-inner">
                <i data-lucide="users" class="w-6 h-6 text-indigo-600"></i>
            </div>
            <div>
                <h3 class="text-xl font-black text-gray-900 tracking-tight">회원 관리</h3>
                <p class="text-sm font-medium text-gray-500 mt-0.5">전체 회원의 상태를 조회하고 관리합니다.</p>
            </div>
        </div>

        <div class="flex items-center gap-2 bg-gray-50 p-1.5 rounded-2xl border border-gray-200 shadow-sm w-full md:w-auto">
            <select id="userSearchType" class="bg-white border border-gray-200 text-gray-700 text-xs font-bold rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-indigo-100 transition-shadow">
                <option value="all">전체</option>
                <option value="nickname">닉네임</option>
                <option value="email">이메일</option>
            </select>

            <div class="relative flex-1 md:w-64">
                <input type="text"
                       id="userSearchKeyword"
                       placeholder="검색어 입력"
                       class="w-full pl-9 pr-4 py-2.5 bg-transparent text-sm font-medium placeholder-gray-400 focus:outline-none"
                       onkeypress="if(event.keyCode === 13) searchMembers()">
                <i data-lucide="search" class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
            </div>

            <button onclick="searchMembers()" class="p-2.5 bg-indigo-600 text-white rounded-xl hover:bg-indigo-700 transition-colors shadow-md shadow-indigo-200">
                <i data-lucide="arrow-right" class="w-4 h-4"></i>
            </button>

            <button onclick="users_resetSearch()" class="p-2.5 text-gray-400 hover:text-gray-600 hover:bg-gray-200/50 rounded-xl transition-colors" title="초기화">
                <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
            </button>
        </div>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full">
            <thead>
                <tr class="border-b border-gray-100 bg-gray-50/30 text-left">
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider w-[40%]">회원 정보</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">상태</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">가입일</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider text-right">관리</th>
                </tr>
            </thead>
            <tbody id="userTableBody" class="divide-y divide-gray-50">
                </tbody>
        </table>
    </div>

    <div class="px-8 py-6 border-t border-gray-100 bg-gray-50/30 flex items-center justify-center">
        <div id="userPaginationButtons" class="flex gap-2 pagination-container"></div>
    </div>
</div>

<script>
    window.onClickUserMenu = function(event, seq, status) {
        if(event) {
            event.stopPropagation();
            event.preventDefault();
        }

        const menu = document.getElementById('userActionMenu');
        menu.classList.remove('hidden');

        let btn = event.currentTarget || event.target.closest('button');
        const rect = btn.getBoundingClientRect();
        const spaceBelow = window.innerHeight - rect.bottom;

        // 메뉴 위치 조정 (우측 정렬)
        menu.style.top = (spaceBelow < 150 ? rect.top - 140 : rect.bottom + 8) + 'px';
        menu.style.left = (rect.right - 160) + 'px'; // 버튼 우측 끝에 맞춤

        document.getElementById('btnActionBan').onclick = () => window.updateUserStatus(seq, 'BAN');
        document.getElementById('btnActionActive').onclick = () => window.updateUserStatus(seq, 'ACTIVE');
        document.getElementById('btnActionDelete').onclick = () => window.updateUserStatus(seq, 'DELETE');
    };

    window.renderMemberTable = function(members) {
        const tbody = document.getElementById('userTableBody');
        tbody.innerHTML = '';

        if (!members || members.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="4" class="px-8 py-24 text-center">
                        <div class="flex flex-col items-center justify-center text-gray-400">
                            <i data-lucide="user-x" class="w-12 h-12 mb-3 opacity-20"></i>
                            <p class="text-sm font-medium">검색 결과가 없습니다.</p>
                        </div>
                    </td>
                </tr>`;
            if(window.lucide) lucide.createIcons();
            return;
        }

        let html = '';
        members.forEach(m => {
            const nick = m.member_nicknm || '?';
            const email = m.member_email || '-';
            const status = m.member_st || 'JOIN';
            const date = m.crt_dtm ? String(m.crt_dtm).substring(0, 10) : '-';

            // 상태 뱃지 디자인 개선
            let statusBadge = '';
            if (status === 'JOIN') {
                statusBadge = `<span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-emerald-50 text-emerald-600 text-[10px] font-bold border border-emerald-100">
                    <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span> 활동중
                </span>`;
            } else if (status === 'BAN') {
                statusBadge = `<span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-red-50 text-red-600 text-[10px] font-bold border border-red-100">
                    <span class="w-1.5 h-1.5 rounded-full bg-red-500"></span> 정지됨
                </span>`;
            } else {
                statusBadge = `<span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-gray-100 text-gray-500 text-[10px] font-bold border border-gray-200">
                    탈퇴/기타
                </span>`;
            }

            html += `
                <tr class="group hover:bg-gray-50/50 transition-colors duration-200">
                    <td class="px-8 py-5">
                        <div class="flex items-center gap-4">
                            <div class="w-10 h-10 rounded-full bg-indigo-50 flex items-center justify-center font-bold text-indigo-600 border border-indigo-100 shadow-sm text-sm">
                                \${nick.substring(0,1).toUpperCase()}
                            </div>
                            <div>
                                <p class="text-sm font-bold text-gray-900">\${nick}</p>
                                <p class="text-xs text-gray-400 mt-0.5">\${email}</p>
                            </div>
                        </div>
                    </td>
                    <td class="px-8 py-5">\${statusBadge}</td>
                    <td class="px-8 py-5 text-xs text-gray-500 font-mono">\${date}</td>
                    <td class="px-8 py-5 text-right">
                        <button type="button"
                                onclick="window.onClickUserMenu(event, \${m.member_seq}, '\${status}')"
                                class="p-2 text-gray-400 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition-all duration-200">
                            <i data-lucide="more-horizontal" class="w-5 h-5"></i>
                        </button>
                    </td>
                </tr>`;
        });

        tbody.innerHTML = html;
        if (window.lucide) lucide.createIcons();
    };

    document.addEventListener('DOMContentLoaded', () => {
        const menu = document.getElementById('userActionMenu');
        if (menu && menu.parentElement !== document.body) document.body.appendChild(menu);
        searchMembers(1);
    });

    document.addEventListener('click', (e) => {
        const menu = document.getElementById('userActionMenu');
        if (menu && !menu.classList.contains('hidden') && !menu.contains(e.target)) {
            menu.classList.add('hidden');
        }
    });

    window.searchMembers = function(page) {
        const p = page || 1;
        const typeEl = document.getElementById('userSearchType');
        const keyEl = document.getElementById('userSearchKeyword');
        const url = '/admin/api/users?page=' + p + '&size=10&keyword=' + encodeURIComponent(keyEl?keyEl.value:'') + '&searchType=' + (typeEl?typeEl.value:'all') + '&status=all';
        fetch(url).then(r=>r.json()).then(d=>{
            renderMemberTable(d.list);
            if(window.renderCommonPagination) {
                renderCommonPagination('userPaginationButtons', d.total, d.curPage, d.size, 'searchMembers');
                // 페이징 버튼 스타일 커스터마이징 (필요 시 CSS 클래스 추가 로직)
            }
        });
    };

    window.users_resetSearch = function() {
        document.getElementById('userSearchKeyword').value = '';
        document.getElementById('userSearchType').value = 'all';
        searchMembers(1);
    }

    window.updateUserStatus = function(seq, action) {
        let actionText = action === 'BAN' ? '정지' : (action === 'ACTIVE' ? '해제' : '강제 탈퇴');
        if(!confirm(actionText + ' 처리하시겠습니까?')) return;

        fetch('/admin/api/users', {
            method: 'PATCH',
            headers: {'Content-Type':'application/json'},
            body: JSON.stringify({seq:seq, action:action})
        }).then(r=>{
            if(r.ok) {
                document.getElementById('userActionMenu').classList.add('hidden');
                searchMembers(1); // 현재 페이지 유지하려면 인자 전달 필요
            } else alert('처리 실패');
        });
    }
</script>