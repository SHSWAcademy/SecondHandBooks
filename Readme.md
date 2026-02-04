# SecondaryBook - 중고책 거래 및 독서 모임 플랫폼

## 프로젝트 개요
중고책 판매/구매와 독서 모임을 결합한 온라인 플랫폼입니다.

---

## 주요 기능

### 1. 회원 관리
- **소셜 로그인** - 카카오, 네이버 OAuth 2.0 (WebClient 사용)
- **회원가입/로그인** - 일반 이메일 로그인
- **비밀번호 찾기** - Gmail SMTP 이메일 인증
- **회원 정보 수정/탈퇴**

---

### 2. 중고책 거래

#### 거래 플로우
```
판매자: 판매글 등록 → 구매자: 채팅 문의 → 판매자: 안전결제 요청
    → 구매자: 결제 완료 → 배송 → 구매자: 구매 확정 (또는 15일 후 자동 확정)
```

#### 상세 기능
- **책 검색** - 카카오 책 검색 API 연동
- **판매글 CRUD** - 등록, 조회, 수정, 삭제
- **이미지 업로드** - S3 + CloudFront 다중 업로드
- **찜하기** - 관심 상품 저장
- **카테고리별 필터링**
- **판매 상태 관리** - 판매중 / 판매완료

---

### 3. 안전 결제

#### 결제 플로우
```
1. 판매자가 채팅에서 "안전결제 요청" 버튼 클릭
2. 구매자에게 결제 페이지 링크 전송 (5분 타임아웃)
3. 구매자가 Toss Payments로 결제
4. 결제 완료 → 판매 상태 "판매완료"로 변경
5. 구매자가 "구매 확정" 클릭 또는 15일 후 자동 확정
```

#### 상세 기능
| 기능 | 설명 |
|------|------|
| **결제 수단** | Toss Payments (카드, 간편결제) |
| **타임아웃** | 안전결제 요청 후 5분 내 미결제 시 자동 취소 |
| **자동 확정** | 구매 후 15일 경과 시 스케줄러가 자동 구매 확정 |
| **수정/삭제 제한** | 안전결제 진행 중(PENDING) 또는 완료(COMPLETED) 상태에서는 판매글 수정/삭제 불가 |

#### 관리자 기능
- **안전결제 내역 조회** - 관리자 페이지에서 전체 안전결제 내역 확인 가능
- **결제 상태 모니터링** - NONE / PENDING / COMPLETED 상태 관리

---

### 4. 실시간 채팅

#### 채팅 플로우
```
구매자: 판매글에서 "채팅하기" 클릭 → 1:1 채팅방 생성
    → 실시간 대화 → 판매자: 안전결제 요청 → 결제 진행
```

#### 상세 기능
- **1:1 채팅** - 구매자-판매자 간 실시간 대화
- **WebSocket + STOMP** 기반 실시간 통신
- **Redis Pub/Sub** - 메시지 브로커로 다중 서버 지원
- **채팅방 목록 조회** - 판매중/판매완료 필터링
- **읽음/안읽음 표시**
- **안전결제 요청** - 채팅 내에서 결제 요청 발송

---

### 5. 독서 모임

#### 모임 플로우
```
1. 모임장: 독서모임 개설 (모임명, 설명, 최대 인원, 배너 이미지)
2. 일반 회원: 모임 목록에서 가입 신청
3. 모임장: 가입 신청 승인/거절
4. 멤버: 모임 게시판에서 글 작성, 댓글, 좋아요
5. 모임장: 모임 정보 수정, 멤버 관리, 모임 종료
```

#### 가입 프로세스
| 상태 | 설명 |
|------|------|
| **WAIT** | 가입 신청 대기 중 |
| **JOINED** | 가입 승인됨 (활동 가능) |
| **REJECTED** | 가입 거절됨 |

#### 상세 기능
- **모임 개설** - 모임명, 설명, 모집 인원, 정기 모임 장소 설정
- **배너/프로필 이미지** - S3 업로드
- **모임 목록** - 페이지네이션, 검색
- **가입 신청** - 가입 사유 작성 후 모임장 승인 대기
- **모임 게시판** - 글 작성, 이미지 첨부, 댓글, 좋아요
- **멤버 관리** - 모임장이 멤버 강퇴, 권한 위임
- **찜하기** - 관심 모임 저장
- **모임 종료** - 모임장이 모임 종료 시 게시글/이미지 일괄 삭제

---

### 6. 마이페이지
- **판매 내역** - 판매중/판매완료 필터링
- **구매 내역** - 안전결제 구매 목록, 구매 확정 버튼
- **찜 목록** - 찜한 상품/모임
- **회원 정보 수정**
- **배송 주소 관리** - 배송지 등록/수정/삭제
- **나의 모임** - 가입한 독서모임 목록

