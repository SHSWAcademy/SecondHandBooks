<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
  <div class="p-6 border-b border-gray-100 bg-gray-50/50">
    <h3 class="font-bold text-lg text-gray-900">회원 접속 기록</h3>
    <p class="text-xs text-gray-500 mt-1">최근 로그인 기록 및 활동 내역</p>
  </div>

  <!-- 검색 영역 -->
        <div class="px-6 py-5 bg-gray-50/50 border-b border-gray-100">
          <div class="flex items-center gap-3">
            <!-- 검색 타입 -->
            <select
              id="usersLogSearchType"
              class="px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition">
              <option value="all">전체</option>
              <option value="nickname">닉네임</option>
              <option value="ip">IP</option>
              <option value="accessTime">접속시간</option>
            </select>

            <!-- 검색 입력창 -->
            <div class="flex-1 relative">
              <input
                type="text"
                id="usersLogSearchKeyword"
                placeholder="검색어를 입력하세요..."
                class="w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition pl-10"
                onkeypress="if(event.keyCode === 13) searchMembers()">
              <i data-lucide="search" class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
            </div>

            <!-- 버튼 그룹 -->
            <div class="flex gap-2">
              <button
                type="button"
                onclick="searchUsersLog()"
                class="px-5 py-2.5 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-all flex items-center gap-2 shadow-sm hover:shadow">
                <i data-lucide="search" class="w-4 h-4"></i>
                검색
              </button>
              <button
                type="button"
                onclick="usersLog_resetSearch()"
                class="px-5 py-2.5 bg-white border border-gray-300 text-gray-700 text-sm font-medium rounded-lg hover:bg-gray-50 transition-all flex items-center gap-2">
                <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
                초기화
              </button>
            </div>
          </div>
        </div>
  <table class="w-full">
    <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
    <tr>
      <th class="px-6 py-4 text-left">회원</th>
      <th class="px-6 py-4 text-left">접속 IP</th>
      <th class="px-6 py-4 text-left">접속 시간</th>
      <th class="px-6 py-4 text-left">접속 종료시간</th>
    </tr>
    </thead>
    <tbody id="usersLog"class="divide-y divide-gray-50">
    <c:choose>
      <c:when test="${not empty userLogs}">
        <c:forEach var="log" items="${userLogs}">
          <tr class="hover:bg-gray-50/50 transition-colors">
            <td class="px-6 py-4">
              <p class="text-sm font-bold text-gray-900">${log.member_nicknm}</p>
              <c:if test="${not empty log.member_email}">
                <p class="text-xs text-gray-500 mt-0.5">${log.member_email}</p>
              </c:if>
            </td>
            <td class="px-6 py-4 text-xs text-gray-500 font-mono">${log.login_ip}</td>
            <td class="px-6 py-4 text-xs text-gray-500 font-mono">${log.formattedLoginDtm}</td>
            <td class="px-6 py-4 text-xs text-gray-500 font-mono">${log.formattedLogoutDtm}</td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr>
          <td colspan="4" class="px-6 py-12 text-center text-sm text-gray-400">접속 기록이 없습니다</td>
        </tr>
      </c:otherwise>
    </c:choose>
    </tbody>
  </table>
</div>

<script>
    function searchUsersLog(page) {
        const p = page || 1;
        const searchType = document.getElementById('usersLogSearchType').value;
        const keyword = document.getElementById('usersLogSearchKeyword').value;
        const url = '/admin/api/users?page=' + p
                  + '&size=10'
                  + '&keyword=' + encodeURIComponent(keyword)
                  + '&searchType=' + searchType
                  + '&status=all';
        fetch(url)
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                renderMemberTable(data.list);

                renderCommonPagination(
                    'userPaginationButtons',
                    data.total,
                    data.curPage,
                    data.size,
                    'searchMembers'
                );
            })
            .catch(function(error) {
                console.error('검색 중 오류 발생:', error);
            });
    }

    function renderMemberTable(members) {
        const tbody = document.querySelector('#userTableBody');
        tbody.innerHTML = ''; // 기존 내용 삭제

        if (!members || members.length === 0) {
            const tr = document.createElement('tr');
            const td = document.createElement('td');
            td.colSpan = 4;
            td.className = 'px-6 py-12 text-center text-gray-500';
            td.textContent = '검색 결과가 없습니다.';
            tr.appendChild(td);
            tbody.appendChild(tr);
            return;
        }

        members.forEach(m => {
            const tr = document.createElement('tr');
            tr.className = 'hover:bg-gray-50/50 transition-colors';

            const tdInfo = document.createElement('td');
            tdInfo.className = 'px-6 py-4';

            const flexDiv = document.createElement('div');
            flexDiv.className = 'flex items-center gap-3';

            const avatar = document.createElement('div');
            avatar.className = 'w-9 h-9 rounded-full bg-blue-50 flex items-center justify-center font-bold text-primary-600 border border-blue-100';
            avatar.textContent = m.member_nicknm ? m.member_nicknm.substring(0,1) : '?';

            const textDiv = document.createElement('div');
            const nameP = document.createElement('p');
            nameP.className = 'text-sm font-bold text-gray-900';
            nameP.textContent = m.member_nicknm;
            const emailP = document.createElement('p');
            emailP.className = 'text-[11px] text-gray-400';
            emailP.textContent = m.member_email;

            textDiv.appendChild(nameP);
            textDiv.appendChild(emailP);
            flexDiv.appendChild(avatar);
            flexDiv.appendChild(textDiv);
            tdInfo.appendChild(flexDiv);

            const tdStatus = document.createElement('td');
            tdStatus.className = 'px-6 py-4';
            const statusBadge = document.createElement('span');

            if (m.member_st === 'JOIN') {
                statusBadge.className = 'inline-flex items-center px-2.5 py-1 rounded-md text-[10px] font-bold bg-emerald-50 text-emerald-600 border border-emerald-100';
                statusBadge.textContent = 'Active';
            } else {
                statusBadge.className = 'inline-flex items-center px-2.5 py-1 rounded-md text-[10px] font-bold bg-gray-50 text-gray-600 border border-gray-100';
                statusBadge.textContent = 'Inactive';
            }
            tdStatus.appendChild(statusBadge);

            const tdDate = document.createElement('td');
            tdDate.className = 'px-6 py-4 text-xs text-gray-500 font-mono';
            tdDate.textContent = m.crt_dtm ? String(m.crt_dtm) : '-';

            const tdAction = document.createElement('td');
            tdAction.className = 'px-6 py-4 text-right';
            const btn = document.createElement('button');
                    btn.className = 'text-gray-400 hover:text-gray-600';
                    btn.innerHTML = '<i data-lucide="more-horizontal" class="w-4 h-4"></i>';
                    tdAction.appendChild(btn);

                    // 행에 모든 열 추가
                    tr.appendChild(tdInfo);
                    tr.appendChild(tdStatus);
                    tr.appendChild(tdDate);
                    tr.appendChild(tdAction);

                    tbody.appendChild(tr);
        });

        if (window.lucide) {
                lucide.createIcons();
        }
    }

    function users_resetSearch() {
        document.getElementById('usersLogSearchKeyword').value = '';
        document.getElementById('usersLogSearchType').value = 'all';
        searchUsersLog(1);
    }

    // 페이지 로드 시 자동으로 첫 페이지 데이터와 페이징 버튼을 가져옵니다.
    document.addEventListener('DOMContentLoaded', function() {
        searchUsersLog(1);
    });
</script>