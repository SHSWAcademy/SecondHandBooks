<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
          fontFamily: {
            sans: ['Noto Sans KR', 'sans-serif'],
          }
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
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
          <h3 class="font-bold text-lg text-gray-900">회원 관리 (최근 가입순)</h3>
        </div>
        <table class="w-full">
          <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
          <tr><th class="px-6 py-4 text-left">회원 정보</th><th class="px-6 py-4 text-left">상태</th><th class="px-6 py-4 text-left">가입일</th><th class="px-6 py-4 text-right">관리</th></tr>
          </thead>
          <tbody class="divide-y divide-gray-50">
          <c:forEach var="m" items="${members}">
            <tr class="hover:bg-gray-50/50 transition-colors">
              <td class="px-6 py-4">
                <div class="flex items-center gap-3">
                  <div class="w-9 h-9 rounded-full bg-blue-50 flex items-center justify-center font-bold text-primary-600 border border-blue-100">${fn:substring(m.member_nicknm, 0, 1)}</div>
                  <div><p class="text-sm font-bold text-gray-900">${m.member_nicknm}</p><p class="text-[11px] text-gray-400">${m.member_email}</p></div>
                </div>
              </td>
              <td class="px-6 py-4">
                <c:choose>
                  <c:when test="${m.member_st == 'JOIN'}"><span class="inline-flex items-center px-2.5 py-1 rounded-md text-[10px] font-bold bg-emerald-50 text-emerald-600 border border-emerald-100">Active</span></c:when>
                  <c:otherwise><span class="inline-flex items-center px-2.5 py-1 rounded-md text-[10px] font-bold bg-gray-50 text-gray-600 border border-gray-100">Inactive</span></c:otherwise>
                </c:choose>
              </td>
              <td class="px-6 py-4 text-xs text-gray-500 font-mono">${fn:substring(m.crt_dtm, 0, 10)}</td>
              <td class="px-6 py-4 text-right"><button class="text-gray-400 hover:text-gray-600"><i data-lucide="more-horizontal" class="w-4 h-4"></i></button></td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>

    <div id="view-books" class="view-section hidden animate-[fadeIn_0.3s_ease-out]">
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <div class="p-6 border-b border-gray-100 bg-gray-50/50"><h3 class="font-bold text-lg text-gray-900">상품 관리 (최근 등록순)</h3></div>
        <table class="w-full">
          <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
          <tr><th class="px-6 py-4 text-left">상품명</th><th class="px-6 py-4 text-left">가격</th><th class="px-6 py-4 text-left">지역</th><th class="px-6 py-4 text-left">상태</th><th class="px-6 py-4 text-left">등록일</th></tr>
          </thead>
          <tbody class="divide-y divide-gray-50">
          <c:forEach var="t" items="${trades}">
            <tr class="hover:bg-gray-50/50 transition-colors">
              <td class="px-6 py-4"><p class="text-sm font-bold text-gray-900 w-64 truncate">${t.sale_title}</p><p class="text-[10px] text-gray-400">${t.book_title}</p></td>
              <td class="px-6 py-4 text-sm font-black text-primary-600"><fmt:formatNumber value="${t.sale_price}" pattern="#,###" />원</td>
              <td class="px-6 py-4 text-xs text-gray-500">${t.sale_rg}</td>
              <td class="px-6 py-4"><span class="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold ${t.sale_st == 'SALE' ? 'bg-green-50 text-green-600' : 'bg-gray-100 text-gray-500'}">${t.sale_st}</span></td>
              <td class="px-6 py-4 text-xs text-gray-500 font-mono">${fn:substring(t.crt_dtm, 0, 10)}</td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>

    <div id="view-groups" class="view-section hidden animate-[fadeIn_0.3s_ease-out]">
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <div class="p-6 border-b border-gray-100 bg-gray-50/50"><h3 class="font-bold text-lg text-gray-900">모임 관리 (최근 생성순)</h3></div>
        <table class="w-full">
          <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
          <tr><th class="px-6 py-4 text-left">모임명</th><th class="px-6 py-4 text-left">지역</th><th class="px-6 py-4 text-left">정원</th><th class="px-6 py-4 text-left">일정</th><th class="px-6 py-4 text-left">생성일</th></tr>
          </thead>
          <tbody class="divide-y divide-gray-50">
          <c:forEach var="g" items="${clubs}">
            <tr class="hover:bg-gray-50/50 transition-colors">
              <td class="px-6 py-4"><p class="text-sm font-bold text-gray-900">${g.book_club_name}</p></td>
              <td class="px-6 py-4 text-xs text-gray-500"><div class="flex items-center gap-1"><i data-lucide="map-pin" class="w-3 h-3"></i> ${g.book_club_rg}</div></td>
              <td class="px-6 py-4 text-xs font-bold text-primary-600">${g.book_club_max_member}명</td>
              <td class="px-6 py-4 text-xs text-gray-500">${g.book_club_schedule}</td>
              <td class="px-6 py-4 text-xs text-gray-500 font-mono">${fn:substring(g.crt_dtm, 0, 10)}</td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</main>