---

### 7. 공지사항
- **공지사항 목록** - 관리자가 등록한 공지사항 조회
- **공지사항 상세** - 공지사항 내용 확인

---

### 8. 관리자
- **대시보드** - 회원 수, 거래 수, 모임 수 통계
- **회원 관리** - 회원 목록, 검색, 상세 조회
- **상품 관리** - 판매글 목록, 검색
- **모임 관리** - 독서모임 목록, 검색
- **안전결제 내역** - 전체 결제 내역 조회
- **공지사항 관리** - 공지 CRUD
- **배너 관리** - 메인 페이지 배너 관리

---

## 📦 S3 & CloudFront (이미지 최적화)

### 아키텍처
```
이미지 업로드 → S3 저장 → CloudFront URL 반환 → 사용자에게 CDN으로 제공
```

### 구성

| 항목 | 값 |
|------|-----|
| **S3 버킷** | secondarybooksimages |
| **CloudFront 도메인** | d3p8m254izebr5.cloudfront.net |
| **이미지 경로** | images/{UUID}.{확장자} |

### 최적화 효과

| 항목 | S3 직접 | CloudFront |
|------|---------|------------|
| **응답 시간** | ~300ms | ~50ms |
| **캐싱** | 없음 | 엣지 로케이션 캐싱 |
| **비용** | 요청당 과금 | 캐시 히트 시 무료 |

### 코드 구현
```java
// S3Service.java
@Value("${AWS_CLOUDFRONT_DOMAIN:}")
private String cloudFrontDomain;

public String uploadFile(MultipartFile file) {
    // S3에 업로드 후 CloudFront URL 반환
    if (cloudFrontDomain != null && !cloudFrontDomain.isEmpty()) {
        return String.format("https://%s/%s", cloudFrontDomain, key);
    }
    return String.format("https://%s.s3.%s.amazonaws.com/%s", bucketName, region, key);
}
```

### 적용 범위
- 중고책 판매 이미지
- 독서모임 배너/게시글 이미지
- 회원 프로필 이미지

---

## 기술 스택

