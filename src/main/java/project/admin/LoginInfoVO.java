package project.admin;

import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
public class LoginInfoVO {
    private Long login_info_seq;
    private Long admin_seq;
    private Long member_seq;
    private LocalDateTime login_dtm;
    private LocalDateTime logout_dtm;
    private String login_ip;
    private String logout_ip;

    private String admin_login_id;

    private String member_nicknm;
    private String member_email;

    // 포맷터 상수 (재사용)
    private static final DateTimeFormatter DATE_FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter TIME_FORMATTER =
            DateTimeFormatter.ofPattern("HH:mm:ss");
    private static final DateTimeFormatter DATETIME_FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // ===== 로그인 시간 포맷팅 =====
    public String getLoginDate() {
        return login_dtm != null ? login_dtm.format(DATE_FORMATTER) : "-";
    }

    public String getLoginTime() {
        return login_dtm != null ? login_dtm.format(TIME_FORMATTER) : "-";
    }

    public String getFormattedLoginDtm() {
        return login_dtm != null ? login_dtm.format(DATETIME_FORMATTER) : "-";
    }

    // ===== 로그아웃 시간 포맷팅 =====
    public String getLogoutDate() {
        return logout_dtm != null ? logout_dtm.format(DATE_FORMATTER) : null;
    }

    public String getLogoutTime() {
        return logout_dtm != null ? logout_dtm.format(TIME_FORMATTER) : null;
    }

    public String getFormattedLogoutDtm() {
        return logout_dtm != null ? logout_dtm.format(DATETIME_FORMATTER) : "-";
    }

    // ===== 접속 여부 =====
    public boolean isActive() {
        return logout_dtm == null;
    }

    // ===== 접속 시간 계산 (분 단위) =====
    public Long getSessionDurationMinutes() {
        if (login_dtm == null || logout_dtm == null) {
            return null;
        }
        return java.time.Duration.between(login_dtm, logout_dtm).toMinutes();
    }
}
