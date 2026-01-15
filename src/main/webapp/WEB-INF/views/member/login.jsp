<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<div class="max-w-[400px] mx-auto mt-12">
    <div class="bg-white p-8 rounded-lg border border-gray-200 shadow-sm">
        <div class="text-center mb-8">
            <h1 class="text-3xl font-black text-primary-600 tracking-tighter mb-2 cursor-pointer leading-none" onclick="location.href='/home'">
                Shinhan<span class="text-gray-900">Books</span>
            </h1>
            <p class="text-gray-500 text-sm mt-3">금융처럼 안전한 중고 서적 거래</p>
        </div>

        <form action="/login" method="post" class="space-y-3">
            <div>
                <input type="text" name="login_id" placeholder="아이디" required
                       class="w-full px-4 py-3.5 border border-gray-300 rounded-md focus:border-primary-500 outline-none transition text-sm focus:ring-1 focus:ring-primary-500" />
            </div>
            <div>
                <input type="password" name="member_pwd" placeholder="비밀번호" required
                       class="w-full px-4 py-3.5 border border-gray-300 rounded-md focus:border-primary-500 outline-none transition text-sm focus:ring-1 focus:ring-primary-500" />
            </div>

            <div class="flex justify-between items-center text-xs text-gray-500 pt-1 pb-2">
                <label class="flex items-center gap-1.5 cursor-pointer hover:text-gray-800">
                    <input type="checkbox" name="remember" class="rounded-sm text-primary-500 focus:ring-primary-500 border-gray-300"/>
                    <span>로그인 상태 유지</span>
                </label>
                <div class="flex gap-2">
                    <a href="/findAccount" class="hover:underline">아이디 찾기</a>
                    <span class="text-gray-300">|</span>
                    <a href="/findAccount" class="hover:underline">비밀번호 찾기</a>
                </div>
            </div>

            <button type="submit" class="w-full bg-primary-500 text-white py-4 rounded-md font-bold text-sm hover:bg-primary-600 transition shadow-sm">
                로그인
            </button>
        </form>

        <div class="mt-6 pt-6 border-t border-gray-100 space-y-3">
            <a href="https://kauth.kakao.com/oauth/authorize?client_id=540d6c34f2540fb2c6e27bac5a1d8922&redirect_uri=http://localhost:8005/auth/kakao/callback&response_type=code"
               class="w-full py-3.5 bg-[#FEE500] text-[#3c1e1e] rounded-md font-bold text-sm hover:bg-[#fdd835] transition flex items-center justify-center gap-2">
                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 3C7.58 3 4 5.28 4 8.1c0 1.77 1.43 3.34 3.73 4.25-.16.59-.57 2.06-.66 2.4-.1.38.14.38.29.28.2.13 2.82-1.92 3.96-2.7.22.03.45.04.68.04 4.42 0 8-2.28 8-5.1S16.42 3 12 3z"/>
                </svg>
                카카오로 시작하기
            </a>
            <button onclick="alert('네이버 로그인은 준비 중입니다.')" class="w-full py-3.5 bg-[#03C75A] text-white rounded-md font-bold text-sm hover:bg-[#02b351] transition flex items-center justify-center gap-2">
                <span class="font-black">N</span>
                네이버로 시작하기
            </button>
        </div>

        <div class="mt-6 pt-6 border-t border-gray-100">
            <a href="/signup" class="block w-full py-3.5 border border-gray-300 text-gray-700 rounded-md font-medium hover:bg-gray-50 transition text-sm text-center">
                회원가입
            </a>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
