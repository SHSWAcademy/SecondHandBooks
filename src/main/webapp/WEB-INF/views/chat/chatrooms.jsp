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

    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            height: 100vh;
            margin: 0;
            background: #f5f5f5;
        }

        /* 왼쪽 채팅방 리스트 */
        #chatroomsList {
            width: 250px;
            border-right: 1px solid #ccc;
            overflow-y: auto;
            background: #fff;
        }
        #chatroomsList h3 {
            margin: 0;
            padding: 10px;
            background: #eee;
            border-bottom: 1px solid #ccc;
        }
        .chatroom-item {
            padding: 10px;
            cursor: pointer;
            border-bottom: 1px solid #f0f0f0;
        }
        .chatroom-item:hover {
            background: #f0f0f0;
        }
        /* 채팅방 아이템 */
        .chatroom-item {
            padding: 10px;
            cursor: pointer;
            border-bottom: 1px solid #f0f0f0;
        }

        .chatroom-item:hover {
            background: #f7f7f7;
        }

        /* 채팅방 제목 */
        .room-title {
            font-weight: bold;
            font-size: 14px;
            margin-bottom: 4px;
            color: #333;
        }

        /* 마지막 메시지 */
        .room-last-msg {
            font-size: 13px;
            color: #666;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* 마지막 시간 */
        .room-time {
            font-size: 11px;
            color: #999;
            text-align: right;
            margin-top: 2px;
        }

        /* 오른쪽 채팅 영역 */
        #chatArea {
            flex: 1;
            display: flex;
            flex-direction: column;
            padding: 10px;
        }

        #chatHeader {
            font-weight: bold;
            padding-bottom: 10px;
            border-bottom: 1px solid #ccc;
        }

        #chatContainer {
            flex: 1;
            overflow-y: auto;
            padding: 10px;
            background: #fff;
            margin-bottom: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        /* 메시지 wrapper */
        .msg-left,
        .msg-right {
            margin: 10px 0;
            display: flex;
            flex-direction: column;
            max-width: 70%;
        }

        /* 왼쪽 메시지 */
        .msg-left {
            align-items: flex-start;
        }

        /* 오른쪽 메시지 */
        .msg-right {
            align-items: flex-end;
        }

        /* 말풍선 */
        .msg-left div,
        .msg-right div {
            display: inline-block;
            padding: 8px 12px;
            border-radius: 10px;
            font-size: 14px;
            word-break: break-word;
        }

        /* 색상 유지 */
        .msg-left .content {
            background: #eee;
        }

        .msg-right .content {
            background: #ffe066;
        }

        /* 시간 표시 */
        .msg-time {
            font-size: 11px;
            color: #888;
            margin-top: 2px;
        }


        #messageInputArea {
            display: flex;
        }
        #message {
            flex: 1;
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ccc;
            margin-right: 5px;
        }
        #sendBtn {
            padding: 8px 12px;
            background: #ffe066;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }
        #sendBtn:hover {
            background: #ffdb4d;
        }
    </style>

    <script>
        const loginMemberSeq = Number("${sessionScope.loginSess.member_seq}");
        let chat_room_seq = Number("${trade_chat_room.chat_room_seq}");
        const trade_seq = Number("${trade_chat_room.trade_seq}");
    </script>

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
