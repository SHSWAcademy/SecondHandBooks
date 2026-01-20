package project.member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
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

    @Value("${mail.username}")
    private String fromEmail;

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

        // 3. 이메일 전송 (디자인 적용)
        String title = "[SecondHand Books] 회원가입 인증번호 안내";

        // 신한 블루 컬러: #0046FF (또는 #3F51B5 계열)
        // 깔끔한 카드형 디자인
        StringBuilder content = new StringBuilder();
        content.append("<div style='font-family: \"Malgun Gothic\", \"Apple SD Gothic Neo\", sans-serif; background-color: #f4f5f7; padding: 40px 0;'>");
        content.append("  <div style='max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.05); border: 1px solid #e1e4e8;'>");

        // [헤더] 신한 블루 배경
        content.append("    <div style='background-color: #0046FF; padding: 24px 30px; text-align: left;'>");
        content.append("      <h1 style='color: #ffffff; font-size: 20px; margin: 0; font-weight: 700; letter-spacing: -0.5px;'>SecondHand Books</h1>");
        content.append("    </div>");

        // [본문]
        content.append("    <div style='padding: 40px 30px;'>");
        content.append("      <h2 style='color: #1a1a1a; font-size: 24px; font-weight: 700; margin: 0 0 20px 0; letter-spacing: -0.5px;'>회원가입 인증번호 안내</h2>");
        content.append("      <p style='color: #555555; font-size: 15px; line-height: 1.6; margin: 0 0 30px 0;'>");
        content.append("        안녕하세요, 고객님.<br>");
        content.append("        SecondHand Books를 이용해 주셔서 감사합니다.<br>");
        content.append("        아래 <strong>인증번호 6자리</strong>를 화면에 입력하여 본인 인증을 완료해 주세요.");
        content.append("      </p>");

        // [인증번호 박스] 강조
        content.append("      <div style='background-color: #F0F4FF; border-radius: 4px; padding: 30px; text-align: center; margin-bottom: 30px; border: 1px solid #D6E4FF;'>");
        content.append("        <span style='display: block; color: #0046FF; font-size: 32px; font-weight: 800; letter-spacing: 4px;'>").append(checkNum).append("</span>");
        content.append("      </div>");

        // [유의사항]
        content.append("      <div style='background-color: #fafafa; padding: 20px; border-radius: 4px; border: 1px solid #eeeeee;'>");
        content.append("        <ul style='margin: 0; padding-left: 20px; color: #888888; font-size: 13px; line-height: 1.5;'>");
        content.append("          <li style='margin-bottom: 5px;'>인증번호의 유효 시간은 <strong>3분</strong>입니다.</li>");
        content.append("          <li>본 메일은 발신 전용이며, 회신되지 않습니다.</li>");
        content.append("          <li>만약 본인이 요청하지 않았다면, 이 메일을 무시해 주세요.</li>");
        content.append("        </ul>");
        content.append("      </div>");
        content.append("    </div>"); // 본문 끝

        // [푸터]
        content.append("    <div style='background-color: #f9f9f9; padding: 20px 30px; border-top: 1px solid #eeeeee; text-align: center;'>");
        content.append("      <p style='color: #999999; font-size: 12px; margin: 0;'>© SecondHand Books Corp. All rights reserved.</p>");
        content.append("    </div>");

        content.append("  </div>");
        content.append("</div>");

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");

            // 보내는 사람 설정 (구글 SMTP 설정과 일치해야 함)
            helper.setFrom(fromEmail);
            helper.setTo(email);
            helper.setSubject(title);
            helper.setText(content.toString(), true); // HTML true 설정 필수

            mailSender.send(message);
            return true;
        } catch (Exception e) {
            log.error("이메일 발송 실패", e);
            return false;
        }
    }

    // 인증번호 검증 (기존 코드 유지)
    public boolean verifyEmailCode(String email, String code) {
        String savedCode = redisTemplate.opsForValue().get("AuthCode:" + email);

        if (savedCode != null && savedCode.equals(code)) {
            redisTemplate.delete("AuthCode:" + email); // 인증 성공 시 삭제
            return true;
        }
        return false;
    }
}