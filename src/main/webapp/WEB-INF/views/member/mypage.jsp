<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../common/header.jsp" />
<script src="https://unpkg.com/lucide@latest"></script>

<div class="flex flex-col lg:flex-row gap-8 max-w-6xl mx-auto min-h-[600px]">

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
                <button onclick="loadTab('INFO', this)" class="nav-btn w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all bg-primary-50 text-primary-600" id="btn-INFO">
                    <i data-lucide="user" class="w-4 h-4"></i> 내 프로필
                </button>
                <button onclick="loadTab('PURCHASES', this)" class="nav-btn w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all text-gray-600 hover:bg-gray-50 hover:text-gray-900">
                    <i data-lucide="shopping-bag" class="w-4 h-4"></i> 구매 내역
                </button>
                <button onclick="loadTab('SALES', this)" class="nav-btn w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all text-gray-600 hover:bg-gray-50 hover:text-gray-900">
                    <i data-lucide="package" class="w-4 h-4"></i> 판매 내역
                </button>
                <button onclick="loadTab('WISHLIST', this)" class="nav-btn w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all text-gray-600 hover:bg-gray-50 hover:text-gray-900">
                    <i data-lucide="heart" class="w-4 h-4"></i> 찜한 상품
                </button>
                <button onclick="loadTab('GROUPS', this)" class="nav-btn w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all text-gray-600 hover:bg-gray-50 hover:text-gray-900">
                    <i data-lucide="users" class="w-4 h-4"></i> 내 모임
                </button>
                <button onclick="loadTab('ADDRESSES', this)" class="nav-btn w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all text-gray-600 hover:bg-gray-50 hover:text-gray-900">
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

    <div class="lg:flex-1" id="tab-content-area">
    </div>

</div>

<script>
    // 페이지 로드 시 기본 탭(내 프로필) 로드
    $(document).ready(function() {
        loadTab('INFO', $('#btn-INFO'));
    });

    function loadTab(tabName, btn) {
        // 1. 버튼 스타일 활성화
        $('.nav-btn').removeClass('bg-primary-50 text-primary-600').addClass('text-gray-600 hover:bg-gray-50 hover:text-gray-900');
        $('.nav-btn i').addClass('text-gray-400').removeClass('text-primary-600');

        $(btn).removeClass('text-gray-600 hover:bg-gray-50 hover:text-gray-900').addClass('bg-primary-50 text-primary-600');
        $(btn).find('i').removeClass('text-gray-400').addClass('text-primary-600');
        lucide.createIcons();

        // 2. 컨텐츠 로드 (URL 매핑 필요)
        let url = '';
        if (tabName === 'INFO') url = '/member/tab/profile'; // 프로필 정보 (아직 안 만드셨으면 임시)
        else if (tabName === 'ADDRESSES') url = '/profile/tab/addresses'; // 배송지 관리
        // ... 나머지 탭 URL ...

        if(url) {
            $('#tab-content-area').html('<div class="text-center py-20"><span class="loading">로딩중...</span></div>');
            $('#tab-content-area').load(url, function() {
                lucide.createIcons(); // 아이콘 다시 렌더링
            });
        }
    }
</script>

<jsp:include page="../common/footer.jsp" />