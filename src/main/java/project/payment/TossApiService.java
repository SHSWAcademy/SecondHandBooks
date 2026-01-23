package project.payment;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import java.util.HashMap;
import java.util.Map;

@Service
@Slf4j
@RequiredArgsConstructor
public class TossApiService {

    private final WebClient tossPaymentWebClient;  // WebClientConfig에서 주입

    /**
     * 토스 결제 승인 API 호출
     */
    public TossPaymentResponse confirmPayment(String paymentKey, String orderId, int amount) {

        // 1. 요청 바디 생성
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("paymentKey", paymentKey);
        requestBody.put("orderId", orderId);
        requestBody.put("amount", amount);

        try {
            // 2. WebClient로 POST 요청
            TossPaymentResponse response = tossPaymentWebClient
                    .post()
                    .bodyValue(requestBody)           // JSON 바디
                    .retrieve()                       // 응답 받기
                    .bodyToMono(TossPaymentResponse.class)  // JSON → 객체 변환
                    .block();                         // 동기 처리 (결과 기다림)

            log.info("토스 결제 승인 성공: {}", response);
            return response;

        } catch (WebClientResponseException e) {
            // 3. 토스 API 에러 응답 처리
            log.error("토스 API 에러: {} - {}", e.getStatusCode(), e.getResponseBodyAsString());

            TossPaymentResponse errorResponse = new TossPaymentResponse();
            errorResponse.setCode("TOSS_API_ERROR");
            errorResponse.setMessage(e.getResponseBodyAsString());
            return errorResponse;

        } catch (Exception e) {
            log.error("토스 결제 승인 실패", e);

            TossPaymentResponse errorResponse = new TossPaymentResponse();
            errorResponse.setCode("UNKNOWN_ERROR");
            errorResponse.setMessage(e.getMessage());
            return errorResponse;
        }
    }
}
