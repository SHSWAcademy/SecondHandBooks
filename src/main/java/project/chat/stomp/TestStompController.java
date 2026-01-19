package project.chat.stomp;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.lang.Nullable;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageHeaders;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessageType;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.stereotype.Controller;
import project.chat.dto.RequestDto;
import project.chat.dto.ResponseDto;
import project.chat.dto.ResponseSessionsDto;

import java.io.IOException;
import java.security.InvalidParameterException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Random;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledFuture;


@Slf4j
@Controller
@RequiredArgsConstructor
public class TestStompController {

    private final TestStompEventListener eventListener;
    private final SimpMessagingTemplate messagingTemplate; // @EnableWebSocketMessageBroker 로 stomp 활성화 시 스프링이 자동 주입
    private final TaskScheduler taskScheduler;

    // key : websocket Session, value : ScheduledFuture
    private final ConcurrentHashMap<String, ScheduledFuture<?>> scheduledMap = new ConcurrentHashMap<>();


    // @GetMapping 은 http 요청 처리, @MessageMapping 은 웹소켓 메시지 처리
    @MessageMapping("/hello") // /app/hello 로 요청 시 해당 매핑이 처리
    @SendTo("/topic/hello") // /topic/hello 를 구독한 클라이언트에게 발행 (발행 = 브로드캐스트)
    public ResponseDto basic(RequestDto request) {
        log.info("request: {}", request);
        return new ResponseDto(request.getMessage().toUpperCase(), LocalDateTime.now());
    }

    @MessageMapping("/multi") // /app/multi 로 요청 시 해당 매핑이 처리
    @SendTo({"/topic/hello", "/topic/hello2"}) // 배열로 발행 가능
    public ResponseDto nulti(RequestDto request) {
        log.info("request: {}", request);

        return new ResponseDto(request.getMessage().toUpperCase(), LocalDateTime.now());
    }

    @MessageMapping("/hello1")
    @SendTo("/topic/hello")
    public ResponseDto annotations(Message<RequestDto> message, MessageHeaders headers, RequestDto request) {
        // RequestDto request 는 웹소켓 메시지 바디 부분에 대한 데이터만 확인 가능
        // MessageHeaders headers 는 웹소켓 메시지 헤더만 확인 가능
        // Message<RequestDto> message 는 웹소켓 메시지 바디와 함께 헤더에 대한 데이터도 확인 가능
        // Message<RequestDto> = MessageHeaders + RequestDto (body)
        log.info("message: {}", message);
        log.info("headers: {}", headers);
        log.info("request: {}", request);

        return new ResponseDto(request.getMessage().toUpperCase(), LocalDateTime.now());
    }

    @MessageMapping("/hello/{detail}")
    @SendTo("/topic/hello")
    public ResponseDto detail(@DestinationVariable("detail") String detail, RequestDto request) {
        // @DestinationVariable : @PathVariable 과 비슷한 역할, {detail}로 들어온 값을 String detail 에 담아 사용
        // ex : /app/hello/world
        log.info("detail: {}", detail);
        log.info("request: {}", request);

        return new ResponseDto("[" + detail + "]_" + request.getMessage().toUpperCase(), LocalDateTime.now());
    }


    /*
       @MessageMapping("/sessions") : /app/sessions 로 요청 시 해당 매핑이 처리
       SendToUser : 요청을 보낸 현재 웹소켓 세션에만 발행 (not 브로드캐스트, 브로드캐스트 = 모든 사람에게 전달)
       SendToUser 의 prefix로 /user이 항상 생략되어있다. (클라이언트는 요청 시 /user/queue/sessions 로 요청해야 한다.)
       요청을 보낸 웹소켓 세션이 /user/queue/sessions 구독 시 해당 웹소켓 세션에만 전달
       요청을 보낸 웹소켓 세션이 /user/queue/sessions 구독을 하고 있지 않다면 메시지는 전송되지만 받을 사람이 없어 사라진다 (예외 발생은 x)
       반드시 /queue/sessions 를 구독하고 있어야 메시지가 전달된다.
     */
    @MessageMapping("/sessions")
    @SendToUser("/queue/sessions") // 일반적으로 sentToUser 1:1 통신 시 prefix 를 관례적으로 /queue 로 사용
    public ResponseSessionsDto sessions(RequestDto request, MessageHeaders headers) { // request : body, MessageHeaders : header
        log.info("request: {}", request);

        Set<String> sessions = eventListener.getSessions(); // 전체 세션 조회

        String sessionId = headers.get("simpSessionId").toString();

        ResponseSessionsDto responseSessionsDto = new ResponseSessionsDto(
                sessions.size(), sessions.stream().toList(),
                sessionId, LocalDateTime.now());

        return responseSessionsDto;
    }



