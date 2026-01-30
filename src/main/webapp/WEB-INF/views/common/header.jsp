<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Secondary Books</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
          /**
           * 로그인 페이지로 리다이렉트 (현재 URL을 redirect 파라미터로 전달)
           * - 로그인 후 원래 페이지로 돌아오기 위함
           * - 독서모임 상세 페이지에서 게시판 탭이 활성화된 경우 ?tab=board 추가
           */
          function redirectToLogin() {
            var currentUrl = window.location.pathname + window.location.search;

            // 독서모임 상세 페이지에서 게시판 탭이 활성화된 경우 ?tab=board 추가
            var boardTab = document.querySelector('.bc-tab-link[data-tab="board"].active');
            if (boardTab && currentUrl.indexOf('tab=board') === -1) {
                if (currentUrl.indexOf('?') === -1) {
                    currentUrl += '?tab=board';
                } else {
                    currentUrl += '&tab=board';
                }
            }

            var loginUrl = '/login?redirect=' + encodeURIComponent(currentUrl);
            window.location.href = loginUrl;
          }
        </script>
        <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Pretendard', 'sans-serif'] },
                    colors: {
                        primary: { 50: '#eef4ff', 100: '#d9e6ff', 500: '#0046FF', 600: '#0036cc', 700: '#002ba3', 900: '#00206b' },
                        gray: { 50: '#f8f9fa', 100: '#f1f3f5', 800: '#343a40', 900: '#212529' }
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-[#F8F9FA] text-gray-900 font-sans antialiased">


    <%-- [2] 일반 회원/비회원 헤더 (기존 코드 유지) --%>
<header class="bg-white border-b border-gray-200 sticky top-0 z-50 shadow-[0_1px_3px_rgba(0,0,0,0.05)]">
    <div class="max-w-7xl mx-auto px-6 h-[72px] flex items-center justify-between">
        <div class="flex items-center gap-2 cursor-pointer mr-10" onclick="location.href='/home'">
            <div class="flex flex-col leading-none">
                <span class="text-[10px] font-bold text-primary-500 tracking-widest mb-0.5">PREMIUM</span>
                <span class="text-2xl font-black text-primary-600 tracking-tighter">Secondary<span class="text-gray-800 font-bold ml-1">Books</span></span>
            </div>
        </div>

        <nav class="flex items-center gap-4 ml-8">
            <a href="/bookclubs" class="px-3 py-2 text-sm font-bold hover:text-primary-600 transition-colors text-gray-600">독서모임</a>
            <a href="/trade" class="px-3 py-2 text-sm font-bold hover:text-primary-600 transition-colors text-gray-600">판매하기</a>

            <div class="h-4 w-px bg-gray-300 mx-2"></div>

            <c:choose>
            <c:when test="${not empty adminSess}">
                    <span class="badge">ADMIN</span> ${adminSess.admin_login_id}님 환영합니다.
                </c:when>
                <c:when test="${not empty sessionScope.loginSess}">
                    <div class="flex items-center gap-3">
                        <a href="/notice" class="relative p-2 transition hover:text-primary-600 text-gray-600" title="공지사항">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                               <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                               <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                            </svg>
                        </a>
                        <a href="/chatrooms" class="relative p-2 transition hover:text-primary-600 text-gray-600" title="채팅">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                            <c:if test="${messageSign}">
                                <span class="absolute top-1 right-1 w-2.5 h-2.5 bg-red-500 rounded-full"></span>
                            </c:if>
                        </a>
                        <a href="/mypage" class="flex items-center gap-2 text-sm font-medium text-gray-700 hover:text-gray-900 group ml-1">
                            <div class="w-9 h-9 bg-primary-50 text-primary-600 rounded-full border border-primary-100 flex items-center justify-center font-bold text-sm overflow-hidden group-hover:bg-primary-100 transition">
                                    ${sessionScope.loginSess.member_nicknm.substring(0, 1)}
                            </div>
                            <span class="font-bold hidden lg:block">${sessionScope.loginSess.member_nicknm}님</span>
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="/login" class="px-5 py-2.5 bg-primary-500 hover:bg-primary-600 text-white rounded-md text-sm font-bold transition-all shadow-sm hover:shadow-md">로그인</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>
</header>


<main class="flex-1 max-w-7xl mx-auto w-full px-6 py-10">

<c:if test="${not empty sessionScope.adminSess or not empty sessionScope.loginSess}">
  <script>
  (function() {
      // 1. 페이지 로드 시: 관리자든 회원이든 일단 펜딩된 로그아웃을 취소함
      document.addEventListener('DOMContentLoaded', function() {
          // 관리자 세션이 있을 때는 관리자용 취소 API 호출
          <c:if test="${not empty sessionScope.adminSess}">
          fetch('/admin/api/cancel-logout', { method: 'POST', credentials: 'same-origin' });
          </c:if>

          // 일반 회원 세션이 있을 때는 회원용 취소 API 호출
          <c:if test="${not empty sessionScope.loginSess}">
          fetch('/api/member/cancel-logout', { method: 'POST', credentials: 'same-origin' });
          </c:if>
      });

      // 2. 페이지 떠날 때: 일단 펜딩 신호를 보냄
      window.addEventListener('pagehide', function() {
          <c:if test="${not empty sessionScope.adminSess}">
          navigator.sendBeacon('/admin/api/logout-pending');
          </c:if>

          <c:if test="${not empty sessionScope.loginSess}">
          navigator.sendBeacon('/api/member/logout-pending');
          </c:if>
      });
  })();
  </script>
</c:if>