<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<script src="https://js.tosspayments.com/v1/payment"></script>

<div class="min-h-[calc(100vh-200px)]">
    <!-- 페이지 헤더 -->
    <div class="mb-8">
        <h1 class="text-2xl font-bold text-gray-900">결제하기</h1>
        <p class="text-sm text-gray-500 mt-1">주문 정보를 확인하고 결제를 진행해주세요</p>
    </div>

    <div class="flex gap-8">
        <!-- 왼쪽: 구매자 정보, 배송지, 결제수단 -->
        <div class="flex-1 space-y-6">
            <!-- 1. 구매자 정보 -->
            <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-100 bg-gray-50">
                    <h3 class="font-bold text-gray-800 flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-primary-500"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        구매자 정보
                    </h3>
                </div>
                <div class="p-6">
                    <div class="grid grid-cols-3 gap-6">
                        <div>
                            <label class="block text-xs font-medium text-gray-500 mb-1">이름</label>
                            <p class="text-sm font-semibold text-gray-900">${sessionScope.loginSess.member_nicknm}</p>
                        </div>
                        <div>
                            <label class="block text-xs font-medium text-gray-500 mb-1">이메일</label>
                            <p class="text-sm font-semibold text-gray-900">${sessionScope.loginSess.member_email}</p>
                        </div>
                        <div>
                            <label class="block text-xs font-medium text-gray-500 mb-1">연락처</label>
                            <p class="text-sm font-semibold text-gray-900">${sessionScope.loginSess.member_tel_no}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 2. 배송지 정보 -->
            <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-100 bg-gray-50 flex items-center justify-between">
                    <h3 class="font-bold text-gray-800 flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-primary-500"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                        배송지 정보
                    </h3>
                    <c:if test="${not empty addressList}">
                        <button type="button" onclick="toggleAddressModal()" class="text-sm text-primary-600 hover:text-primary-700 font-medium flex items-center gap-1">
                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"/></svg>
                            배송지 변경
                        </button>
                    </c:if>
                </div>
                <div class="p-6">
                    <c:set var="hasDefaultAddress" value="false" />
                    <c:forEach var="addr" items="${addressList}">
                        <c:if test="${addr.default_yn == 1}">
                            <c:set var="hasDefaultAddress" value="true" />
                            <c:set var="defaultAddress" value="${addr}" />
                        </c:if>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${hasDefaultAddress}">
                            <div id="selectedAddress" class="space-y-2">
                                <div class="flex items-center gap-2">
                                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-primary-50 text-primary-700">기본 배송지</span>
                                    <span class="text-sm font-semibold text-gray-900" id="addrName">${defaultAddress.addr_nm}</span>
                                </div>
                                <p class="text-sm text-gray-600">
                                    <span id="addrPostNo">[${defaultAddress.post_no}]</span>
                                    <span id="addrH">${defaultAddress.addr_h}</span>
                                    <span id="addrD">${defaultAddress.addr_d}</span>
                                </p>
                                <input type="hidden" id="selectedAddrSeq" value="${defaultAddress.addr_seq}">
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-6 text-gray-400">
                                <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="mx-auto mb-2 text-gray-300"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                                <p class="text-sm">등록된 배송지가 없습니다</p>
                                <a href="/profile" class="text-sm text-primary-600 hover:underline mt-2 inline-block">배송지 등록하기</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- 3. 결제 수단 -->
            <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-100 bg-gray-50">
                    <h3 class="font-bold text-gray-800 flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-primary-500"><rect width="20" height="14" x="2" y="5" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></svg>
                        결제 수단
                    </h3>
                </div>
                <div class="p-6">
                    <div class="flex items-center gap-3 p-4 bg-blue-50 rounded-xl border border-blue-100">
                        <div class="w-10 h-10 bg-blue-500 rounded-lg flex items-center justify-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10"/><path d="m9 12 2 2 4-4"/></svg>
                        </div>
                        <div>
                            <p class="font-bold text-gray-900">토스 안전 결제</p>
                            <p class="text-xs text-gray-500">안전하고 빠른 결제를 제공합니다</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 오른쪽: 결제 상세 (책 정보) -->
        <div class="w-96 flex-shrink-0">
            <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden sticky top-24">
                <div class="px-5 py-4 border-b border-gray-100 bg-gray-50">
                    <h3 class="font-bold text-gray-800 flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-primary-500"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
                        결제 상세
                    </h3>
                </div>

                <div class="p-5">
                    <!-- 책 정보 (작은 화면) -->
                    <div class="flex gap-4 pb-5 border-b border-gray-100">
                        <div class="w-20 h-28 bg-gray-100 rounded-lg overflow-hidden flex-shrink-0">
                            <img src="${trade.book_img}" alt="${trade.book_title}" class="w-full h-full object-cover">
                        </div>
                        <div class="flex-1 min-w-0">
                            <h4 class="font-semibold text-gray-900 text-sm line-clamp-2">${trade.book_title}</h4>
                            <p class="text-xs text-gray-500 mt-1">${trade.book_author}</p>
                        </div>
                    </div>

                    <!-- 가격 정보 -->
                    <div class="pt-5 space-y-3">
                        <div class="flex justify-between items-center">
                            <span class="text-sm text-gray-600">책 가격</span>
                            <span class="text-sm font-medium text-gray-900">
                                <fmt:formatNumber value="${trade.sale_price}" type="number"/>원
                            </span>
                        </div>
                        <div class="flex justify-between items-center">
                            <span class="text-sm text-gray-600">배송비</span>
                            <span class="text-sm font-medium text-gray-900">
                                <fmt:formatNumber value="${trade.delivery_cost}" type="number"/>원
                            </span>
                        </div>
                        <div class="border-t border-gray-200 pt-3 mt-3">
                            <div class="flex justify-between items-center">
                                <span class="text-base font-bold text-gray-900">총 결제금액</span>
                                <span class="text-xl font-bold text-primary-600">
                                    <fmt:formatNumber value="${trade.sale_price + trade.delivery_cost}" type="number"/>원
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 동의 체크박스 -->
                <div class="px-5 pb-4">
                    <label class="flex items-start gap-3 cursor-pointer group">
                        <div class="relative flex items-center justify-center">
                            <input type="checkbox" id="agreeCheckbox" class="peer sr-only">
                            <div class="w-5 h-5 border-2 border-gray-300 rounded transition-all peer-checked:border-primary-500 peer-checked:bg-primary-500 group-hover:border-primary-400">
                                <svg class="w-full h-full text-white opacity-0 peer-checked:opacity-100 p-0.5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                            </div>
                        </div>
                        <span class="text-sm text-gray-600 leading-tight">
                            주문 내용을 확인하였으며, 정보 제공 등에 동의합니다.
                            <span class="text-red-500 font-medium">(필수)</span>
                        </span>
                    </label>
                    <p id="agreeError" class="hidden text-xs text-red-500 mt-2 ml-8">결제를 진행하려면 동의가 필요합니다.</p>
                </div>

                <!-- 결제 버튼 -->
                <div class="p-5 pt-0">
                    <button type="button" id="payBtn" class="w-full py-4 bg-gray-300 text-gray-500 rounded-xl font-bold text-lg transition-all cursor-not-allowed flex items-center justify-center gap-2" disabled>
                        <fmt:formatNumber value="${trade.sale_price + trade.delivery_cost}" type="number"/>원 결제하기
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 배송지 변경 모달 -->
<div id="addressModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden items-center justify-center">
    <div class="bg-white rounded-2xl w-full max-w-md mx-4 overflow-hidden shadow-xl">
        <div class="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
            <h3 class="font-bold text-gray-900">배송지 변경</h3>
            <button type="button" onclick="toggleAddressModal()" class="text-gray-400 hover:text-gray-600">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
            </button>
        </div>
        <div class="p-6 max-h-80 overflow-y-auto space-y-3">
            <c:forEach var="addr" items="${addressList}">
                <div class="p-4 border border-gray-200 rounded-xl cursor-pointer hover:border-primary-300 hover:bg-primary-50 transition-all address-item ${addr.default_yn == 1 ? 'border-primary-500 bg-primary-50' : ''}"
                     data-addr-seq="${addr.addr_seq}"
                     data-addr-nm="${addr.addr_nm}"
                     data-post-no="${addr.post_no}"
                     data-addr-h="${addr.addr_h}"
                     data-addr-d="${addr.addr_d}"
                     data-default="${addr.default_yn}">
                    <div class="flex items-center gap-2 mb-1">
                        <span class="font-semibold text-gray-900 text-sm">${addr.addr_nm}</span>
                        <c:if test="${addr.default_yn == 1}">
                            <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-primary-100 text-primary-700">기본</span>
                        </c:if>
                    </div>
                    <p class="text-sm text-gray-600">[${addr.post_no}] ${addr.addr_h} ${addr.addr_d}</p>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
    // 토스 결제
    const clientKey = "test_ck_KNbdOvk5rka22P9eoqA43n07xlzm";
    const tossPayments = TossPayments(clientKey);

    const salePrice = Number("${trade.sale_price}");
    const deliveryCost = Number("${trade.delivery_cost}");
    const totalAmount = salePrice + deliveryCost;
    const memberNicknm = "${sessionScope.loginSess.member_nicknm}";
    const bookTitle = "${trade.book_title}";
    const tradeSeq = "${trade.trade_seq}";

    // 현재 도메인 기준 URL 생성
    const baseUrl = window.location.origin;

    const payBtn = document.getElementById('payBtn');
    const agreeCheckbox = document.getElementById('agreeCheckbox');
    const agreeError = document.getElementById('agreeError');

    // 체크박스 상태에 따라 버튼 활성화/비활성화
    agreeCheckbox.addEventListener('change', function() {
        if (this.checked) {
            payBtn.disabled = false;
            payBtn.classList.remove('bg-gray-300', 'text-gray-500', 'cursor-not-allowed');
            payBtn.classList.add('bg-primary-500', 'hover:bg-primary-600', 'text-white', 'shadow-sm', 'hover:shadow-md');
            agreeError.classList.add('hidden');
        } else {
            payBtn.disabled = true;
            payBtn.classList.add('bg-gray-300', 'text-gray-500', 'cursor-not-allowed');
            payBtn.classList.remove('bg-primary-500', 'hover:bg-primary-600', 'text-white', 'shadow-sm', 'hover:shadow-md');
        }
    });

    payBtn.addEventListener('click', function() {
        if (!agreeCheckbox.checked) {
            agreeError.classList.remove('hidden');
            return;
        }

        tossPayments.requestPayment("토스페이", {
            amount: totalAmount,
            orderId: "ORDER_" + tradeSeq + "_" + new Date().getTime(),
            orderName: bookTitle,
            customerName: memberNicknm,
            successUrl: baseUrl + "/payments/success?trade_seq=" + tradeSeq,
            failUrl: baseUrl + "/payments/fail?trade_seq=" + tradeSeq
        }).catch(function(error) {
            if (error.code === "USER_CANCEL") {
                // 사용자가 결제창을 닫음
            } else {
                alert(error.message);
            }
        });
    });

    // 배송지 모달
    function toggleAddressModal() {
        const modal = document.getElementById('addressModal');
        if (modal.classList.contains('hidden')) {
            modal.classList.remove('hidden');
            modal.classList.add('flex');
        } else {
            modal.classList.add('hidden');
            modal.classList.remove('flex');
        }
    }

    // 배송지 선택
    document.querySelectorAll('.address-item').forEach(item => {
        item.addEventListener('click', function() {
            const addrSeq = this.dataset.addrSeq;
            const addrNm = this.dataset.addrNm;
            const postNo = this.dataset.postNo;
            const addrH = this.dataset.addrH;
            const addrD = this.dataset.addrD;

            document.getElementById('addrName').textContent = addrNm;
            document.getElementById('addrPostNo').textContent = '[' + postNo + ']';
            document.getElementById('addrH').textContent = addrH;
            document.getElementById('addrD').textContent = addrD;
            document.getElementById('selectedAddrSeq').value = addrSeq;

            toggleAddressModal();
        });
    });

    // 모달 바깥 클릭 시 닫기
    document.getElementById('addressModal').addEventListener('click', function(e) {
        if (e.target === this) {
            toggleAddressModal();
        }
    });
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
