package project.chat.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@AllArgsConstructor
@Data
public class ResponseSessionsDto {
    // sendToUser 1:1 통신 시 사용자에게 전달되는 웹소켓 응답 객체

    private int count; // sessions.size()
    private List<String> sessions; // 전체 세션 리스트

    private String sessionId; // 현재 웹소켓 세션
    private LocalDateTime localDateTime;
}
