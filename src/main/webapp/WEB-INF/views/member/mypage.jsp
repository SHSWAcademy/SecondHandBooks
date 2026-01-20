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
                <a href="/mypage/profile"
                   class="nav-btn block w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all
                          ${currentTab == 'profile' ? 'bg-primary-50 text-primary-600' : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'}">
                    <i data-lucide="user" class="w-4 h-4"></i> 내 프로필
                </a>

                <a href="/mypage/purchases"
                   class="nav-btn block w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all
                          ${currentTab == 'purchases' ? 'bg-primary-50 text-primary-600' : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'}">
                    <i data-lucide="shopping-bag" class="w-4 h-4"></i> 구매 내역
                </a>

                <a href="/mypage/sales"
                   class="nav-btn block w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all
                          ${currentTab == 'sales' ? 'bg-primary-50 text-primary-600' : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'}">
                    <i data-lucide="package" class="w-4 h-4"></i> 판매 내역
                </a>

                <a href="/mypage/wishlist"
                   class="nav-btn block w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all
                          ${currentTab == 'wishlist' ? 'bg-primary-50 text-primary-600' : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'}">
                    <i data-lucide="heart" class="w-4 h-4"></i> 찜한 상품
                </a>

                <a href="/mypage/groups"
                   class="nav-btn block w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all
                          ${currentTab == 'groups' ? 'bg-primary-50 text-primary-600' : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'}">
                    <i data-lucide="users" class="w-4 h-4"></i> 내 모임
                </a>

                <a href="/mypage/addresses"
                   class="nav-btn block w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all
                          ${currentTab == 'addresses' ? 'bg-primary-50 text-primary-600' : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'}">
                    <i data-lucide="map-pin" class="w-4 h-4"></i> 배송지 관리
                </a>
            </nav>

            <div class="p-4 border-t border-gray-100">
                <button onclick="location.href='/logout'"
                        class="w-full flex items-center justify-center gap-2 text-xs font-bold text-gray-500 hover:text-red-600 py-2 transition">
                    <i data-lucide="log-out" class="w-3.5 h-3.5"></i> 로그아웃
                </button>
            </div>
        </div>
    </div>

    <div class="lg:flex-1 min-h-[500px]">
        <c:choose>
            <c:when test="${currentTab == 'profile'}">
                <jsp:include page="tabs/profile.jsp" />
            </c:when>

            <c:when test="${currentTab == 'purchases'}">
                <jsp:include page="tabs/purchases.jsp" />
            </c:when>

            <c:when test="${currentTab == 'sales'}">
                <jsp:include page="tabs/sales.jsp" />
            </c:when>

            <c:when test="${currentTab == 'wishlist'}">
                <jsp:include page="tabs/wishlist.jsp" />
            </c:when>

            <c:when test="${currentTab == 'groups'}">
                <jsp:include page="tabs/groups.jsp" />
            </c:when>

            <c:when test="${currentTab == 'addresses'}">
                <jsp:include page="tabs/addresses.jsp" />
            </c:when>

            <c:otherwise>
                <!-- 기본값 -->
                <jsp:include page="tabs/profile.jsp" />
            </c:otherwise>
        </c:choose>
    </div>

</div>

<script>
    lucide.createIcons();
</script>

<jsp:include page="../common/footer.jsp" />