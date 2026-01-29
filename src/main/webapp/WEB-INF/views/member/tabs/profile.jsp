<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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

    <form id="edit-mode" action="/member/update" method="post" onsubmit="return validateProfileForm()" class="hidden max-w-md space-y-5">

        <div>
            <label class="block text-sm font-bold text-gray-700 mb-1.5">닉네임 <span class="text-red-500">*</span></label>
            <div class="flex gap-2">
                <input type="text" id="member_nicknm" name="member_nicknm"
                       value="${sessionScope.loginSess.member_nicknm}"
                       maxlength="10"
                       oninput="handleNickChange()"
                       class="flex-1 px-3 py-2.5 border border-gray-300 rounded-sm outline-none focus:border-primary-500 text-sm transition"
                       placeholder="2~10자 이내" />
                <button type="button" id="btn-check-nick" onclick="checkDuplicateNick()"
                        class="px-3 py-2.5 bg-gray-800 text-white text-xs font-bold rounded-sm hover:bg-gray-900 whitespace-nowrap transition">
                    중복확인
                </button>
            </div>
            <p id="nickMsg" class="text-xs mt-1 text-gray-500"></p>
        </div>

        <div>
            <label class="block text-sm font-bold text-gray-700 mb-1.5">이메일</label>
            <input type="email" name="member_email" value="${sessionScope.loginSess.member_email}" readonly
                   class="w-full px-3 py-2.5 border bg-gray-50 border-gray-300 rounded-sm outline-none text-gray-500 text-sm cursor-not-allowed" />
        </div>

        <div>
            <label class="block text-sm font-bold text-gray-700 mb-1.5">휴대폰 번호 <span class="text-red-500">*</span></label>
            <input type="tel" name="member_tel_no" id="member_tel_no"
                   value="${sessionScope.loginSess.member_tel_no}"
                   placeholder="010-0000-0000"
                   maxlength="13"
                   oninput="autoHyphen(this)"
                   class="w-full px-3 py-2.5 border border-gray-300 rounded-sm outline-none focus:border-primary-500 text-sm transition" />
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
    // 전역 변수: 닉네임 중복 확인 상태
    // 초기값은 true (자기 자신의 닉네임이므로)
    let isNickChecked = true;
    const originalNick = "${sessionScope.loginSess.member_nicknm}";

    function toggleEditMode(isEdit) {
        if (isEdit) {
            $('#view-mode').addClass('hidden');
            $('#edit-mode').removeClass('hidden');
            $('#btn-edit-profile').addClass('hidden');

            // 편집 모드 진입 시 초기화
            const nickInput = document.getElementById('member_nicknm');
            nickInput.value = originalNick;
            document.getElementById('nickMsg').textContent = "";
            isNickChecked = true;

        } else {
            $('#view-mode').removeClass('hidden');
            $('#edit-mode').addClass('hidden');
            $('#btn-edit-profile').removeClass('hidden');
        }
    }

    // 닉네임 입력값 변경 감지
    function handleNickChange() {
        const currentVal = document.getElementById('member_nicknm').value;
        const btn = document.getElementById('btn-check-nick');
        const msg = document.getElementById('nickMsg');

        // 원래 닉네임과 같으면 중복 확인 불필요
        if (currentVal === originalNick) {
            isNickChecked = true;
            msg.textContent = "현재 사용 중인 닉네임입니다.";
            msg.className = "text-xs mt-1 text-green-600";
            btn.className = "px-3 py-2.5 bg-gray-100 text-gray-400 text-xs font-bold rounded-sm cursor-not-allowed";
            btn.disabled = true;
        } else {
            isNickChecked = false;
            msg.textContent = "중복 확인이 필요합니다.";
            msg.className = "text-xs mt-1 text-red-500";
            btn.className = "px-3 py-2.5 bg-gray-800 text-white text-xs font-bold rounded-sm hover:bg-gray-900 whitespace-nowrap transition";
            btn.disabled = false;
        }
    }

    // 닉네임 중복 확인 AJAX
    function checkDuplicateNick() {
        const nickInput = document.getElementById('member_nicknm');
        const nick = nickInput.value.trim();
        const msg = document.getElementById('nickMsg');

        if (nick.length < 2) {
            alert("닉네임은 2글자 이상이어야 합니다.");
            return;
        }

        $.ajax({
            url: '/auth/ajax/nicknmCheck',
            type: 'GET',
            data: { member_nicknm: nick },
            success: function(res) {
                if (res > 0) {
                    msg.textContent = "이미 사용 중인 닉네임입니다.";
                    msg.className = "text-xs mt-1 text-red-500 font-bold";
                    isNickChecked = false;
                } else {
                    msg.textContent = "사용 가능한 닉네임입니다.";
                    msg.className = "text-xs mt-1 text-green-600 font-bold";
                    isNickChecked = true;
                }
            },
            error: function() {
                alert("서버 오류가 발생했습니다.");
            }
        });
    }

    // 휴대폰 번호 자동 하이픈
    function autoHyphen(target) {
        target.value = target.value
            .replace(/[^0-9]/g, '')
            .replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3")
            .replace(/(\-{1,2})$/g, "");
    }

    // 폼 제출 전 유효성 검사
    function validateProfileForm() {
        const nick = document.getElementById('member_nicknm').value.trim();
        const tel = document.getElementById('member_tel_no').value.trim();

        if (nick.length < 2) {
            alert("닉네임은 2글자 이상이어야 합니다.");
            return false;
        }

        if (!isNickChecked) {
            alert("닉네임 중복 확인을 해주세요.");
            return false;
        }

        if (!tel) {
            alert("휴대폰 번호를 입력해주세요.");
            return false;
        }

        // 휴대폰 번호 정규식 체크
        const telPattern = /^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$/;
        if (!telPattern.test(tel)) {
            alert("올바른 휴대폰 번호 형식이 아닙니다.");
            return false;
        }

        return true;
    }

    function handleDeleteAccount() {
        if (confirm('정말 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.\n(작성한 게시글 및 데이터는 삭제되지 않을 수 있습니다)')) {
            location.href = '/member/delete';
        }
    }

    lucide.createIcons();
</script>