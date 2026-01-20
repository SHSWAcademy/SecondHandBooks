<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

<script src="https://unpkg.com/lucide@latest"></script>

<div class="flex flex-col lg:flex-row gap-8 max-w-6xl mx-auto">

    <div class="lg:w-1/4">
        <div class="bg-white rounded-lg border border-gray-200 shadow-sm overflow-hidden sticky top-24">
            <div class="p-6 text-center border-b border-gray-100 bg-gray-50/50">
                <div class="w-20 h-20 bg-white border-2 border-primary-100 rounded-full flex items-center justify-center text-3xl font-bold text-primary-600 mx-auto mb-3 shadow-sm">
                    ${sessionScope.loginSess.member_nicknm.substring(0, 1)}
                </div>
                <h2 class="font-bold text-gray-900 text-lg">${sessionScope.loginSess.member_nicknm}님</h2>
                <p class="text-xs text-gray-500">${sessionScope.loginSess.member_email}</p>
            </div>

            <nav class="p-2 space-y-1">
                <button onclick="showTab('INFO', this)" class="nav-btn w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all bg-primary-50 text-primary-600">
                    <i data-lucide="user" class="w-4 h-4"></i> 내 프로필
                </button>
                <button onclick="showTab('PURCHASES', this)" class="nav-btn w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all text-gray-600 hover:bg-gray-50 hover:text-gray-900">
                    <i data-lucide="shopping-bag" class="w-4 h-4"></i> 구매 내역
                </button>
                <button onclick="showTab('SALES', this)" class="nav-btn w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all text-gray-600 hover:bg-gray-50 hover:text-gray-900">
                    <i data-lucide="package" class="w-4 h-4"></i> 판매 내역
                </button>
                <button onclick="showTab('WISHLIST', this)" class="nav-btn w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all text-gray-600 hover:bg-gray-50 hover:text-gray-900">
                    <i data-lucide="heart" class="w-4 h-4"></i> 찜한 상품
                </button>
                <button onclick="showTab('GROUPS', this)" class="nav-btn w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all text-gray-600 hover:bg-gray-50 hover:text-gray-900">
                    <i data-lucide="users" class="w-4 h-4"></i> 내 모임
                </button>
                <button onclick="showTab('ADDRESSES', this)" class="nav-btn w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all text-gray-600 hover:bg-gray-50 hover:text-gray-900">
                    <i data-lucide="map-pin" class="w-4 h-4"></i> 배송지 관리
                </button>
            </nav>

            <div class="p-4 border-t border-gray-100">
                <button onclick="location.href='/logout'" class="w-full flex items-center justify-center gap-2 text-xs font-bold text-gray-500 hover:text-red-600 py-2 transition">
                    <i data-lucide="log-out" class="w-3.5 h-3.5"></i> 로그아웃
                </button>
            </div>
        </div>
    </div>

    <div class="lg:flex-1 min-h-[500px]">

        <div id="tab-INFO" class="tab-content">
            <div class="bg-white rounded-lg border border-gray-200 p-8 shadow-sm">
                <div class="flex justify-between items-center mb-6 pb-4 border-b border-gray-100">
                    <h2 class="text-xl font-bold text-gray-900">내 프로필</h2>
                    <button id="btn-edit-profile" onclick="toggleEditMode(true)" class="flex items-center gap-1.5 text-xs font-bold text-gray-600 bg-gray-100 px-3 py-1.5 rounded hover:bg-gray-200 transition">
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
                        <button onclick="handleDeleteAccount()" class="flex items-center gap-1.5 text-xs text-gray-500 hover:text-red-600 hover:underline">
                            <i data-lucide="trash-2" class="w-3.5 h-3.5"></i> 회원 탈퇴
                        </button>
                    </div>
                </div>

                <form id="edit-mode" action="/member/update" method="post" class="hidden max-w-md space-y-5">
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1.5">닉네임</label>
                        <input type="text" name="member_nicknm" value="${sessionScope.loginSess.member_nicknm}" class="w-full px-3 py-2.5 border border-gray-300 rounded-sm outline-none focus:border-primary-500 text-sm" />
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1.5">이메일</label>
                        <input type="email" name="member_email" value="${sessionScope.loginSess.member_email}" readonly class="w-full px-3 py-2.5 border bg-gray-50 border-gray-300 rounded-sm outline-none focus:border-primary-500 text-sm" />
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1.5">휴대폰 번호</label>
                        <input type="tel" name="member_tel_no" value="${sessionScope.loginSess.member_tel_no}" placeholder="010-0000-0000" class="w-full px-3 py-2.5 border border-gray-300 rounded-sm outline-none focus:border-primary-500 text-sm" />
                    </div>

                    <div class="flex gap-2 pt-2">
                        <button type="button" onclick="toggleEditMode(false)" class="flex-1 py-2.5 border border-gray-300 rounded-sm text-sm font-bold text-gray-600 hover:bg-gray-50">취소</button>
                        <button type="submit" class="flex-1 py-2.5 bg-primary-600 text-white rounded-sm text-sm font-bold hover:bg-primary-700">저장</button>
                    </div>
                </form>
            </div>
        </div>

        <div id="tab-PURCHASES" class="tab-content hidden">
            <div class="space-y-4">
                <h2 class="text-xl font-bold text-gray-900 mb-6">구매 내역</h2>
                <div class="bg-white p-5 rounded-lg border border-gray-200 flex gap-4 items-center">
                    <div class="w-16 h-20 bg-gray-100 rounded border border-gray-100 flex items-center justify-center text-gray-400">
                        <i data-lucide="book" class="w-6 h-6"></i>
                    </div>
                    <div class="flex-1">
                        <div class="flex justify-between mb-1">
                            <span class="text-xs font-bold text-gray-500">2024.05.20</span>
                            <span class="text-xs font-bold px-2 py-0.5 rounded bg-primary-50 text-primary-600">배송중</span>
                        </div>
                        <h3 class="font-bold text-gray-900 mb-1">트렌드 코리아 2025</h3>
                        <p class="text-sm text-gray-700">20,000원</p>
                    </div>
                    <button class="text-xs bg-primary-600 text-white px-3 py-2 rounded font-bold hover:bg-primary-700">구매확정</button>
                </div>
            </div>
        </div>

        <div id="tab-SALES" class="tab-content hidden">
            <div class="space-y-4">
                <h2 class="text-xl font-bold text-gray-900 mb-6">판매 내역</h2>
                <div class="bg-white p-5 rounded-lg border border-gray-200 flex gap-4 items-center">
                    <div class="w-16 h-20 bg-gray-100 rounded border border-gray-100 flex items-center justify-center text-gray-400">
                        <i data-lucide="book" class="w-6 h-6"></i>
                    </div>
                    <div class="flex-1">
                        <div class="flex justify-between mb-1">
                            <span class="text-xs font-bold text-gray-500">2024.05.01</span>
                            <span class="text-xs font-bold px-2 py-0.5 rounded bg-gray-800 text-white">판매완료</span>
                        </div>
                        <h3 class="font-bold text-gray-900 mb-1">클린 코드 (Clean Code)</h3>
                        <p class="text-sm text-gray-700">25,000원</p>
                    </div>
                    <button class="text-xs border border-gray-300 px-3 py-2 rounded font-bold hover:bg-gray-50">상세보기</button>
                </div>
            </div>
        </div>

        <div id="tab-WISHLIST" class="tab-content hidden">
            <h2 class="text-xl font-bold text-gray-900 mb-6">찜한 상품</h2>
            <div class="text-center py-12 bg-white border border-gray-200 border-dashed rounded-lg text-gray-500 text-sm">
                찜한 상품이 없습니다.
            </div>
        </div>

        <div id="tab-GROUPS" class="tab-content hidden">
            <div class="space-y-10">
                <div>
                    <h2 class="text-xl font-bold text-gray-900 mb-4">내가 만든 모임</h2>
                    <div class="text-center py-8 bg-gray-50 border border-gray-100 rounded-lg text-gray-400 text-sm mb-4">
                        만든 모임이 없습니다.
                        <a href="/readingGroups" class="text-primary-600 font-bold ml-2 hover:underline">모임 만들기</a>
                    </div>
                </div>
            </div>
        </div>

        <div id="tab-ADDRESSES" class="tab-content hidden">
            <div>
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-xl font-bold text-gray-900">배송지 관리</h2>
                    <button onclick="openAddressModal()" class="text-xs bg-gray-900 text-white px-3 py-2 rounded font-bold hover:bg-gray-800 flex items-center gap-1">
                        <i data-lucide="plus" class="w-3.5 h-3.5"></i> 새 배송지 추가
                    </button>
                </div>

                <div class="space-y-4" id="address-list">
                    <div class="p-5 rounded-lg border border-primary-500 bg-primary-50/10">
                        <div class="flex justify-between items-start mb-2">
                            <div class="flex items-center gap-2">
                                <span class="font-bold text-gray-900">우리집</span>
                                <span class="text-[10px] bg-primary-100 text-primary-600 px-1.5 py-0.5 rounded font-bold">기본</span>
                            </div>
                            <div class="flex items-center gap-2 text-xs text-gray-500">
                                <button onclick="openAddressModal('우리집', '${sessionScope.loginSess.member_nicknm}', '${sessionScope.loginSess.member_tel_no}', '서울 중구 세종대로 9길 20', '신한은행 본점')" class="hover:text-gray-900 hover:underline">수정</button>
                                <span class="text-gray-300">|</span>
                                <button class="hover:text-red-600 hover:underline">삭제</button>
                            </div>
                        </div>
                        <p class="text-sm text-gray-800 mb-1">서울 중구 세종대로 9길 20 신한은행 본점</p>
                        <p class="text-xs text-gray-500 mb-3">${sessionScope.loginSess.member_nicknm} · ${sessionScope.loginSess.member_tel_no}</p>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<div id="address-modal" class="hidden fixed inset-0 bg-black/50 backdrop-blur-sm items-center justify-center z-50 p-4 flex">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-md p-6 relative">
        <div class="flex justify-between items-center mb-6">
            <h3 class="text-lg font-bold" id="modal-title">새 배송지 추가</h3>
            <button onclick="closeAddressModal()"><i data-lucide="x" class="w-5 h-5 text-gray-400"></i></button>
        </div>

        <div class="space-y-4">
            <div>
                <label class="block text-xs font-bold text-gray-600 mb-1">배송지명</label>
                <input type="text" id="addr-name" placeholder="예: 우리집, 회사" class="w-full border border-gray-300 rounded p-2.5 text-sm outline-none focus:border-primary-500" />
            </div>
            <div class="grid grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-bold text-gray-600 mb-1">받는 사람</label>
                    <input type="text" id="addr-recipient" class="w-full border border-gray-300 rounded p-2.5 text-sm outline-none focus:border-primary-500" />
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-600 mb-1">연락처</label>
                    <input type="text" id="addr-phone" placeholder="010-0000-0000" class="w-full border border-gray-300 rounded p-2.5 text-sm outline-none focus:border-primary-500" />
                </div>
            </div>
            <div>
                <label class="block text-xs font-bold text-gray-600 mb-1">주소</label>
                <div class="flex gap-2 mb-2">
                    <input type="text" id="addr-address" placeholder="주소 검색" readonly class="flex-1 border border-gray-300 rounded p-2.5 text-sm bg-white outline-none focus:border-primary-500" />
                    <button onclick="execDaumPostcode()" class="bg-gray-800 text-white text-xs px-3 rounded font-bold whitespace-nowrap hover:bg-gray-900">검색</button>
                </div>
                <input type="text" id="addr-detail" placeholder="상세 주소 입력" class="w-full border border-gray-300 rounded p-2.5 text-sm outline-none focus:border-primary-500" />
            </div>
            <button onclick="saveAddress()" class="w-full bg-primary-600 text-white py-3 rounded font-bold text-sm hover:bg-primary-700 mt-4">저장하기</button>
        </div>
    </div>