    // @SendTo("/topic/hello") 없이 사용 방법 (if 문을 이용한 경로 분기에서 주로 이용)
    @MessageMapping("/code1") // /app/code
    public void code1(RequestDto request) {
        log.info("request: {}", request);
        ResponseDto resDto = new ResponseDto(request.getMessage().toUpperCase(), LocalDateTime.now());

        // messagingTemplate 를 이용해 destination 을 직접 지정 가능
        // if (~ 일 때) "/queue/hello" else if (~일 때) "/queue/hello2" 등 분기 가능
        // convertAndSend : destination 을 구독하는 모든 웹소켓 세션에게 전달
        messagingTemplate.convertAndSend("/topic/hello", resDto);
    }

    // @SendToUser("/queue/sessions") 없이 사용 방법 (if 문을 이용한 경로 분기에서 주로 이용)
    @MessageMapping("/code2") // /app/code2
    public void code2(RequestDto request, MessageHeaders headers) {
        log.info("request: {}", request);
        String sessionId = headers.get("simpSessionId").toString();
        Set<String> sessions = eventListener.getSessions();

        ResponseSessionsDto resSessionsDto = new ResponseSessionsDto(sessions.size(), sessions.stream().toList(), sessionId, LocalDateTime.now());

        // messagingTemplate 를 이용해 destination 을 직접 지정 가능
        // if (~ 일 때) "/queue/hello" else if (~일 때) "/queue/hello2" 등 분기 가능
        // convertAndSendToUser : 요청한 웹소켓 클라이언트가 destination 을 구독 중일 때 해당 클라이언트에만 응답 (1:1 통신)
        // 1:1 통신 시 sendToUser을 사용하지 않을 때에는 클라이언트에 헤더 정보까지 전달해야 한다 => createHeaders(sessionId)
        // 헤더 정보를 전달하지 않을 경우 클라이언트가 응답을 받지 못한다 (어느 웹소켓 세션으로 전달할지 알 수 없기 때문)
        messagingTemplate.convertAndSendToUser
                (sessionId, "/queue/sessions", resSessionsDto, createHeaders(sessionId));

    }

    // SendToMethodReturnValueHandler.java 클래스의 createHeaders 메서드를 복사, 붙여넣기
    private MessageHeaders createHeaders(@Nullable String sessionId) { //, MethodParameter returnType) {
        SimpMessageHeaderAccessor headerAccessor = SimpMessageHeaderAccessor.create(SimpMessageType.MESSAGE);
        /*
            if (getHeaderInitializer() != null) {
                getHeaderInitializer().initHeaders(headerAccessor);
            }
         */
        if (sessionId != null) {
            headerAccessor.setSessionId(sessionId);
        }
        // headerAccessor.setHeader(AbstractMessageSendingTemplate.CONVERSION_HINT_HEADER, returnType);
        headerAccessor.setLeaveMutable(true);
        return headerAccessor.getMessageHeaders();
    }


    // 실시간 주식 가격 반영 예제
    // @Scheduled 로는 부족하다.
    @MessageMapping("/start")
    public void start(RequestDto request, MessageHeaders headers) {
        log.info("request: {}", request);
        String sessionId = headers.get("simpSessionId").toString();

        // 원하는 시점에 스케줄러를 실행 가능하도록 메서드 내에서 스케줄러 선언
        ScheduledFuture<?> scheduledFuture = taskScheduler.scheduleAtFixedRate(() -> {
            // 실시간 주식 가격을 랜덤으로 설정
            Random random = new Random();
            int currentPrice = random.nextInt(100);

            // 실제 가격을 받을 위치 : /user//queue/trade
            messagingTemplate.convertAndSendToUser(sessionId, "/queue/trade", currentPrice, createHeaders(sessionId));
        }, Duration.ofSeconds(3)); // 3초마다 스케줄러 실행

        scheduledMap.put(sessionId, scheduledFuture);
    }

    @MessageMapping("/stop")
    public void stop(RequestDto request, MessageHeaders headers) {
        log.info("request: {}", request);
        String sessionId = headers.get("simpSessionId").toString();

        // 맵에서 제거
        ScheduledFuture<?> scheduledFuture = scheduledMap.remove(sessionId);
        scheduledFuture.cancel(true); // 스케줄러 실행 취소
    }


    @MessageMapping("/exception")
    @SendTo("/topic/hello")
    public void exception(RequestDto request, MessageHeaders headers) throws Exception {
        log.info("request: {}", request);
        String message = request.getMessage();
        switch(message) {
            case "runtime":
                throw new RuntimeException();
            case "nullPointer":
                throw new NullPointerException();
            case "io":
                throw new IOException();
            case "exception":
                throw new Exception();
            default:
                throw new InvalidParameterException();
        }
    }

}
