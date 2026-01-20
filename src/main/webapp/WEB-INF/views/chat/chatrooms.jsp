<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>채팅</title>

    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
    <style>
        #chatContainer {
            max-height: 400px;
            overflow-y: auto;
            border: 1px solid #ccc;
            padding: 10px;
        }
        #message {
            width: 80%;
        }
        #emptyNotice {
            color: #888;
            margin: 10px 0;
        }
    </style>
</head>
<body>

<h2>채팅방</h2>

<!-- 채팅 메시지 전체 영역 -->
<div id="chatContainer">
    <c:choose>
        <c:when test="${not empty messages}">
            <c:forEach var="msg" items="${messages}">
                <c:choose>
                    <c:when test="${msg.sender_seq == sessionScope.loginSess.member_seq}">
                        <div style="text-align:right; margin:10px 0;">
                            <div style="display:inline-block; background:#ffe066; padding:8px 12px; border-radius:10px;">
                                ${msg.chat_cont}
                            </div>
                            <div style="font-size:11px; color:#888;">
                                <fmt:formatDate value="${msg.send_dtm}" pattern="HH:mm"/>
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
                                <fmt:formatDate value="${msg.send_dtm}" pattern="HH:mm"/>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div id="emptyNotice">이전 메시지가 없습니다.</div>
        </c:otherwise>
    </c:choose>
</div>

<!-- 메시지 입력 -->
<input type="text" id="message" placeholder="메시지 입력">
<button id="sendBtn">전송</button>

<script>
    // 로그인 멤버 seq / 채팅방 seq
    const loginMemberSeq = "${sessionScope.loginSess.member_seq}";
    const chat_room_seq = "${trade_chat_room.chat_room_seq}";
    const trade_seq = "${trade_chat_room.trade_seq}";

    console.log('시퀀스 출력 확인', trade_seq);
    let stompClient = null;
   console.log('시퀀스 출력 !! ' ,chat_room_seq);
   console.log('멤버 출력 !! ' ,loginMemberSeq);

    // 페이지 로드 → 자동 연결
    window.onload = function () {
        connect();
    };

    function connect() {
        const socket = new SockJS('/chatEndPoint');
        stompClient = Stomp.over(socket);

        stompClient.connect({}, function (frame) {
            console.log('STOMP Connected:', frame);

            // 채팅방 구독
            stompClient.subscribe('/chatroom/' + chat_room_seq, function (message) {
                const msg = JSON.parse(message.body);
                console.log('json메세지 확인 !! ', message);
                showMessage(msg);
            });
        });
    }

    function sendMessage() {
        if (!stompClient || !stompClient.connected) return;
        console.log('보낸사람!!', loginMemberSeq);
        const msg = document.getElementById("message").value.trim();
        if (!msg) return;

        stompClient.send(
            "/sendMessage/chat/" + chat_room_seq,
            {},
            JSON.stringify({
                chat_room_seq: chat_room_seq,
                chat_cont: msg,
                sender_seq:loginMemberSeq,
                trade_seq : trade_seq
            })
        );

        document.getElementById("message").value = '';
    }

    // 메시지 렌더링
   function showMessage(msg) {
       // 초기 안내문 제거
       const emptyNotice = document.getElementById("emptyNotice");
       if (emptyNotice) emptyNotice.remove();

       const log = document.getElementById("chatContainer");

       const content = msg.chat_cont || "";
       const timeStr = msg.send_dtm ? formatTime(msg.send_dtm) : "";
       const check = msg.read_yn ? "✔" : "";

       // div 생성 방식으로 안전하게 렌더링
       const msgWrapper = document.createElement('div');
       msgWrapper.style.margin = '10px 0';
       msgWrapper.style.textAlign = (msg.sender_seq === loginMemberSeq) ? 'right' : 'left';

       const msgContent = document.createElement('div');
       msgContent.style.display = 'inline-block';
       msgContent.style.padding = '8px 12px';
       msgContent.style.borderRadius = '10px';
       msgContent.style.background = (msg.sender_seq === loginMemberSeq) ? '#ffe066' : '#eee';
       msgContent.textContent = content; // 안전하게 텍스트로 삽입

       const msgTime = document.createElement('div');
       msgTime.style.fontSize = '11px';
       msgTime.style.color = '#888';
       msgTime.textContent = `${timeStr} ${check}`;

       msgWrapper.appendChild(msgContent);
       msgWrapper.appendChild(msgTime);

       log.appendChild(msgWrapper);
       log.scrollTop = log.scrollHeight;
   }


    // 시간 포맷
    function formatTime(dtm) {
        if (!dtm) return "";
        const date = new Date(dtm);
        const hh = String(date.getHours()).padStart(2, "0");
        const mm = String(date.getMinutes()).padStart(2, "0");
        return `${hh}:${mm}`;
    }

    // 버튼 클릭 이벤트 연결
    document.getElementById("sendBtn").addEventListener("click", sendMessage);

    // 페이지 이탈 → STOMP 해제
    window.addEventListener("beforeunload", function () {
        if (stompClient !== null) {
            stompClient.disconnect();
            console.log("STOMP Disconnected");
        }
    });
</script>

</body>
</html>
