<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/resources/js/paging/paging.js"></script>

<div id="userActionMenu" class="hidden fixed z-[9999] bg-white rounded-lg shadow-xl border border-gray-200 w-32 py-1 overflow-hidden animate-[fadeIn_0.1s_ease-out]">
  <button id="btnActionBan" class="w-full text-left px-4 py-2 text-xs font-medium text-gray-700 hover:bg-gray-50 hover:text-red-600 flex items-center gap-2">
    <i data-lucide="ban" class="w-3 h-3"></i> 정지 (Ban)
  </button>
  <button id="btnActionActive" class="w-full text-left px-4 py-2 text-xs font-medium text-gray-700 hover:bg-gray-50 hover:text-emerald-600 flex items-center gap-2">
    <i data-lucide="check-circle" class="w-3 h-3"></i> 해제 (Active)
  </button>
  <div class="h-px bg-gray-100 my-1"></div>
  <button id="btnActionDelete" class="w-full text-left px-4 py-2 text-xs font-medium text-red-600 hover:bg-red-50 flex items-center gap-2">
    <i data-lucide="trash-2" class="w-3 h-3"></i> 강제 탈퇴
  </button>
</div>

<div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
  <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
    <h3 class="font-bold text-lg text-gray-900">회원 관리 (최근 가입순)</h3>
  </div>

  <div class="px-6 py-5 bg-gray-50/50 border-b border-gray-100">
    <div class="flex items-center gap-3">
      <select id="userSearchType" class="px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition">
        <option value="all">전체</option>
        <option value="nickname">닉네임</option>
        <option value="email">이메일</option>
      </select>
      <div class="flex-1 relative">
        <input type="text" id="userSearchKeyword" placeholder="검색어를 입력하세요..." class="w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition pl-10" onkeypress="if(event.keyCode === 13) searchMembers()">
        <i data-lucide="search" class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
      </div>
      <div class="flex gap-2">
        <button type="button" onclick="searchMembers()" class="px-5 py-2.5 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-all flex items-center gap-2 shadow-sm hover:shadow">
          <i data-lucide="search" class="w-4 h-4"></i> 검색
        </button>
        <button type="button" onclick="users_resetSearch()" class="px-5 py-2.5 bg-white border border-gray-300 text-gray-700 text-sm font-medium rounded-lg hover:bg-gray-50 transition-all flex items-center gap-2">
          <i data-lucide="rotate-ccw" class="w-4 h-4"></i> 초기화
        </button>
      </div>
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
    <tr>
      <td colspan="4" class="px-6 py-12 text-center text-gray-400">
        <div class="flex justify-center items-center gap-2">
          <span class="animate-spin rounded-full h-4 w-4 border-b-2 border-primary-600"></span>
          데이터를 불러오는 중...
        </div>
      </td>
    </tr>
    </tbody>
  </table>

  <div class="px-6 py-4 bg-gray-50/50 border-t border-gray-100 flex items-center justify-center">
    <div id="userPaginationButtons" class="flex gap-1"></div>
  </div>
</div>

