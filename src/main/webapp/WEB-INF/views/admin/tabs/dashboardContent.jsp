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
    // [변경] $.ajax -> fetch API 사용 (jQuery 의존성 제거)
    async function loadCharts() {
        try {
            const response = await fetch('/admin/api/stats');
            if (!response.ok) throw new Error('Network response was not ok');
            const res = await response.json();

            renderMainChart(res.dailySignups, res.dailyTrades);
            renderDoughnutChart(res.categories);
        } catch (err) {
            console.error("Chart load failed", err);
        }
    }

    function renderMainChart(signups, trades) {
        const ctx = document.getElementById('mainChart').getContext('2d');
        // 날짜 라벨 처리 (데이터가 없을 경우 대비)
        const labels = signups && signups.length > 0 ? signups.map(d => d.date) : [];
        const signupData = signups ? signups.map(d => d.count) : [];
        const tradeData = trades ? trades.map(d => d.count) : [];

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: '신규 가입',
                        data: signupData,
                        borderColor: '#3b82f6',
                        backgroundColor: 'rgba(59, 130, 246, 0.1)',
                        fill: true,
                        tension: 0.4
                    },
                    {
                        label: '상품 등록',
                        data: tradeData,
                        borderColor: '#10b981',
                        borderDash: [5, 5],
                        fill: false,
                        tension: 0.4
                    }
                ]
            },
            options: { responsive: true, maintainAspectRatio: false }
        });
    }

    function renderDoughnutChart(categories) {
        const ctx = document.getElementById('doughnutChart').getContext('2d');

        const labels = categories ? categories.map(c => c.name) : [];
        const data = categories ? categories.map(c => c.count) : [];

        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: data,
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
    }

    // [변경] $(document).ready -> DOMContentLoaded 이벤트 사용
    document.addEventListener("DOMContentLoaded", function() {
        loadCharts();
    });
</script>