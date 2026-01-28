<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />

<div class="max-w-[400px] mx-auto mt-12 mb-12">
    <div class="bg-white p-8 rounded-md border border-gray-200 shadow-sm">
        <h2 class="text-xl font-bold mb-6 text-gray-900">회원가입</h2>

        <form action="/auth/signup" method="post" onsubmit="return validateForm()" class="space-y-4">

            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">아이디 <span class="text-red-500">*</span></label>
                <div class="flex gap-2">
                    <input type="text" name="login_id" id="login_id" required
                           class="flex-1 px-3 py-2.5 border border-gray-300 rounded-sm focus:border-primary-500 outline-none text-sm transition"
                           placeholder="영문 소문자/숫자 4자 이상" />
                    <button type="button" onclick="checkLoginId()" id="checkLoginIdBtn"
                            class="text-xs px-3 py-2.5 rounded-sm font-bold whitespace-nowrap border bg-gray-800 text-white border-gray-800 hover:bg-gray-900 transition">
                        중복확인
                    </button>
                </div>
                <p id="loginIdMsg" class="text-xs mt-1"></p>
            </div>

            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">이메일<span class="text-red-500">*</span></label>

                <div class="flex gap-2">
                    <input type="email" name="member_email" id="member_email" required
                           class="flex-1 px-3 py-2.5 border border-gray-300 rounded-sm focus:border-primary-500 outline-none text-sm transition"
                           placeholder="email@email.com" />
                    <button type="button" onclick="checkEmail()" id="checkEmailBtn"
                            class="text-xs px-3 py-2.5 rounded-sm font-bold whitespace-nowrap border bg-gray-800 text-white border-gray-800 hover:bg-gray-900 transition">
                        중복확인
                    </button>
                </div>
                <p id="emailMsg" class="text-xs mt-1"></p>

                <button type="button" id="sendAuthBtn" onclick="sendEmailAuth()"
                        class="hidden w-full mt-2 bg-blue-500 text-white py-2 rounded-sm text-xs font-bold hover:bg-blue-600 transition">
                    인증번호 발송
                </button>

                <div id="authCodeBox" class="hidden mt-2 p-3 bg-gray-50 border border-gray-200 rounded-sm">
                    <div class="flex justify-between items-center mb-1">
                        <span class="text-xs text-gray-600">인증번호 입력</span>
                        <span id="timer" class="text-xs font-bold text-red-500">03:00</span>
                    </div>
                    <div class="flex gap-2">
                        <input type="text" id="authCodeInput"
                               class="flex-1 px-3 py-2 border border-gray-300 rounded-sm text-sm outline-none"
                               placeholder="6자리 번호" maxlength="6" />
                        <button type="button" onclick="verifyAuthCode()" id="verifyBtn"
                                class="px-3 py-2 bg-white border border-gray-300 text-xs font-bold rounded-sm hover:bg-gray-50">
                            확인
                        </button>
                    </div>
                    <div class="flex justify-between items-center mt-1">
                        <p id="authMsg" class="text-xs text-gray-500"></p>
                        <button type="button" onclick="sendEmailAuth()" class="text-xs text-gray-500 underline hover:text-gray-800">
                            재전송
                        </button>
                    </div>
                </div>
            </div>

            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">비밀번호 <span class="text-red-500">*</span></label>
                <input type="password" name="member_pwd" id="member_pwd" required
                       class="w-full px-3 py-2.5 border border-gray-300 rounded-sm focus:border-primary-500 outline-none text-sm transition"
                       placeholder="8자 이상 입력" />
            </div>

            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">비밀번호 확인 <span class="text-red-500">*</span></label>
                <input type="password" name="confirmPwd" id="confirmPwd" required
                       class="w-full px-3 py-2.5 border border-gray-300 rounded-sm focus:border-primary-500 outline-none text-sm transition"
                       placeholder="비밀번호 재입력" />
            </div>

            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">닉네임 <span class="text-red-500">*</span></label>
                <div class="flex gap-2">
                    <input type="text" name="member_nicknm" id="member_nicknm" required
                           class="flex-1 px-3 py-2.5 border border-gray-300 rounded-sm focus:border-primary-500 outline-none text-sm transition"
                           placeholder="사용하실 별명을 입력하세요" />
                    <button type="button" onclick="checkNicknm()" id="checkNicknmBtn"
                            class="text-xs px-3 py-2.5 rounded-sm font-bold whitespace-nowrap border bg-gray-800 text-white border-gray-800 hover:bg-gray-900 transition">
                        중복확인
                    </button>
                </div>
                <p id="nickNmMsg" class="text-xs mt-1"></p>
            </div>

            <div>
                <label class="block text-sm font-bold text-gray-700 mb-1.5">휴대폰 번호 <span class="text-red-500">*</span></label>
                <input type="tel" name="member_tel_no" id="member_tel_no" required maxlength="13" oninput="autoHyphen(this)"
                       class="w-full px-3 py-2.5 border border-gray-300 rounded-sm focus:border-primary-500 outline-none text-sm transition"
                       placeholder="010-0000-0000" />
            </div>

            <div id="errorMsg" class="text-xs text-red-500 font-bold"></div>

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
    let loginIdChecked = false;
    let emailChecked = false;
    let emailVerified = false; // 인증번호 통과 여부
    let timerInterval; // 인증번호 만료 제한시간
    let nickNmChecked = false;

    // [추가] 이메일 입력값 변경 감지 -> 상태 초기화
    document.getElementById('member_email').addEventListener('input', function() {
        const msg = document.getElementById('emailMsg');
        const btn = document.getElementById('checkEmailBtn');
        const sendAuthBtn = document.getElementById('sendAuthBtn');
        const authCodeBox = document.getElementById('authCodeBox');

        // 상태 초기화
        emailChecked = false;
        emailVerified = false;

        // 버튼 및 메시지 원상복구
        msg.textContent = '';
        btn.textContent = '중복확인';
        btn.disabled = false;
        btn.className = "text-xs px-3 py-2.5 rounded-sm font-bold whitespace-nowrap border bg-gray-800 text-white border-gray-800 hover:bg-gray-900 transition";

        // 인증 관련 UI 숨기기 및 초기화
        sendAuthBtn.classList.add('hidden');
        sendAuthBtn.disabled = false;
        sendAuthBtn.textContent = "인증번호 발송";

        authCodeBox.classList.add('hidden');
        document.getElementById('authCodeInput').value = '';
        document.getElementById('authCodeInput').disabled = false;
        document.getElementById('verifyBtn').disabled = false;

        // 타이머 정지
        if (timerInterval) clearInterval(timerInterval);
        document.getElementById('timer').textContent = "03:00";
    });

    function checkLoginId() {
        const login_id = document.getElementById('login_id').value;
        const msg = document.getElementById('loginIdMsg');
        const btn = document.getElementById('checkLoginIdBtn');

        if (login_id.length < 4) {
            msg.textContent = '아이디는 4글자 이상이어야 합니다.';
            msg.className = 'text-xs mt-1 text-red-500';
            return;
        }

        $.ajax({
            url: '/auth/ajax/idCheck',
            type: 'GET',
            data: {login_id: login_id},
            success: function(res) {
                if (res > 0) {
                    msg.textContent = '이미 사용 중인 아이디입니다.';
                    msg.className = 'text-xs mt-1 text-red-500';
                    loginIdChecked = false;
                } else {
                    msg.textContent = '사용 가능한 아이디입니다.';
                    msg.className = 'text-xs mt-1 text-green-600';
                    loginIdChecked = true;
                    btn.textContent = '✓';
                    btn.className = 'text-xs px-3 py-2.5 rounded-sm font-bold whitespace-nowrap border border-green-500 text-green-600 bg-white';
                }
            },
            error: function() {
                alert('서버 통신 중 오류가 발생했습니다.');
            }
        })
    }

    function checkEmail() {
        const member_email = document.getElementById('member_email').value;
        const msg = document.getElementById('emailMsg');
        const btn = document.getElementById('checkEmailBtn');
        const sendAuthBtn = document.getElementById('sendAuthBtn');

        // 간단한 이메일 형식 검사
        const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

        if (!emailPattern.test(member_email)) {
            msg.textContent = '올바른 이메일 형식이 아닙니다.';
            msg.className = 'text-xs mt-1 text-red-500';
            return;
        }

        $.ajax({
            url: '/auth/ajax/emailCheck',
            type: 'GET',
            data: {member_email: member_email},
            success: function(res) {
                if (res > 0) {
                    msg.textContent = '이미 사용 중인 이메일입니다.';
                    msg.className = 'text-xs mt-1 text-red-500';
                    emailChecked = false;
                } else {
                    msg.textContent = '사용 가능한 이메일입니다. 인증번호를 발송해 입력해주세요.';
                    msg.className = 'text-xs mt-1 text-green-600';
                    emailChecked = true;

                    // 중복 확인 성공 시 버튼 스타일 변경
                    btn.textContent = '✓';
                    btn.className = 'text-xs px-3 py-2.5 rounded-sm font-bold whitespace-nowrap border border-green-500 text-green-600 bg-white';

                    // 인증번호 발송 버튼 노출
                    sendAuthBtn.classList.remove('hidden');
                }
            },
            error: function() {
                alert('서버 통신 중 오류가 발생했습니다.');
            }
        })
    }

    function sendEmailAuth() {
        const email = document.getElementById('member_email').value;
        if (!emailChecked) {
            alert("이메일 중복 확인을 먼저 해주세요.");
            return;
        }

        const sendAuthBtn = document.getElementById('sendAuthBtn');
        const authCodeBox = document.getElementById('authCodeBox');
        const authInput = document.getElementById('authCodeInput');
        const verifyBtn = document.getElementById('verifyBtn');
        const authMsg = document.getElementById('authMsg');

        // 전송 중 상태 표시
        sendAuthBtn.textContent = "전송 중..";
        sendAuthBtn.disabled = true;

        $.ajax({
            url: '/auth/ajax/sendEmail',
            type: 'GET',
            data: {email: email},
            success: function(res) {
                if (res === "success") {
                    alert("인증번호가 발송되었습니다. 메일함을 확인해주세요.");

                    // 발송 성공 시 버튼 숨기고 인증번호 입력창 표시
                    sendAuthBtn.classList.add('hidden');
                    authCodeBox.classList.remove('hidden');

                    // 입력창 초기화
                    authInput.value = '';
                    authInput.disabled = false;
                    verifyBtn.disabled = false;

                    authMsg.textContent = "3분 이내에 입력해주세요.";
                    authMsg.className = "text-xs text-gray-500";

                    // 타이머 시작 (기존 타이머가 있다면 리셋됨)
                    startTimer(180);
                } else {
                    // 실패 시 다시 시도할 수 있도록 버튼 복구
                    alert("메일 발송에 실패했습니다. 이메일 주소를 확인해주세요.");
                    sendAuthBtn.textContent = "인증번호 발송";
                    sendAuthBtn.disabled = false;
                }
            },
            error: function() {
                alert("서버 오류로 메일 발송에 실패했습니다.");
                sendAuthBtn.textContent = "인증번호 발송";
                sendAuthBtn.disabled = false;
            }
        })
    }

    function startTimer(duration) {
        let timer = duration, minutes, seconds;
        const display = document.getElementById('timer');

        // 기존 타이머가 있으면 제거
        if (timerInterval) clearInterval(timerInterval);

        timerInterval = setInterval(function() {
            minutes = parseInt(timer / 60, 10);
            seconds = parseInt(timer % 60, 10);
            minutes = minutes < 10 ? "0" + minutes : minutes;
            seconds = seconds < 10 ? "0" + seconds : seconds;
            display.textContent = minutes + ":" + seconds;

            if (--timer < 0) {
                clearInterval(timerInterval);
                display.textContent = "시간만료";
                document.getElementById('authCodeInput').disabled = true;
                document.getElementById('verifyBtn').disabled = true;
                document.getElementById('authMsg').textContent = "인증 시간이 만료되었습니다.";
                document.getElementById('authMsg').className = "text-xs text-red-500";
            }
        }, 1000);
    }

    function verifyAuthCode() {
        const email = document.getElementById('member_email').value;
        const code = document.getElementById('authCodeInput').value;
        const authMsg = document.getElementById('authMsg');
        const authInput = document.getElementById('authCodeInput');
        const verifyBtn = document.getElementById('verifyBtn');

        if (code.length < 6) {
            authMsg.textContent = "6자리 인증번호를 입력해주세요.";
            authMsg.className = "text-xs text-red-500";
            return;
        }

        $.ajax({
            url: '/auth/ajax/checkEmailCode',
            type: 'GET',
            data: {email: email, code: code},
            success: function(res) {
                if (res) {
                    authMsg.textContent = "인증이 완료되었습니다.";
                    authMsg.className = "text-xs text-green-600 font-bold";
                    clearInterval(timerInterval);
                    document.getElementById('timer').textContent = "";
                    authInput.disabled = true;
                    verifyBtn.disabled = true;

                    // 인증 완료 시 이메일 수정 불가 (원하면 주석 처리 가능)
                    document.getElementById('member_email').readOnly = true;
                    document.getElementById('checkEmailBtn').disabled = true;

                    emailVerified = true;
                } else {
                    authMsg.textContent = "인증번호가 일치하지 않거나 만료되었습니다.";
                    authMsg.className = "text-xs text-red-500";
                    emailVerified = false;
                }
            },
            error: function() {
                alert("인증 확인 중 오류가 발생했습니다.");
            }
        })
    }

    function checkNicknm() {
        const member_nicknm = document.getElementById('member_nicknm').value;
        const msg = document.getElementById('nickNmMsg');
        const btn = document.getElementById('checkNicknmBtn');

        if (member_nicknm.length < 2) {
            msg.textContent = '닉네임은 2글자 이상이어야 합니다.';
            msg.className = 'text-xs mt-1 text-red-500';
            return;
        }

        $.ajax({
            url: '/auth/ajax/nicknmCheck',
            type: 'GET',
            data: {member_nicknm: member_nicknm},
            success: function(res) {
                if (res > 0) {
                    msg.textContent = '이미 사용 중인 닉네임입니다.';
                    msg.className = 'text-xs mt-1 text-red-500';
                    nickNmChecked = false;
                } else {
                    msg.textContent = '사용 가능한 닉네임입니다.';
                    msg.className = 'text-xs mt-1 text-green-600';
                    nickNmChecked = true;
                    btn.textContent = '✓';
                    btn.className = 'text-xs px-3 py-2.5 rounded-sm font-bold whitespace-nowrap border border-green-500 text-green-600 bg-white';
                }
            }
        })
    }

    // 휴대폰 번호 자동 하이픈 (010-0000-0000)
    function autoHyphen(target) {
        target.value = target.value
            .replace(/[^0-9]/g, '')
            .replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, `$1-$2-$3`);
    }

    function validateForm() {
        const errorMsg = document.getElementById('errorMsg');
        errorMsg.textContent = "";

        if (!loginIdChecked) {
            errorMsg.textContent = '아이디 중복 확인을 해주세요.';
            return false;
        }

        if (!emailChecked) {
            errorMsg.textContent = '이메일 중복 확인을 해주세요.';
            return false;
        }

        if (!emailVerified) {
            errorMsg.textContent = "이메일 인증을 완료해주세요.";
            return false;
        }

        const member_pwd = document.getElementById('member_pwd').value;
        const confirmPwd = document.getElementById('confirmPwd').value;

        if (member_pwd.length < 8) {
            errorMsg.textContent = '비밀번호는 8자 이상이어야 합니다.';
            return false;
        }

        if (member_pwd !== confirmPwd) {
            errorMsg.textContent = '비밀번호가 일치하지 않습니다.';
            return false;
        }

        const member_nicknm = document.getElementById('member_nicknm').value;
        if (member_nicknm.length < 2) {
            errorMsg.textContent = '닉네임은 2글자 이상이어야 합니다.';
            return false;
        }

        const member_tel_no = document.getElementById('member_tel_no').value;
        const telPattern = /^\d{3}-\d{4}-\d{4}$/;

        if (!member_tel_no) {
            errorMsg.textContent = '휴대폰 번호를 입력해주세요.';
            return false;
        }

        if (!telPattern.test(member_tel_no)) {
            errorMsg.textContent = '휴대폰 번호 형식이 올바르지 않습니다. (예: 010-1234-5678)';
            return false;
        }

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

    document.querySelectorAll('.terms-checkbox').forEach(cb => {
        cb.addEventListener('change', () => {
            const allChecked = Array.from(document.querySelectorAll('.terms-checkbox')).every(c => c.checked);
            document.getElementById('termsAll').checked = allChecked;
        });
    });
</script>

<jsp:include page="../common/footer.jsp" />