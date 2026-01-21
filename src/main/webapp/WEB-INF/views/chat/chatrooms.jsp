<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.time.LocalDateTime, java.util.Date, project.chat.message.MessageVO" %>
<!DOCTYPE html>
<html>
<head>
    <title>채팅</title>

    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
    <script>
        const loginMemberSeq = Number("${sessionScope.loginSess.member_seq}");
        let chat_room_seq = Number("${trade_chat_room.chat_room_seq}");
        const trade_seq = Number("${trade_chat_room.trade_seq}");
    </script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/js/chat/css/chat.css">
    <script src="${pageContext.request.contextPath}/resources/js/chat/chat.js"></script>
</head>
<body>
<!-- 왼쪽 채팅방 리스트 -->
<div id="chatroomsList">
    <h3>내 채팅방</h3>

    <c:forEach var="room" items="${chatrooms}">
        <div class="chatroom-item" data-chat-room-seq="${room.chat_room_seq}">
            <div class="room-title">
                ${room.sale_title}
            </div>

            <div class="room-last-msg">
                <c:choose>
                    <c:when test="${not empty room.last_msg}">
                        ${room.last_msg}
                    </c:when>
                    <c:otherwise>
                        아직 메시지가 없습니다.
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:forEach>
</div>

<!-- 오른쪽 채팅 영역 -->
<div id="chatArea">
    <div id="chatHeader">
        <c:forEach var="room" items="${chatrooms}">
            <c:if test="${room.trade_seq == trade_chat_room.trade_seq}">
                <div class="chatroom-item">
                    ${room.sale_title}
                </div>
            </c:if>
        </c:forEach>
    </div>

    <div id="chatContainer">
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
                            <c:if test="${msg.read_yn}">✔</c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div id="emptyNotice">이전 메시지가 없습니다.</div>
            </c:otherwise>
        </c:choose>
    </div>
    <!-- 메시지 입력 -->
    <div id="messageInputArea">
        <input type="text" id="message" placeholder="메시지 입력">
        <button id="sendBtn">전송</button>
    </div>
</div>
</body>
</html>
