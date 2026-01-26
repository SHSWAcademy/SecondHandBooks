<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
  <!-- 헤더 -->
  <div class="p-6 border-b border-gray-100 bg-gray-50/50 flex items-center justify-between">
    <h3 class="font-bold text-lg text-gray-900">공지사항 관리</h3>
    <button
      onclick="createNotice()"
      class="px-4 py-2 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-all flex items-center gap-2 shadow-sm hover:shadow">
      <i data-lucide="plus" class="w-4 h-4"></i>
      새 공지사항
    </button>
  </div>

  <!-- 검색 영역 -->
  <div class="px-6 py-5 bg-gray-50/50 border-b border-gray-100">
    <div class="flex items-center gap-3">
      <!-- 검색 타입 -->
      <select
        id="searchType"
        class="px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition">
        <option value="all">전체</option>
        <option value="title">제목</option>
        <option value="content">내용</option>
        <option value="author">작성자</option>
      </select>

      <!-- 상태 필터 -->
      <select
        id="statusFilter"
        class="px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition">
        <option value="all">전체 상태</option>
        <option value="active">공개</option>
        <option value="inactive">비공개</option>
      </select>

      <!-- 중요 공지 필터 -->
      <select
        id="importantFilter"
        class="px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition">
        <option value="all">전체</option>
        <option value="important">중요 공지</option>
        <option value="normal">일반 공지</option>
      </select>

      <!-- 검색 입력창 -->
      <div class="flex-1 relative">
        <input
          type="text"
          id="searchKeyword"
          placeholder="검색어를 입력하세요..."
          class="w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition pl-10"
          onkeypress="if(event.keyCode === 13) searchNotices()">
        <i data-lucide="search" class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
      </div>

      <!-- 버튼 그룹 -->
      <div class="flex gap-2">
        <button
          onclick="searchNotices()"
          class="px-5 py-2.5 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-all flex items-center gap-2 shadow-sm hover:shadow">
          <i data-lucide="search" class="w-4 h-4"></i>
          검색
        </button>
        <button
          onclick="resetSearch()"
          class="px-5 py-2.5 bg-white border border-gray-300 text-gray-700 text-sm font-medium rounded-lg hover:bg-gray-50 transition-all flex items-center gap-2">
          <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
          초기화
        </button>
      </div>
    </div>
  </div>

  <!-- 테이블 -->
  <table class="w-full">
    <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
      <tr>
        <th class="px-6 py-4 text-left w-12">
          <input type="checkbox" id="selectAll" onclick="toggleSelectAll(this)"
            class="w-4 h-4 text-primary-600 bg-gray-100 border-gray-300 rounded focus:ring-primary-500">
        </th>
        <th class="px-6 py-4 text-left">제목</th>
        <th class="px-6 py-4 text-left">작성자</th>
        <th class="px-6 py-4 text-center">조회수</th>
        <th class="px-6 py-4 text-center">상태</th>
        <th class="px-6 py-4 text-left">등록일</th>
        <th class="px-6 py-4 text-center">관리</th>
      </tr>
    </thead>
    <tbody class="divide-y divide-gray-50" id="noticeTableBody">
     <tr>
      <td colspan="6" class="px-6 py-12 text-center">
        <div class="flex flex-col items-center justify-center gap-3">
            <i data-lucide="loader" class="w-12 h-12 text-gray-300 animate-spin"></i>
            <p class="text-sm text-gray-500">공지사항을 불러오는 중...</p>
        </div>
      </td>
     </tr>
    </tbody>
  </table>

  <!-- 하단 액션바 -->
  <div class="px-6 py-4 bg-gray-50/50 border-t border-gray-100 flex items-center justify-between">
    <div class="flex items-center gap-2">
      <button
        onclick="deleteSelectedNotices()"
        class="px-4 py-2 bg-white border border-gray-300 text-gray-700 text-sm font-medium rounded-lg hover:bg-gray-50 transition-all flex items-center gap-2">
        <i data-lucide="trash-2" class="w-4 h-4"></i>
        선택 삭제
      </button>
    </div>

    <div class="text-sm text-gray-600">
      총 <span id="noticeTotalCount" class="font-bold text-primary-600">${fn:length(notices)}</span>개의 공지사항
    </div>
  </div>
</div>

