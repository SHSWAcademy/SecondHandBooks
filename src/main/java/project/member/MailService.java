package project.member;

package project.member; // 또는 project.common.service 등 패키지 분리 권장

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.mail.internet.MimeMessage;
import java.util.Random;
import java.util.concurrent.TimeUnit;

@Service
@Slf4j
@RequiredArgsConstructor
public class MailService {

    private final JavaMailSender mailSender;
    private final StringRedisTemplate redisTemplate;

    // 인증 이메일 발송
    public boolean sendAuthEmail(String email) {
        // 1. 난수 생성
        Random random = new Random();
        String checkNum = String.valueOf(random.nextInt(888888) + 111111);

        // 2. Redis 저장 (유효기간 3분)
        try {
            redisTemplate.opsForValue().set("AuthCode:" + email, checkNum, 180, TimeUnit.SECONDS);
        } catch (Exception e) {
            log.error("Redis 저장 실패", e);
            return false;
        }

        // 3. 이메일 전송
        String title = "[Shinhan Books] 회원가입 인증번호입니다.";
        String content = "<h3>Shinhan Books 회원가입 인증번호</h3>" +
                "<p>아래 인증번호를 3분 이내에 입력해주세요.</p>" +
                "<h1>[" + checkNum + "]</h1>";

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");

            // 보내는 사람 설정 (구글 SMTP 설정과 일치해야 함)
            helper.setFrom("본인구글이메일@gmail.com");
            helper.setTo(email);
            helper.setSubject(title);
            helper.setText(content, true);

            mailSender.send(message);
            return true;
        } catch (Exception e) {
            log.error("이메일 발송 실패", e);
            return false;
        }
    }

    // 인증번호 검증
    public boolean verifyEmailCode(String email, String code) {
        String savedCode = redisTemplate.opsForValue().get("AuthCode:" + email);

        if (savedCode != null && savedCode.equals(code)) {
            redisTemplate.delete("AuthCode:" + email); // 인증 성공 시 삭제
            return true;
        }
        return false;
    }
}