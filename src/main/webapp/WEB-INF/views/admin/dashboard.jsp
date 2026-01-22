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
            primary: { 50: '#eff6ff', 100: '#dbeafe', 500: '#3b82f6', 600: '#0046FF', 700: '#1d4ed8', 900: '#1e3a8a' },
            shinhan: { blue: '#0046FF', gold: '#D4AF37', sky: '#EBF5FF' }
          },
          fontFamily: { sans: ['Noto Sans KR', 'sans-serif'] }
        }
      }
    }
  </script>
  <script src="https://unpkg.com/lucide@latest"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
</head>
<body class="bg-gray-50 h-screen flex overflow-hidden text-gray-800 font-sans">

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
    <button onclick="switchView('users', this)" class="nav-item w-full flex items-center gap-3 px-4 py-3 text-sm font-medium text-gray-600 rounded-xl hover:bg-gray-50 hover:text-gray-900 transition-all"><i data-lucide="users" class="w-5 h-5"></i> 회원 관리</button>
    <button onclick="switchView('books', this)" class="nav-item w-full flex items-center gap-3 px-4 py-3 text-sm font-medium text-gray-600 rounded-xl hover:bg-gray-50 hover:text-gray-900 transition-all"><i data-lucide="shopping-bag" class="w-5 h-5"></i> 상품 관리</button>
    <button onclick="switchView('groups', this)" class="nav-item w-full flex items-center gap-3 px-4 py-3 text-sm font-medium text-gray-600 rounded-xl hover:bg-gray-50 hover:text-gray-900 transition-all"><i data-lucide="book-open" class="w-5 h-5"></i> 모임 관리</button>
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
      <span class="font-medium text-gray-400">Console</span> <i data-lucide="chevron-right" class="w-4 h-4"></i> <span id="page-title" class="font-bold text-gray-900">Dashboard</span>
    </div>
  </header>

  <div class="p-8 max-w-7xl mx-auto space-y-8">

    <div id="view-dashboard" class="view-section animate-[fadeIn_0.3s_ease-out]">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm relative overflow-hidden group">
          <div class="absolute right-0 top-0 w-24 h-24 bg-primary-50 rounded-bl-full -mr-4 -mt-4 transition-transform group-hover:scale-110"></div>
          <div class="relative z-10">
            <p class="text-gray-500 text-xs font-bold uppercase mb-1">Total Users</p>
            <h3 class="text-3xl font-black text-gray-900 mb-2"><fmt:formatNumber value="${memberCount}" pattern="#,###" /></h3>
            <div class="flex items-center gap-1 text-xs font-bold text-emerald-500"><i data-lucide="users" class="w-3 h-3"></i> 전체 회원</div>
          </div>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm relative overflow-hidden group">
          <div class="absolute right-0 top-0 w-24 h-24 bg-purple-50 rounded-bl-full -mr-4 -mt-4 transition-transform group-hover:scale-110"></div>
          <div class="relative z-10">
            <p class="text-gray-500 text-xs font-bold uppercase mb-1">Active Trades</p>
            <h3 class="text-3xl font-black text-gray-900 mb-2"><fmt:formatNumber value="${tradeCount}" pattern="#,###" /></h3>
            <div class="flex items-center gap-1 text-xs font-bold text-emerald-500"><i data-lucide="book" class="w-3 h-3"></i> 등록된 상품</div>
          </div>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm relative overflow-hidden group">
          <div class="absolute right-0 top-0 w-24 h-24 bg-orange-50 rounded-bl-full -mr-4 -mt-4 transition-transform group-hover:scale-110"></div>
          <div class="relative z-10">
            <p class="text-gray-500 text-xs font-bold uppercase mb-1">Total Groups</p>
            <h3 class="text-3xl font-black text-gray-900 mb-2"><fmt:formatNumber value="${clubCount}" pattern="#,###" /></h3>
            <div class="flex items-center gap-1 text-xs font-bold text-primary-600"><i data-lucide="users" class="w-3 h-3"></i> 운영 중인 모임</div>
          </div>
        </div>
      </div>
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm">
          <h3 class="font-bold text-gray-900 mb-4 text-sm">주간 가입 및 거래 추이</h3>
          <div class="h-64"><canvas id="mainChart"></canvas></div>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-sm">
          <h3 class="font-bold text-gray-900 mb-4 text-sm">카테고리별 거래 비중</h3>
          <div class="h-64 flex justify-center"><canvas id="doughnutChart"></canvas></div>
        </div>
      </div>
    </div>

    <div id="view-users" class="view-section hidden animate-[fadeIn_0.3s_ease-out]">
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden min-h-[600px]">
        <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
          <h3 class="font-bold text-lg text-gray-900">회원 관리</h3>
          <div class="flex gap-2">
            <select id="user-status" class="px-3 py-2 bg-white border border-gray-200 rounded-lg text-xs outline-none">
              <option value="ALL">전체 상태</option>
              <option value="JOIN">정상 (Active)</option>
              <option value="STOP">정지 (Banned)</option>
            </select>
            <input type="text" id="user-keyword" placeholder="닉네임/이메일 검색" class="px-3 py-2 bg-white border border-gray-200 rounded-lg text-xs outline-none w-48" onkeyup="if(event.key==='Enter') fetchUsers()">
            <button onclick="fetchUsers()" class="px-4 py-2 bg-primary-600 text-white rounded-lg text-xs font-bold hover:bg-primary-700">검색</button>
          </div>
        </div>
        <table class="w-full">
          <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
          <tr><th class="px-6 py-4 text-left">회원 정보</th><th class="px-6 py-4 text-left">상태</th><th class="px-6 py-4 text-left">가입일</th><th class="px-6 py-4 text-right">관리</th></tr>
          </thead>
          <tbody id="user-list" class="divide-y divide-gray-50"></tbody> </table>
      </div>
    </div>

    <div id="view-books" class="view-section hidden animate-[fadeIn_0.3s_ease-out]">
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden min-h-[600px]">
        <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
          <h3 class="font-bold text-lg text-gray-900">상품 관리</h3>
          <div class="flex gap-2">
            <select id="trade-status" class="px-3 py-2 bg-white border border-gray-200 rounded-lg text-xs outline-none">
              <option value="ALL">전체 상태</option>
              <option value="SALE">판매중</option>
              <option value="RESERVED">예약중</option>
              <option value="SOLD_OUT">판매완료</option>
            </select>
            <input type="text" id="trade-keyword" placeholder="상품명 검색" class="px-3 py-2 bg-white border border-gray-200 rounded-lg text-xs outline-none w-48" onkeyup="if(event.key==='Enter') fetchTrades()">
            <button onclick="fetchTrades()" class="px-4 py-2 bg-primary-600 text-white rounded-lg text-xs font-bold hover:bg-primary-700">검색</button>
          </div>
        </div>
        <table class="w-full">
          <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
          <tr><th class="px-6 py-4 text-left">상품명</th><th class="px-6 py-4 text-left">가격</th><th class="px-6 py-4 text-left">상태</th><th class="px-6 py-4 text-left">등록일</th><th class="px-6 py-4 text-right">관리</th></tr>
          </thead>
          <tbody id="trade-list" class="divide-y divide-gray-50"></tbody> </table>
      </div>
    </div>

    <div id="view-groups" class="view-section hidden animate-[fadeIn_0.3s_ease-out]">
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden min-h-[600px]">
        <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
          <h3 class="font-bold text-lg text-gray-900">모임 관리</h3>
          <div class="flex gap-2">
            <input type="text" id="group-keyword" placeholder="모임명 검색" class="px-3 py-2 bg-white border border-gray-200 rounded-lg text-xs outline-none w-48" onkeyup="if(event.key==='Enter') fetchGroups()">
            <button onclick="fetchGroups()" class="px-4 py-2 bg-primary-600 text-white rounded-lg text-xs font-bold hover:bg-primary-700">검색</button>
          </div>
        </div>
        <table class="w-full">
          <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
          <tr><th class="px-6 py-4 text-left">모임명</th><th class="px-6 py-4 text-left">지역</th><th class="px-6 py-4 text-left">정원</th><th class="px-6 py-4 text-left">일정</th><th class="px-6 py-4 text-right">관리</th></tr>
          </thead>
          <tbody id="group-list" class="divide-y divide-gray-50"></tbody> </table>
      </div>
    </div>

  </div>
