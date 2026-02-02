package project.common;

public enum UserType {
    ADMIN(1),   // 10초 후 로그아웃
    MEMBER(1); // 5분(300초) 후 로그아웃

    private final int timeoutSeconds;

    UserType(int timeoutSeconds) {
        this.timeoutSeconds = timeoutSeconds;
    }

    public int getTimeoutSeconds() {
        return timeoutSeconds;
    }
}
