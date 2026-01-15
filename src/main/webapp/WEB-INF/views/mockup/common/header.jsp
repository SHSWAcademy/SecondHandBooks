<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Shinhan Books - 믿을 수 있는 중고 서적 거래</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            fontFamily: {
              sans: ['Pretendard', 'Apple SD Gothic Neo', 'Malgun Gothic', 'sans-serif'],
            },
            colors: {
              primary: {
                50: '#eef4ff',
                100: '#d9e6ff',
                200: '#bcd4ff',
                300: '#8ebaff',
                400: '#599aff',
                500: '#0046FF',
                600: '#0036cc',
                700: '#002ba3',
                800: '#002485',
                900: '#00206b',
              },
              gray: {
                50: '#f8f9fa',
                100: '#f1f3f5',
                200: '#e9ecef',
                300: '#dee2e6',
                400: '#ced4da',
                500: '#adb5bd',
                600: '#868e96',
                700: '#495057',
                800: '#343a40',
                900: '#212529',
              }
            }
          }
        }
      }
    </script>
    <style>
        .line-clamp-1 {
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 1;
            -webkit-box-orient: vertical;
        }
    </style>
</head>
<body class="bg-[#F8F9FA] text-gray-900 font-sans antialiased">
    <!-- Desktop Header - Shinhan Books Style -->
    <header class="bg-white border-b border-gray-200 sticky top-0 z-50 shadow-[0_1px_3px_rgba(0,0,0,0.05)]">
        <div class="max-w-7xl mx-auto px-6 h-[72px] flex items-center justify-between">

          <!-- Logo -->
          <div class="flex items-center gap-2 cursor-pointer mr-10" onclick="location.href='/home'">
            <div class="flex flex-col leading-none">
                <span class="text-[10px] font-bold text-primary-500 tracking-widest mb-0.5">PREMIUM</span>
                <span class="text-2xl font-black text-primary-600 tracking-tighter">Shinhan<span class="text-gray-800 font-bold ml-1">Books</span></span>
            </div>
          </div>

          <!-- Search Bar -->
          <div class="hidden md:flex flex-1 max-w-2xl relative">
            <form action="/home" method="get" class="w-full">
                <input type="text" name="search" placeholder="찾고 싶은 도서나 저자를 검색해보세요"
                       class="w-full pl-5 pr-14 py-3 bg-gray-50 border border-gray-200 rounded-full focus:outline-none focus:ring-2 focus:ring-primary-200 focus:border-primary-500 transition-all text-sm placeholder-gray-400 shadow-sm" />
                <button type="submit" class="absolute right-2 top-1.5 h-9 w-9 bg-primary-500 rounded-full flex items-center justify-center text-white hover:bg-primary-600 transition">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
                </button>
            </form>
          </div>

          <!-- Navigation Actions -->
          <nav class="flex items-center gap-4 ml-8">
            <a href="/readingGroups" class="px-3 py-2 text-sm font-bold hover:text-primary-600 transition-colors text-gray-600">독서모임</a>
            <a href="/trade" class="px-3 py-2 text-sm font-bold hover:text-primary-600 transition-colors text-gray-600">판매하기</a>

            <c:if test="${not empty user and user.isAdmin}">
                <a href="/admin" class="flex items-center gap-1.5 px-3 py-2 text-sm font-bold transition-colors text-gray-500 hover:text-gray-900">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/></svg>
                    관리자
                </a>
            </c:if>

            <div class="h-4 w-px bg-gray-300 mx-2"></div>

            <c:choose>
                <c:when test="${not empty user}">
                    <div class="flex items-center gap-3">
                        <a href="/wishlist" class="relative p-2 transition hover:text-primary-600 text-gray-600" title="찜한 상품">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.29 1.51 4.04 3 5.5l7 7Z"/></svg>
                        </a>
                        <a href="/chat" class="relative p-2 transition hover:text-primary-600 text-gray-600" title="채팅">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                        </a>
                        <a href="/profile" class="flex items-center gap-2 text-sm font-medium text-gray-700 hover:text-gray-900 group ml-1">
                            <div class="w-9 h-9 bg-primary-50 text-primary-600 rounded-full border border-primary-100 flex items-center justify-center font-bold text-sm overflow-hidden group-hover:bg-primary-100 transition">
                                ${user.nickname.substring(0, 1)}
                            </div>
                            <span class="font-bold hidden lg:block">${user.nickname}님</span>
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

    <!-- Main Content Area -->
    <main class="flex-1 max-w-7xl mx-auto w-full px-6 py-10">
