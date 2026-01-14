<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/header.jsp" />

<div class="max-w-[400px] mx-auto mt-12 mb-12">
    <div class="bg-white p-8 rounded-md border border-gray-200 shadow-sm">
        <h2 class="text-xl font-bold mb-6 text-gray-900">회원가입</h2>

        <form action="login/signup" method="post" onsubmit="return validateCheck()" class="space-y-4">

            <!-- 1. ID Input & Duplicate Check -->
            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">아이디 <span class="text-red-500">*</span></label>
                <div class="flex gap-2">
                    <input type="text" name="login_id" id="login_id" required
                           class="flex-1 px-3 py-2.5 border border-gray-300 rounded-sm focus:border-primary-500 outline-none text-sm transition"
                           placeholder="영문 소문자/숫자 4자 이상" />
                    <button type="button" onclick="checkUsername()" id="checkUsernameBtn"
                            class="text-xs px-3 py-2.5 rounded-sm font-bold whitespace-nowrap border bg-gray-800 text-white border-gray-800 hover:bg-gray-900 transition">
                        중복확인
                    </button>
                </div>
                <p id="usernameMsg" class="text-xs mt-1"></p>
            </div>

            <!-- 2. Email Input -->
            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">이메일 <span class="text-red-500">*</span></label>
                <input type="email" name="member_email" id="member_email" required
                       class="w-full px-3 py-2.5 border border-gray-300 rounded-sm focus:border-primary-500 outline-none text-sm transition"
                       placeholder="example@email.com" />
            </div>

            <!-- 3. Password -->
            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">비밀번호 <span class="text-red-500">*</span></label>
                <input type="password" name="member_pwd" id="member_pwd" required
                       class="w-full px-3 py-2.5 border border-gray-300 rounded-sm focus:border-primary-500 outline-none text-sm transition"
                       placeholder="8자 이상 입력" />
            </div>

            <!-- 4. Confirm Password -->
            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">비밀번호 확인 <span class="text-red-500">*</span></label>
                <input type="password" name="confirmPwd" id="confirmPwd" required
                       class="w-full px-3 py-2.5 border border-gray-300 rounded-sm focus:border-primary-500 outline-none text-sm transition"
                       placeholder="비밀번호 재입력" />
            </div>

            <!-- 5. NickName Input & Duplicate Check -->
            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">닉네임 <span class="text-red-500">*</span></label>
                <div class="flex gap-2">
                    <input type="text" name="member_nicknm" id="member_nicknm" required
                           class="flex-1 px-3 py-2.5 border border-gray-300 rounded-sm focus:border-primary-500 outline-none text-sm transition"
                           placeholder="사용하실 별명을 입력하세요" />
                    <button type="button" onclick="checkUsername()" id="checkUsernameBtn"
                            class="text-xs px-3 py-2.5 rounded-sm font-bold whitespace-nowrap border bg-gray-800 text-white border-gray-800 hover:bg-gray-900 transition">
                        중복확인
                    </button>
                </div>
                <p id="usernameMsg" class="text-xs mt-1"></p>
            </div>

            <!-- 6. Phone Number (Optional) -->
            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">휴대폰 번호 (선택)</label>
                <input type="tel" name="member_tel_no" id="member_tel_no"
                       class="w-full px-3 py-2.5 border border-gray-300 rounded-sm focus:border-primary-500 outline-none text-sm transition"
                       placeholder="010-0000-0000" />
            </div>

            <!-- Error Message -->
            <div id="errorMsg" class="text-xs text-red-500"></div>

            <!-- Terms -->
            <div class="text-xs text-gray-600 bg-gray-50 p-3 rounded border border-gray-100 space-y-1.5">
                <label class="flex items-center gap-2 cursor-pointer hover:text-gray-900">
                    <input type="checkbox" id="termsAll" onchange="toggleAll(this)" class="rounded-sm text-primary-500 focus:ring-primary-500 border-gray-300"/>
                    <span class="font-bold">전체 동의</span>
                </label>
                <div class="border-t border-gray-200 my-2"></div>
                <label class="flex items-center gap-2 cursor-pointer hover:text-gray-900">
                    <input type="checkbox" name="terms1" class="terms-checkbox rounded-sm text-primary-500 focus:ring-primary-500 border-gray-300"/>
                    <span>[필수] 만 14세 이상입니다</span>
                </label>
                <label class="flex items-center gap-2 cursor-pointer hover:text-gray-900">
                    <input type="checkbox" name="terms2" class="terms-checkbox rounded-sm text-primary-500 focus:ring-primary-500 border-gray-300"/>
                    <span>[필수] 이용약관 동의</span>
                </label>
                <label class="flex items-center gap-2 cursor-pointer hover:text-gray-900">
                    <input type="checkbox" name="terms3" class="terms-checkbox rounded-sm text-primary-500 focus:ring-primary-500 border-gray-300"/>
                    <span>[필수] 개인정보 수집 및 이용 동의</span>
                </label>
            </div>

            <button type="submit" class="w-full bg-primary-500 text-white py-3.5 rounded-md font-bold hover:bg-primary-600 transition text-sm">
                회원가입
            </button>
        </form>

        <div class="mt-6 text-center text-sm text-gray-600">
            이미 계정이 있으신가요?
            <a href="/login" class="text-primary-600 font-bold hover:underline ml-1">로그인</a>
        </div>
    </div>
