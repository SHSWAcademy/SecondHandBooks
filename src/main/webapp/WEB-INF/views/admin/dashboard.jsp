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
    <button onclick="switchView('dashboard', this)" class="nav-item w-full flex items-center gap-3 px-4 py-3 text-sm font-bold rounded-xl transition-all bg-primary-50 text-primary-700">
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

    <div class="pt-4 pb-2 px-4 text-[10px] font-extrabold text-gray-400 uppercase tracking-wider">System</div>

    <button onclick="switchView('notices', this)" class="nav-item w-full flex items-center gap-3 px-4 py-3 text-sm font-medium text-gray-600 rounded-xl hover:bg-gray-50 hover:text-gray-900 transition-all">
      <i data-lucide="megaphone" class="w-5 h-5"></i> 공지사항
    </button>
    <button onclick="switchView('logs', this)" class="nav-item w-full flex items-center gap-3 px-4 py-3 text-sm font-medium text-gray-600 rounded-xl hover:bg-gray-50 hover:text-gray-900 transition-all">
      <i data-lucide="history" class="w-5 h-5"></i> 시스템 로그
    </button>
  </nav>

  <div class="p-4 border-t border-gray-100">
    <div class="flex items-center gap-3 p-3 rounded-xl bg-gray-50 border border-gray-200">
      <div class="w-9 h-9 rounded-full bg-primary-600 flex items-center justify-center text-white font-bold text-sm">A</div>
      <div class="flex-1 min-w-0">
        <p class="text-sm font-bold text-gray-900 truncate">Administrator</p>
        <p class="text-xs text-gray-500 truncate">master@shinhan.com</p>
      </div>
      <button onclick="location.href='/logout'" class="text-gray-400 hover:text-red-500 transition"><i data-lucide="log-out" class="w-4 h-4"></i></button>
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
    <div class="flex items-center gap-4">
      <div class="relative">
        <i data-lucide="search" class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400"></i>
        <input type="text" placeholder="통합 검색..." class="pl-9 pr-4 py-2 bg-gray-100 border-none rounded-lg text-sm focus:ring-2 focus:ring-primary-100 outline-none w-64 transition-all focus:w-80">
      </div>
      <button class="relative p-2 text-gray-400 hover:text-gray-600 transition">
        <i data-lucide="bell" class="w-5 h-5"></i>
        <span class="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full border border-white"></span>
      </button>
    </div>
  </header>

  <div class="p-8 max-w-7xl mx-auto space-y-8">

    <div id="view-dashboard" class="view-section animate-[fadeIn_0.3s_ease-out]">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm hover:shadow-md transition-shadow relative overflow-hidden group">
          <div class="absolute right-0 top-0 w-24 h-24 bg-primary-50 rounded-bl-full -mr-4 -mt-4 transition-transform group-hover:scale-110"></div>
          <div class="relative z-10">
            <p class="text-gray-500 text-xs font-bold uppercase mb-1">Total Users</p>
            <h3 class="text-3xl font-black text-gray-900 mb-2">1,248</h3>
            <div class="flex items-center gap-1 text-xs font-bold text-emerald-500">
              <i data-lucide="trending-up" class="w-3 h-3"></i> +12.5% <span class="text-gray-400 font-medium ml-1">vs last month</span>
            </div>
          </div>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm hover:shadow-md transition-shadow relative overflow-hidden group">
          <div class="absolute right-0 top-0 w-24 h-24 bg-purple-50 rounded-bl-full -mr-4 -mt-4 transition-transform group-hover:scale-110"></div>
          <div class="relative z-10">
            <p class="text-gray-500 text-xs font-bold uppercase mb-1">Active Books</p>
            <h3 class="text-3xl font-black text-gray-900 mb-2">856</h3>
            <div class="flex items-center gap-1 text-xs font-bold text-emerald-500">
              <i data-lucide="trending-up" class="w-3 h-3"></i> +5.2% <span class="text-gray-400 font-medium ml-1">new listings</span>
            </div>
          </div>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm hover:shadow-md transition-shadow relative overflow-hidden group">
          <div class="absolute right-0 top-0 w-24 h-24 bg-orange-50 rounded-bl-full -mr-4 -mt-4 transition-transform group-hover:scale-110"></div>
          <div class="relative z-10">
            <p class="text-gray-500 text-xs font-bold uppercase mb-1">Total Groups</p>
            <h3 class="text-3xl font-black text-gray-900 mb-2">42</h3>
            <div class="flex items-center gap-1 text-xs font-bold text-red-500">
              <i data-lucide="trending-down" class="w-3 h-3"></i> -2.1% <span class="text-gray-400 font-medium ml-1">retention</span>
            </div>
          </div>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm hover:shadow-md transition-shadow relative overflow-hidden group">
          <div class="absolute right-0 top-0 w-24 h-24 bg-blue-50 rounded-bl-full -mr-4 -mt-4 transition-transform group-hover:scale-110"></div>
          <div class="relative z-10">
            <p class="text-gray-500 text-xs font-bold uppercase mb-1">Reports</p>
            <h3 class="text-3xl font-black text-gray-900 mb-2">5</h3>
            <div class="flex items-center gap-1 text-xs font-bold text-orange-500">
              <i data-lucide="alert-circle" class="w-3 h-3"></i> Action Needed
            </div>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
        <div class="lg:col-span-2 bg-white p-6 rounded-2xl border border-gray-100 shadow-sm">
          <div class="flex justify-between items-center mb-6">
            <h3 class="font-bold text-gray-900">주간 거래 및 가입 추이</h3>
            <button class="text-xs font-bold text-primary-600 bg-primary-50 px-3 py-1 rounded-lg">Last 7 Days</button>
          </div>
          <div class="relative h-64 w-full">
            <canvas id="mainChart"></canvas>
          </div>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm">
          <h3 class="font-bold text-gray-900 mb-6">도서 카테고리 분포</h3>
          <div class="relative h-48 w-full flex justify-center">
            <canvas id="doughnutChart"></canvas>
          </div>
          <div class="mt-6 space-y-2">
            <div class="flex justify-between text-xs">
              <span class="flex items-center gap-2"><span class="w-2 h-2 rounded-full bg-blue-500"></span>IT/개발</span>
              <span class="font-bold">45%</span>
            </div>
            <div class="flex justify-between text-xs">
              <span class="flex items-center gap-2"><span class="w-2 h-2 rounded-full bg-emerald-400"></span>경제/경영</span>
              <span class="font-bold">30%</span>
            </div>
            <div class="flex justify-between text-xs">
              <span class="flex items-center gap-2"><span class="w-2 h-2 rounded-full bg-purple-400"></span>자기계발</span>
              <span class="font-bold">25%</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div id="view-users" class="view-section hidden animate-[fadeIn_0.3s_ease-out]">
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
          <div>
            <h3 class="font-bold text-lg text-gray-900">회원 관리</h3>
            <p class="text-xs text-gray-500">플랫폼 전체 회원 목록 및 상태 관리</p>
          </div>
          <div class="flex gap-2">
            <button class="px-4 py-2 bg-white border border-gray-200 rounded-lg text-xs font-bold text-gray-600 hover:bg-gray-50 shadow-sm">필터</button>
            <button class="px-4 py-2 bg-primary-600 text-white rounded-lg text-xs font-bold hover:bg-primary-700 shadow-sm shadow-primary-200">엑셀 다운로드</button>
          </div>
        </div>
        <table class="w-full">
          <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
          <tr>
            <th class="px-6 py-4 text-left">회원 정보</th>
            <th class="px-6 py-4 text-left">상태</th>
            <th class="px-6 py-4 text-left">권한</th>
            <th class="px-6 py-4 text-left">가입일</th>
            <th class="px-6 py-4 text-right">관리</th>
          </tr>
          </thead>
          <tbody class="divide-y divide-gray-50">
          <tr class="hover:bg-gray-50/50 transition-colors">
            <td class="px-6 py-4">
              <div class="flex items-center gap-3">
                <div class="w-9 h-9 rounded-full bg-gradient-to-tr from-blue-100 to-blue-50 flex items-center justify-center font-bold text-primary-600 border border-blue-100">K</div>
                <div>
                  <p class="text-sm font-bold text-gray-900">kim_dev</p>
                  <p class="text-[11px] text-gray-400">dev@test.com</p>
                </div>
              </div>
            </td>
            <td class="px-6 py-4">
                                    <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-[10px] font-bold bg-emerald-50 text-emerald-600 border border-emerald-100">
                                        <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span> Active
                                    </span>
            </td>
            <td class="px-6 py-4"><span class="text-xs font-medium text-gray-500 bg-gray-100 px-2 py-1 rounded">USER</span></td>
            <td class="px-6 py-4 text-xs text-gray-500 font-mono">2024.03.15</td>
            <td class="px-6 py-4 text-right">
              <button class="text-gray-400 hover:text-gray-600 p-1"><i data-lucide="more-horizontal" class="w-4 h-4"></i></button>
            </td>
          </tr>
          <tr class="hover:bg-gray-50/50 transition-colors bg-red-50/10">
            <td class="px-6 py-4">
              <div class="flex items-center gap-3">
                <div class="w-9 h-9 rounded-full bg-red-50 flex items-center justify-center font-bold text-red-600 border border-red-100">B</div>
                <div>
                  <p class="text-sm font-bold text-gray-900">bad_user</p>
                  <p class="text-[11px] text-gray-400">spam@mail.com</p>
                </div>
              </div>
            </td>
            <td class="px-6 py-4">
                                    <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-[10px] font-bold bg-red-50 text-red-600 border border-red-100">
                                        <span class="w-1.5 h-1.5 rounded-full bg-red-500"></span> Banned
                                    </span>
            </td>
            <td class="px-6 py-4"><span class="text-xs font-medium text-gray-500 bg-gray-100 px-2 py-1 rounded">USER</span></td>
            <td class="px-6 py-4 text-xs text-gray-500 font-mono">2024.01.10</td>
            <td class="px-6 py-4 text-right">
              <button class="text-gray-400 hover:text-gray-600 p-1"><i data-lucide="more-horizontal" class="w-4 h-4"></i></button>
            </td>
          </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div id="view-books" class="view-section hidden animate-[fadeIn_0.3s_ease-out]">
      <div class="bg-white rounded-2xl border border-gray-200 p-10 text-center">
        <div class="w-16 h-16 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-4 text-gray-300">
          <i data-lucide="shopping-bag" class="w-8 h-8"></i>
        </div>
        <h3 class="text-lg font-bold text-gray-900">상품 관리 화면</h3>
        <p class="text-gray-500 text-sm mt-1">이곳에 상품 리스트와 관리 기능이 표시됩니다.</p>
      </div>
    </div>

  </div>
