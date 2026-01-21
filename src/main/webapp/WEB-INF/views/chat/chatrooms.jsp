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
    const trade_seq = Number("${trade_chat_room.trade_seq}");
</script>

<style>
    .chatroom-item.active {
        background-color: #eef4ff;
        border-color: #0046FF;
    }
    .chatroom-item:hover {
        background-color: #f8f9fa;
    }
    .chatroom-item.active:hover {
        background-color: #eef4ff;
    }
    #chatContainer {
        scrollbar-width: thin;
        scrollbar-color: #ced4da #f1f3f5;
    }
    #chatContainer::-webkit-scrollbar {
        width: 6px;
    }
    #chatContainer::-webkit-scrollbar-track {
        background: #f1f3f5;
        border-radius: 3px;
    }
    #chatContainer::-webkit-scrollbar-thumb {
        background: #ced4da;
        border-radius: 3px;
    }
    #chatContainer::-webkit-scrollbar-thumb:hover {
        background: #adb5bd;
    }
</style>

<div class="min-h-[calc(100vh-200px)]">
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
                            <div class="chatroom-item px-5 py-4 border-b border-gray-100 cursor-pointer transition-all duration-200 ${room.chat_room_seq == trade_chat_room.chat_room_seq ? 'active border-l-4' : 'border-l-4 border-l-transparent'}"
                                 data-chat-room-seq="${room.chat_room_seq}">
                                <div class="flex items-start gap-3">
                                    <div class="w-10 h-10 bg-primary-50 rounded-lg flex items-center justify-center flex-shrink-0">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-primary-500"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20"/></svg>
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <div class="font-semibold text-gray-900 text-sm truncate">
                                            ${room.sale_title}
                                        </div>
                                        <div class="text-xs text-gray-500 mt-1 truncate">
                                            <c:choose>
                                                <c:when test="${not empty room.last_msg}">
                                                    ${room.last_msg}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400 italic">아직 메시지가 없습니다</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="flex flex-col items-center justify-center h-full py-12 text-gray-400">
                            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="mb-3 text-gray-300"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
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
                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-gray-400"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                            </div>
                            <div>
                                <h4 class="font-medium text-gray-500">채팅방을 선택해주세요</h4>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 채팅 메시지 영역 -->
            <div id="chatContainer" class="flex-1 overflow-y-auto px-6 py-4 bg-gray-50 space-y-3">
                <c:choose>
                    <c:when test="${not empty messages}">
                        <c:forEach var="msg" items="${messages}">
                            <div class="flex ${msg.sender_seq == sessionScope.loginSess.member_seq ? 'justify-end' : 'justify-start'}">
                                <div class="max-w-[70%] ${msg.sender_seq == sessionScope.loginSess.member_seq ? 'order-last' : ''}">
                                    <div class="${msg.sender_seq == sessionScope.loginSess.member_seq ? 'bg-primary-500 text-white' : 'bg-white border border-gray-200 text-gray-900'} px-4 py-2.5 rounded-2xl ${msg.sender_seq == sessionScope.loginSess.member_seq ? 'rounded-tr-md' : 'rounded-tl-md'} shadow-sm">
                                        <p class="text-sm leading-relaxed">${msg.chat_cont}</p>
                                    </div>
                                    <div class="flex items-center gap-1.5 mt-1 ${msg.sender_seq == sessionScope.loginSess.member_seq ? 'justify-end' : 'justify-start'} px-1">
                                        <span class="text-[10px] text-gray-400">
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
                                        </span>
                                        <c:if test="${msg.read_yn && msg.sender_seq == sessionScope.loginSess.member_seq}">
                                            <span class="text-primary-500">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div id="emptyNotice" class="flex flex-col items-center justify-center h-full text-gray-400">
                            <svg xmlns="http://www.w3.org/2000/svg" width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="mb-4 text-gray-300"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                            <p class="text-sm font-medium">이전 메시지가 없습니다</p>
                            <p class="text-xs text-gray-400 mt-1">첫 메시지를 보내보세요!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 메시지 입력 영역 -->
            <div id="messageInputArea" class="px-6 py-4 border-t border-gray-100 bg-white">
                <div class="flex items-center gap-3">
                    <input type="text" id="message" placeholder="메시지를 입력하세요..."
                           class="flex-1 px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary-200 focus:border-primary-500 transition-all text-sm placeholder-gray-400" />
                    <button id="sendBtn" class="px-5 py-3 bg-primary-500 hover:bg-primary-600 text-white rounded-xl font-semibold text-sm transition-all shadow-sm hover:shadow-md flex items-center gap-2">
                        <span>전송</span>
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/chat/chat.js"></script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
