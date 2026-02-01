<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/resources/js/paging/paging.js"></script>

<div class="bg-white rounded-[2rem] border border-gray-100 shadow-[0_10px_30px_-10px_rgba(0,0,0,0.05)] overflow-hidden">

    <div class="p-8 border-b border-gray-100 flex flex-col md:flex-row md:items-center justify-between gap-6 bg-white/50 backdrop-blur-sm">
        <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-orange-50 to-orange-100 flex items-center justify-center shadow-inner">
                <i data-lucide="megaphone" class="w-6 h-6 text-orange-600"></i>
            </div>
            <div>
                <h3 class="text-xl font-black text-gray-900 tracking-tight">공지사항 관리</h3>
                <p class="text-sm font-medium text-gray-500 mt-0.5">사용자에게 전달할 중요 소식을 관리합니다.</p>
            </div>
        </div>

        <button onclick="createNotice()" class="flex items-center gap-2 px-5 py-2.5 bg-gray-900 hover:bg-black text-white rounded-xl text-sm font-bold shadow-lg hover:shadow-xl transition-all hover:-translate-y-0.5">
            <i data-lucide="plus" class="w-4 h-4"></i>
            <span>새 공지사항 작성</span>
        </button>
    </div>

    <div class="px-8 py-5 bg-gray-50/50 border-b border-gray-100">
        <div class="flex flex-col xl:flex-row items-center gap-3">

            <div class="flex items-center gap-2 w-full xl:w-auto overflow-x-auto pb-2 xl:pb-0 scrollbar-hide">
                <select id="noticesSearchType" class="bg-white border border-gray-200 text-gray-700 text-xs font-bold rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-orange-100 transition-shadow min-w-[100px]">
                    <option value="all">전체 조건</option>
                    <option value="title">제목</option>
                    <option value="content">내용</option>
                    <option value="author">작성자</option>
                </select>

                <select id="statusFilter" class="bg-white border border-gray-200 text-gray-700 text-xs font-bold rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-orange-100 transition-shadow min-w-[100px]">
                    <option value="all">전체 상태</option>
                    <option value="active">공개</option>
                    <option value="inactive">비공개</option>
                </select>

                <select id="importantFilter" class="bg-white border border-gray-200 text-gray-700 text-xs font-bold rounded-xl px-4 py-2.5 focus:outline-none focus:ring-2 focus:ring-orange-100 transition-shadow min-w-[100px]">
                    <option value="all">전체 중요도</option>
                    <option value="important">중요 공지</option>
                    <option value="normal">일반 공지</option>
                </select>
            </div>

            <div class="relative flex-1 w-full">
                <input type="text"
                       id="noticesSearchKeyword"
                       placeholder="검색어 입력"
                       class="w-full pl-9 pr-4 py-2.5 bg-white border border-gray-200 rounded-xl text-sm font-medium placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-orange-100 transition-shadow"
                       onkeypress="if(event.keyCode === 13) searchNotices(1)">
                <i data-lucide="search" class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
            </div>

            <div class="flex gap-2 w-full xl:w-auto">
                <button onclick="searchNotices(1)" class="px-6 py-2.5 bg-orange-600 text-white rounded-xl text-sm font-bold hover:bg-orange-700 transition-colors shadow-md shadow-orange-200 flex-1 xl:flex-none justify-center">
                    검색
                </button>
                <button onclick="notices_resetSearch()" class="px-4 py-2.5 text-gray-500 hover:text-gray-700 hover:bg-gray-100 rounded-xl transition-colors flex items-center justify-center border border-gray-200 bg-white" title="초기화">
                    <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
                </button>
            </div>
        </div>
    </div>

    <div class="overflow-x-auto min-h-[400px]">
        <table class="w-full">
            <thead>
                <tr class="border-b border-gray-100 bg-gray-50/30 text-left">
                    <th class="px-8 py-4 w-16 text-center">
                        <input type="checkbox" id="selectAll" onclick="toggleSelectAll(this)"
                               class="w-4 h-4 text-orange-600 bg-white border-gray-300 rounded focus:ring-orange-500 cursor-pointer accent-orange-600">
                    </th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider w-[40%]">제목</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">작성자</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider text-center">조회수</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider text-center">상태</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider">등록일</th>
                    <th class="px-8 py-4 text-[11px] font-extrabold text-gray-400 uppercase tracking-wider text-center">관리</th>
                </tr>
            </thead>
            <tbody id="noticeTableBody" class="divide-y divide-gray-50">
                <tr>
                    <td colspan="7" class="px-8 py-24 text-center">
                        <div class="flex flex-col items-center justify-center text-gray-400 gap-3">
                            <div class="w-10 h-10 border-4 border-orange-100 border-t-orange-500 rounded-full animate-spin"></div>
                            <p class="text-sm font-medium">데이터를 불러오는 중입니다...</p>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="px-8 py-6 border-t border-gray-100 bg-gray-50/30 flex flex-col md:flex-row items-center justify-between gap-4">

        <div class="flex items-center gap-4 w-full md:w-auto justify-between md:justify-start">
            <button onclick="deleteSelectedNotices()"
                    class="group flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 text-gray-600 text-xs font-bold rounded-xl hover:bg-red-50 hover:text-red-600 hover:border-red-100 transition-all shadow-sm">
                <i data-lucide="trash-2" class="w-3.5 h-3.5 group-hover:scale-110 transition-transform"></i>
                선택 삭제
            </button>
            <span class="text-xs font-medium text-gray-400">
                총 <span id="noticeTotalCount" class="text-gray-900 font-bold">0</span>개
            </span>
        </div>

        <div id="noticePaginationButtons" class="flex gap-2"></div>
    </div>
