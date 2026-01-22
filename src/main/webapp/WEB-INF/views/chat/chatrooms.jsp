<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.time.LocalDateTime, java.util.Date, project.chat.message.MessageVO" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script>
    const loginMemberSeq = Number("${sessionScope.loginSess.member_seq}");
    let chat_room_seq = Number("${trade_chat_room.chat_room_seq}");
    let trade_seq = Number("${trade_chat_room.trade_seq}");
    let member_seller_seq = Number("${trade_info.member_seller_seq}");
    let isSeller = (loginMemberSeq === member_seller_seq);

    // trade 정보 (안전결제용)
    let currentTradeInfo = {
        trade_seq: Number("${trade_info.trade_seq}") || 0,
        book_img: "${trade_info.book_img}",
        book_title: "${trade_info.book_title}",
        sale_price: Number("${trade_info.sale_price}") || 0,
        delivery_cost: Number("${trade_info.delivery_cost}") || 0,
        book_st: "${trade_info.book_st}"
    };
</script>

<style>
    /* 채팅방 리스트 아이템 */
    .chatroom-item.active {
        background-color: #eef4ff;
        border-left-color: #0046FF;
    }

    /* 스크롤바 */
    #chatContainer::-webkit-scrollbar,
    #chatroomsList::-webkit-scrollbar {
        width: 6px;
    }
    #chatContainer::-webkit-scrollbar-track,
    #chatroomsList::-webkit-scrollbar-track {
        background: #f1f3f5;
    }
    #chatContainer::-webkit-scrollbar-thumb,
    #chatroomsList::-webkit-scrollbar-thumb {
        background: #ced4da;
        border-radius: 3px;
    }

    /* 메시지 정렬 */
    .msg-left,
    .msg-right {
        display: flex;
        flex-direction: column;
        max-width: 70%;
        margin: 12px 0;
    }
    .msg-left {
        align-items: flex-start;
        margin-right: auto;
    }
    .msg-right {
        align-items: flex-end;
        margin-left: auto;
    }

    /* 말풍선 */
    .msg-left .content {
        background: #fff;
        border: 1px solid #e9ecef;
        color: #212529;
        border-radius: 16px;
        border-top-left-radius: 4px;
    }
    .msg-right .content {
        background: #0046FF;
        color: #fff;
        border-radius: 16px;
        border-top-right-radius: 4px;
    }
    .content {
        padding: 10px 14px;
        font-size: 14px;
        line-height: 1.5;
        word-break: break-word;
        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    }

    /* 시간 표시 */
    .msg-time {
        font-size: 10px;
        color: #868e96;
        margin-top: 4px;
        display: flex;
        align-items: center;
        gap: 4px;
    }

    /* + 버튼 및 안전결제 메뉴 */
    .plus-btn-wrapper {
        position: relative;
    }
    .plus-btn {
        width: 44px;
        height: 44px;
        border-radius: 12px;
        background: #f1f3f5;
        border: 1px solid #e9ecef;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.2s;
    }
    .plus-btn:hover {
        background: #e9ecef;
    }
    .plus-menu {
        position: absolute;
        bottom: 54px;
        left: 0;
        background: #fff;
        border: 1px solid #e9ecef;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        padding: 8px 0;
        min-width: 180px;
        display: none;
        z-index: 100;
    }
    .plus-menu.show {
        display: block;
    }
    .plus-menu-item {
        padding: 10px 16px;
        cursor: pointer;
        font-size: 14px;
        color: #212529;
        transition: background 0.2s;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .plus-menu-item:hover {
        background: #f8f9fa;
    }

    /* 안전결제 요청 카드 */
    .safe-payment-card {
        background: linear-gradient(135deg, #f8f9fa 0%, #fff 100%);
        border: 1px solid #e9ecef;
        border-radius: 16px;
        padding: 16px;
        max-width: 280px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    }
    .safe-payment-card .card-header {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 12px;
        padding-bottom: 12px;
        border-bottom: 1px solid #e9ecef;
    }
    .safe-payment-card .card-header svg {
        color: #0046FF;
    }
    .safe-payment-card .card-title {
        font-weight: 700;
        font-size: 14px;
        color: #212529;
    }
    .safe-payment-card .timer {
        font-size: 12px;
        color: #fa5252;
        font-weight: 600;
    }
    .safe-payment-card .product-info {
        display: flex;
        gap: 12px;
        margin-bottom: 12px;
    }
    .safe-payment-card .product-img {
        width: 60px;
        height: 80px;
        border-radius: 8px;
        object-fit: cover;
        background: #f1f3f5;
    }
    .safe-payment-card .product-detail {
        flex: 1;
        min-width: 0;
    }
    .safe-payment-card .product-title {
        font-size: 13px;
        font-weight: 600;
        color: #212529;
        margin-bottom: 4px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }
    .safe-payment-card .product-status {
        font-size: 11px;
        color: #868e96;
        margin-bottom: 6px;
    }
    .safe-payment-card .product-price {
        font-size: 14px;
        font-weight: 700;
        color: #0046FF;
    }
    .safe-payment-card .product-delivery {
        font-size: 11px;
        color: #868e96;
        margin-top: 2px;
    }
    .safe-payment-card .action-btn {
        width: 100%;
        padding: 10px 16px;
        border-radius: 10px;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
        border: none;
    }
    .safe-payment-card .action-btn.primary {
        background: #0046FF;
        color: #fff;
    }
    .safe-payment-card .action-btn.primary:hover {
        background: #0039d1;
    }
    .safe-payment-card .action-btn:disabled {
        background: #ced4da;
        cursor: not-allowed;
    }
    .safe-payment-card .expired-notice {
        text-align: center;
        font-size: 12px;
        color: #868e96;
        padding: 10px;
    }
</style>

<div class="min-h-[calc(100vh-200px)]">
    <!-- 페이지 헤더 -->
    <div class="mb-6">
        <h1 class="text-2xl font-bold text-gray-900">채팅</h1>
        <p class="text-sm text-gray-500 mt-1">거래 관련 대화를 나눠보세요</p>
    </div>

    <div class="flex gap-6 h-[600px]">
        <!-- 왼쪽 채팅방 리스트 -->
        <div class="w-80 bg-white rounded-2xl border border-gray-200 shadow-sm flex flex-col overflow-hidden">
            <div class="px-5 py-4 border-b border-gray-100 bg-gray-50">
                <h3 class="font-bold text-gray-800 flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-primary-500"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                    내 채팅방
                    <span class="ml-auto text-xs font-medium text-gray-400 bg-gray-200 px-2 py-0.5 rounded-full">${chatrooms.size()}</span>
                </h3>
            </div>

            <div id="chatroomsList" class="flex-1 overflow-y-auto">
                <c:choose>
                    <c:when test="${not empty chatrooms}">
                        <c:forEach var="room" items="${chatrooms}">
                            <div class="chatroom-item px-5 py-4 border-b border-gray-100 cursor-pointer transition-all hover:bg-gray-50 border-l-4 border-l-transparent ${room.chat_room_seq == trade_chat_room.chat_room_seq ? 'active' : ''}"
                                 data-chat-room-seq="${room.chat_room_seq}">
                                <div class="flex items-start gap-3">
                                    <div class="w-10 h-10 bg-primary-50 rounded-lg flex items-center justify-center flex-shrink-0">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-primary-500"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20"/></svg>
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <div class="font-semibold text-gray-900 text-sm truncate">${room.sale_title}</div>
                                        <div class="text-xs text-gray-500 mt-1 truncate">
                                            <c:choose>
                                                <c:when test="${not empty room.last_msg}">${room.last_msg}</c:when>
                                                <c:otherwise><span class="text-gray-400 italic">아직 메시지가 없습니다</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="flex flex-col items-center justify-center h-full py-12 text-gray-400">
                            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="mb-3 text-gray-300"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                            <p class="text-sm">채팅방이 없습니다</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 오른쪽 채팅 영역 -->
        <div id="chatArea" class="flex-1 bg-white rounded-2xl border border-gray-200 shadow-sm flex flex-col overflow-hidden">
            <!-- 채팅 헤더 -->
            <div id="chatHeader" class="px-6 py-4 border-b border-gray-100 bg-white">
                <c:choose>
                    <c:when test="${not empty trade_chat_room}">
                        <c:forEach var="room" items="${chatrooms}">
                            <c:if test="${room.chat_room_seq == trade_chat_room.chat_room_seq}">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 bg-primary-50 rounded-lg flex items-center justify-center">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-primary-500"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20"/></svg>
                                    </div>
                                    <div>
                                        <h4 class="font-bold text-gray-900">${room.sale_title}</h4>
                                        <p class="text-xs text-gray-500">거래 채팅</p>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 bg-gray-100 rounded-lg flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="text-gray-400"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                            </div>
                            <h4 class="font-medium text-gray-500">채팅방을 선택해주세요</h4>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 채팅 메시지 영역 -->
            <div id="chatContainer" class="flex-1 overflow-y-auto px-6 py-4 bg-gray-50">
                <c:choose>
                    <c:when test="${not empty messages}">
                        <c:forEach var="msg" items="${messages}">
                            <div class="${msg.sender_seq == sessionScope.loginSess.member_seq ? 'msg-right' : 'msg-left'}">
                                <div class="content">${msg.chat_cont}</div>
                                <div class="msg-time">
                                    <%
                                        Object obj = pageContext.findAttribute("msg");
                                        if(obj != null) {
                                            MessageVO message = (MessageVO) obj;
                                            LocalDateTime ldt = message.getSent_dtm();
                                            Date date = null;
                                            if(ldt != null) {
                                                date = Date.from(ldt.atZone(java.time.ZoneId.systemDefault()).toInstant());
                                            }
                                    %>
                                    <fmt:formatDate value="<%=date%>" pattern="yyyy/MM/dd HH:mm"/>
                                    <%
                                        }
                                    %>
                                    <c:if test="${msg.read_yn}">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#0046FF" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div id="emptyNotice" class="flex flex-col items-center justify-center h-full text-gray-400">
                            <svg xmlns="http://www.w3.org/2000/svg" width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="mb-4 text-gray-300"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                            <p class="text-sm font-medium">이전 메시지가 없습니다</p>
                            <p class="text-xs text-gray-400 mt-1">첫 메시지를 보내보세요!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 메시지 입력 영역 -->
            <div id="messageInputArea" class="px-6 py-4 border-t border-gray-100 bg-white">
                <div class="flex items-center gap-3">
                    <!-- + 버튼 (판매자에게만 보임) -->
                    <div class="plus-btn-wrapper" id="plusBtnWrapper" style="display: none;">
                        <button type="button" class="plus-btn" id="plusBtn">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#495057" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="12" y1="5" x2="12" y2="19"></line>
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                            </svg>
                        </button>
                        <div class="plus-menu" id="plusMenu">
                            <div class="plus-menu-item" id="safePaymentRequestBtn">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#0046FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect>
                                    <line x1="1" y1="10" x2="23" y2="10"></line>
                                </svg>
                                안전 결제 요청 보내기
                            </div>
                        </div>
                    </div>
                    <input type="text" id="message" placeholder="메시지를 입력하세요..."
                           class="flex-1 px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary-200 focus:border-primary-500 transition-all text-sm" />
                    <button id="sendBtn" class="px-5 py-3 bg-primary-500 hover:bg-primary-600 text-white rounded-xl font-semibold text-sm transition-all shadow-sm hover:shadow-md flex items-center gap-2">
                        전송
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/chat/chat.js"></script>

<script>
console.log('=== 안전결제 스크립트 로드 시작 ===');
console.log('chat.js fetchMessages 존재 여부:', typeof fetchMessages);

// =====================================================
// 안전결제 기능 스크립트
// =====================================================

// 타이머 관리 객체
const safePaymentTimers = {};

// 페이지 로드 시 판매자 여부에 따라 + 버튼 표시
document.addEventListener("DOMContentLoaded", function() {
    updatePlusButtonVisibility();
    setupPlusButtonEvents();
});

// + 버튼 표시/숨김 (판매자만 보임)
function updatePlusButtonVisibility() {
    const plusBtnWrapper = document.getElementById('plusBtnWrapper');
    console.log('=== updatePlusButtonVisibility ===');
    console.log('loginMemberSeq:', loginMemberSeq);
    console.log('member_seller_seq:', member_seller_seq);
    console.log('isSeller:', isSeller);
    console.log('chat_room_seq:', chat_room_seq);
    console.log('plusBtnWrapper:', plusBtnWrapper);

    if (plusBtnWrapper && isSeller && chat_room_seq > 0) {
        plusBtnWrapper.style.display = 'block';
        console.log('+ 버튼 표시');
    } else if (plusBtnWrapper) {
        plusBtnWrapper.style.display = 'none';
        console.log('+ 버튼 숨김');
    }
}

// + 버튼 이벤트 설정
function setupPlusButtonEvents() {
    const plusBtn = document.getElementById('plusBtn');
    const plusMenu = document.getElementById('plusMenu');
    const safePaymentRequestBtn = document.getElementById('safePaymentRequestBtn');

    if (plusBtn && plusMenu) {
        // + 버튼 클릭 시 메뉴 토글
        plusBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            plusMenu.classList.toggle('show');
        });

        // 다른 곳 클릭 시 메뉴 닫기
        document.addEventListener('click', function() {
            plusMenu.classList.remove('show');
        });
    }

    if (safePaymentRequestBtn) {
        safePaymentRequestBtn.addEventListener('click', function() {
            sendSafePaymentRequest();
            plusMenu.classList.remove('show');
        });
    }
}

