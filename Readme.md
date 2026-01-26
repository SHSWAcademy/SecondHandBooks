# SecondaryBook - 중고책 거래 및 독서 모임 플랫폼

## 프로젝트 개요
중고책 판매/구매와 독서 모임을 결합한 온라인 플랫폼입니다.

---

## 주요 기능

### 1. 회원 관리
- **소셜 로그인** - 카카오, 네이버 OAuth 2.0
- **회원가입/로그인** - 일반 이메일 로그인
- **비밀번호 찾기** - Gmail SMTP 이메일 인증
- **회원 정보 수정/탈퇴**

---

### 2. 중고책 거래
- **책 검색** - 카카오 책 검색 API 연동
- **판매글 CRUD** - 등록, 조회, 수정, 삭제
- **이미지 업로드** - 상품 사진 다중 업로드
- **찜하기** - 관심 상품 저장
- **카테고리별 필터링**

---

### 3. 결제
- **Toss Payments 연동** - 카드 결제, 간편 결제
- **주문 생성/조회**
- **결제 승인/취소**

---

### 4. 실시간 채팅
- **1:1 채팅** - 구매자-판매자 간 실시간 대화
- **WebSocket + STOMP** 기반
- **Redis** 메시지 브로커
- **채팅방 목록 조회**
- **읽음/안읽음 표시**

---

### 5. 독서 모임
- **모임 개설** - 모임명, 설명, 모집 인원 설정
- **모임 목록/상세 조회**
- **가입 신청/승인** - 모임장 승인 방식
- **모임 게시판** - 공지사항 및 소통
- **찜하기** - 관심 모임 저장

---

### 6. 마이페이지
- **판매/구매 내역**
- **찜 목록**
- **회원 정보 수정**

---

### 7. 관리자
- **회원 관리**
- **상품 관리**
- **모임 관리**

---

## 기술 스택

| 구분 | 기술 |
|------|------|
| **Backend** | Spring MVC 5.3.39, MyBatis 3.5.19 |
| **Database** | PostgreSQL (AWS RDS) |
| **Connection Pool** | HikariCP 4.0.3 |
| **Real-time** | WebSocket, STOMP, Redis (Lettuce) |
| **Payment** | Toss Payments API |
| **OAuth** | 카카오, 네이버 |
| **External API** | 카카오 책 검색 API |
| **Email** | Gmail SMTP |
| **Build Tool** | Maven 3.6+ |
| **Java Version** | Java 17 |
| **Web Server** | Tomcat 9 (Cargo Plugin) |

---

## 프로젝트 구조
```
secondaryBook/
├── src/main/java/project/
│   ├── config/                # Spring 설정
│   │   ├── AppConfig.java
│   │   ├── MvcConfig.java
│   │   ├── RedisConfig.java
│   │   ├── StompConfig.java
│   │   └── WebClientConfig.java
│   ├── member/                # 회원 관리
│   ├── trade/                 # 중고책 거래
│   ├── payment/               # 결제
│   ├── chat/                  # 실시간 채팅
│   │   ├── chatroom/          # 채팅방
│   │   ├── message/           # 메시지
│   │   └── StompController.java
│   ├── bookclub/              # 독서 모임
│   │   ├── controller/
│   │   ├── service/
│   │   ├── mapper/
│   │   └── vo/
│   ├── mypage/                # 마이페이지
│   ├── admin/                 # 관리자
│   ├── address/               # 주소 관리
│   └── util/                  # 유틸리티
│       ├── book/              # 책 API
│       ├── imgUpload/         # 이미지 업로드
│       ├── exception/         # 예외 처리
│       └── interceptor/       # 인터셉터
├── src/main/resources/
│   ├── project/               # MyBatis Mapper XML
│   └── application.properties # 설정 파일
├── src/main/webapp/WEB-INF/
│   ├── spring/                # Spring XML 설정
│   └── views/                 # JSP
│       ├── member/
│       ├── trade/
│       ├── payment/
│       ├── chat/
│       ├── bookclub/
│       ├── admin/
│       ├── common/
│       └── error/
└── pom.xml
```

---

## 개발 환경 설정

### 필수 요구사항
- **Java**: JDK 17
- **Maven**: 3.6.0 이상
- **Redis**: 로컬 또는 원격 Redis 서버
- **Database**: PostgreSQL

### 1. 프로젝트 클론
```bash
git clone <repository-url>
cd secondaryBook
```

### 2. 설정 파일 수정
`src/main/resources/application.properties` 파일에서 환경에 맞게 설정:

```properties
# Database
db.url=jdbc:log4jdbc:postgresql://your-host:5432/your-db
db.username=your-username
db.password=your-password

# Redis
redis.host=localhost
redis.port=6379

# 이미지 저장 경로
file.dir=/your/image/path

# Toss Payments
api.toss.secret-key=your-secret-key

# Kakao OAuth
api.kakao.client.id=your-client-id
api.kakao.client_secret=your-secret
api.kakao.redirect.uri=http://localhost:8080/auth/kakao/callback

# Naver OAuth
api.naver.client.id=your-client-id
api.naver.client.secret=your-secret
api.naver.redirect.uri=http://localhost:8080/auth/naver/callback

# Kakao Book API
api.kakao.rest-api-key=your-api-key

# Gmail SMTP
mail.username=your-email@gmail.com
mail.password=your-app-password
```

### 3. 빌드 및 실행

**macOS/Linux:**
```bash
./mvnw clean package
./mvnw cargo:run
```

**Windows:**
```cmd
mvnw.cmd clean package
mvnw.cmd cargo:run
```

### 4. 접속
- http://localhost:8080/

---

## 외부 API

| API | 용도 | 상태 |
|-----|------|------|
| **Toss Payments** | 결제 | 연동 완료 |
| **카카오 책 검색** | 도서 정보 조회 | 연동 완료 |
| **카카오 OAuth** | 소셜 로그인 | 연동 완료 |
| **네이버 OAuth** | 소셜 로그인 | 연동 완료 |
| **Gmail SMTP** | 이메일 발송 | 연동 완료 |
| **AWS S3/CloudFront** | 이미지 저장 | 예정 |

---

## 향후 계획
- AWS S3 + CloudFront 이미지 저장소 마이그레이션
- 알림 기능 (실시간 알림)
- 포인트/적립금 시스템
- 리뷰/평점 시스템
