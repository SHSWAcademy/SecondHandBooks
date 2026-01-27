<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
      <script src="/resources/js/paging/paging.js"></script>

<div id="userActionMenu" class="hidden fixed z-[9999] bg-white rounded-lg shadow-xl border border-gray-200 w-32 py-1 overflow-hidden">
  <button id="btnActionBan" class="w-full text-left px-4 py-2 text-xs font-medium text-gray-700 hover:bg-gray-50 hover:text-red-600 flex items-center gap-2">
    <i data-lucide="ban" class="w-3 h-3"></i> 정지
  </button>
  <button id="btnActionActive" class="w-full text-left px-4 py-2 text-xs font-medium text-gray-700 hover:bg-gray-50 hover:text-emerald-600 flex items-center gap-2">
    <i data-lucide="check-circle" class="w-3 h-3"></i> 해제
  </button>
  <div class="h-px bg-gray-100 my-1"></div>
  <button id="btnActionDelete" class="w-full text-left px-4 py-2 text-xs font-medium text-red-600 hover:bg-red-50 flex items-center gap-2">
    <i data-lucide="trash-2" class="w-3 h-3"></i> 강제 탈퇴
  </button>
</div>

<div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
  <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
    <h3 class="font-bold text-lg text-gray-900">회원 관리</h3>
  </div>
  <div class="px-6 py-5 bg-gray-50/50 border-b border-gray-100">
    <div class="flex items-center gap-3">
      <select id="userSearchType" class="px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white"><option value="all">전체</option><option value="nickname">닉네임</option><option value="email">이메일</option></select>
      <input type="text" id="userSearchKeyword" placeholder="검색..." class="flex-1 px-4 py-2.5 text-sm border border-gray-300 rounded-lg" onkeypress="if(event.keyCode === 13) searchMembers()">
      <button onclick="searchMembers()" class="px-5 py-2.5 bg-primary-600 text-white rounded-lg text-sm">검색</button>
      <button onclick="users_resetSearch()" class="px-5 py-2.5 bg-white border border-gray-300 rounded-lg text-sm">초기화</button>
    </div>
  </div>

  <table class="w-full">
    <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
    <tr>
      <th class="px-6 py-4 text-left">회원 정보</th>
      <th class="px-6 py-4 text-left">상태</th>
      <th class="px-6 py-4 text-left">가입일</th>
      <th class="px-6 py-4 text-right">관리</th>
    </tr>
    </thead>
    <tbody id="userTableBody" class="divide-y divide-gray-50">
    <tr><td colspan="4" class="p-8 text-center">로딩중...</td></tr>
    </tbody>
  </table>
  <div class="px-6 py-4 bg-gray-50/50 border-t border-gray-100 flex items-center justify-center">
    <div id="userPaginationButtons" class="flex gap-1"></div>
  </div>
</div>