// 안전 결제 요청 보내기
function sendSafePaymentRequest() {
    if (!stompClient || !stompClient.connected) {
        alert('채팅 연결이 필요합니다.');
        return;
    }

    if (!isSeller) {
        alert('판매자만 안전 결제 요청을 보낼 수 있습니다.');
        return;
    }

    // 특별한 메시지 형식으로 안전 결제 요청 전송
    stompClient.send(
        "/sendMessage/chat/" + chat_room_seq,
        {},
        JSON.stringify({
            chat_room_seq: chat_room_seq,
            chat_cont: "[SAFE_PAYMENT_REQUEST]",
            sender_seq: loginMemberSeq,
            trade_seq: trade_seq
        })
    );
}

// 기존 showMessage 함수 오버라이드
const originalShowMessage = showMessage;
showMessage = function(msg) {
    const chatCont = msg.chat_cont || '';

    // 안전 결제 요청 메시지인 경우
    if (chatCont === '[SAFE_PAYMENT_REQUEST]') {
        showSafePaymentRequest(msg);
        return;
    }

    // 구매 요청 수락 메시지인 경우
    if (chatCont === '[SAFE_PAYMENT_ACCEPT]') {
        showSafePaymentAccept(msg);
        return;
    }

    // 결제 완료 메시지인 경우
    if (chatCont === '[SAFE_PAYMENT_COMPLETE]') {
        showSafePaymentComplete(msg);
        return;
    }

    // 일반 메시지는 기존 함수 사용
    originalShowMessage(msg);
};

