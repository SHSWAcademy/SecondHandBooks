<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ShinhanBooks Admin Console</title>

  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            primary: { 50: '#eff6ff', 100: '#dbeafe', 500: '#3b82f6', 600: '#2563eb', 700: '#1d4ed8', 900: '#1e3a8a' }
          }
        }
      }
    }
  </script>
  <script src="https://unpkg.com/lucide@latest"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
  <style> body { font-family: 'Noto Sans KR', sans-serif; } </style>
</head>
<body class="bg-gray-50 h-screen flex overflow-hidden text-gray-800">

<aside class="w-64 bg-white border-r border-gray-200 flex flex-col z-20 flex-shrink-0">
  <div class="h-16 flex items-center px-6 border-b border-gray-100">
    <div class="flex items-center gap-2 text-primary-600">
      <i data-lucide="shield-check" class="w-6 h-6"></i>
      <span class="text-xl font-black tracking-tight text-gray-900">Admin<span class="text-primary-600">Console</span></span>
    </div>
  </div>

  <nav class="flex-1 overflow-y-auto py-6 px-3 space-y-1">
    <button onclick="switchView('dashboard', this)" class="nav-item w-full flex items-center gap-3 px-4 py-3 text-sm font-bold rounded-xl bg-primary-50 text-primary-700 transition-all">
      <i data-lucide="layout-dashboard" class="w-5 h-5"></i> 대시보드
    </button>

    <div class="pt-4 pb-2 px-4 text-[10px] font-extrabold text-gray-400 uppercase tracking-wider">Management</div>

    <button onclick="switchView('users', this)" class="nav-item w-full flex items-center gap-3 px-4 py-3 text-sm font-medium text-gray-600 rounded-xl hover:bg-gray-50 hover:text-gray-900 transition-all">
      <i data-lucide="users" class="w-5 h-5"></i> 회원 관리
    </button>
    <button onclick="switchView('books', this)" class="nav-item w-full flex items-center gap-3 px-4 py-3 text-sm font-medium text-gray-600 rounded-xl hover:bg-gray-50 hover:text-gray-900 transition-all">
      <i data-lucide="shopping-bag" class="w-5 h-5"></i> 상품 관리
    </button>
    <button onclick="switchView('groups', this)" class="nav-item w-full flex items-center gap-3 px-4 py-3 text-sm font-medium text-gray-600 rounded-xl hover:bg-gray-50 hover:text-gray-900 transition-all">
      <i data-lucide="book-open" class="w-5 h-5"></i> 모임 관리
    </button>
  </nav>

  <div class="p-4 border-t border-gray-100">
    <div class="flex items-center gap-3 p-3 rounded-xl bg-gray-50 border border-gray-200">
      <div class="w-9 h-9 rounded-full bg-primary-600 flex items-center justify-center text-white font-bold text-sm">A</div>
      <div class="flex-1 min-w-0">
        <p class="text-sm font-bold text-gray-900">${sessionScope.adminSess.admin_login_id}</p>
        <p class="text-xs text-gray-500 truncate">Administrator</p>
      </div>
      <a href="/admin/logout" class="text-gray-400 hover:text-red-500 transition"><i data-lucide="log-out" class="w-4 h-4"></i></a>
    </div>
  </div>
</aside>