| 구분 | 기술 |
|------|------|
| **Backend** | Spring MVC 5.3.39, MyBatis 3.5.19 |
| **Database** | PostgreSQL (AWS RDS) |
| **Connection Pool** | HikariCP 4.0.3 |
| **Cache/Broker** | Redis (Lettuce) - ElastiCache |
| **Real-time** | WebSocket, STOMP, Redis Pub/Sub |
| **Storage** | AWS S3 + CloudFront CDN |
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
│   ├── config/                    # Spring 설정
│   │   ├── AppConfig.java         # RestTemplate, ObjectMapper Bean
│   │   ├── MvcConfig.java         # View Resolver, 정적 리소스
│   │   ├── StompConfig.java       # WebSocket STOMP 설정
│   │   ├── S3Config.java          # AWS S3 Client
│   │   ├── SchedulerConfig.java   # @EnableScheduling
│   │   ├── WebClientConfig.java   # OAuth, Toss API WebClient
│   │   ├── InterceptorConfig.java
│   │   ├── interceptor/           # 인터셉터
│   │   │   ├── AdminAuthInterceptor.java
│   │   │   └── MemberActivityInterceptor.java
│   │   └── redis/                 # Redis 설정
│   │       ├── RedisConfig.java
│   │       └── RedisCacheConfig.java
│   │
│   ├── member/                    # 회원 관리
│   │   ├── MemberController.java  # OAuth, 회원가입/로그인
│   │   ├── MemberService.java
│   │   ├── MemberMapper.java
│   │   ├── MemberVO.java
│   │   ├── MailService.java       # Gmail SMTP
│   │   └── ENUM/
│   │       └── MemberStatus.java
│   │
│   ├── trade/                     # 중고책 거래
│   │   ├── TradeController.java   # 판매글 CRUD
│   │   ├── TradeService.java
│   │   ├── TradeMapper.java
│   │   ├── TradeVO.java
│   │   ├── BookImgMapper.java
│   │   └── ENUM/
│   │       ├── SaleStatus.java    # SELLING, SOLD_OUT
│   │       ├── BookStatus.java
│   │       └── PaymentType.java
│   │
│   ├── payment/                   # 안전 결제
│   │   ├── PaymentController.java
│   │   ├── PaymentService.java
│   │   ├── TossApiService.java    # Toss Payments API
│   │   ├── PaymentVO.java
│   │   └── SafePaymentScheduler.java  # 타임아웃/자동확정
│   │
│   ├── chat/                      # 실시간 채팅
│   │   ├── StompController.java   # WebSocket 메시지 핸들러
│   │   ├── chatroom/
│   │   │   ├── ChatroomController.java
│   │   │   ├── ChatroomService.java
│   │   │   └── ChatroomVO.java
│   │   └── message/
│   │       ├── MessageService.java
│   │       └── MessageVO.java
│   │
│   ├── bookclub/                  # 독서 모임
│   │   ├── controller/
│   │   │   ├── BookClubController.java
│   │   │   └── BookClubManageController.java
│   │   ├── service/
│   │   │   └── BookClubService.java
│   │   ├── mapper/
│   │   │   └── BookClubMapper.java
│   │   ├── dto/                   # 데이터 전송 객체
│   │   │   ├── BookClubJoinRequestDTO.java
│   │   │   └── BookClubPageResponseDTO.java
│   │   ├── vo/
│   │   │   ├── BookClubVO.java
│   │   │   ├── BookClubBoardVO.java
│   │   │   ├── BookClubMemberVO.java
│   │   │   └── BookClubWishVO.java
│   │   └── ENUM/
│   │       └── JoinStatus.java    # WAIT, JOINED, REJECTED
│   │
│   ├── mypage/                    # 마이페이지
│   │   └── MypageController.java
│   │
│   ├── admin/                     # 관리자
│   │   ├── AdminController.java
│   │   ├── AdminService.java
│   │   ├── BannerVO.java
│   │   └── notice/
│   │       └── NoticeVO.java
│   │
│   ├── address/                   # 배송 주소 관리
│   │   ├── AddressController.java
│   │   ├── AddressService.java
│   │   └── AddressVO.java
│   │
│   ├── notice/                    # 공지사항
│   │   └── NoticeController.java
│   │
│   ├── common/                    # 공통 기능
│   │   └── LogoutPendingManager.java
│   │
│   └── util/                      # 유틸리티
│       ├── S3Service.java         # S3 파일 업로드
│       ├── HomeController.java
│       ├── HealthController.java  # 헬스체크
│       ├── book/
│       │   └── BookApiService.java  # 카카오 책 검색 API
│       ├── imgUpload/
│       │   └── FileStore.java
│       ├── exception/
│       │   └── GlobalExceptionHandler.java
│       └── paging/
│           ├── PageResult.java
│           └── SearchVO.java
│
├── src/main/resources/
│   ├── project/                   # MyBatis Mapper XML
│   │   ├── trade/
│   │   ├── chat/
│   │   ├── bookclub/
│   │   ├── member/
│   │   ├── admin/
│   │   └── address/
│   ├── application.properties     # 환경 설정
│   └── logback.xml                # 로깅 설정
│
├── src/main/webapp/WEB-INF/
│   ├── spring/
│   │   ├── root-context.xml
│   │   └── appServlet/
│   │       └── servlet-context.xml
│   └── views/                     # JSP (59개)
│       ├── member/
│       │   ├── mypage.jsp
│       │   ├── signup.jsp
│       │   └── tabs/              # 마이페이지 탭
│       │       ├── profile.jsp
│       │       ├── sales.jsp
│       │       ├── purchases.jsp
│       │       ├── wishlist.jsp
│       │       ├── groups.jsp
│       │       └── addresses.jsp
│       ├── trade/
│       │   ├── tradelist.jsp
│       │   ├── tradedetail.jsp
│       │   ├── tradeform.jsp
│       │   └── tradeupdate.jsp
│       ├── chat/
│       │   └── chatrooms.jsp
│       ├── bookclub/
│       │   ├── bookclub_list.jsp
│       │   ├── bookclub_create.jsp
│       │   ├── bookclub_detail.jsp
│       │   ├── bookclub_manage.jsp
│       │   └── bookclub_posts.jsp
│       ├── payment/
│       │   ├── payform.jsp
│       │   ├── success.jsp
│       │   └── fail.jsp
│       ├── admin/
│       ├── common/
│       └── error/
│
├── k6/                            # 부하 테스트 스크립트
├── scripts/                       # 배포 스크립트
├── appspec.yml                    # AWS CodeDeploy
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

## AWS 인프라

### 아키텍처
```
사용자 → Route 53 → ALB → EC2 (Auto Scaling)
                         ↓
                    RDS (PostgreSQL)
                         ↓
                    ElastiCache (Redis)

이미지 → S3 → CloudFront (CDN)
```

### 구성 요소