// 안전 결제 요청 UI 표시
function showSafePaymentRequest(msg) {
    const log = document.getElementById("chatContainer");
    const emptyNotice = document.getElementById("emptyNotice");
    if (emptyNotice) emptyNotice.remove();

    const msgWrapper = document.createElement('div');
    const isMyMessage = Number(msg.sender_seq) === loginMemberSeq;
    msgWrapper.className = isMyMessage ? 'msg-right' : 'msg-left';

    const card = document.createElement('div');
    card.className = 'safe-payment-card';

    const msgId = 'safe-pay-req-' + Date.now();
    card.id = msgId;

    if (isMyMessage) {
        // 판매자 본인이 보낸 경우 - 요청 완료 표시
        card.innerHTML =
            '<div class="card-header">' +
                '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
                    '<rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect>' +
                    '<line x1="1" y1="10" x2="23" y2="10"></line>' +
                '</svg>' +
                '<span class="card-title">안전 결제 요청</span>' +
            '</div>' +
            '<div style="text-align:center; padding: 8px 0; color: #495057; font-size: 13px;">' +
                '구매자에게 안전 결제 요청을 보냈습니다.' +
            '</div>';
    } else {
        // 구매자가 받은 경우 - 구매 요청하기 버튼 표시
        card.innerHTML =
            '<div class="card-header">' +
                '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
                    '<rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect>' +
                    '<line x1="1" y1="10" x2="23" y2="10"></line>' +
                '</svg>' +
                '<span class="card-title">안전 결제 요청</span>' +
                '<span class="timer" id="timer-' + msgId + '">01:00</span>' +
            '</div>' +
            '<div style="text-align:center; padding: 8px 0; color: #495057; font-size: 13px; margin-bottom: 12px;">' +
                '판매자가 안전 결제를 요청했습니다.' +
            '</div>' +
            '<button class="action-btn primary" id="btn-' + msgId + '" onclick="acceptSafePaymentRequest(\'' + msgId + '\')">' +
                '구매 요청하기' +
            '</button>';

        // 1분 타이머 시작
        startTimer(msgId, 60, function() {
            expireSafePaymentRequest(msgId);
        });
    }

    msgWrapper.appendChild(card);
    log.appendChild(msgWrapper);
    log.scrollTop = log.scrollHeight;
}