</div>

<script>
let usernameChecked = false;

function checkUsername() {
    const username = document.getElementById('username').value;
    const msg = document.getElementById('usernameMsg');
    const btn = document.getElementById('checkUsernameBtn');

    if (username.length < 4) {
        msg.textContent = '아이디는 4글자 이상이어야 합니다.';
        msg.className = 'text-xs mt-1 text-red-500';
        return;
    }

    // Simulate async check
    btn.textContent = '확인 중...';
    btn.disabled = true;

    setTimeout(() => {
        if (username === 'admin') {
            msg.textContent = '이미 사용 중인 아이디입니다.';
            msg.className = 'text-xs mt-1 text-red-500';
            usernameChecked = false;
        } else {
            msg.textContent = '사용 가능한 아이디입니다.';
            msg.className = 'text-xs mt-1 text-green-600';
            usernameChecked = true;
            document.getElementById('username').readOnly = true;
            btn.textContent = '✓';
            btn.className = 'text-xs px-3 py-2.5 rounded-sm font-bold whitespace-nowrap border border-green-500 text-green-600 bg-white';
        }
        btn.disabled = false;
    }, 800);
}

function validateForm() {
    const errorMsg = document.getElementById('errorMsg');
    errorMsg.textContent = '';

    if (!usernameChecked) {
        errorMsg.textContent = '아이디 중복 확인을 해주세요.';
        return false;
    }

    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    if (password.length < 8) {
        errorMsg.textContent = '비밀번호는 8자 이상이어야 합니다.';
        return false;
    }

    if (password !== confirmPassword) {
        errorMsg.textContent = '비밀번호가 일치하지 않습니다.';
        return false;
    }

    const nickname = document.getElementById('nickname').value;
    if (nickname.length < 2) {
        errorMsg.textContent = '닉네임은 2글자 이상이어야 합니다.';
        return false;
    }

    // Check required terms
    const terms1 = document.querySelector('input[name="terms1"]').checked;
    const terms2 = document.querySelector('input[name="terms2"]').checked;
    const terms3 = document.querySelector('input[name="terms3"]').checked;

    if (!terms1 || !terms2 || !terms3) {
        errorMsg.textContent = '필수 약관에 모두 동의해주세요.';
        return false;
    }

    return true;
}

function toggleAll(checkbox) {
    const checkboxes = document.querySelectorAll('.terms-checkbox');
    checkboxes.forEach(cb => cb.checked = checkbox.checked);
}

// Auto-check "전체 동의" when all individual terms are checked
document.querySelectorAll('.terms-checkbox').forEach(cb => {
    cb.addEventListener('change', () => {
        const allChecked = Array.from(document.querySelectorAll('.terms-checkbox')).every(c => c.checked);
        document.getElementById('termsAll').checked = allChecked;
    });
});
</script>

<jsp:include page="common/footer.jsp" />
