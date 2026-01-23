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
    <tbody class="divide-y divide-gray-50">
      <c:choose>
        <c:when test="${empty notices}">
          <tr>
            <td colspan="7" class="px-6 py-12 text-center">
              <div class="flex flex-col items-center justify-center gap-3">
                <i data-lucide="file-text" class="w-12 h-12 text-gray-300"></i>
                <p class="text-sm text-gray-500">등록된 공지사항이 없습니다.</p>
              </div>
            </td>
          </tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="notice" items="${notices}">
            <tr class="hover:bg-gray-50/50 transition-colors">
              <!-- 체크박스 -->
              <td class="px-6 py-4">
                <input type="checkbox" name="noticeCheck" value="${notice.notice_id}"
                  class="w-4 h-4 text-primary-600 bg-gray-100 border-gray-300 rounded focus:ring-primary-500">
              </td>

              <!-- 제목 -->
              <td class="px-6 py-4">
                <div class="flex items-center gap-2">
                  <c:if test="${notice.is_important}">
                    <span class="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold bg-red-50 text-red-600">
                      <i data-lucide="alert-circle" class="w-3 h-3 mr-1"></i>
                      중요
                    </span>
                  </c:if>
                  <a href="javascript:void(0)" onclick="viewNotice(${notice.notice_id})"
                    class="text-sm font-bold text-gray-900 hover:text-primary-600 transition-colors">
                    ${notice.notice_title}
                  </a>
                </div>
              </td>

              <!-- 작성자 -->
              <td class="px-6 py-4">
                <div class="flex items-center gap-2">
                  <div class="w-8 h-8 rounded-full bg-primary-100 flex items-center justify-center">
                    <span class="text-xs font-bold text-primary-600">
                      ${fn:substring(notice.admin_name, 0, 1)}
                    </span>
                  </div>
                  <span class="text-sm text-gray-700">${notice.admin_name}</span>
                </div>
              </td>

              <!-- 조회수 -->
              <td class="px-6 py-4 text-center">
                <div class="flex items-center justify-center gap-1">
                  <i data-lucide="eye" class="w-3.5 h-3.5 text-gray-400"></i>
                  <span class="text-sm text-gray-600 font-medium">
                    <fmt:formatNumber value="${notice.view_count}" pattern="#,###" />
                  </span>
                </div>
              </td>

              <!-- 상태 -->
              <td class="px-6 py-4 text-center">
                <span class="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold
                  ${notice.is_active ? 'bg-green-50 text-green-600' : 'bg-gray-100 text-gray-500'}">
                  ${notice.is_active ? '공개' : '비공개'}
                </span>
              </td>

              <!-- 등록일 -->
              <td class="px-6 py-4 text-xs text-gray-500 font-mono">
                ${fn:substring(notice.crt_dtm, 0, 10)}
              </td>

              <!-- 관리 버튼 -->
              <td class="px-6 py-4">
                <div class="flex items-center justify-center gap-1">
                  <button
                    onclick="editNotice(${notice.notice_id})"
                    class="p-1.5 text-gray-400 hover:text-primary-600 hover:bg-primary-50 rounded transition-all"
                    title="수정">
                    <i data-lucide="edit-2" class="w-4 h-4"></i>
                  </button>
                  <button
                    onclick="deleteNotice(${notice.notice_id})"
                    class="p-1.5 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded transition-all"
                    title="삭제">
                    <i data-lucide="trash-2" class="w-4 h-4"></i>
                  </button>
                </div>
              </td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
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
      총 <span class="font-bold text-primary-600">${fn:length(notices)}</span>개의 공지사항
    </div>
  </div>
</div>

<script>
  // Lucide 아이콘 초기화
  if (typeof lucide !== 'undefined') {
    lucide.createIcons();
  }

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
  function viewNotice(noticeId) {
    window.location.href = '/admin/notices/view?noticeId=' + noticeId;
  }

  // 공지사항 생성
  function createNotice() {
    switchView('notice-write', null);
  }

  // 공지사항 수정
  function editNotice(noticeId) {
    window.location.href = '/admin/notices/edit?noticeId=' + noticeId;
  }

  // 공지사항 삭제
  function deleteNotice(noticeId) {
    if (confirm('정말로 이 공지사항을 삭제하시겠습니까?')) {
      fetch('/admin/notices/delete/' + noticeId, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json'
        }
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          alert('공지사항이 삭제되었습니다.');
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