// 구매 요청 수락 (구매자가 클릭)
function acceptSafePaymentRequest(msgId) {
    // 타이머 정지
    if (safePaymentTimers[msgId]) {
        clearInterval(safePaymentTimers[msgId]);
        delete safePaymentTimers[msgId];
    }

    // 구매 요청 수락 메시지 전송
    if (stompClient && stompClient.connected) {
        stompClient.send(
            "/sendMessage/chat/" + chat_room_seq,
            {},
            JSON.stringify({
                chat_room_seq: chat_room_seq,
                chat_cont: "[SAFE_PAYMENT_ACCEPT]",
                sender_seq: loginMemberSeq,
                trade_seq: trade_seq
            })
        );
    }

    // 기존 카드 업데이트
    const card = document.getElementById(msgId);
    if (card) {
        card.innerHTML =
            '<div class="card-header">' +
                '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
                    '<polyline points="20 6 9 17 4 12"></polyline>' +
                '</svg>' +
                '<span class="card-title">구매 요청 완료</span>' +
            '</div>' +
            '<div style="text-align:center; padding: 8px 0; color: #495057; font-size: 13px;">' +
                '구매 요청을 보냈습니다.' +
            '</div>';
    }
}

// 안전 결제 수락 UI 표시 (상품 정보 + 결제하기 버튼)
function showSafePaymentAccept(msg) {
    const log = document.getElementById("chatContainer");
    const emptyNotice = document.getElementById("emptyNotice");
    if (emptyNotice) emptyNotice.remove();

    const msgWrapper = document.createElement('div');
    const isMyMessage = Number(msg.sender_seq) === loginMemberSeq;
    msgWrapper.className = isMyMessage ? 'msg-right' : 'msg-left';

    const card = document.createElement('div');
    card.className = 'safe-payment-card';

    const msgId = 'safe-pay-accept-' + Date.now();
    card.id = msgId;

    // 상품 정보 가져오기
    const trade = currentTradeInfo;
    const bookStatusText = getBookStatusText(trade.book_st);
    const totalPrice = trade.sale_price + trade.delivery_cost;
    const bookImg = trade.book_img || '/resources/img/no-image.png';

    if (isMyMessage) {
        // 구매자 본인이 보낸 경우 - 결제하기 버튼 표시
        card.innerHTML =
            '<div class="card-header">' +
                '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
                    '<rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect>' +
                    '<line x1="1" y1="10" x2="23" y2="10"></line>' +
                '</svg>' +
                '<span class="card-title">결제 정보</span>' +
                '<span class="timer" id="timer-' + msgId + '">01:00</span>' +
            '</div>' +
            '<div class="product-info">' +
                '<img src="' + bookImg + '" alt="상품 이미지" class="product-img" onerror="this.src=\'/resources/img/no-image.png\'">' +
                '<div class="product-detail">' +
                    '<div class="product-title">' + escapeHtml(trade.book_title) + '</div>' +
                    '<div class="product-status">' + bookStatusText + '</div>' +
                    '<div class="product-price">' + numberFormat(trade.sale_price) + '원</div>' +
                    '<div class="product-delivery">배송비 ' + numberFormat(trade.delivery_cost) + '원</div>' +
                '</div>' +
            '</div>' +
            '<div style="text-align:right; margin-bottom: 12px; font-size: 14px; font-weight: 700; color: #212529;">' +
                '총 결제금액: <span style="color: #0046FF;">' + numberFormat(totalPrice) + '원</span>' +
            '</div>' +
            '<button class="action-btn primary" id="btn-' + msgId + '" onclick="goToPayment(\'' + msgId + '\')">' +
                '결제하기' +
            '</button>';

        // 1분 타이머 시작
        startTimer(msgId, 60, function() {
            expirePayment(msgId);
        });
    } else {
        // 판매자가 받은 경우 - 구매자가 수락했다는 알림
        card.innerHTML =
            '<div class="card-header">' +
                '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
                    '<polyline points="20 6 9 17 4 12"></polyline>' +
                '</svg>' +
                '<span class="card-title">구매 요청 수락</span>' +
            '</div>' +
            '<div class="product-info">' +
                '<img src="' + bookImg + '" alt="상품 이미지" class="product-img" onerror="this.src=\'/resources/img/no-image.png\'">' +
                '<div class="product-detail">' +
                    '<div class="product-title">' + escapeHtml(trade.book_title) + '</div>' +
                    '<div class="product-status">' + bookStatusText + '</div>' +
                    '<div class="product-price">' + numberFormat(trade.sale_price) + '원</div>' +
                    '<div class="product-delivery">배송비 ' + numberFormat(trade.delivery_cost) + '원</div>' +
                '</div>' +
            '</div>' +
            '<div style="text-align:center; padding: 8px 0; color: #495057; font-size: 13px;">' +
                '구매자가 결제를 진행 중입니다.' +
            '</div>';
    }

    msgWrapper.appendChild(card);
    log.appendChild(msgWrapper);
    log.scrollTop = log.scrollHeight;
}

