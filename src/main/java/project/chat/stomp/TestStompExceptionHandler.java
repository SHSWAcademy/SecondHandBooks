package project.chat.stomp;

import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.MessageHeaders;
import org.springframework.messaging.handler.annotation.MessageExceptionHandler;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.ControllerAdvice;

import java.io.IOException;

@ControllerAdvice // @RestControllerAdvice 도 있다, 예외 처리를 위한 클래스
@Slf4j
public class TestStompExceptionHandler {
    private final SimpMessagingTemplate messagingTemplate;

    public TestStompExceptionHandler(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    // MVC 에서는 @ExceptionHandler 사용, 웹소켓에서는 @MessageExceptionHandler 사용
    @MessageExceptionHandler
    public void handleException(Exception exception) {
        log.error("exception: {}", exception.getClass());

    }

    @MessageExceptionHandler
    public void handleException(RuntimeException exception) {
        log.error("exception: {}", exception.getClass());

    }

    @MessageExceptionHandler
    @SendTo("/topic/hello") // /topic/hello 를 구독한 모든 웹소켓 세션
    public String handleException(IOException exception, MessageHeaders headers) {
        log.error("exception: {}", exception.getClass());
        return "error!!";
    }
}

