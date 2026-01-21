<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>ShinhanBooks Admin Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 h-screen flex items-center justify-center">
<div class="bg-white p-8 rounded-lg shadow-lg w-96">
    <h2 class="text-2xl font-bold text-center text-gray-800 mb-6">관리자 로그인</h2>

    <form action="/admin/loginProcess" method="post" class="space-y-4">
        <div>
            <label class="block text-sm font-medium text-gray-700">Admin ID</label>
            <input type="text" name="id" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none mt-1">
        </div>
        <div>
            <label class="block text-sm font-medium text-gray-700">Password</label>
            <input type="password" name="pwd" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none mt-1">
        </div>

        <c:if test="${param.error == 'true'}">
            <p class="text-red-500 text-xs text-center font-bold">아이디 또는 비밀번호가 일치하지 않습니다.</p>
        </c:if>

        <button type="submit" class="w-full bg-gray-900 text-white py-2 rounded-lg font-bold hover:bg-gray-800 transition">
            로그인
        </button>
    </form>

    <div class="mt-4 text-center">
        <a href="/home" class="text-xs text-gray-500 hover:underline">메인으로 돌아가기</a>
    </div>
</div>
</body>
</html>