// 결제 페이지로 이동
function goToPayment(msgId) {
    // 타이머 정지
    if (safePaymentTimers[msgId]) {
        clearInterval(safePaymentTimers[msgId]);
        delete safePaymentTimers[msgId];
    }

    const tradeSeq = currentTradeInfo.trade_seq || trade_seq;
    if (tradeSeq > 0) {
        window.location.href = '/payments?trade_seq=' + tradeSeq;
    } else {
        alert('거래 정보를 찾을 수 없습니다.');
    }
}

// 결제 완료 UI 표시
function showSafePaymentComplete(msg) {
    const log = document.getElementById("chatContainer");
    const emptyNotice = document.getElementById("emptyNotice");
    if (emptyNotice) emptyNotice.remove();

    const msgWrapper = document.createElement('div');
    const isMyMessage = Number(msg.sender_seq) === loginMemberSeq;
    msgWrapper.className = isMyMessage ? 'msg-right' : 'msg-left';

    const card = document.createElement('div');
    card.className = 'safe-payment-card';

    // 상품 정보 가져오기
    const trade = currentTradeInfo;
    const bookStatusText = getBookStatusText(trade.book_st);
    const totalPrice = trade.sale_price + trade.delivery_cost;
    const bookImg = trade.book_img || '/resources/img/no-image.png';

    if (isMyMessage) {
        // 구매자 본인이 보낸 경우 - 결제 완료 표시
        card.innerHTML =
            '<div class="card-header">' +
                '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#22c55e" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
                    '<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>' +
                    '<polyline points="22 4 12 14.01 9 11.01"></polyline>' +
                '</svg>' +
                '<span class="card-title" style="color: #22c55e;">결제 완료</span>' +
            '</div>' +
            '<div class="product-info">' +
                '<img src="' + bookImg + '" alt="상품 이미지" class="product-img" onerror="this.src=\'/resources/img/no-image.png\'">' +
                '<div class="product-detail">' +
                    '<div class="product-title">' + escapeHtml(trade.book_title) + '</div>' +
                    '<div class="product-status">' + bookStatusText + '</div>' +
                    '<div class="product-price">' + numberFormat(trade.sale_price) + '원</div>' +
                    '<div class="product-delivery">배송비 ' + numberFormat(trade.delivery_cost) + '원</div>' +
                '</div>' +
            '</div>' +
            '<div style="text-align:center; padding: 12px 0; color: #22c55e; font-size: 13px; font-weight: 600;">' +
                '결제가 완료되었습니다!' +
            '</div>';
    } else {
        // 판매자가 받은 경우 - 구매자가 결제 완료했다는 알림
        card.innerHTML =
            '<div class="card-header">' +
                '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#22c55e" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
                    '<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>' +
                    '<polyline points="22 4 12 14.01 9 11.01"></polyline>' +
                '</svg>' +
                '<span class="card-title" style="color: #22c55e;">결제 완료</span>' +
            '</div>' +
            '<div class="product-info">' +
                '<img src="' + bookImg + '" alt="상품 이미지" class="product-img" onerror="this.src=\'/resources/img/no-image.png\'">' +
                '<div class="product-detail">' +
                    '<div class="product-title">' + escapeHtml(trade.book_title) + '</div>' +
                    '<div class="product-status">' + bookStatusText + '</div>' +
                    '<div class="product-price">' + numberFormat(trade.sale_price) + '원</div>' +
                    '<div class="product-delivery">배송비 ' + numberFormat(trade.delivery_cost) + '원</div>' +
                '</div>' +
            '</div>' +
            '<div style="text-align:center; padding: 12px 0; color: #22c55e; font-size: 13px; font-weight: 600;">' +
                '구매자가 결제를 완료했습니다!' +
            '</div>';
    }

    msgWrapper.appendChild(card);
    log.appendChild(msgWrapper);
    log.scrollTop = log.scrollHeight;
}