<div id="tetris-modal" class="hidden fixed inset-0 z-50 bg-indigo-950/60 backdrop-blur-sm flex items-center justify-center animate-[fadeIn_0.3s_ease-out]">
  <div class="bg-white p-2 rounded-[2rem] shadow-2xl relative overflow-hidden max-w-sm w-full mx-4 border border-blue-100">
    <div class="bg-gradient-to-r from-blue-600 to-indigo-700 p-6 rounded-t-[1.6rem] text-center relative overflow-hidden shadow-md">
      <div class="absolute -right-4 -top-4 w-24 h-24 bg-white/10 rounded-full blur-xl"></div>
      <div class="absolute -left-4 -bottom-4 w-20 h-20 bg-yellow-400/20 rounded-full blur-lg"></div>

      <h2 class="text-2xl font-black text-white tracking-widest relative z-10 drop-shadow-md">S-TETRIS</h2>
      <p class="text-blue-100 text-[10px] mt-1 font-medium relative z-10 uppercase tracking-widest">Admin Lounge</p>

      <button onclick="closeTetris()" class="absolute top-4 right-4 text-white/70 hover:text-white transition z-20 hover:rotate-90 duration-300">
        <i data-lucide="x" class="w-6 h-6"></i>
      </button>
    </div>

    <div class="p-6 bg-slate-50 rounded-b-[1.6rem]">
      <div class="relative border-[6px] border-blue-50 rounded-2xl bg-slate-900 shadow-inner overflow-hidden mx-auto w-fit">
        <canvas id="tetris" width="240" height="400" class="block opacity-95"></canvas>

        <div class="absolute top-3 right-3 bg-blue-600/90 backdrop-blur-md px-3 py-1.5 rounded-lg border border-blue-400/30 shadow-lg">
          <p class="text-[9px] text-blue-100 font-bold uppercase tracking-wider text-right">S-Point</p>
          <p id="score" class="text-lg font-mono font-black text-yellow-300 text-right leading-none drop-shadow-sm">0</p>
        </div>
      </div>

      <div class="mt-6 flex justify-center gap-4 text-slate-400">
        <div class="flex flex-col items-center gap-1 group cursor-pointer active:scale-95 transition-transform" onclick="playerMove(-1)">
          <div class="w-10 h-10 rounded-full bg-white border border-slate-200 flex items-center justify-center shadow-[0_4px_0_0_rgba(203,213,225,1)] group-active:translate-y-1 group-active:shadow-none transition-all">
            <i data-lucide="arrow-left" class="w-5 h-5 text-blue-600"></i>
          </div>
        </div>
        <div class="flex flex-col items-center gap-1 mt-6 group cursor-pointer active:scale-95 transition-transform" onclick="playerDrop()">
          <div class="w-10 h-10 rounded-full bg-white border border-slate-200 flex items-center justify-center shadow-[0_4px_0_0_rgba(203,213,225,1)] group-active:translate-y-1 group-active:shadow-none transition-all">
            <i data-lucide="arrow-down" class="w-5 h-5 text-blue-600"></i>
          </div>
        </div>
        <div class="flex flex-col items-center gap-1 group cursor-pointer active:scale-95 transition-transform" onclick="playerRotate(1)">
          <div class="w-14 h-14 rounded-full bg-gradient-to-b from-blue-500 to-blue-600 border border-blue-700 flex items-center justify-center shadow-[0_4px_0_0_rgba(30,58,138,1)] group-active:translate-y-1 group-active:shadow-none transition-all">
            <i data-lucide="rotate-cw" class="w-7 h-7 text-white"></i>
          </div>
        </div>
        <div class="flex flex-col items-center gap-1 group cursor-pointer active:scale-95 transition-transform" onclick="playerMove(1)">
          <div class="w-10 h-10 rounded-full bg-white border border-slate-200 flex items-center justify-center shadow-[0_4px_0_0_rgba(203,213,225,1)] group-active:translate-y-1 group-active:shadow-none transition-all">
            <i data-lucide="arrow-right" class="w-5 h-5 text-blue-600"></i>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  // 1. Initialize Icons
  lucide.createIcons();

  // 2. View Switching Logic
  function switchView(viewName, btn) {
    document.querySelectorAll('.nav-item').forEach(el => {
      el.classList.remove('bg-primary-50', 'text-primary-700');
      el.classList.add('text-gray-600', 'hover:bg-gray-50', 'hover:text-gray-900');
    });
    btn.classList.remove('text-gray-600', 'hover:bg-gray-50', 'hover:text-gray-900');
    btn.classList.add('bg-primary-50', 'text-primary-700');

    document.querySelectorAll('.view-section').forEach(el => el.classList.add('hidden'));
    const target = document.getElementById('view-' + viewName);
    if(target) target.classList.remove('hidden');

    const titleMap = {
      'dashboard': 'Dashboard', 'users': 'User Management', 'books': 'Product Management', 'groups': 'Group Management'
    };
    document.getElementById('page-title').innerText = titleMap[viewName] || 'Dashboard';
  }

  // 3. Charts (Mock Data)
  try {
    const ctxMain = document.getElementById('mainChart').getContext('2d');
    new Chart(ctxMain, {
      type: 'line',
      data: {
        labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        datasets: [{
          label: '신규 가입', data: [12, 19, 3, 5, 2, 3, 10], borderColor: '#0046FF', backgroundColor: 'rgba(0, 70, 255, 0.1)', tension: 0.4, fill: true
        }]
      },
      options: { responsive: true, maintainAspectRatio: false }
    });

    const ctxDoughnut = document.getElementById('doughnutChart').getContext('2d');
    new Chart(ctxDoughnut, {
      type: 'doughnut',
      data: {
        labels: ['IT', '경제', '기타'],
        datasets: [{ data: [45, 30, 25], backgroundColor: ['#0046FF', '#D4AF37', '#EBF5FF'], borderWidth: 0 }]
      },
      options: { responsive: true, maintainAspectRatio: false, cutout: '75%', plugins: { legend: { display: false } } }
    });
  } catch(e) {}

  // ==========================================
  // TETRIS GAME ENGINE (Shinhan Theme)
  // ==========================================
  const canvas = document.getElementById('tetris');
  const context = canvas.getContext('2d');
  context.scale(20, 20);

  // Shinhan Brand Colors for Tetrominos
  const colors = [
    null,
    '#0046FF', // Shinhan Blue (T)
    '#5784FF', // Light Blue (J)
    '#D4AF37', // Gold (L)
    '#F2B705', // Bright Yellow (O)
    '#6E85B2', // Warm Grey-Blue (S)
    '#A0B1CC', // Silver (Z)
    '#FFFFFF', // White (I) - will pop on dark bg
  ];

  function createPiece(type) {
    if (type === 'I') return [[0,1,0,0],[0,1,0,0],[0,1,0,0],[0,1,0,0]];
    if (type === 'L') return [[0,2,0],[0,2,0],[0,2,2]];
    if (type === 'J') return [[0,3,0],[0,3,0],[3,3,0]];
    if (type === 'O') return [[4,4],[4,4]];
    if (type === 'Z') return [[5,5,0],[0,5,5],[0,0,0]];
    if (type === 'S') return [[0,6,6],[6,6,0],[0,0,0]];
    if (type === 'T') return [[0,7,0],[7,7,7],[0,0,0]];
  }

  function arenaSweep() {
    let rowCount = 1;
    outer: for (let y = arena.length - 1; y > 0; --y) {
      for (let x = 0; x < arena[y].length; ++x) {
        if (arena[y][x] === 0) continue outer;
      }
      const row = arena.splice(y, 1)[0].fill(0);
      arena.unshift(row);
      ++y;
      player.score += rowCount * 10;
      rowCount *= 2;
    }
  }

  function collide(arena, player) {
    const [m, o] = [player.matrix, player.pos];
    for (let y = 0; y < m.length; ++y) {
      for (let x = 0; x < m[y].length; ++x) {
        if (m[y][x] !== 0 && (arena[y + o.y] && arena[y + o.y][x + o.x]) !== 0) return true;
      }
    }
    return false;
  }

  function createMatrix(w, h) {
    const matrix = [];
    while (h--) matrix.push(new Array(w).fill(0));
    return matrix;
  }

  function draw() {
    // Dark Blue Background for Game
    context.fillStyle = '#0f172a';
    context.fillRect(0, 0, canvas.width, canvas.height);
    drawMatrix(arena, {x: 0, y: 0});
    drawMatrix(player.matrix, player.pos);
  }

  function drawMatrix(matrix, offset) {
    matrix.forEach((row, y) => {
      row.forEach((value, x) => {
        if (value !== 0) {
          context.fillStyle = colors[value];
          context.fillRect(x + offset.x, y + offset.y, 1, 1);
          // Add subtle inner border for block effect
          context.lineWidth = 0.05;
          context.strokeStyle = 'rgba(0,0,0,0.3)';
          context.strokeRect(x + offset.x, y + offset.y, 1, 1);
        }
      });
    });
  }

  function merge(arena, player) {
    player.matrix.forEach((row, y) => {
      row.forEach((value, x) => {
        if (value !== 0) arena[y + player.pos.y][x + player.pos.x] = value;
      });
    });
  }

  function rotate(matrix, dir) {
    for (let y = 0; y < matrix.length; ++y) {
      for (let x = 0; x < y; ++x) [matrix[x][y], matrix[y][x]] = [matrix[y][x], matrix[x][y]];
    }
    if (dir > 0) matrix.forEach(row => row.reverse());
    else matrix.reverse();
  }

  function playerDrop() {
    player.pos.y++;
    if (collide(arena, player)) {
      player.pos.y--;
      merge(arena, player);
      playerReset();
      arenaSweep();
      updateScore();
    }
    dropCounter = 0;
  }

  function playerMove(offset) {
    player.pos.x += offset;
    if (collide(arena, player)) player.pos.x -= offset;
  }

  function playerReset() {
    const pieces = 'ILJOTSZ';
    player.matrix = createPiece(pieces[pieces.length * Math.random() | 0]);
    player.pos.y = 0;
    player.pos.x = (arena[0].length / 2 | 0) - (player.matrix[0].length / 2 | 0);
    if (collide(arena, player)) {
      arena.forEach(row => row.fill(0));
      player.score = 0;
      updateScore();
    }
  }

  function playerRotate(dir) {
    const pos = player.pos.x;
    let offset = 1;
    rotate(player.matrix, dir);
    while (collide(arena, player)) {
      player.pos.x += offset;
      offset = -(offset + (offset > 0 ? 1 : -1));
      if (offset > player.matrix[0].length) {
        rotate(player.matrix, -dir);
        player.pos.x = pos;
        return;
      }
    }
  }

  let dropCounter = 0;
  let dropInterval = 1000;
  let lastTime = 0;
  let isPaused = true;

  function update(time = 0) {
    if (isPaused) return;
    const deltaTime = time - lastTime;
    lastTime = time;
    dropCounter += deltaTime;
    if (dropCounter > dropInterval) playerDrop();
    draw();
    requestAnimationFrame(update);
  }

  function updateScore() {
    document.getElementById('score').innerText = player.score;
  }

  const arena = createMatrix(12, 20);
  const player = { pos: {x: 0, y: 0}, matrix: null, score: 0 };

  // Konami Code Listener
  const konamiCode = ['ArrowUp', 'ArrowUp', 'ArrowDown', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'ArrowLeft', 'ArrowRight', 'b', 'a'];
  let konamiCursor = 0;

  document.addEventListener('keydown', (e) => {
    if (e.key === konamiCode[konamiCursor]) konamiCursor++;
    else konamiCursor = 0;

    if (konamiCursor === konamiCode.length) {
      startTetris();
      konamiCursor = 0;
    }

    if (!isPaused) {
      if (e.key === 'ArrowLeft') playerMove(-1);
      else if (e.key === 'ArrowRight') playerMove(1);
      else if (e.key === 'ArrowDown') playerDrop();
      else if (e.key === 'ArrowUp') playerRotate(1);
    }
  });

  function startTetris() {
    document.getElementById('tetris-modal').classList.remove('hidden');
    playerReset();
    updateScore();
    isPaused = false;
    update();
  }

  function closeTetris() {
    document.getElementById('tetris-modal').classList.add('hidden');
    isPaused = true;
  }
</script>

</body>
</html>