<main class="flex-1 overflow-y-auto bg-gray-50/50">
  <header class="bg-white border-b border-gray-200 h-16 flex items-center justify-between px-8 sticky top-0 z-10">
    <div class="flex items-center gap-2 text-sm text-gray-500">
      <span class="font-medium text-gray-400">Console</span>
      <i data-lucide="chevron-right" class="w-4 h-4"></i>
      <span id="page-title" class="font-bold text-gray-900">Dashboard</span>
    </div>
  </header>

  <div class="p-8 max-w-7xl mx-auto space-y-8">

    <div id="view-dashboard" class="view-section animate-[fadeIn_0.3s_ease-out]">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm relative overflow-hidden group">
          <div class="absolute right-0 top-0 w-24 h-24 bg-primary-50 rounded-bl-full -mr-4 -mt-4 transition-transform group-hover:scale-110"></div>
          <div class="relative z-10">
            <p class="text-gray-500 text-xs font-bold uppercase mb-1">Total Users</p>
            <h3 class="text-3xl font-black text-gray-900 mb-2">
              <fmt:formatNumber value="${memberCount}" pattern="#,###" />
            </h3>
            <div class="flex items-center gap-1 text-xs font-bold text-emerald-500">
              <i data-lucide="users" class="w-3 h-3"></i> 전체 회원
            </div>
          </div>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm relative overflow-hidden group">
          <div class="absolute right-0 top-0 w-24 h-24 bg-purple-50 rounded-bl-full -mr-4 -mt-4 transition-transform group-hover:scale-110"></div>
          <div class="relative z-10">
            <p class="text-gray-500 text-xs font-bold uppercase mb-1">Active Trades</p>
            <h3 class="text-3xl font-black text-gray-900 mb-2">
              <fmt:formatNumber value="${tradeCount}" pattern="#,###" />
            </h3>
            <div class="flex items-center gap-1 text-xs font-bold text-emerald-500">
              <i data-lucide="book" class="w-3 h-3"></i> 등록된 상품
            </div>
          </div>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm relative overflow-hidden group">
          <div class="absolute right-0 top-0 w-24 h-24 bg-orange-50 rounded-bl-full -mr-4 -mt-4 transition-transform group-hover:scale-110"></div>
          <div class="relative z-10">
            <p class="text-gray-500 text-xs font-bold uppercase mb-1">Total Groups</p>
            <h3 class="text-3xl font-black text-gray-900 mb-2">
              <fmt:formatNumber value="${clubCount}" pattern="#,###" />
            </h3>
            <div class="flex items-center gap-1 text-xs font-bold text-primary-600">
              <i data-lucide="users" class="w-3 h-3"></i> 운영 중인 모임
            </div>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm">
          <h3 class="font-bold text-gray-900 mb-4 text-sm">주간 가입 및 거래 추이</h3>
          <div class="h-64">
            <canvas id="mainChart"></canvas>
          </div>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm">
          <h3 class="font-bold text-gray-900 mb-4 text-sm">카테고리별 거래 비중</h3>
          <div class="h-64 flex justify-center">
            <canvas id="doughnutChart"></canvas>
          </div>
        </div>
      </div>
    </div>

    <div id="view-users" class="view-section hidden animate-[fadeIn_0.3s_ease-out]">
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
          <h3 class="font-bold text-lg text-gray-900">회원 관리 (최근 가입순)</h3>
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
          <tbody class="divide-y divide-gray-50">
          <c:forEach var="m" items="${members}">
            <tr class="hover:bg-gray-50/50 transition-colors">
              <td class="px-6 py-4">
                <div class="flex items-center gap-3">
                  <div class="w-9 h-9 rounded-full bg-blue-50 flex items-center justify-center font-bold text-primary-600 border border-blue-100">
                      ${m.member_nicknm.substring(0,1)}
                  </div>
                  <div>
                    <p class="text-sm font-bold text-gray-900">${m.member_nicknm}</p>
                    <p class="text-[11px] text-gray-400">${m.member_email}</p>
                  </div>
                </div>
              </td>
              <td class="px-6 py-4">
                <c:choose>
                  <c:when test="${m.member_st == 'JOIN'}">
                    <span class="inline-flex items-center px-2.5 py-1 rounded-md text-[10px] font-bold bg-emerald-50 text-emerald-600 border border-emerald-100">Active</span>
                  </c:when>
                  <c:otherwise>
                    <span class="inline-flex items-center px-2.5 py-1 rounded-md text-[10px] font-bold bg-gray-50 text-gray-600 border border-gray-100">Inactive</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td class="px-6 py-4 text-xs text-gray-500 font-mono">${m.crt_dtm}</td>
              <td class="px-6 py-4 text-right">
                <button class="text-gray-400 hover:text-gray-600"><i data-lucide="more-horizontal" class="w-4 h-4"></i></button>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>

    <div id="view-books" class="view-section hidden animate-[fadeIn_0.3s_ease-out]">
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <div class="p-6 border-b border-gray-100 bg-gray-50/50">
          <h3 class="font-bold text-lg text-gray-900">상품 관리 (최근 등록순)</h3>
        </div>
        <table class="w-full">
          <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
          <tr>
            <th class="px-6 py-4 text-left">상품명</th>
            <th class="px-6 py-4 text-left">가격</th>
            <th class="px-6 py-4 text-left">지역</th>
            <th class="px-6 py-4 text-left">상태</th>
            <th class="px-6 py-4 text-left">등록일</th>
          </tr>
          </thead>
          <tbody class="divide-y divide-gray-50">
          <c:forEach var="t" items="${trades}">
            <tr class="hover:bg-gray-50/50 transition-colors">
              <td class="px-6 py-4">
                <p class="text-sm font-bold text-gray-900 w-64 truncate">${t.sale_title}</p>
                <p class="text-[10px] text-gray-400">${t.book_title}</p>
              </td>
              <td class="px-6 py-4 text-sm font-black text-primary-600">
                <fmt:formatNumber value="${t.sale_price}" pattern="#,###" />원
              </td>
              <td class="px-6 py-4 text-xs text-gray-500">${t.sale_rg}</td>
              <td class="px-6 py-4">
                                <span class="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold
                                    ${t.sale_st == 'SALE' ? 'bg-green-50 text-green-600' : 'bg-gray-100 text-gray-500'}">
                                    ${t.sale_st}
                                </span>
              </td>
              <td class="px-6 py-4 text-xs text-gray-500 font-mono">${t.crt_dtm}</td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>

    <div id="view-groups" class="view-section hidden animate-[fadeIn_0.3s_ease-out]">
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <div class="p-6 border-b border-gray-100 bg-gray-50/50">
          <h3 class="font-bold text-lg text-gray-900">모임 관리 (최근 생성순)</h3>
        </div>
        <table class="w-full">
          <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
          <tr>
            <th class="px-6 py-4 text-left">모임명</th>
            <th class="px-6 py-4 text-left">지역</th>
            <th class="px-6 py-4 text-left">정원</th>
            <th class="px-6 py-4 text-left">일정</th>
            <th class="px-6 py-4 text-left">생성일</th>
          </tr>
          </thead>
          <tbody class="divide-y divide-gray-50">
          <c:forEach var="g" items="${clubs}">
            <tr class="hover:bg-gray-50/50 transition-colors">
              <td class="px-6 py-4">
                <p class="text-sm font-bold text-gray-900">${g.book_club_name}</p>
              </td>
              <td class="px-6 py-4 text-xs text-gray-500">
                <div class="flex items-center gap-1"><i data-lucide="map-pin" class="w-3 h-3"></i> ${g.book_club_rg}</div>
              </td>
              <td class="px-6 py-4 text-xs font-bold text-primary-600">${g.book_club_max_member}명</td>
              <td class="px-6 py-4 text-xs text-gray-500">${g.book_club_schedule}</td>
              <td class="px-6 py-4 text-xs text-gray-500 font-mono">${g.crt_dtm}</td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</main>