<script>
  // [1] 전역 함수로 선언 (가장 확실한 방법)
  // HTML onclick 속성에서 이 함수를 직접 부릅니다.
  window.onClickUserMenu = function(event, seq, status) {
    // 1. 이벤트 전파 중단 (필수)
    if(event) {
      event.stopPropagation();
      event.preventDefault();
    }

    // 2. 디버깅용 로그 (콘솔 확인용)
    console.log("🔥 버튼 클릭 성공! SEQ:", seq);

<<<<<<< HEAD
    // 3. 메뉴 열기 로직
    const menu = document.getElementById('userActionMenu');
    menu.classList.remove('hidden');
=======
      <script>
        console.log('🔥 usersContent.jsp script loaded');
        // [1] 메뉴 초기화 (body로 이동)
        document.addEventListener('DOMContentLoaded', function () {
          const menu = document.getElementById('userActionMenu');
          if (menu && menu.parentElement !== document.body) {
            document.body.appendChild(menu);
          }
          // 초기 로드
          searchMembers(1);
        });
>>>>>>> 65ddf49 (dom)

    // 버튼 위치 찾기 (event.target이 아이콘일 수 있으므로 button 태그 찾기)
    // 만약 event.target이 button이 아니면 closest로 찾음
    let btn = event.currentTarget || event.target.closest('button');

    // 위치 계산
    const rect = btn.getBoundingClientRect();
    const spaceBelow = window.innerHeight - rect.bottom;

    // 메뉴 위치 지정 (z-index가 높아야 보임)
    menu.style.top = (spaceBelow < 150 ? rect.top - 120 : rect.bottom + 5) + 'px';
    menu.style.left = (rect.left - 80) + 'px';

    // 버튼 기능 연결
    document.getElementById('btnActionBan').onclick = () => window.updateUserStatus(seq, 'BAN');
    document.getElementById('btnActionActive').onclick = () => window.updateUserStatus(seq, 'ACTIVE');
    document.getElementById('btnActionDelete').onclick = () => window.updateUserStatus(seq, 'DELETE');
  };

  // [2] 테이블 렌더링 함수
  window.renderMemberTable = function(members) {
    const tbody = document.getElementById('userTableBody');
    tbody.innerHTML = '';

    if (!members || members.length === 0) {
      tbody.innerHTML = '<tr><td colspan="4" class="p-8 text-center">데이터 없음</td></tr>';
      return;
    }

    let html = '';
    members.forEach(m => {
      const nick = m.member_nicknm || '?';
      const email = m.member_email || '-';
      const status = m.member_st || 'JOIN';
      const date = m.crt_dtm ? String(m.crt_dtm).substring(0, 10) : '-';

      const statusBadge = status === 'JOIN'
              ? '<span class="text-emerald-600 bg-emerald-50 px-2 py-1 rounded text-xs font-bold border border-emerald-100">Active</span>'
              : '<span class="text-gray-600 bg-gray-50 px-2 py-1 rounded text-xs font-bold border border-gray-100">Inactive</span>';

      // [핵심] onclick을 문자열로 직접 박아넣음 + style로 z-index 높임 + 텍스트 추가
      html += `
            <tr class="hover:bg-gray-50 transition">
                <td class="px-6 py-4">
                    <div class="flex items-center gap-3">
                        <div class="w-9 h-9 rounded-full bg-blue-50 flex items-center justify-center font-bold text-primary-600 border border-blue-100">\${nick.substring(0,1)}</div>
                        <div><p class="text-sm font-bold text-gray-900">\${nick}</p><p class="text-[11px] text-gray-400">\${email}</p></div>
                    </div>
                </td>
                <td class="px-6 py-4">\${statusBadge}</td>
                <td class="px-6 py-4 text-xs text-gray-500 font-mono">\${date}</td>
                <td class="px-6 py-4 text-right">
                    <button type="button"
                            onclick="window.onClickUserMenu(event, \${m.member_seq}, '\${status}')"
                            class="relative z-10 p-2 text-gray-500 hover:bg-gray-200 rounded cursor-pointer border border-gray-200 bg-white"
                            style="pointer-events: auto;">
                        <span class="flex items-center gap-1">
                            <i data-lucide="more-horizontal" class="w-4 h-4 pointer-events-none"></i>
                        </span>
                    </button>
                </td>
            </tr>`;
    });

    tbody.innerHTML = html;
    if (window.lucide) lucide.createIcons();
  };

  // [3] 초기화 및 기타 함수들
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
    // (기존과 동일한 로직, 생략하지 않고 넣음)
    const p = page || 1;
    const typeEl = document.getElementById('userSearchType');
    const keyEl = document.getElementById('userSearchKeyword');
    const url = '/admin/api/users?page=' + p + '&size=10&keyword=' + encodeURIComponent(keyEl?keyEl.value:'') + '&searchType=' + (typeEl?typeEl.value:'all') + '&status=all';
    fetch(url).then(r=>r.json()).then(d=>{
      renderMemberTable(d.list);
      if(window.renderCommonPagination) renderCommonPagination('userPaginationButtons', d.total, d.curPage, d.size, 'searchMembers');
    });
  };

<<<<<<< HEAD
  window.users_resetSearch = function() {
    document.getElementById('userSearchKeyword').value = '';
    searchMembers(1);
  }