// 안전 결제 요청 만료
function expireSafePaymentRequest(msgId) {
    const card = document.getElementById(msgId);
    if (card) {
        card.innerHTML =
            '<div class="card-header">' +
                '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#868e96" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
                    '<circle cx="12" cy="12" r="10"></circle>' +
                    '<line x1="12" y1="8" x2="12" y2="12"></line>' +
                    '<line x1="12" y1="16" x2="12.01" y2="16"></line>' +
                '</svg>' +
                '<span class="card-title" style="color: #868e96;">안전 결제 요청</span>' +
            '</div>' +
            '<div class="expired-notice">' +
                '요청 시간이 만료되었습니다.' +
            '</div>';
    }
}

// 결제 만료
function expirePayment(msgId) {
    const card = document.getElementById(msgId);
    if (card) {
        const btn = document.getElementById('btn-' + msgId);
        if (btn) {
            btn.disabled = true;
            btn.textContent = '시간 만료';
        }
        const timer = document.getElementById('timer-' + msgId);
        if (timer) {
            timer.textContent = '만료됨';
            timer.style.color = '#868e96';
        }
    }
}

// 타이머 시작
function startTimer(msgId, seconds, onExpire) {
    let remaining = seconds;
    const timerEl = document.getElementById('timer-' + msgId);

    safePaymentTimers[msgId] = setInterval(function() {
        remaining--;
        if (timerEl) {
            const mins = Math.floor(remaining / 60);
            const secs = remaining % 60;
            timerEl.textContent = String(mins).padStart(2, '0') + ':' + String(secs).padStart(2, '0');
        }

        if (remaining <= 0) {
            clearInterval(safePaymentTimers[msgId]);
            delete safePaymentTimers[msgId];
            if (onExpire) onExpire();
        }
    }, 1000);
}

