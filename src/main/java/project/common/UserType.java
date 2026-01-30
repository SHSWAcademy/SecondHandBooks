package project.common;

public enum UserType {
    ADMIN(10),   // 10초 후 로그아웃
    MEMBER(300); // 5분(300초) 후 로그아웃

    private final int timeoutSeconds;

    UserType(int timeoutSeconds) {
        this.timeoutSeconds = timeoutSeconds;
    }

    public int getTimeoutSeconds() {
        return timeoutSeconds;
    }
}