=======
            // ✅ [핵심 수정] addEventListener만 사용, stopPropagation으로 전역 click 차단
            btn.addEventListener('click', function (e) {
              console.log('🔴 버튼 클릭됨!', e.target, '버튼:', btn, 'seq:', m.member_seq);
              e.stopPropagation(); // 94번 라인 전역 클릭 이벤트 차단
              window.openUserActionMenu(btn, m.member_seq, status); // 버튼 엘리먼트 직접 전달
            });
>>>>>>> 65ddf49 (dom)

  window.fetchUsers = function() { searchMembers(1); }

<<<<<<< HEAD
  window.updateUserStatus = function(seq, action) {
    if(!confirm(action + ' 하시겠습니까?')) return;
    fetch('/admin/api/users', {
      method: 'PATCH',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({seq:seq, action:action})
    }).then(r=>{
      if(r.ok) {
        document.getElementById('userActionMenu').classList.add('hidden');
        searchMembers(1);
      } else alert('실패');
    });
  }
</script>
=======
          // 5. 아이콘 렌더링
          if (window.lucide) lucide.createIcons();
        };

        // [6] 메뉴 열기 로직
        window.openUserActionMenu = function (btnElement, memberSeq, currentStatus) {
          console.log('🔵 openUserActionMenu 호출됨, seq:', memberSeq, 'status:', currentStatus);
          const menu = document.getElementById('userActionMenu');
          console.log('🟢 menu 엘리먼트:', menu);
          menu.classList.remove('hidden');

          // ✅ 버튼 엘리먼트 기준으로 위치 계산 (lucide svg와 무관하게 항상 버튼 좌표)
          const rect = btnElement.getBoundingClientRect();
          console.log('🟡 버튼 좌표:', rect, 'viewport 높이:', window.innerHeight);
          const spaceBelow = window.innerHeight - rect.bottom;
          const menuHeight = 120; // 메뉴 예상 높이
          const menuWidth = 128; // w-32 = 128px

          // ✅ 세로 위치: 아래 공간 부족 시 위로
          let menuTop = (spaceBelow < menuHeight)
            ? Math.max(10, rect.top - menuHeight) // 화면 위쪽 10px 최소 여백
            : rect.bottom + 5;

          // ✅ 가로 위치: 버튼 오른쪽 정렬, 화면 밖 튀지 않게
          let menuLeft = rect.right - menuWidth;
          if (menuLeft < 10) menuLeft = 10; // 왼쪽 여백 최소 10px
          if (menuLeft + menuWidth > window.innerWidth - 10) {
            menuLeft = window.innerWidth - menuWidth - 10; // 오른쪽 여백 최소 10px
          }

          menu.style.top = menuTop + 'px';
          menu.style.left = menuLeft + 'px';
          console.log('🟣 메뉴 최종 위치:', { top: menu.style.top, left: menu.style.left, hidden: menu.classList.contains('hidden') });

          // ✅ 버튼 상태 제어
          const btnBan = document.getElementById('btnActionBan');
          const btnActive = document.getElementById('btnActionActive');
          const btnDelete = document.getElementById('btnActionDelete');

          if (currentStatus === 'BAN') {
            btnBan.style.display = 'none';
            btnActive.style.display = 'flex';
          } else {
            btnBan.style.display = 'flex';
            btnActive.style.display = 'none';
          }

          // ✅ 기능 연결 (기존 로직 유지)
          btnBan.onclick = () => window.updateUserStatus(memberSeq, 'BAN');
          btnActive.onclick = () => window.updateUserStatus(memberSeq, 'ACTIVE');
          btnDelete.onclick = () => window.updateUserStatus(memberSeq, 'DELETE');
        };

        // [7] 상태 변경 API
        window.updateUserStatus = function (seq, action) {
          let msg = action === 'DELETE' ? '강제 탈퇴' : (action === 'BAN' ? '정지' : '해제');
          if (!confirm(msg + ' 처리 하시겠습니까?')) return;

          fetch('/admin/api/users', {
            method: 'PATCH',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ seq: seq, action: action })
          })
            .then(res => {
              if (res.ok) {
                document.getElementById('userActionMenu').classList.add('hidden');
                searchMembers(1); // 새로고침
              } else {
                alert('실패했습니다.');
              }
            })
            .catch(err => alert('오류: ' + err));
        };

      </script>
>>>>>>> 65ddf49 (dom)
