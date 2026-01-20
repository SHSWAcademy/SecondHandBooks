package project.chat.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RequestDto {
    private String message;
    private LocalDateTime localDateTime;
}