</div>

<script>
    // 아이콘 초기화
    if (typeof lucide !== 'undefined') lucide.createIcons();

    // 검색 함수
    function searchNotices(page) {
        const p = page || 1;
        const searchType = document.getElementById('noticesSearchType')?.value || 'all';
        const searchKeyword = document.getElementById('noticesSearchKeyword')?.value || '';
        const statusFilter = document.getElementById('statusFilter')?.value || 'all';
        const importantFilter = document.getElementById('importantFilter')?.value || 'all';

        const url = '/admin/api/notices?page=' + p
                  + '&size=10'
                  + '&keyword=' + encodeURIComponent(searchKeyword)
                  + '&searchType=' + searchType
                  + '&statusFilter=' + statusFilter
                  + '&importantFilter=' + importantFilter;

        fetch(url)
            .then(res => res.json())
            .then(data => {
                renderNoticeTable(data.list || []);
                if (window.renderCommonPagination) {
                    renderCommonPagination('noticePaginationButtons', data.total, data.curPage, data.size, 'searchNotices');
                }
                updateNoticeCount(data.total || 0);
            })
            .catch(err => {
                console.error('Error:', err);
                document.getElementById('noticeTableBody').innerHTML = `
                    <tr><td colspan="7" class="px-8 py-12 text-center text-red-500 font-medium">데이터 로드 실패</td></tr>`;
            });
    }

    // 테이블 렌더링
    function renderNoticeTable(notices) {
        const tbody = document.getElementById('noticeTableBody');
        tbody.innerHTML = '';

        if (!notices || notices.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="7" class="px-8 py-24 text-center">
                        <div class="flex flex-col items-center justify-center text-gray-400">
                            <i data-lucide="file-x" class="w-12 h-12 mb-3 opacity-20"></i>
                            <p class="text-sm font-medium">등록된 공지사항이 없습니다.</p>
                        </div>
                    </td>
                </tr>`;
            if(typeof lucide !== 'undefined') lucide.createIcons();
            return;
        }

        notices.forEach(notice => {
            const tr = document.createElement('tr');
            tr.className = 'group hover:bg-gray-50/50 transition-colors duration-200';

            // 1. Checkbox
            tr.innerHTML += `
                <td class="px-8 py-5 text-center">
                    <input type="checkbox" name="noticeCheck" value="\${notice.notice_seq}"
                           class="w-4 h-4 text-orange-600 bg-white border-gray-300 rounded focus:ring-orange-500 cursor-pointer accent-orange-600">
                </td>`;

            // 2. Title (Important Badge)
            let importantBadge = '';
            if (notice.notice_priority === 1) {
                importantBadge = `<span class="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold bg-red-50 text-red-600 mr-2 border border-red-100 shadow-sm"><i data-lucide="alert-circle" class="w-3 h-3 mr-1"></i>중요</span>`;
            }

            tr.innerHTML += `
                <td class="px-8 py-5">
                    <div class="flex items-center">
                        \${importantBadge}
                        <a href="javascript:void(0)" onclick="viewNotice(\${notice.notice_seq})"
                           class="text-sm font-bold text-gray-900 hover:text-orange-600 transition-colors line-clamp-1">
                            \${notice.notice_title}
                        </a>
                    </div>
                </td>`;

            // 3. Author
            tr.innerHTML += `
                <td class="px-8 py-5">
                    <div class="flex items-center gap-3">
                        <div class="w-8 h-8 rounded-full bg-orange-50 flex items-center justify-center text-xs font-bold text-orange-600 border border-orange-100 shadow-sm">
                            \${(notice.admin_login_id || 'A').substring(0, 1).toUpperCase()}
                        </div>
                        <span class="text-sm font-medium text-gray-700">\${notice.admin_login_id || '관리자'}</span>
                    </div>
                </td>`;

            // 4. Views
            tr.innerHTML += `
                <td class="px-8 py-5 text-center">
                    <span class="inline-flex items-center gap-1 text-sm font-medium text-gray-500 bg-gray-50 px-2.5 py-1 rounded-md">
                        <i data-lucide="eye" class="w-3 h-3"></i>
                        \${notice.view_count ? notice.view_count.toLocaleString() : '0'}
                    </span>
                </td>`;

            // 5. Status
            let statusBadge = notice.active
                ? `<span class="inline-flex items-center px-2.5 py-1 rounded-full bg-emerald-50 text-emerald-600 text-[10px] font-bold border border-emerald-100">공개</span>`
                : `<span class="inline-flex items-center px-2.5 py-1 rounded-full bg-gray-100 text-gray-500 text-[10px] font-bold border border-gray-200">비공개</span>`;

            tr.innerHTML += `<td class="px-8 py-5 text-center">\${statusBadge}</td>`;

            // 6. Date
            tr.innerHTML += `
                <td class="px-8 py-5 text-xs text-gray-400 font-mono">
                    \${notice.formattedCrtDtm || (notice.crt_dtm ? String(notice.crt_dtm).substring(0, 10) : '-')}
                </td>`;

            // 7. Actions
            tr.innerHTML += `
                <td class="px-8 py-5 text-center">
                    <div class="flex items-center justify-center gap-2">
                        <button onclick="editNotice(\${notice.notice_seq})"
                                class="p-2 text-gray-400 hover:text-orange-600 hover:bg-orange-50 rounded-lg transition-all" title="수정">
                            <i data-lucide="edit-2" class="w-4 h-4"></i>
                        </button>
                        <button onclick="deleteNotice(\${notice.notice_seq})"
                                class="p-2 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-all" title="삭제">
                            <i data-lucide="trash-2" class="w-4 h-4"></i>
                        </button>
                    </div>
                </td>`;

            tbody.appendChild(tr);
        });

        if(typeof lucide !== 'undefined') lucide.createIcons();
    }

    // 유틸리티 함수들
    function updateNoticeCount(count) {
        const el = document.getElementById('noticeTotalCount');
        if(el) el.innerText = count;
    }

    function toggleSelectAll(checkbox) {
        document.querySelectorAll('input[name="noticeCheck"]').forEach(cb => cb.checked = checkbox.checked);
    }

    function notices_resetSearch() {
        document.getElementById('noticesSearchType').value = 'all';
        document.getElementById('noticesSearchKeyword').value = '';
        document.getElementById('statusFilter').value = 'all';
        document.getElementById('importantFilter').value = 'all';
        searchNotices(1);
    }

    // 페이지 이동 함수들
    function viewNotice(seq) { window.location.href = '/admin/notices/view?notice_seq=' + seq; }
    function createNotice() { switchView('notice-write', null); }
    function editNotice(seq) { window.location.href = '/admin/notices/edit?notice_seq=' + seq; }

    // 삭제 로직
    function deleteNotice(seq) {
        if (!confirm('정말로 삭제하시겠습니까?')) return;
        fetch('/admin/notices/delete/' + seq, { method: 'DELETE' })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    searchNotices(1);
                } else alert(data.message || '삭제 실패');
            });
    }

    function deleteSelectedNotices() {
        const checked = document.querySelectorAll('input[name="noticeCheck"]:checked');
        if (checked.length === 0) {
            alert('삭제할 항목을 선택해주세요.');
            return;
        }
        if (!confirm(`선택한 \${checked.length}개의 공지사항을 삭제하시겠습니까?`)) return;

        const ids = Array.from(checked).map(cb => cb.value);
        fetch('/admin/notices/delete-multiple', {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ noticeIds: ids })
        }).then(res => res.json()).then(data => {
            if (data.success) {
                alert('삭제되었습니다.');
                searchNotices(1);
            } else alert(data.message || '삭제 실패');
        });
    }

    // 초기 실행
    (function() { searchNotices(1); })();
</script>