<script>
  // Lucide 아이콘 초기화
  if (typeof lucide !== 'undefined') {
    lucide.createIcons();
  }

  // 페이지 로드 시 공지사항 목록 불러오기
  document.addEventListener('DOMContentLoaded', function() {
    loadNoticeList();
   });

   // 공지사항 목록 로드 함수
    function loadNoticeList() {
        fetch('/admin/api/notices')
          .then(response => response.json())
          .then(notices => {
            console.log('첫 번째 공지사항:', notices[0]);
            const tbody = document.getElementById('noticeTableBody');

            if (!notices || notices.length === 0) {
              tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-12 text-center">' +
                '<div class="flex flex-col items-center justify-center gap-3">' +
                '<i data-lucide="file-text" class="w-12 h-12 text-gray-300"></i>' +
                '<p class="text-sm text-gray-500">등록된 공지사항이 없습니다.</p>' +
                '</div></td></tr>';
              lucide.createIcons();
              return;
            }

            tbody.innerHTML = '';

            notices.forEach(notice => {
              const tr = document.createElement('tr');
              tr.className = 'hover:bg-gray-50/50 transition-colors';

              // ✅ DOM 요소로 하나씩 생성 (백틱 대신)

              // 1. 체크박스
              const tdCheck = document.createElement('td');
              tdCheck.className = 'px-6 py-4';
              const checkbox = document.createElement('input');
              checkbox.type = 'checkbox';
              checkbox.name = 'noticeCheck';
              checkbox.value = notice.notice_seq;
              checkbox.className = 'w-4 h-4 text-primary-600 bg-gray-100 border-gray-300 rounded focus:ring-primary-500';
              tdCheck.appendChild(checkbox);
              tr.appendChild(tdCheck);

              // 2. 제목
              const tdTitle = document.createElement('td');
              tdTitle.className = 'px-6 py-4';
              const titleDiv = document.createElement('div');
              titleDiv.className = 'flex items-center gap-2';

              // 중요 공지 배지
              if (notice.notice_priority === 1) {
                const badge = document.createElement('span');
                badge.className = 'inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold bg-red-50 text-red-600';
                badge.innerHTML = '<i data-lucide="alert-circle" class="w-3 h-3 mr-1"></i>중요';
                titleDiv.appendChild(badge);
              }

              // 제목 링크
              const titleLink = document.createElement('a');
              titleLink.href = 'javascript:void(0)';
              titleLink.onclick = function() { viewNotice(notice.notice_seq); };
              titleLink.className = 'text-sm font-bold text-gray-900 hover:text-primary-600 transition-colors';
              titleLink.textContent = notice.notice_title;
              titleDiv.appendChild(titleLink);
              tdTitle.appendChild(titleDiv);
              tr.appendChild(tdTitle);

              // 3. 작성자
              const tdAuthor = document.createElement('td');
              tdAuthor.className = 'px-6 py-4';
              const authorDiv = document.createElement('div');
              authorDiv.className = 'flex items-center gap-2';

              const avatar = document.createElement('div');
              avatar.className = 'w-8 h-8 rounded-full bg-primary-100 flex items-center justify-center';
              const initial = document.createElement('span');
              initial.className = 'text-xs font-bold text-primary-600';
              initial.textContent = notice.admin_name ? notice.admin_name.substring(0, 1) : 'A';
              avatar.appendChild(initial);

              const authorName = document.createElement('span');
              authorName.className = 'text-sm text-gray-700';
              authorName.textContent = notice.admin_name || '관리자';

              authorDiv.appendChild(avatar);
              authorDiv.appendChild(authorName);
              tdAuthor.appendChild(authorDiv);
              tr.appendChild(tdAuthor);

              // 4. 상태
              const tdStatus = document.createElement('td');
              tdStatus.className = 'px-6 py-4 text-center';
              const statusBadge = document.createElement('span');
              statusBadge.className = 'inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold ' +
                (notice.active ? 'bg-green-50 text-green-600' : 'bg-gray-100 text-gray-500');
              statusBadge.textContent = notice.active ? '공개' : '비공개';
              tdStatus.appendChild(statusBadge);
              tr.appendChild(tdStatus);

              // 5. 등록일
              const tdDate = document.createElement('td');
              tdDate.className = 'px-6 py-4 text-xs text-gray-500 font-mono';
              tdDate.textContent = notice.formattedCrtDtm?.substring(0, 10) || '날짜 없음';
              tr.appendChild(tdDate);

              // 6. 관리 버튼
              const tdActions = document.createElement('td');
              tdActions.className = 'px-6 py-4';
              const actionsDiv = document.createElement('div');
              actionsDiv.className = 'flex items-center justify-center gap-1';

              // 수정 버튼
              const editBtn = document.createElement('button');
              editBtn.className = 'p-1.5 text-gray-400 hover:text-primary-600 hover:bg-primary-50 rounded transition-all';
              editBtn.title = '수정';
              editBtn.onclick = function() { editNotice(notice.notice_seq); };
              editBtn.innerHTML = '<i data-lucide="edit-2" class="w-4 h-4"></i>';

              // 삭제 버튼
              const deleteBtn = document.createElement('button');
              deleteBtn.className = 'p-1.5 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded transition-all';
              deleteBtn.title = '삭제';
              deleteBtn.onclick = function() { deleteNotice(notice.notice_seq); };
              deleteBtn.innerHTML = '<i data-lucide="trash-2" class="w-4 h-4"></i>';

              actionsDiv.appendChild(editBtn);
              actionsDiv.appendChild(deleteBtn);
              tdActions.appendChild(actionsDiv);
              tr.appendChild(tdActions);

              tbody.appendChild(tr);
            });

            // Lucide 아이콘 재생성
            lucide.createIcons();

            // 총 개수 업데이트
            updateNoticeCount(notices.length);
          })
          .catch(error => {
            console.error('공지사항 로드 실패:', error);
            const tbody = document.getElementById('noticeTableBody');
            tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-12 text-center">' +
              '<p class="text-red-500">데이터를 불러오는데 실패했습니다.</p>' +
              '</td></tr>';
          });
      }

      // 총 개수 업데이트
      function updateNoticeCount(count) {
        const countElement = document.querySelector('#noticeTotalCount');
        if (countElement) {
          countElement.textContent = count;
        }
      }

      // 페이지 로드 시 실행
      document.addEventListener('DOMContentLoaded', function() {
        loadNoticeList();
      });

  // 전체 선택/해제
  function toggleSelectAll(checkbox) {
    const checkboxes = document.querySelectorAll('input[name="noticeCheck"]');
    checkboxes.forEach(cb => cb.checked = checkbox.checked);
  }

  // 검색
  function searchNotices() {
    const searchType = document.getElementById('searchType').value;
    const searchKeyword = document.getElementById('searchKeyword').value;
    const statusFilter = document.getElementById('statusFilter').value;
    const importantFilter = document.getElementById('importantFilter').value;

    const params = new URLSearchParams({
      searchType: searchType,
      searchKeyword: searchKeyword,
      statusFilter: statusFilter,
      importantFilter: importantFilter
    });

    window.location.href = '/admin/notices?' + params.toString();
  }

  // 검색 초기화
  function resetSearch() {
    document.getElementById('searchType').value = 'all';
    document.getElementById('searchKeyword').value = '';
    document.getElementById('statusFilter').value = 'all';
    document.getElementById('importantFilter').value = 'all';
    window.location.href = '/admin/notices';
  }

  // 공지사항 보기
  function viewNotice(notice_seq) {
    window.location.href = '/admin/notices/view?notice_seq=' + notice_seq;
  }

  // 공지사항 생성
  function createNotice() {
    switchView('notice-write', null);
  }

  // 공지사항 수정
  function editNotice(notice_seq) {
    window.location.href = '/admin/notices/edit?notice_seq=' + notice_seq;
  }

  // 공지사항 삭제
  function deleteNotice(notice_seq) {
    if (confirm('정말로 이 공지사항을 삭제하시겠습니까?')) {
      fetch('/admin/notices/delete/' + notice_seq, {
        method: 'DELETE'
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          alert('공지사항이 삭제되었습니다.');
          loadNoticeList();
        } else {
          alert('삭제 중 오류가 발생했습니다: ' + data.message);
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('삭제 중 오류가 발생했습니다.');
      });
    }
  }

  // 선택된 공지사항 삭제
  function deleteSelectedNotices() {
    const checkedBoxes = document.querySelectorAll('input[name="noticeCheck"]:checked');

    if (checkedBoxes.length === 0) {
      alert('삭제할 공지사항을 선택해주세요.');
      return;
    }

    if (confirm(`선택한 ${checkedBoxes.length}개의 공지사항을 삭제하시겠습니까?`)) {
      const noticeIds = Array.from(checkedBoxes).map(cb => cb.value);

      fetch('/admin/notices/delete-multiple', {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ noticeIds: noticeIds })
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          alert('선택한 공지사항이 삭제되었습니다.');
          location.reload();
        } else {
          alert('삭제 중 오류가 발생했습니다: ' + data.message);
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('삭제 중 오류가 발생했습니다.');
      });
    }
  }
</script>