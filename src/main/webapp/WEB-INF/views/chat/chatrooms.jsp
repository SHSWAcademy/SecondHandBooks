<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>채팅</title>

    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
</head>
<body>

<h2>채팅방</h2>
<c:forEach var="msg" items="${messages}">
    <c:choose>

        <c:when test="${msg.sender.member_seq == sessionScope.loginSess.member_seq}">
            <div style="text-align:right; margin:10px 0;">
                <div style="display:inline-block; background:#ffe066; padding:8px 12px; border-radius:10px;">
                    ${msg.chat_cont}
                </div>
                <div style="font-size:11px; color:#888;">
                    <fmt:formatDate value="${msg.send_dtm}" pattern="HH:mm" />
                    <c:if test="${msg.read_yn}">✔</c:if>
                </div>
            </div>
        </c:when>

        <c:otherwise>
            <div style="text-align:left; margin:10px 0;">
                <div style="font-size:12px; color:#555;">
                    ${msg.sender_seq}
                </div>
                <div style="display:inline-block; background:#eee; padding:8px 12px; border-radius:10px;">
                    ${msg.chat_cont}
                </div>
                <div style="font-size:11px; color:#888;">
                    <fmt:formatDate value="${msg.send_dtm}" pattern="HH:mm" />
                </div>
            </div>
        </c:otherwise>

    </c:choose>
</c:forEach>


<div id="chatLog"></div>

<input type="text" id="message" placeholder="메시지 입력">
<button onclick="sendMessage()">전송</button>

<script>
    let stompClient = null;
    const chat_room_seq = ${trade_chat_room.chat_room_seq};
    const member_seq = ${member_seq};

    /* ===============================
       페이지 로드 → 자동 연결
       =============================== */
    window.onload = function () {
        connect();
    };

    function connect() {
        const socket = new SockJS('/chatEndPoint');
        stompClient = Stomp.over(socket);

        stompClient.connect({}, function (frame) {
            console.log('STOMP Connected:', frame);

            // 구독요청
            stompClient.subscribe('/chatroom/' + chat_room_seq, function (message) {
                showMessage(message.body);
            });
        });
    }

    function sendMessage() {
        if (!stompClient || !stompClient.connected) return;

        const msg = document.getElementById("message").value;
        stompClient.send(
            "/sendMessage/chat/" + chat_room_seq,
            {},
            JSON.stringify({
                chat_room_seq: chat_room_seq,
                chat_cont: msg,
                sender_seq: member_seq
            })
        );

        document.getElementById("message").value = '';
    }

    function showMessage(message) {
        const log = document.getElementById("chatLog");
        const msg = JSON.parse(message);
        const div = document.createElement("div");

        if (msg.sender_seq == member_seq) {
            // 내 메시지 (오른쪽)
            div.style.cssText = "text-align:right; margin:10px 0;";
            div.innerHTML = '<div style="display:inline-block; background:#ffe066; padding:8px 12px; border-radius:10px;">' + msg.chat_cont + '</div>';
        } else {
            // 상대방 메시지 (왼쪽)
            div.style.cssText = "text-align:left; margin:10px 0;";
            div.innerHTML = '<div style="display:inline-block; background:#eee; padding:8px 12px; border-radius:10px;">' + msg.chat_cont + '</div>';
        }

        log.appendChild(div);
    }

    /* ===============================
       페이지 이탈 → 자동 해제
       =============================== */
    window.addEventListener("beforeunload", function () {
        if (stompClient !== null) {
            stompClient.disconnect();
            console.log("STOMP Disconnected");
        }
    });
</script>

</body>
</html>