</main>
</div>

<script>
  // 1. 아이콘 로드
  lucide.createIcons();

  // 2. 뷰 전환 로직
  function switchView(viewName, btn) {
    // 메뉴 활성화 스타일 변경
    document.querySelectorAll('.nav-item').forEach(el => {
      el.classList.remove('bg-primary-50', 'text-primary-700');
      el.classList.add('text-gray-600', 'hover:bg-gray-50', 'hover:text-gray-900');
    });
    btn.classList.remove('text-gray-600', 'hover:bg-gray-50', 'hover:text-gray-900');
    btn.classList.add('bg-primary-50', 'text-primary-700');

    // 컨텐츠 전환
    document.querySelectorAll('.view-section').forEach(el => el.classList.add('hidden'));

    // 해당 뷰가 존재하면 보여주고, 없으면 대시보드(기본값) 혹은 빈화면 처리
    const targetView = document.getElementById('view-' + viewName);
    if(targetView) {
      targetView.classList.remove('hidden');
    }

    // 헤더 타이틀 변경
    const titleMap = {
      'dashboard': 'Dashboard',
      'users': 'User Management',
      'books': 'Product Management',
      'groups': 'Group Management',
      'notices': 'Notices',
      'logs': 'System Logs'
    };
    document.getElementById('page-title').innerText = titleMap[viewName] || 'Dashboard';
  }

  // 3. 차트 초기화 (Mock Data)
  const ctxMain = document.getElementById('mainChart').getContext('2d');
  const mainChart = new Chart(ctxMain, {
    type: 'line',
    data: {
      labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      datasets: [{
        label: '신규 가입',
        data: [12, 19, 3, 5, 2, 3, 10],
        borderColor: '#3b82f6', // primary-500
        backgroundColor: 'rgba(59, 130, 246, 0.1)',
        tension: 0.4,
        fill: true
      }, {
        label: '거래 완료',
        data: [8, 12, 6, 9, 12, 15, 20],
        borderColor: '#10b981', // emerald-500
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
</script>

</body>
</html>