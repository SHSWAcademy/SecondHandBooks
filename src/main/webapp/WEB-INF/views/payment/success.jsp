<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="min-h-[calc(100vh-200px)] flex items-center justify-center">
    <div class="w-full max-w-lg">
        <!-- 결제 완료 카드 -->
        <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
            <!-- 성공 아이콘 -->
            <div class="pt-10 pb-6 text-center bg-gradient-to-b from-green-50 to-white">
                <div class="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#22c55e" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 6 9 17l-5-5"/>
                    </svg>
                </div>
                <h1 class="text-2xl font-bold text-gray-900">결제가 완료되었습니다</h1>
                <p class="text-sm text-gray-500 mt-2">주문이 정상적으로 접수되었습니다</p>
            </div>

            <!-- 결제 정보 -->
            <div class="px-6 py-6 border-t border-gray-100">
                <h3 class="text-sm font-bold text-gray-700 mb-4 flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-primary-500">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                        <polyline points="14 2 14 8 20 8"/>
                        <line x1="16" y1="13" x2="8" y2="13"/>
                        <line x1="16" y1="17" x2="8" y2="17"/>
                        <polyline points="10 9 9 9 8 9"/>
                    </svg>
                    결제 정보
                </h3>

                <div class="space-y-3">

                    <div class="flex justify-between items-center py-2 border-b border-gray-50">
                        <span class="text-sm text-gray-500">결제수단</span>
                        <span class="text-sm font-medium text-gray-900">${payment.method}</span>
                    </div>
                    <c:if test="${not empty payment.card_company}">
                        <div class="flex justify-between items-center py-2 border-b border-gray-50">
                            <span class="text-sm text-gray-500">카드정보</span>
                            <span class="text-sm font-medium text-gray-900">${payment.card_company} ${payment.card_number}</span>
                        </div>
                    </c:if>
                    <div class="flex justify-between items-center py-2 border-b border-gray-50">
                        <span class="text-sm text-gray-500">결제상태</span>
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                            결제완료
                        </span>
                    </div>
                    <div class="flex justify-between items-center pt-3">
                        <span class="text-base font-bold text-gray-900">결제금액</span>
                        <span class="text-xl font-bold text-primary-600">
                            <fmt:formatNumber value="${payment.amount}" type="number"/>원
                        </span>
                    </div>
                </div>
            </div>

            <!-- 버튼 영역 -->
            <div class="px-6 pb-6 flex gap-3">
                <a href="/" class="flex-1 py-3 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-xl font-semibold text-sm text-center transition-all">
                    홈으로
                </a>
                <a href="/mypage/orders" class="flex-1 py-3 bg-primary-500 hover:bg-primary-600 text-white rounded-xl font-semibold text-sm text-center transition-all shadow-sm hover:shadow-md">
                    주문내역 보기
                </a>
            </div>
        </div>

        <!-- 안내 문구 -->
        <p class="text-center text-xs text-gray-400 mt-4">
            주문 관련 문의는 마이페이지에서 확인하실 수 있습니다
        </p>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