<script>
  // [1] 메뉴 초기화 (body로 이동)
  document.addEventListener('DOMContentLoaded', function() {
    const menu = document.getElementById('userActionMenu');
    if (menu && menu.parentElement !== document.body) {
      document.body.appendChild(menu);
    }
    // 초기 로드
    searchMembers(1);
  });

  // [2] 화면 클릭 시 메뉴 닫기
  document.addEventListener('click', function(e) {
    const menu = document.getElementById('userActionMenu');
    if (menu && !menu.classList.contains('hidden')) {
      // 메뉴 내부를 클릭한 게 아니라면 닫기
      if (!menu.contains(e.target)) {
        menu.classList.add('hidden');
      }
    }
  });

  // [3] 대시보드 연동용 함수
  window.fetchUsers = function() {
    searchMembers(1);
  };

  // [4] 검색 함수
  window.searchMembers = function(page) {
    const p = page || 1;
    // 요소가 없을 경우를 대비한 안전장치
    const typeEl = document.getElementById('userSearchType');
    const keyEl = document.getElementById('userSearchKeyword');
    const searchType = typeEl ? typeEl.value : 'all';
    const keyword = keyEl ? keyEl.value : '';

    const url = '/admin/api/users?page=' + p + '&size=10&keyword=' + encodeURIComponent(keyword) + '&searchType=' + searchType + '&status=all';

    fetch(url)
            .then(res => res.json())
            .then(data => {
              renderMemberTable(data.list);
              if (window.renderCommonPagination) {
                renderCommonPagination('userPaginationButtons', data.total, data.curPage, data.size, 'searchMembers');
              }
            })
            .catch(error => {
              console.error('검색 오류:', error);
            });
  };

  // [5] 테이블 렌더링 (핵심 수정 부분: createElement 사용)
  window.renderMemberTable = function(members) {
    const tbody = document.getElementById('userTableBody');
    tbody.innerHTML = '';

    if (!members || members.length === 0) {
      tbody.innerHTML = '<tr><td colspan="4" class="px-6 py-12 text-center text-gray-500">검색 결과가 없습니다.</td></tr>';
      return;
    }

    members.forEach(m => {
      // 1. 행(TR) 생성
      const tr = document.createElement('tr');
      tr.className = 'hover:bg-gray-50/50 transition-colors';

      // 2. 데이터 준비
      const nick = m.member_nicknm || '?';
      const email = m.member_email || '-';
      const status = m.member_st || 'JOIN';
      const date = m.crt_dtm ? String(m.crt_dtm).substring(0, 10) : '-';

      // 3. HTML 문자열로 텍스트 부분 채우기 (여기는 문제 없음)
      const statusHtml = status === 'JOIN'
              ? '<span class="inline-flex items-center px-2.5 py-1 rounded-md text-[10px] font-bold bg-emerald-50 text-emerald-600 border border-emerald-100">Active</span>'
              : '<span class="inline-flex items-center px-2.5 py-1 rounded-md text-[10px] font-bold bg-gray-50 text-gray-600 border border-gray-100">Inactive</span>';

      tr.innerHTML = `
        <td class="px-6 py-4">
            <div class="flex items-center gap-3">
                <div class="w-9 h-9 rounded-full bg-blue-50 flex items-center justify-center font-bold text-primary-600 border border-blue-100">
                    \${nick.substring(0,1)}
                </div>
                <div>
                    <p class="text-sm font-bold text-gray-900">\${nick}</p>
                    <p class="text-[11px] text-gray-400">\${email}</p>
                </div>
            </div>
        </td>
        <td class="px-6 py-4">\${statusHtml}</td>
        <td class="px-6 py-4 text-xs text-gray-500 font-mono">\${date}</td>
      `;

      // 4. [중요] 관리 버튼을 "DOM Element"로 직접 만들어서 붙임
      // 문자열 파싱 오류나 이벤트 위임 실패가 발생할 수 없음
      const tdAction = document.createElement('td');
      tdAction.className = 'px-6 py-4 text-right relative';

      const btn = document.createElement('button');
      // 스타일 지정 (디버깅을 위해 빨간 테두리 임시 적용 -> 잘 되면 border-red-500 제거하세요)
      btn.className = 'text-gray-400 hover:text-gray-600 p-2 rounded hover:bg-gray-100 transition cursor-pointer border border-transparent hover:border-gray-200';
      btn.innerHTML = '<i data-lucide="more-horizontal" class="w-4 h-4"></i>';
      btn.addEventListener('click', () => alert('버튼 클릭됨')); // 임시
      // [핵심] 클릭 이벤트 직접 연결
      btn.onclick = function(e) {
        // console.log('클릭 성공!', m.member_seq); // 로그 확인용
        e.stopPropagation();
        window.openUserActionMenu(e, m.member_seq, status);
      };

      tdAction.appendChild(btn);
      tr.appendChild(tdAction);
      tbody.appendChild(tr);
    });

    // 5. 아이콘 렌더링
    if (window.lucide) lucide.createIcons();
  };

  // [6] 메뉴 열기 로직
  window.openUserActionMenu = function(event, memberSeq, currentStatus) {
    const menu = document.getElementById('userActionMenu');
    menu.classList.remove('hidden');

    // 버튼 위치 기준으로 메뉴 띄우기
    // event.target이 아이콘일 수도 있으므로 button을 확실히 찾음
    const btnElement = event.currentTarget;
    const rect = btnElement.getBoundingClientRect();

    // 화면 아래 여유 공간 계산
    const spaceBelow = window.innerHeight - rect.bottom;
    const menuHeight = 120;

    if (spaceBelow < menuHeight) {
      menu.style.top = (rect.top - menuHeight) + 'px'; // 위로
    } else {
      menu.style.top = (rect.bottom + 5) + 'px'; // 아래로
    }
    // 왼쪽으로 살짝 당겨서 배치
    menu.style.left = (rect.left - 80) + 'px';

    // 버튼 상태 제어
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

    // 기능 연결
    btnBan.onclick = () => window.updateUserStatus(memberSeq, 'BAN');
    btnActive.onclick = () => window.updateUserStatus(memberSeq, 'ACTIVE');
    btnDelete.onclick = () => window.updateUserStatus(memberSeq, 'DELETE');
  };

  // [7] 상태 변경 API
  window.updateUserStatus = function(seq, action) {
    let msg = action === 'DELETE' ? '강제 탈퇴' : (action === 'BAN' ? '정지' : '해제');
    if (!confirm(msg + ' 처리 하시겠습니까?')) return;

    fetch('/admin/api/users', {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ seq: seq, action: action })
    })
            .then(res => {
              if(res.ok) {
                document.getElementById('userActionMenu').classList.add('hidden');
                searchMembers(1); // 새로고침
              } else {
                alert('실패했습니다.');
              }
            })
            .catch(err => alert('오류: ' + err));
  };
</script>