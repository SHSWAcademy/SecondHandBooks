<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/header.jsp" />

<div class="max-w-4xl mx-auto">
    <h1 class="text-2xl font-bold mb-8">내 프로필</h1>

    <div class="bg-white rounded-lg border border-gray-200 p-8 mb-6">
        <!-- Profile Header -->
        <div class="flex items-center gap-6 pb-8 border-b border-gray-200">
            <div class="w-24 h-24 bg-primary-100 text-primary-600 rounded-full flex items-center justify-center font-bold text-3xl">
                ${user.nickname.substring(0, 1)}
            </div>
            <div class="flex-1">
                <h2 class="text-xl font-bold mb-1">${user.nickname}</h2>
                <p class="text-gray-500 text-sm">${user.email}</p>
                <p class="text-xs text-gray-400 mt-1">가입일: <c:out value="${user.joinedAt}" /></p>
            </div>
            <div class="text-right">
                <div class="text-sm text-gray-500 mb-1">매너온도</div>
                <div class="text-3xl font-bold text-primary-600">${user.temperature}°C</div>
            </div>
        </div>

        <!-- Profile Info -->
        <div class="mt-6 space-y-4">
            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">아이디</label>
                <input type="text" value="${user.username}" readonly
                       class="w-full px-4 py-2.5 border border-gray-200 rounded-md bg-gray-50 text-gray-500" />
            </div>

            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">닉네임</label>
                <input type="text" value="${user.nickname}"
                       class="w-full px-4 py-2.5 border border-gray-300 rounded-md focus:border-primary-500 outline-none" />
            </div>

            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">이메일</label>
                <input type="email" value="${user.email}"
                       class="w-full px-4 py-2.5 border border-gray-300 rounded-md focus:border-primary-500 outline-none" />
            </div>

            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">휴대폰 번호</label>
                <input type="tel" value="${user.phoneNumber}"
                       class="w-full px-4 py-2.5 border border-gray-300 rounded-md focus:border-primary-500 outline-none"
                       placeholder="010-0000-0000" />
            </div>

            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">주소</label>
                <input type="text" value="${user.address}"
                       class="w-full px-4 py-2.5 border border-gray-300 rounded-md focus:border-primary-500 outline-none"
                       placeholder="주소를 입력하세요" />
            </div>

            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">포인트</label>
                <div class="text-2xl font-bold text-primary-600">${user.points} P</div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="flex gap-3 mt-8 pt-6 border-t border-gray-200">
            <button onclick="updateProfile()" class="flex-1 bg-primary-500 text-white py-3 rounded-md font-bold hover:bg-primary-600 transition">
                프로필 수정
            </button>
            <a href="/logout" class="flex-1 bg-gray-100 text-gray-700 py-3 rounded-md font-bold hover:bg-gray-200 transition text-center">
                로그아웃
            </a>
        </div>
    </div>
</div>

<script>
function updateProfile() {
    alert('프로필이 수정되었습니다.');
}
</script>

<jsp:include page="common/footer.jsp" />
