package project.chat.stomp;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.*;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Component // 빈 등록
@Slf4j
public class StompEventListener {

    // key = value = websocket session id (value 자리에 다른 값 player, User 등 다른 java 객체가 올 수도 있다)
    private final ConcurrentHashMap<String, String> sessionMap = new ConcurrentHashMap<>();

    public Set<String> getSessions() {
        return sessionMap.keySet();
    }

    // 이벤트 : 프로그램에서 발생하는 특정 사건, 상황
    // ex : 웹소켓 연결이라는 SessionConnectedEvent 사건

    // 리스너로 등록하고 싶은 메서드에 어노테이션 등록
    // @EventListener 어노테이션은 스프링이 지원, 이벤트 (사건)가 발생하면 메서드가 동작, 알림 받기 비유
    // @EventListener : STOMP 연결, 구독, 해제와 같은 세션 생명주기 이벤트를 감지하고 처리

    // SessionConnectEvent : 웹소켓 세션이 서버에 연결 시도 시 이벤트 등록
    @EventListener
    public void listener(SessionConnectEvent sessionConnectEvent) {
        log.info("sessionConnectEvent. {}", sessionConnectEvent);
    }

    // SessionConnectedEvent : 웹소켓 세션이 서버에 완전히 연결되었을 때 이벤트 등록 (connected)
    @EventListener
    public void listener(SessionConnectedEvent sessionConnectedEvent) {
        log.info("sessionConnectedEvent. {}", sessionConnectedEvent);
        String sessionId = sessionConnectedEvent.getMessage().getHeaders().get("simpSessionId").toString();
        sessionMap.put(sessionId, sessionId); // 웹소켓 세션 아이디 등록
    }

    // SessionSubscribeEvent : 웹소켓 세션(클라이언트) 이 특정 토픽(/topic/game/room1) 구독 시 동작
    @EventListener
    public void listener(SessionSubscribeEvent sessionSubscribeEvent) {
        log.info("sessionSubscribeEvent. {}", sessionSubscribeEvent);
    }

    // SessionUnsubscribeEvent : 웹소켓 세션(클라이언트) 이 특정 토픽(/topic/game/room1) 구독 취소 시 동작
    @EventListener
    public void listener(SessionUnsubscribeEvent sessionUnsubscribeEvent) {
        log.info("sessionUnsubscribeEvent. {}", sessionUnsubscribeEvent);
    }

    // SessionConnectEvent : 웹소켓 세션 연결이 해제되었을 때 이벤트 등록
    @EventListener
    public void listener(SessionDisconnectEvent sessionDisconnectEvent) {
        log.info("sessionDisconnectEvent. {}", sessionDisconnectEvent);
        String sessionId = sessionDisconnectEvent.getMessage().getHeaders().get("simpSessionId").toString();
        sessionMap.remove(sessionId); // 웹소켓 세션 아이디 삭제
    }
}