// 책 상태 텍스트 변환
function getBookStatusText(status) {
    const statusMap = {
        'NEW': '새 상품',
        'LIKE_NEW': '거의 새 것',
        'GOOD': '양호',
        'ACCEPTABLE': '사용감 있음'
    };
    return statusMap[status] || status || '-';
}

// 숫자 포맷
function numberFormat(num) {
    return (num || 0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

// HTML 이스케이프
function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// fetchMessages 함수 오버라이드 (Object[] 데이터 처리)
const originalFetchMessages = fetchMessages;
fetchMessages = function(roomSeq) {
    const url = '/chat/messages?chat_room_seq=' + encodeURIComponent(roomSeq);
    console.log('=== fetchMessages 호출 ===', roomSeq);

    fetch(url, {
        method: 'GET',
        credentials: 'same-origin',
        headers: { 'Accept': 'application/json' }
    })
    .then(res => {
        if (!res.ok) throw new Error('HTTP ' + res.status);
        return res.json();
    })
    .then(data => {
        console.log('=== fetchMessages 응답 ===', data);

        // Object[] 형태: data[0] = 메시지 배열, data[1] = TradeVO
        if (Array.isArray(data) && data.length >= 2) {
            const messages = data[0];
            const tradeInfo = data[1];

            console.log('tradeInfo:', tradeInfo);

            // trade 정보 업데이트
            if (tradeInfo) {
                currentTradeInfo = {
                    trade_seq: tradeInfo.trade_seq || 0,
                    book_img: tradeInfo.book_img || '',
                    book_title: tradeInfo.book_title || '',
                    sale_price: tradeInfo.sale_price || 0,
                    delivery_cost: tradeInfo.delivery_cost || 0,
                    book_st: tradeInfo.book_st || ''
                };

                // trade_seq 업데이트
                if (tradeInfo.trade_seq) {
                    trade_seq = tradeInfo.trade_seq;
                }

                // 판매자 여부 재확인
                if (tradeInfo.member_seller_seq) {
                    member_seller_seq = tradeInfo.member_seller_seq;
                    isSeller = (loginMemberSeq === tradeInfo.member_seller_seq);
                    console.log('isSeller 업데이트:', isSeller, 'loginMemberSeq:', loginMemberSeq, 'member_seller_seq:', member_seller_seq);
                    updatePlusButtonVisibility();
                }
            }

            // 메시지 렌더링
            if (Array.isArray(messages)) {
                messages.forEach(msg => showMessage(msg));
            }
        } else if (Array.isArray(data)) {
            // 기존 형식 호환 (단일 배열)
            console.log('기존 형식 (단일 배열) 사용');
            data.forEach(msg => showMessage(msg));
        }
    })
    .catch(err => console.error('채팅 메시지 로드 실패:', err));
};
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
