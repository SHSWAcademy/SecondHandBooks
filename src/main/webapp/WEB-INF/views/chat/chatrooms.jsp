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
          * { box-sizing: border-box; }
          body { margin: 0; font-family: sans-serif; }

          .chat-wrapper {
              display: flex;
              height: 100vh;
          }

          /* 좌측: 채팅방 목록 */
          .room-list {
              width: 300px;
              border-right: 1px solid #ccc;
              overflow-y: auto;
          }
          .room-list h3 {
              padding: 15px;
              margin: 0;
              background: #f5f5f5;
              border-bottom: 1px solid #ccc;
          }
          .room-item {
              padding: 15px;
              border-bottom: 1px solid #eee;
              cursor: pointer;
          }
          .room-item:hover {
              background: #f9f9f9;
          }
          .room-item.active {
              background: #e3f2fd;
          }
          .room-item .last-msg {
              font-size: 13px;
              color: #666;
              margin-top: 5px;
              overflow: hidden;
              text-overflow: ellipsis;
              white-space: nowrap;
          }
          .room-item .time {
              font-size: 11px;
              color: #999;
          }

          /* 우측: 채팅 내용 */
          .chat-area {
              flex: 1;
              display: flex;
              flex-direction: column;
          }
          .chat-header {
              padding: 15px;
              background: #f5f5f5;
              border-bottom: 1px solid #ccc;
          }
          .chat-messages {
              flex: 1;
              overflow-y: auto;
              padding: 15px;
          }
          .chat-input {
              display: flex;
              padding: 15px;
              border-top: 1px solid #ccc;
          }
          .chat-input input {
              flex: 1;
              padding: 10px;
              border: 1px solid #ccc;
              border-radius: 5px;
          }
          .chat-input button {
              margin-left: 10px;
              padding: 10px 20px;
              background: #4CAF50;
              color: white;
              border: none;
              border-radius: 5px;
              cursor: pointer;
          }

          /* 메시지 스타일 */
          .msg-wrapper {
              margin: 10px 0;
          }
          .msg-wrapper.mine {
              text-align: right;
          }
          .msg-wrapper.other {
              text-align: left;
          }
          .msg-content {
              display: inline-block;
              padding: 8px 12px;
              border-radius: 10px;
              max-width: 70%;
          }
          .msg-wrapper.mine .msg-content {
              background: #ffe066;
          }
          .msg-wrapper.other .msg-content {
              background: #eee;
          }
          .msg-time {
              font-size: 11px;
              color: #888;
              margin-top: 3px;
          }

          .empty-notice {
              color: #888;
              text-align: center;
              margin-top: 50px;
          }
          .no-room-selected {
              color: #888;
              text-align: center;
              margin-top: 100px;
          }
      </style>
  </head>
  <body>

  <div class="chat-wrapper">
      <!-- 좌측: 채팅방 목록 -->
      <div class="room-list">
          <h3>채팅 목록</h3>
          <c:choose>
              <c:when test="${not empty chatrooms}">
                  <c:forEach var="room" items="${chatrooms}">
                      <div class="room-item ${room.chat_room_seq == trade_chat_room.chat_room_seq ? 'active' : ''}"
                           data-room-seq="${room.chat_room_seq}"
                           data-trade-seq="${room.trade_seq}"
                           onclick="switchRoom(${room.chat_room_seq}, ${room.trade_seq})">
                          <div>
                              <strong>채팅방 #${room.chat_room_seq}</strong>
                              <span class="time">
                                  <c:if test="${room.lastMsgDtmAsDate != null}">
                                      <fmt:formatDate value="${room.lastMsgDtmAsDate}" pattern="MM/dd HH:mm"/>
                                  </c:if>
                              </span>
                          </div>
                          <div class="last-msg">
                              ${not empty room.last_msg ? room.last_msg : '새로운 채팅방'}
                          </div>
                      </div>
                  </c:forEach>
              </c:when>
              <c:otherwise>
                  <div class="empty-notice">채팅방이 없습니다.</div>
              </c:otherwise>
          </c:choose>
      </div>

      <!-- 우측: 채팅 내용 -->
      <div class="chat-area">
          <div class="chat-header">
              <c:choose>
                  <c:when test="${not empty trade_chat_room}">
                      <strong>채팅방 #${trade_chat_room.chat_room_seq}</strong>
                  </c:when>
                  <c:otherwise>
                      <strong>채팅</strong>
                  </c:otherwise>
              </c:choose>
          </div>

          <div class="chat-messages" id="chatContainer">
              <c:choose>
                  <c:when test="${not empty trade_chat_room}">
                      <c:choose>
                          <c:when test="${not empty messages}">
                              <c:forEach var="msg" items="${messages}">
                                  <div class="msg-wrapper ${msg.sender_seq == sessionScope.loginSess.member_seq ? 'mine' : 'other'}">
                                      <div class="msg-content">${msg.chat_cont}</div>
                                      <div class="msg-time">
                                          <c:if test="${msg.sentDtmAsDate != null}">
                                              <fmt:formatDate value="${msg.sentDtmAsDate}" pattern="HH:mm"/>
                                          </c:if>
                                          <c:if test="${msg.read_yn}">✔</c:if>
                                      </div>
                                  </div>
                              </c:forEach>
                          </c:when>
                          <c:otherwise>
                              <div class="empty-notice" id="emptyNotice">이전 메시지가 없습니다.</div>
                          </c:otherwise>
                      </c:choose>
                  </c:when>
                  <c:otherwise>
                      <div class="no-room-selected">채팅방을 선택해주세요.</div>
                  </c:otherwise>
              </c:choose>
          </div>

          <div class="chat-input">
              <input type="text" id="message" placeholder="메시지 입력"
                     ${empty trade_chat_room ? 'disabled' : ''}>
              <button id="sendBtn" ${empty trade_chat_room ? 'disabled' : ''}>전송</button>
          </div>
      </div>
  </div>

  <script>
      const loginMemberSeq = Number("${sessionScope.loginSess.member_seq}");
      let currentRoomSeq = "${trade_chat_room.chat_room_seq}" || null;
      let currentTradeSeq = "${trade_chat_room.trade_seq}" || null;
      let stompClient = null;
      let currentSubscription = null;

      // 페이지 로드 시 웹소켓 연결
      window.onload = function () {
          connect();
      };

      function connect() {
          const socket = new SockJS('/chatEndPoint');
          stompClient = Stomp.over(socket);

          stompClient.connect({}, function (frame) {
              console.log('STOMP Connected:', frame);

              // 현재 선택된 채팅방이 있으면 구독
              if (currentRoomSeq) {
                  subscribeRoom(currentRoomSeq);
              }
          });
      }

      // 채팅방 구독
      function subscribeRoom(roomSeq) {
          // 기존 구독 해제
          if (currentSubscription) {
              currentSubscription.unsubscribe();
          }