</main>

<script>
  // 1. 아이콘 초기화
  lucide.createIcons();

  // 2. 초기 로딩 (차트 & 전체 탭 데이터 미리 로드)
  document.addEventListener("DOMContentLoaded", function() {
    loadCharts();
    fetchUsers();
    fetchTrades();
    fetchGroups();
  });

  // 3. 뷰 전환 로직
  function switchView(viewName, btn) {
    // 버튼 스타일 초기화 & 활성화
    document.querySelectorAll('.nav-item').forEach(el => {
      el.classList.remove('bg-primary-50', 'text-primary-700', 'font-bold');
      el.classList.add('text-gray-600', 'hover:bg-gray-50', 'hover:text-gray-900');
    });
    btn.classList.remove('text-gray-600', 'hover:bg-gray-50', 'hover:text-gray-900');
    btn.classList.add('bg-primary-50', 'text-primary-700', 'font-bold');

    // 컨텐츠 숨기기 & 보이기
    document.querySelectorAll('.view-section').forEach(el => el.classList.add('hidden'));
    document.getElementById('view-' + viewName).classList.remove('hidden');

    // 타이틀 변경
    const titleMap = {
      'dashboard': 'Dashboard',
      'users': 'User Management',
      'books': 'Product Management',
      'groups': 'Group Management'
    };
    document.getElementById('page-title').innerText = titleMap[viewName] || 'Dashboard';

    // 탭 전환 시 데이터 리프레시 (선택 사항)
    if (viewName === 'users') fetchUsers();
    if (viewName === 'books') fetchTrades();
    if (viewName === 'groups') fetchGroups();
  }

  // --- [1] USERS FETCH ---
  async function fetchUsers() {
    const status = document.getElementById('user-status').value;
    const keyword = document.getElementById('user-keyword').value;

    try {
      const res = await fetch(`/admin/api/users?status=\${status}&keyword=\${keyword}`);
      if(!res.ok) throw new Error('API Error');
      const data = await res.json();

      const tbody = document.getElementById('user-list');
      if(data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4" class="px-6 py-10 text-center text-gray-400">데이터가 없습니다.</td></tr>';
        return;
      }

      tbody.innerHTML = data.map(m => `
                <tr class="hover:bg-gray-50/50 transition-colors">
                    <td class="px-6 py-4">
                        <div class="flex items-center gap-3">
                            <div class="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center font-bold text-blue-600 text-xs">\${m.member_nicknm.charAt(0)}</div>
                            <div><p class="text-sm font-bold text-gray-900">\${m.member_nicknm}</p><p class="text-[10px] text-gray-400">\${m.member_email}</p></div>
                        </div>
                    </td>
                    <td class="px-6 py-4">
                        \${m.member_st === 'JOIN'
                            ? '<span class="px-2 py-1 rounded text-[10px] font-bold bg-green-50 text-green-600">Active</span>'
                            : '<span class="px-2 py-1 rounded text-[10px] font-bold bg-red-50 text-red-600">Banned</span>'}
                    </td>
                    <td class="px-6 py-4 text-xs text-gray-500 font-mono">\${m.crt_dtm ? m.crt_dtm.substring(0, 10) : '-'}</td>
                    <td class="px-6 py-4 text-right">
                        <select onchange="handleUserAction(this, \${m.member_seq})" class="text-xs border border-gray-200 rounded px-1 py-1 outline-none bg-white">
                            <option value="">관리</option>
                            <option value="ACTIVE">활성화</option>
                            <option value="BAN">정지</option>
                            <option value="DELETE">삭제</option>
                        </select>
                    </td>
                </tr>
            `).join('');
    } catch (e) { console.error(e); }
  }

  async function handleUserAction(select, seq) {
    const action = select.value;
    if(!action || !confirm('상태를 변경하시겠습니까?')) { select.value = ""; return; }

    await fetch('/admin/api/users', {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ seq, action })
    });
    fetchUsers();
  }

  // --- [2] TRADES FETCH ---
  async function fetchTrades() {
    const status = document.getElementById('trade-status').value;
    const keyword = document.getElementById('trade-keyword').value;

    try {
      const res = await fetch(`/admin/api/trades?status=\${status}&keyword=\${keyword}`);
      if(!res.ok) throw new Error('API Error');
      const data = await res.json();

      const tbody = document.getElementById('trade-list');
      if(data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5" class="px-6 py-10 text-center text-gray-400">데이터가 없습니다.</td></tr>';
        return;
      }

      tbody.innerHTML = data.map(t => `
                <tr class="hover:bg-gray-50/50">
                    <td class="px-6 py-4"><p class="text-sm font-bold text-gray-900 w-48 truncate">\${t.sale_title}</p></td>
                    <td class="px-6 py-4 text-sm font-bold text-blue-600">\${Number(t.sale_price).toLocaleString()}원</td>
                    <td class="px-6 py-4"><span class="px-2 py-1 rounded text-[10px] font-bold bg-gray-100 text-gray-600">\${t.sale_st}</span></td>
                    <td class="px-6 py-4 text-xs text-gray-500 font-mono">\${t.crt_dtm ? t.crt_dtm.substring(0, 10) : '-'}</td>
                    <td class="px-6 py-4 text-right">
                        <select onchange="handleTradeAction(this, \${t.trade_seq})" class="text-xs border border-gray-200 rounded px-1 py-1 outline-none bg-white">
                            <option value="">관리</option>
                            <option value="SALE">판매중</option>
                            <option value="SOLD_OUT">판매완료</option>
                            <option value="DELETE">삭제</option>
                        </select>
                    </td>
                </tr>
            `).join('');
    } catch (e) { console.error(e); }
  }

  async function handleTradeAction(select, seq) {
    const action = select.value;
    if(!action || !confirm('상태를 변경하시겠습니까?')) { select.value = ""; return; }

    await fetch('/admin/api/trades', {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ seq, action })
    });
    fetchTrades();
  }

  // --- [3] GROUPS FETCH ---
  async function fetchGroups() {
    const keyword = document.getElementById('group-keyword').value;

    try {
      const res = await fetch(`/admin/api/clubs?keyword=\${keyword}`);
      if(!res.ok) throw new Error('API Error');
      const data = await res.json();

      const tbody = document.getElementById('group-list');
      if(data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5" class="px-6 py-10 text-center text-gray-400">데이터가 없습니다.</td></tr>';
        return;
      }

      tbody.innerHTML = data.map(g => `
                <tr class="hover:bg-gray-50/50">
                    <td class="px-6 py-4"><p class="text-sm font-bold text-gray-900">\${g.bookClubName}</p></td>
                    <td class="px-6 py-4 text-xs text-gray-500">\${g.bookClubRg}</td>
                    <td class="px-6 py-4 text-xs font-bold text-blue-600">\${g.bookClubMaxMember}명</td>
                    <td class="px-6 py-4 text-xs text-gray-500">\${g.bookClubSchedule}</td>
                    <td class="px-6 py-4 text-right">
                        <button onclick="deleteGroup(\${g.bookClubSeq})" class="text-xs text-red-500 hover:bg-red-50 px-2 py-1 rounded font-bold">해산</button>
                    </td>
                </tr>
            `).join('');
    } catch (e) { console.error(e); }
  }

  async function deleteGroup(seq) {
    if(!confirm('모임을 정말 해산하시겠습니까? 복구할 수 없습니다.')) return;

    await fetch('/admin/api/clubs', {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ seq, action: 'DELETE' })
    });
    fetchGroups();
  }

  // --- [4] CHART LOAD ---
  async function loadCharts() {
    try {
      const response = await fetch('/admin/api/stats');
      if (!response.ok) return;
      const res = await response.json();

      // 데이터 매핑 (Null 체크)
      const labels = res.dailySignups ? res.dailySignups.map(d => d.date) : [];
      const signupData = res.dailySignups ? res.dailySignups.map(d => d.count) : [];
      const tradeData = res.dailyTrades ? res.dailyTrades.map(d => d.count) : [];

      const catLabels = res.categories ? res.categories.map(c => c.name) : [];
      const catData = res.categories ? res.categories.map(c => c.count) : [];

      // Line Chart
      const ctxMain = document.getElementById('mainChart').getContext('2d');
      new Chart(ctxMain, {
        type: 'line',
        data: {
          labels: labels,
          datasets: [
            { label: '신규 가입', data: signupData, borderColor: '#3b82f6', backgroundColor: 'rgba(59, 130, 246, 0.1)', fill: true, tension: 0.4 },
            { label: '상품 등록', data: tradeData, borderColor: '#10b981', borderDash: [5, 5], fill: false, tension: 0.4 }
          ]
        },
        options: { responsive: true, maintainAspectRatio: false }
      });

      // Doughnut Chart
      const ctxDoughnut = document.getElementById('doughnutChart').getContext('2d');
      new Chart(ctxDoughnut, {
        type: 'doughnut',
        data: {
          labels: catLabels,
          datasets: [{
            data: catData,
            backgroundColor: ['#3b82f6', '#34d399', '#f59e0b', '#ef4444', '#a78bfa'],
            borderWidth: 0
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { position: 'right' } },
          cutout: '70%'
        }
      });
    } catch (err) { console.error("Chart load failed", err); }
  }
</script>

</body>
</html>