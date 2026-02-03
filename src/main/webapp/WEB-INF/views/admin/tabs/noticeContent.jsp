<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <script src="/resources/js/paging/paging.js"></script>

        <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
          <!-- 헤더 -->
          <div class="p-6 border-b border-gray-100 bg-gray-50/50 flex items-center justify-between">
            <h3 class="font-bold text-lg text-gray-900">공지사항 관리</h3>
            <button onclick="createNotice()"
              class="px-4 py-2 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-all flex items-center gap-2 shadow-sm hover:shadow">
              <i data-lucide="plus" class="w-4 h-4"></i>
              새 공지사항
            </button>
          </div>

          <!-- 검색 영역 -->
          <div class="px-6 py-5 bg-gray-50/50 border-b border-gray-100">
            <div class="flex items-center gap-3">
              <!-- 검색 타입 -->
              <select id="noticesSearchType"
                class="px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition">
                <option value="all">전체</option>
                <option value="title">제목</option>
                <option value="content">내용</option>
                <option value="author">작성자</option>
              </select>

              <!-- 검색 입력창 -->
              <div class="flex-1 relative">
                <input type="text" id="noticesSearchKeyword" placeholder="검색어를 입력하세요..."
                  class="w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition pl-10"
                  onkeypress="if(event.keyCode === 13) searchNotices(1)">
                <i data-lucide="search" class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
              </div>

              <!-- 버튼 그룹 -->
              <div class="flex gap-2">
                <button onclick="searchNotices(1)"
                  class="px-5 py-2.5 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-all flex items-center gap-2 shadow-sm hover:shadow">
                  <i data-lucide="search" class="w-4 h-4"></i>
                  검색
                </button>
                <button onclick="notices_resetSearch()"
                  class="px-5 py-2.5 bg-white border border-gray-300 text-gray-700 text-sm font-medium rounded-lg hover:bg-gray-50 transition-all flex items-center gap-2">
                  <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
                  초기화
                </button>
              </div>
            </div>
          </div>

          <!-- 테이블 -->
          <table class="w-full">
            <thead
              class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
              <tr>
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
                <td colspan="7" class="px-6 py-12 text-center">
                  <div class="flex flex-col items-center justify-center gap-3">
                    <i data-lucide="loader" class="w-12 h-12 text-gray-300 animate-spin"></i>
                    <p class="text-sm text-gray-500">공지사항을 불러오는 중...</p>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>

          <!-- 페이징 영역 -->
          <div class="px-6 py-4 bg-white border-t border-gray-100 flex items-center relative">
            <div class="flex-1 flex justify-center">
              <div id="noticePaginationButtons" class="flex gap-1"></div>
            </div>

            <div class="absolute right-6 text-sm text-gray-600">
              총 <span id="noticeTotalCount" class="font-bold text-primary-600">0</span>개의 공지사항
            </div>
          </div>
        </div>

        <script>
          // Lucide 아이콘 초기화
          if (typeof lucide !== 'undefined') {
            lucide.createIcons();
          }

          // 공지사항 검색 및 목록 로드 (페이징 지원)
          function searchNotices(page) {
            const p = page || 1;
            const searchType = document.getElementById('noticesSearchType')?.value || 'all';  // ✅ 수정
            const searchKeyword = document.getElementById('noticesSearchKeyword')?.value || '';
            const statusFilter = document.getElementById('statusFilter')?.value || 'all';
            const importantFilter = document.getElementById('importantFilter')?.value || 'all';

            const url = '/admin/api/notices?page=' + p
              + '&size=10'
              + '&keyword=' + encodeURIComponent(searchKeyword)
              + '&searchType=' + searchType
              + '&statusFilter=' + statusFilter
              + '&importantFilter=' + importantFilter;

            console.log('🔍 공지사항 API 요청:', url);

            fetch(url)
              .then(response => {
                console.log('📡 응답 상태:', response.status);
                return response.json();
              })
              .then(data => {
                console.log('📦 받은 데이터:', data);

                renderNoticeTable(data.list || []);

                // 페이징 렌더링
                renderCommonPagination(
                  'noticePaginationButtons',
                  data.total,
                  data.curPage,
                  data.size,
                  'searchNotices'
                );

                // 총 개수 업데이트
                updateNoticeCount(data.total || 0);
              })
              .catch(error => {
                console.error('❌ 공지사항 로드 실패:', error);
                const tbody = document.getElementById('noticeTableBody');
                tbody.innerHTML = '<tr><td colspan="7" class="px-6 py-12 text-center">' +
                  '<p class="text-red-500">데이터를 불러오는데 실패했습니다.</p>' +
                  '</td></tr>';
              });
          }

          // 테이블 렌더링
          function renderNoticeTable(notices) {
            const tbody = document.getElementById('noticeTableBody');

            if (!notices || notices.length === 0) {
              tbody.innerHTML = '<tr><td colspan="7" class="px-6 py-12 text-center">' +
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

              // 2. 제목
              const tdTitle = document.createElement('td');
              tdTitle.className = 'px-6 py-4';
              const titleDiv = document.createElement('div');
              titleDiv.className = 'flex items-center gap-2';

              if (notice.notice_priority === 1) {
                const badge = document.createElement('span');
                badge.className = 'inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold bg-red-50 text-red-600';
                badge.innerHTML = '<i data-lucide="alert-circle" class="w-3 h-3 mr-1"></i>중요';
                titleDiv.appendChild(badge);
              }

              const titleLink = document.createElement('a');
              titleLink.href = 'javascript:void(0)';
              titleLink.onclick = function () { viewNotice(notice.notice_seq); };
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
              initial.textContent = notice.admin_login_id ? notice.admin_login_id.substring(0, 1) : 'A';
              avatar.appendChild(initial);

              const authorName = document.createElement('span');
              authorName.className = 'text-sm text-gray-700';
              authorName.textContent = notice.admin_login_id || '관리자';

              authorDiv.appendChild(avatar);
              authorDiv.appendChild(authorName);
              tdAuthor.appendChild(authorDiv);
              tr.appendChild(tdAuthor);

              // 4. 조회수
              const tdViews = document.createElement('td');
              tdViews.className = 'px-6 py-4 text-center text-sm text-gray-600';
              tdViews.textContent = notice.view_count ? notice.view_count.toLocaleString() : '0';
              tr.appendChild(tdViews);

              // 5. 상태
              const tdStatus = document.createElement('td');
              tdStatus.className = 'px-6 py-4 text-center';
              const statusBadge = document.createElement('span');
              statusBadge.className = 'inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold ' +
                (notice.active ? 'bg-green-50 text-green-600' : 'bg-gray-100 text-gray-500');
              statusBadge.textContent = notice.active ? '공개' : '비공개';
              tdStatus.appendChild(statusBadge);
              tr.appendChild(tdStatus);

              // 6. 등록일
              const tdDate = document.createElement('td');
              tdDate.className = 'px-6 py-4 text-xs text-gray-500 font-mono';
              tdDate.textContent = notice.formattedCrtDtm || (notice.crt_dtm ? String(notice.crt_dtm) : '-');
              tr.appendChild(tdDate);

              // 7. 관리 버튼
              const tdActions = document.createElement('td');
              tdActions.className = 'px-6 py-4';
              const actionsDiv = document.createElement('div');
              actionsDiv.className = 'flex items-center justify-center gap-1';

              const editBtn = document.createElement('button');
              editBtn.className = 'p-1.5 text-gray-400 hover:text-primary-600 hover:bg-primary-50 rounded transition-all';
              editBtn.title = '수정';
              editBtn.onclick = function () { editNotice(notice.notice_seq); };
              editBtn.innerHTML = '<i data-lucide="edit-2" class="w-4 h-4"></i>';

              const deleteBtn = document.createElement('button');
              deleteBtn.className = 'p-1.5 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded transition-all';
              deleteBtn.title = '삭제';
              deleteBtn.onclick = function () { deleteNotice(notice.notice_seq); };
              deleteBtn.innerHTML = '<i data-lucide="trash-2" class="w-4 h-4"></i>';

              actionsDiv.appendChild(editBtn);
              actionsDiv.appendChild(deleteBtn);
              tdActions.appendChild(actionsDiv);
              tr.appendChild(tdActions);

              tbody.appendChild(tr);
            });

            lucide.createIcons();
          }

          // 총 개수 업데이트
          function updateNoticeCount(count) {
            const countElement = document.querySelector('#noticeTotalCount');
            if (countElement) {
              countElement.textContent = count;
            }
          }

          // 전체 선택/해제
          function toggleSelectAll(checkbox) {
            const checkboxes = document.querySelectorAll('input[name="noticeCheck"]');
            checkboxes.forEach(cb => cb.checked = checkbox.checked);
          }

          // 검색 초기화
          function notices_resetSearch() {
            document.getElementById('noticesSearchType').value = 'all';
            document.getElementById('noticesSearchKeyword').value = '';
            document.getElementById('statusFilter').value = 'all';
            document.getElementById('importantFilter').value = 'all';
            searchNotices(1);
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
                    searchNotices(1);
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
                    searchNotices(1);
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

          // ✅ 즉시 실행 (동적 로드 대응)
          (function () {
            console.log('🚀 공지사항 목록 초기화');
            searchNotices(1);
          })();
        </script>