</div>

<script>
    // 1. Lucide 아이콘 초기화
    lucide.createIcons();

    // 2. 탭 전환 기능
    function showTab(tabId, btn) {
        // 모든 탭 숨기기
        $('.tab-content').addClass('hidden');
        // 선택한 탭 보이기
        $('#tab-' + tabId).removeClass('hidden');

        // 모든 버튼 스타일 초기화
        $('.nav-btn').removeClass('bg-primary-50 text-primary-600').addClass('text-gray-600 hover:bg-gray-50 hover:text-gray-900');
        // 선택한 버튼 아이콘 색상 초기화
        $('.nav-btn i').addClass('text-gray-400').removeClass('text-primary-600');

        // 선택한 버튼 스타일 적용
        $(btn).removeClass('text-gray-600 hover:bg-gray-50 hover:text-gray-900').addClass('bg-primary-50 text-primary-600');
        $(btn).find('i').removeClass('text-gray-400').addClass('text-primary-600');

        // 아이콘 다시 렌더링 (동적 클래스 변경 반영)
        lucide.createIcons();
    }

    // 3. 프로필 수정 모드 토글
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

    // 4. 회원 탈퇴
    function handleDeleteAccount() {
        if (confirm('정말 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
            location.href = '/member/delete'; // 탈퇴 로직 호출
        }
    }

    // 5. 배송지 모달 제어
    function openAddressModal(name = '', recipient = '', phone = '', address = '', detail = '') {
        $('#modal-title').text(name ? '배송지 수정' : '새 배송지 추가');
        $('#addr-name').val(name);
        $('#addr-recipient').val(recipient);
        $('#addr-phone').val(phone);
        $('#addr-address').val(address);
        $('#addr-detail').val(detail);

        $('#address-modal').removeClass('hidden');
    }

    function closeAddressModal() {
        $('#address-modal').addClass('hidden');
    }

    // 6. 다음 주소 API
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = data.roadAddress; // 도로명 주소
                if(data.userSelectedType === 'R'){
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        // 법정동명이 있을 경우 추가
                    }
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        addr += ' (' + data.buildingName + ')';
                    }
                }
                $('#addr-address').val(addr);
                $('#addr-detail').focus();
            }
        }).open();
    }

    function saveAddress() {
        $.ajax({
            url: "/member/"
        })
        alert('저장되었습니다 (UI 데모)');
        closeAddressModal();
    }
</script>

<jsp:include page="../common/footer.jsp" />