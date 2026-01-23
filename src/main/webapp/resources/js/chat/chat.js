let stompClient = null;

window.onload = function () {
    connect();
    setupChatroomClick();
};

/* -------------------------------
   STOMP 연결
-------------------------------- */
function connect() {
    const socket = new SockJS('/chatEndPoint');
    stompClient = Stomp.over(socket);

    stompClient.connect({}, function (frame) {
        console.log('STOMP Connected:', frame);
        subscribeCurrentRoom();
    });
}

function subscribeCurrentRoom() {
    if (!stompClient) return;

    stompClient.subscribe('/chatroom/' + chat_room_seq, function (message) {
        const msg = JSON.parse(message.body);
        showMessage(msg);
    });
}

/* -------------------------------
   메시지 전송
-------------------------------- */
function sendMessage() {
    if (!stompClient || !stompClient.connected) return;

    const input = document.getElementById("message");
    const msg = input.value.trim();
    if (!msg) return;

    stompClient.send(
        "/sendMessage/chat/" + chat_room_seq,
        {},
        JSON.stringify({
            chat_room_seq: chat_room_seq,
            chat_cont: msg,
            sender_seq: loginMemberSeq,
            trade_seq: trade_seq
        })
    );

    input.value = '';
}

/* -------------------------------
   메시지 렌더링
-------------------------------- */
function showMessage(msg) {
    const log = document.getElementById("chatContainer");

    const emptyNotice = document.getElementById("emptyNotice");
    if (emptyNotice) emptyNotice.remove();

    const msgWrapper = document.createElement('div');

    // 보낸 사람 기준 정렬
    if (Number(msg.sender_seq) === loginMemberSeq) {
        msgWrapper.className = 'msg-right';
    } else {
        msgWrapper.className = 'msg-left';
    }

    const msgContent = document.createElement('div');
    msgContent.className = 'content';
    msgContent.textContent = msg.chat_cont || '';

    // sent_dtm JSON 처리
    let dateObj;
    if (Array.isArray(msg.sent_dtm)) {
        dateObj = parseLocalDateTime(msg.sent_dtm);
    } else {
        dateObj = new Date();
    }

    const timeStr =
        dateObj.getFullYear() + "/" +
        String(dateObj.getMonth() + 1).padStart(2, '0') + "/" +
        String(dateObj.getDate()).padStart(2, '0') + " " +
        String(dateObj.getHours()).padStart(2, '0') + ":" +
        String(dateObj.getMinutes()).padStart(2, '0');

    const msgTime = document.createElement('div');
    msgTime.className = 'msg-time';
    msgTime.textContent = timeStr + (msg.read_yn ? " ✔" : "");

    msgWrapper.appendChild(msgContent);
    msgWrapper.appendChild(msgTime);

    log.appendChild(msgWrapper);
    log.scrollTop = log.scrollHeight;
}

/* -------------------------------
   채팅방 클릭
-------------------------------- */
function setupChatroomClick() {
    const rooms = document.querySelectorAll('.chatroom-item');

    rooms.forEach(room => {
        room.addEventListener('click', function () {
            const selectedRoomSeq = this.getAttribute('data-chat-room-seq');
            chat_room_seq = Number(selectedRoomSeq);

            // 메시지 영역 초기화
            document.getElementById("chatContainer").innerHTML =
                '<div id="emptyNotice">이전 메시지가 없습니다.</div>';

            // 헤더 제목 갱신
            const titleEl = this.querySelector('.room-title');
            document.getElementById("chatHeader").textContent =
                titleEl ? titleEl.textContent : '';

            // STOMP 재연결
            if (stompClient) {
                stompClient.disconnect(() => connect());
            }

            fetchMessages(chat_room_seq);
        });
    });
}

/* -------------------------------
   메시지 AJAX 조회
-------------------------------- */
function fetchMessages(roomSeq) {
    const url = '/chat/messages?chat_room_seq=' + encodeURIComponent(roomSeq);

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
        if (Array.isArray(data)) {
            data.forEach(msg => showMessage(msg));
        }
    })
    .catch(err => console.error('채팅 메시지 로드 실패:', err));
}

/* -------------------------------
   LocalDateTime 배열 파싱
-------------------------------- */
function parseLocalDateTime(arr) {
    if (!Array.isArray(arr)) return new Date();

    const [y, m, d, h, min, s, nano] = arr;

    return new Date(
        y,
        m - 1,
        d,
        h,
        min,
        s,
        Math.floor((nano || 0) / 1_000_000)
    );
}

/* -------------------------------
   이벤트 바인딩
-------------------------------- */
document.addEventListener("DOMContentLoaded", function () {
    document.getElementById("sendBtn")
        .addEventListener("click", sendMessage);
});

window.addEventListener("beforeunload", function () {
    if (stompClient) stompClient.disconnect();
});
