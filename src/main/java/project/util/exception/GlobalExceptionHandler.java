package project.util.exception;


import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(TradeNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handleTradeNotFound(TradeNotFoundException e, Model model) {
        model.addAttribute("errorMessage", e.getMessage());
        return "error/400";
    }

    // 기타 예외 처리
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public String handleGenericException(Exception e, Model model) {
        model.addAttribute("errorMessage", "서버 오류가 발생했습니다.");
        return "error/500";
    }

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public String handleMaxSizeException(MaxUploadSizeExceededException ex, Model model) {
        // FlashAttributes 대신 Model에 바로 넣기
        model.addAttribute("errorMessage", "업로드 가능한 파일 크기를 초과했습니다. (최대 5MB)");
        return "error/fileSizeError"; // 리다이렉트 하지 않고 바로 JSP 렌더
    }
}