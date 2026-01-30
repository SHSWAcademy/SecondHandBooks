<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SecondHand Books</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Pretendard', 'sans-serif'] },
                    colors: {
                        primary: { 50: '#eef4ff', 100: '#d9e6ff', 500: '#0046FF', 600: '#0036cc', 700: '#002ba3', 900: '#00206b' },
                        gray: { 50: '#f8f9fa', 100: '#f1f3f5', 800: '#343a40', 900: '#212529' }
                    },
                    boxShadow: {
                        'soft': '0 4px 20px -2px rgba(0, 0, 0, 0.05)',
                        'glow': '0 0 15px rgba(0, 70, 255, 0.15)'
                    }
                }
            }
        }

        function redirectToLogin() {
            var currentUrl = window.location.pathname + window.location.search;
            var boardTab = document.querySelector('.bc-tab-link[data-tab="board"].active');
            if (boardTab && currentUrl.indexOf('tab=board') === -1) {
                currentUrl += (currentUrl.indexOf('?') === -1 ? '?' : '&') + 'tab=board';
            }
            window.location.href = '/login?redirect=' + encodeURIComponent(currentUrl);
        }
    </script>
    <style>
        .glass-header {
            background-color: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border-bottom: 1px solid rgba(229, 231, 235, 0.6);
        }
        body { -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }
    </style>
</head>
<body class="bg-[#F8F9FA] text-gray-900 font-sans antialiased">

<c:choose>
    <%-- [1] 관리자 헤더 --%>
    <c:when test="${not empty sessionScope.adminSess}">
        <header class="bg-gray-900 border-b border-gray-800 sticky top-0 z-50 shadow-md">
            <div class="max-w-7xl mx-auto px-6 h-[72px] flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <span class="text-xl font-black text-white tracking-tight">Admin<span class="text-primary-500">View</span></span>
                    <span class="px-2 py-0.5 bg-gray-800 border border-gray-700 rounded text-[10px] font-bold text-gray-400 uppercase tracking-wider">Management Mode</span>
                </div>
                <div class="flex items-center gap-4">
                    <span class="text-sm text-gray-400"><span class="text-white font-bold">${sessionScope.adminSess.admin_login_id}</span> 관리자님</span>
                    <a href="/admin" class="flex items-center gap-2 px-4 py-2 bg-primary-600 text-white rounded-lg text-sm font-bold hover:bg-primary-700 transition shadow-glow">
                        <i data-lucide="layout-dashboard" class="w-4 h-4"></i> 관리자 홈
                    </a>
                </div>
            </div>
        </header>
    </c:when>

    <%-- [2] 일반 사용자 헤더 --%>
    <c:otherwise>
        <header class="glass-header sticky top-0 z-50 transition-all duration-300">
            <div class="max-w-7xl mx-auto px-6 h-[72px] flex items-center justify-between">

                <div class="flex items-center gap-2 cursor-pointer mr-10 group" onclick="location.href='/home'">
                    <div class="flex flex-col leading-none">
                        <span class="text-[10px] font-bold text-primary-500 tracking-widest mb-0.5 ml-0.5 opacity-80 group-hover:opacity-100 transition-opacity">PREMIUM</span>
                        <span class="text-2xl font-black text-gray-900 tracking-tighter group-hover:text-primary-600 transition-colors">
                            Shinhan<span class="text-primary-600 group-hover:text-gray-900 transition-colors">Books</span>
                        </span>
                    </div>
                </div>

                <nav class="flex items-center gap-2 ml-auto">
                    <a href="/bookclubs" class="px-4 py-2 rounded-full text-sm font-bold text-gray-600 hover:text-gray-900 hover:bg-gray-100/80 transition-all">독서모임</a>
                    <a href="/trade" class="px-4 py-2 rounded-full text-sm font-bold text-gray-600 hover:text-gray-900 hover:bg-gray-100/80 transition-all">판매하기</a>

                    <div class="h-5 w-px bg-gray-200 mx-3"></div>

                    <c:choose>
                        <c:when test="${not empty sessionScope.loginSess}">
                            <div class="flex items-center gap-2">
                                <a href="/notice" class="p-2.5 rounded-full text-gray-500 hover:text-gray-900 hover:bg-gray-100/80 transition-all relative group" title="공지사항">
                                    <i data-lucide="bell" class="w-5 h-5 group-hover:scale-110 transition-transform"></i>
                                </a>
                                <a href="/chatrooms" class="p-2.5 rounded-full text-gray-500 hover:text-gray-900 hover:bg-gray-100/80 transition-all relative group" title="채팅">
                                    <i data-lucide="message-circle" class="w-5 h-5 group-hover:scale-110 transition-transform"></i>
                                    <c:if test="${messageSign}">
                                        <span class="absolute top-2 right-2 w-2.5 h-2.5 bg-red-500 rounded-full border-2 border-white animate-pulse"></span>
                                    </c:if>
                                </a>
                                <a href="/mypage" class="flex items-center gap-2 pl-1.5 pr-3 py-1.5 rounded-full border border-gray-200 bg-white hover:border-gray-300 hover:shadow-soft transition-all ml-2 group">
                                    <div class="w-8 h-8 bg-gradient-to-br from-primary-500 to-primary-700 text-white rounded-full flex items-center justify-center font-bold text-sm shadow-sm group-hover:scale-105 transition-transform">
                                            ${sessionScope.loginSess.member_nicknm.substring(0, 1)}
                                    </div>
                                    <span class="text-sm font-bold text-gray-700 group-hover:text-gray-900 transition-colors hidden lg:block pr-1">${sessionScope.loginSess.member_nicknm}</span>
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="/login" class="px-6 py-2.5 bg-gray-900 hover:bg-black text-white rounded-full text-sm font-bold transition-all shadow-md hover:shadow-lg hover:-translate-y-0.5 flex items-center gap-2">
                                <span>로그인</span>
                                <i data-lucide="arrow-right" class="w-3.5 h-3.5 opacity-70"></i>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </nav>
            </div>
        </header>
    </c:otherwise>
</c:choose>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        if (window.lucide) {
            lucide.createIcons();
        }
    });
</script>

<main class="flex-1 max-w-7xl mx-auto w-full px-6 py-12 min-h-[calc(100vh-200px)]">

<c:if test="${not empty loginSess}">
    <script>
        (function() {
            const RELOAD_KEY = 'member_page_unload_time';
            const RELOAD_THRESHOLD = 3000;

            document.addEventListener('DOMContentLoaded', function() {
                const unloadTime = sessionStorage.getItem(RELOAD_KEY);
                if (unloadTime) {
                    const timeDiff = Date.now() - parseInt(unloadTime, 10);
                    if (timeDiff < RELOAD_THRESHOLD) {
                        fetch('/api/member/cancel-logout', {
                            method: 'POST',
                            credentials: 'same-origin'
                        }).catch(function(err) {
                            console.error('로그아웃 취소 실패:', err);
                        });
                    }
                    sessionStorage.removeItem(RELOAD_KEY);
                }
            });

            window.addEventListener('pagehide', function(event) {
                sessionStorage.setItem(RELOAD_KEY, Date.now().toString());
                navigator.sendBeacon('/api/member/logout-pending');
            });
        })();
    </script>
</c:if>