<script>
  // 1. 아이콘 로드 (이제 안전하게 실행됩니다)
  lucide.createIcons();

  // 2. 뷰 전환 로직
  function switchView(viewName, btn) {
    document.querySelectorAll('.nav-item').forEach(el => {
      el.classList.remove('bg-primary-50', 'text-primary-700');
      el.classList.add('text-gray-600', 'hover:bg-gray-50', 'hover:text-gray-900');
    });
    btn.classList.remove('text-gray-600', 'hover:bg-gray-50', 'hover:text-gray-900');
    btn.classList.add('bg-primary-50', 'text-primary-700');

    document.querySelectorAll('.view-section').forEach(el => el.classList.add('hidden'));

    const targetView = document.getElementById('view-' + viewName);
    if(targetView) {
      targetView.classList.remove('hidden');
    }

    const titleMap = {
      'dashboard': 'Dashboard',
      'users': 'User Management',
      'books': 'Product Management',
      'groups': 'Group Management',
    };
    document.getElementById('page-title').innerText = titleMap[viewName] || 'Dashboard';
  }

  // 3. 차트 초기화 (HTML에 canvas가 있으므로 에러 없이 실행됨)
  try {
    const ctxMain = document.getElementById('mainChart').getContext('2d');
    const mainChart = new Chart(ctxMain, {
      type: 'line',
      data: {
        labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        datasets: [{
          label: '신규 가입',
          data: [12, 19, 3, 5, 2, 3, 10],
          borderColor: '#3b82f6',
          backgroundColor: 'rgba(59, 130, 246, 0.1)',
          tension: 0.4,
          fill: true
        }, {
          label: '거래 완료',
          data: [8, 12, 6, 9, 12, 15, 20],
          borderColor: '#10b981',
          backgroundColor: 'transparent',
          tension: 0.4,
          borderDash: [5, 5]
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { position: 'top', align: 'end', labels: { boxWidth: 10, usePointStyle: true } } },
        scales: { y: { beginAtZero: true, grid: { borderDash: [2, 4] } }, x: { grid: { display: false } } }
      }
    });

    const ctxDoughnut = document.getElementById('doughnutChart').getContext('2d');
    const doughnutChart = new Chart(ctxDoughnut, {
      type: 'doughnut',
      data: {
        labels: ['IT/개발', '경제/경영', '자기계발', '기타'],
        datasets: [{
          data: [45, 30, 15, 10],
          backgroundColor: ['#3b82f6', '#34d399', '#a78bfa', '#f3f4f6'],
          borderWidth: 0
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        cutout: '75%'
      }
    });
  } catch (e) {
    console.error("Chart rendering failed:", e);
  }
</script>

</body>
</html>