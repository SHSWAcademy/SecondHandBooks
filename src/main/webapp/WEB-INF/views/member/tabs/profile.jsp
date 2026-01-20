<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 기존 디자인 그대로 복사 -->
<div class="bg-white rounded-lg border border-gray-200 p-8 shadow-sm">
    <div class="flex justify-between items-center mb-6 pb-4 border-b border-gray-100">
        <h2 class="text-xl font-bold text-gray-900">내 프로필</h2>
        <button id="btn-edit-profile" onclick="toggleEditMode(true)"
                class="flex items-center gap-1.5 text-xs font-bold text-gray-600 bg-gray-100 px-3 py-1.5 rounded hover:bg-gray-200 transition">
            <i data-lucide="edit-2" class="w-3.5 h-3.5"></i> 수정하기
        </button>
    </div>

    <div id="view-mode" class="space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div>
                <span class="text-xs font-bold text-gray-400 block mb-1">닉네임</span>
                <span class="text-gray-900 font-medium">${sessionScope.loginSess.member_nicknm}</span>
            </div>
            <div>
                <span class="text-xs font-bold text-gray-400 block mb-1">이메일</span>
                <span class="text-gray-900 font-medium">${sessionScope.loginSess.member_email}</span>
            </div>
            <div>
                <span class="text-xs font-bold text-gray-400 block mb-1">휴대폰 번호</span>
                <span class="text-gray-900 font-medium">${not empty sessionScope.loginSess.member_tel_no ? sessionScope.loginSess.member_tel_no : '미등록'}</span>
            </div>
        </div>

        <div class="pt-8 mt-8 border-t border-gray-100">
            <h3 class="text-sm font-bold text-red-600 mb-2">계정 관리</h3>
            <button onclick="handleDeleteAccount()"
                    class="flex items-center gap-1.5 text-xs text-gray-500 hover:text-red-600 hover:underline">
                <i data-lucide="trash-2" class="w-3.5 h-3.5"></i> 회원 탈퇴
            </button>
        </div>
    </div>

    <form id="edit-mode" action="/member/update" method="post" class="hidden max-w-md space-y-5">
        <div>
            <label class="block text-sm font-bold text-gray-700 mb-1.5">닉네임</label>
            <input type="text" name="member_nicknm" value="${sessionScope.loginSess.member_nicknm}"
                   class="w-full px-3 py-2.5 border border-gray-300 rounded-sm outline-none focus:border-primary-500 text-sm" />
        </div>
        <div>
            <label class="block text-sm font-bold text-gray-700 mb-1.5">이메일</label>
            <input type="email" name="member_email" value="${sessionScope.loginSess.member_email}" readonly
                   class="w-full px-3 py-2.5 border bg-gray-50 border-gray-300 rounded-sm outline-none focus:border-primary-500 text-sm" />
        </div>
        <div>
            <label class="block text-sm font-bold text-gray-700 mb-1.5">휴대폰 번호</label>
            <input type="tel" name="member_tel_no" value="${sessionScope.loginSess.member_tel_no}" placeholder="010-0000-0000"
                   class="w-full px-3 py-2.5 border border-gray-300 rounded-sm outline-none focus:border-primary-500 text-sm" />
        </div>

        <div class="flex gap-2 pt-2">
            <button type="button" onclick="toggleEditMode(false)"
                    class="flex-1 py-2.5 border border-gray-300 rounded-sm text-sm font-bold text-gray-600 hover:bg-gray-50">취소</button>
            <button type="submit"
                    class="flex-1 py-2.5 bg-primary-600 text-white rounded-sm text-sm font-bold hover:bg-primary-700">저장</button>
        </div>
    </form>
</div>

<script>
    function toggleEditMode(isEdit) {
        if (isEdit) {
            $('#view-mode').addClass('hidden');
            $('#edit-mode').removeClass('hidden');
            $('#btn-edit-profile').addClass('hidden');
        } else {
            $('#view-mode').removeClass('hidden');
            $('#edit-mode').addClass('hidden');
            $('#btn-edit-profile').removeClass('hidden');
        }
    }

    function handleDeleteAccount() {
        if (confirm('정말 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
            location.href = '/member/delete';
        }
    }

    // Lucide 아이콘 다시 초기화
    lucide.createIcons();
</script>