<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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

<script>
  // Charts (Mock Data)
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
</script>