| 서비스 | 스펙 | 용도 |
|--------|------|------|
| **EC2** | t3.small (2GB RAM) | 웹 서버 |
| **ALB** | Application Load Balancer | 로드 밸런싱 |
| **Auto Scaling** | 최소 1대, 최대 8대 | 자동 확장 |
| **RDS** | PostgreSQL | 데이터베이스 |
| **ElastiCache** | Redis | 캐시 + 메시지 브로커 |
| **S3** | Standard | 이미지 저장 |
| **CloudFront** | CDN | 이미지 캐싱 |

### Auto Scaling 정책

| 항목 | 설정 |
|------|------|
| 트리거 | CPU 사용률 **50%** 초과 |
| 최소 인스턴스 | 1대 |
| 최대 인스턴스 | 8대 |
| 쿨다운 | 60초 |

---

## 부하 테스트 (k6)

AWS CloudWatch를 통해 실시간 모니터링하며 테스트를 진행했습니다.

### 테스트 환경

| 항목 | 값 |
|------|-----|
| 서버 | EC2 t3.small (2GB RAM) |
| Auto Scaling | 최소 1대, 최대 8대 |
| 모니터링 | AWS CloudWatch |

### 시나리오 1: Load Test (예상 트래픽)

발표 시 약 30명의 인원이 30분간 웹사이트에 접속하는 상황을 시뮬레이션합니다.

```javascript
export const options = {
    stages: [
        { duration: '2m', target: 30 },   // 2분 동안 30명까지 증가
        { duration: '26m', target: 30 },  // 26분 동안 30명 유지
        { duration: '2m', target: 0 },    // 2분 동안 종료
    ],
    thresholds: {
        http_req_duration: ['p(95)<1000'],  // 95% 요청 1초 이내
        http_req_failed: ['rate<0.05'],     // 에러율 5% 미만
    },
};
```

**결과:**
| 지표 | 기준 | 결과 | 판정 |
|------|------|------|------|
| p(95) 응답시간 | 1초 미만 | **59.7ms** | ✅ 통과 |
| 에러율 | 5% 미만 | **0.00%** | ✅ 통과 |

```
http_req_duration: avg=26.73ms, med=21.52ms, p(95)=59.7ms
http_req_failed: 0.00%
http_reqs: 13,695건 (7.6/s)
```

**결론:** 30 VU, 30분 부하에서 에러 0%, p95 60ms로 매우 안정적입니다.

---

### 시나리오 2: Stress Test (한계 테스트)

시스템의 한계점을 파악하기 위해 500 VU까지 점진적으로 부하를 증가시킵니다.

```javascript
export const options = {
    stages: [
        { duration: '1m', target: 30 },    // 워밍업
        { duration: '3m', target: 30 },
        { duration: '1m', target: 100 },
        { duration: '5m', target: 100 },
        { duration: '1m', target: 200 },
        { duration: '5m', target: 200 },
        { duration: '1m', target: 350 },
        { duration: '5m', target: 350 },
        { duration: '1m', target: 500 },   // 최대
        { duration: '5m', target: 500 },
        { duration: '2m', target: 0 },
    ],
    thresholds: {
        http_req_duration: ['p(95)<3000'],
        http_req_failed: ['rate<0.10'],
    },
};
```

**결과 (t3.small × 2대, Auto Scaling):**
| 지표 | 기준 | 결과 | 판정 |
|------|------|------|------|
| p(95) 응답시간 | 3초 미만 | **1.85초** | ✅ 통과 |
| 에러율 | 10% 미만 | **0.00%** | ✅ 통과 |

```
http_req_duration: avg=452.92ms, med=149.01ms, p(90)=1.06s, p(95)=1.85s
http_req_failed: 0.00%
http_reqs: 458,004건 (254/s)
data_received: 19 GB
```

**Auto Scaling 동작:**
- 테스트 중 CPU 50% 초과 → 자동으로 1대 → 2대 스케일 아웃
- 테스트 종료 후 부하 감소 → 자동으로 2대 → 1대 스케일 인

**결론:** 500 VU (동시 사용자 500명)는 t3.small 2대로 안정적으로 처리 가능합니다.

---

## 외부 API

| API | 용도 | 상태 |
|-----|------|------|
| **Toss Payments** | 결제 | ✅ 연동 완료 |
| **카카오 책 검색** | 도서 정보 조회 | ✅ 연동 완료 |
| **카카오 OAuth** | 소셜 로그인 | ✅ 연동 완료 |
| **네이버 OAuth** | 소셜 로그인 | ✅ 연동 완료 |
| **Gmail SMTP** | 이메일 발송 | ✅ 연동 완료 |
| **AWS S3** | 이미지 저장 | ✅ 연동 완료 |
| **AWS CloudFront** | 이미지 CDN | ✅ 연동 완료 |

---

## 향후 계획
- 알림 기능 (실시간 알림)
- 포인트/적립금 시스템
- 리뷰/평점 시스템
