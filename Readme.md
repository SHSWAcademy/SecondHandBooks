# 📚 SecondHand Books

> **책의 가치를 잇고, 독자를 연결하다.**
>
> 중고 서적 거래 & 로컬 독서 커뮤니티 플랫폼

<p align="center">
  <img src="https://img.shields.io/badge/Spring-6DB33F?style=for-the-badge&logo=spring&logoColor=white"/>
  <img src="https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white"/>
  <img src="https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white"/>
  <img src="https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white"/>
  <img src="https://img.shields.io/badge/WebSocket-010101?style=for-the-badge&logo=socket.io&logoColor=white"/>
</p>

---

## 📋 목차

- [프로젝트 소개](#-프로젝트-소개)
- [주요 기능](#-주요-기능)
- [기술 스택](#-기술-스택)
- [시스템 아키텍처](#-시스템-아키텍처)
- [ERD](#-erd)
- [API 설계](#-api-설계)
- [핵심 기술 상세](#-핵심-기술-상세)
- [트러블슈팅](#-트러블슈팅)
- [CI/CD 파이프라인](#-cicd-파이프라인)
- [팀 구성](#-팀-구성)

---

## 🎯 프로젝트 소개

### 프로젝트 배경

| 문제점 | 해결책 |
|--------|--------|
| 📝 **등록의 번거로움** - 책 정보를 하나하나 입력하는 과정 | ISBN/제목 입력만으로 **자동 등록** (Naver/Kakao Book API) |
| 🔒 **거래의 불안정성** - 비대면 거래의 신뢰 문제 | **에스크로 안전결제** 시스템 (Toss Payments) |
| 👥 **독서의 단절** - 혼자 읽는 독서 | **위치 기반 독서모임** 커뮤니티 |

### 프로젝트 기간
- **개발 기간**: 2024.12 ~ 2025.01 (6주)
- **팀 구성**: 6명

---

## ⭐ 주요 기능

### 1️⃣ 중고 서적 거래 (Trade)

```
판매글 등록 → 실시간 채팅 → 안전결제/계좌이체 → 구매확정 → 거래 완료
```

| 기능 | 설명 | 기술 |
|------|------|------|
| **1초 자동 등록** | ISBN/제목만 입력하면 책 정보 자동 완성 | WebClient (Non-blocking), Naver/Kakao API |
| **실시간 채팅** | 판매자-구매자 1:1 채팅 | WebSocket, STOMP, Pub/Sub |
| **안전결제 (에스크로)** | 구매확정 시까지 대금 보호 | Toss Payments API |
| **자동 구매확정** | 15일 후 자동 확정 | @Scheduled, Cron Expression |
| **판매 완료 처리** | 거래 완료 시 자동 상태 변경 | Transaction, State Machine |

#### 안전결제 플로우
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  결제 요청   │ ──▶ │  결제 수락   │ ──▶ │  대금 보관   │ ──▶ │  구매 확정   │
│  (구매자)    │     │  (판매자)    │     │  (플랫폼)    │     │  (15일/수동) │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
                                                                    │
                                                                    ▼
                                                           ┌─────────────┐
                                                           │  정산 완료   │
                                                           │  (판매자)    │
                                                           └─────────────┘
```

### 2️⃣ 회원 & 관리자 (Member & Admin)

| 기능 | 설명 |
|------|------|
| **소셜 로그인** | 카카오, 네이버 OAuth 2.0 연동 |
| **일반 로그인** | Spring Security 기반 인증/인가 |
| **마이페이지** | 판매/구매 내역, 찜 목록, 독서모임 관리 |
| **관리자 대시보드** | 회원/상품/모임 관리, 통계, 공지사항 |
| **로그인 로그** | 접속 기록 조회 및 모니터링 |

### 3️⃣ 독서모임 커뮤니티 (BookClub)

| 기능 | 설명 |
|------|------|
| **모임 생성/관리** | 독서모임 개설 및 운영 |
| **위치 기반 검색** | Kakao Map API 연동, 내 주변 모임 찾기 |
| **가입 신청/승인** | 모임장 승인 방식의 멤버십 |
| **커뮤니티 게시판** | 모임 내 게시글 작성, 댓글 |
| **찜하기** | 관심 모임 저장 |

---

## 🛠 기술 스택

### Backend
| 기술 | 버전 | 용도 |
|------|------|------|
| **Java** | 17 | 메인 언어 |
| **Spring MVC** | 5.3.x | 웹 프레임워크 |
| **Spring Security** | 5.8.x | 인증/인가 |
| **Spring WebFlux** | - | WebClient (Non-blocking HTTP) |
| **MyBatis** | 3.5.x | ORM |
| **WebSocket** | STOMP | 실시간 채팅 |

### Database & Cache
| 기술 | 용도 |
|------|------|
| **PostgreSQL** | 메인 데이터베이스 (AWS RDS) |
| **Redis** | 캐시, 세션 저장소 (AWS ElastiCache) |

### Infrastructure (AWS)
| 서비스 | 용도 |
|--------|------|
| **VPC** | 네트워크 격리 (Public/Private Subnet) |
| **ALB** | 로드밸런싱, HTTPS 종료 |
| **EC2** | 애플리케이션 서버 (Auto Scaling) |
| **RDS** | PostgreSQL 데이터베이스 |
| **ElastiCache** | Redis 캐시 클러스터 |
| **S3** | 이미지 저장소 |
| **CloudFront** | CDN (이미지 캐싱) |
| **CodeDeploy** | 자동 배포 |

### CI/CD & Monitoring
| 기술 | 용도 |
|------|------|
| **GitHub Actions** | CI/CD 파이프라인 |
| **CodeDeploy** | EC2 자동 배포 |
| **CloudWatch** | 모니터링, 로그 수집 |

### External APIs
| API | 용도 |
|-----|------|
| **Naver Book API** | 도서 정보 검색 |
| **Kakao Book API** | 도서 정보 검색 |
| **Kakao Map API** | 위치 기반 서비스 |
| **Toss Payments API** | 안전결제 (에스크로) |
| **Kakao OAuth** | 소셜 로그인 |
| **Naver OAuth** | 소셜 로그인 |

---

## 🏗 시스템 아키텍처

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                 AWS Cloud                                    │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │                           VPC (10.0.0.0/16)                            │  │
│  │                                                                        │  │
│  │   ┌─────────────────────────────────────────────────────────────────┐ │  │
│  │   │                    Public Subnet (AZ-a, AZ-c)                    │ │  │
│  │   │                                                                  │ │  │
│  │   │    ┌──────────────┐              ┌──────────────┐               │ │  │
│  │   │    │   Internet   │              │     NAT      │               │ │  │
│  │   │    │   Gateway    │              │   Gateway    │               │ │  │
│  │   │    └──────┬───────┘              └──────┬───────┘               │ │  │
│  │   │           │                             │                        │ │  │
│  │   │    ┌──────┴─────────────────────────────┴──────┐                │ │  │
│  │   │    │      Application Load Balancer (HTTPS)    │                │ │  │
│  │   │    │           [Sticky Session 활성화]          │                │ │  │
│  │   │    └─────────────────────┬─────────────────────┘                │ │  │
│  │   └──────────────────────────┼──────────────────────────────────────┘ │  │
│  │                              │                                        │  │
│  │   ┌──────────────────────────┼──────────────────────────────────────┐ │  │
│  │   │                          │    Private Subnet (AZ-a, AZ-c)       │ │  │
│  │   │                          ▼                                      │ │  │
│  │   │   ┌───────────────────────────────────────────┐                 │ │  │
│  │   │   │           Auto Scaling Group              │                 │ │  │
│  │   │   │    ┌───────────┐      ┌───────────┐       │                 │ │  │
│  │   │   │    │   EC2     │      │   EC2     │       │                 │ │  │
│  │   │   │    │ (Tomcat)  │      │ (Tomcat)  │       │                 │ │  │
│  │   │   │    │ t3.small  │      │ t3.small  │       │                 │ │  │
│  │   │   │    └─────┬─────┘      └─────┬─────┘       │                 │ │  │
│  │   │   │          │   Min:1 Max:2    │             │                 │ │  │
│  │   │   └──────────┼──────────────────┼─────────────┘                 │ │  │
│  │   │              │                  │                               │ │  │
│  │   │              ▼                  ▼                               │ │  │
│  │   │   ┌─────────────────┐  ┌─────────────────┐                      │ │  │
│  │   │   │  RDS PostgreSQL │  │   ElastiCache   │                      │ │  │
│  │   │   │   (Multi-AZ)    │  │    (Redis)      │                      │ │  │
│  │   │   └─────────────────┘  └─────────────────┘                      │ │  │
│  │   └─────────────────────────────────────────────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
│                                                                              │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │   ┌──────────────┐      ┌──────────────┐      ┌──────────────┐       │  │
│  │   │  CloudFront  │──────│      S3      │      │  CodeDeploy  │       │  │
│  │   │    (CDN)     │      │   (Images)   │      │  (CI/CD)     │       │  │
│  │   └──────────────┘      └──────────────┘      └──────────────┘       │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Security Groups

| Security Group | Inbound | Source |
|----------------|---------|--------|
| ALB-SG | 80, 443 | 0.0.0.0/0 |
| EC2-SG | 8080 | ALB-SG |
| RDS-SG | 5432 | EC2-SG |
| Redis-SG | 6379 | EC2-SG |

---

## 📊 ERD

### 전체 ERD 다이어그램

<p align="center">
  <img src="docs/erd_diagram.png" alt="ERD Diagram" width="100%"/>
</p>

### 핵심 엔티티 관계도

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              ERD Overview                                    │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│  MEMBER_INFO │───┬───│ SB_TRADE_INFO│───────│  BOOK_INFO   │
│──────────────│   │   │──────────────│       │──────────────│
│ member_seq   │   │   │ trade_seq    │       │ book_info_seq│
│ login_id     │   │   │ sale_title   │       │ isbn         │
│ member_pwd   │   │   │ sale_price   │       │ book_title   │
│ member_email │   │   │ sale_st      │       │ book_author  │
│ member_nicknm│   │   │ safe_payment │       │ book_img     │
└──────────────┘   │   └──────┬───────┘       └──────────────┘
       │           │          │
       │           │          │
       ▼           │          ▼
┌──────────────┐   │   ┌──────────────┐       ┌──────────────┐
│ MEMBER_OAUTH │   │   │   CHATROOM   │───────│   CHAT_MSG   │
│──────────────│   │   │──────────────│       │──────────────│
│ provider     │   │   │ chat_room_seq│       │ chat_msg_seq │
│ oauth_id     │   │   │ trade_seq    │       │ chat_cont    │
└──────────────┘   │   │ last_msg     │       │ sent_dtm     │
                   │   └──────────────┘       └──────────────┘
                   │
                   │   ┌──────────────┐       ┌──────────────┐
                   └───│  BOOK_CLUB   │───────│BOOK_CLUB_MEMBER
                       │──────────────│       │──────────────│
                       │ book_club_seq│       │ member_seq   │
                       │ book_club_nm │       │ join_st      │
                       │ leader_seq   │       │ leader_yn    │
                       └──────┬───────┘       └──────────────┘
                              │
                              ▼
                       ┌──────────────┐
                       │BOOK_CLUB_BOARD
                       │──────────────│
                       │ board_seq    │
                       │ board_title  │
                       │ board_cont   │
                       └──────────────┘
```

### 주요 테이블 (18개)

| 도메인 | 테이블 | 설명 |
|--------|--------|------|
| **회원** | MEMBER_INFO | 회원 기본 정보 |
| | MEMBER_OAUTH | 소셜 로그인 연동 정보 |
| | ADDRESS_INFO | 배송지 정보 |
| **거래** | SB_TRADE_INFO | 판매글 정보 |
| | BOOK_INFO | 도서 정보 (ISBN 기반) |
| | BOOK_IMAGE | 상품 이미지 |
| | TRADE_WISH | 찜하기 |
| | SETTLEMENT | 정산 정보 |
| **채팅** | CHATROOM | 채팅방 |
| | CHAT_MSG | 채팅 메시지 |
| **독서모임** | BOOK_CLUB | 독서모임 |
| | BOOK_CLUB_MEMBER | 모임 멤버 |
| | BOOK_CLUB_REQUEST | 가입 신청 |
| | BOOK_CLUB_BOARD | 게시판 |
| | BOOK_CLUB_WISH | 모임 찜 |
| **관리** | ADMIN | 관리자 |
| | NOTICE | 공지사항 |
| | LOGIN_INFO | 로그인 로그 |

---

## 🔌 API 설계

### Trade API

| Method | Endpoint | 설명 |
|--------|----------|------|
| GET | `/trades` | 판매글 목록 조회 |
| GET | `/trades/{id}` | 판매글 상세 조회 |
| POST | `/trades` | 판매글 등록 |
| PUT | `/trades/{id}` | 판매글 수정 |
| DELETE | `/trades/{id}` | 판매글 삭제 |
| POST | `/trades/{id}/wish` | 찜하기 |
| GET | `/api/books/search` | 도서 검색 (ISBN/제목) |

### Chat API

| Method | Endpoint | 설명 |
|--------|----------|------|
| GET | `/chat/rooms` | 채팅방 목록 |
| POST | `/chat/rooms` | 채팅방 생성 |
| GET | `/chat/rooms/{id}/messages` | 메시지 조회 |
| WS | `/ws/chat` | WebSocket 연결 |

### Payment API

| Method | Endpoint | 설명 |
|--------|----------|------|
| POST | `/api/payment/request` | 결제 요청 |
| POST | `/api/payment/confirm` | 결제 승인 |
| POST | `/api/payment/cancel` | 결제 취소 |
| POST | `/api/purchase/confirm` | 구매 확정 |

### BookClub API

| Method | Endpoint | 설명 |
|--------|----------|------|
| GET | `/bookclubs` | 모임 목록 |
| GET | `/bookclubs/{id}` | 모임 상세 |
| POST | `/bookclubs` | 모임 생성 |
| POST | `/bookclubs/{id}/join` | 가입 신청 |
| POST | `/bookclubs/{id}/approve` | 가입 승인 |
| GET | `/bookclubs/{id}/boards` | 게시글 목록 |

### Member API

| Method | Endpoint | 설명 |
|--------|----------|------|
| POST | `/login` | 로그인 |
| POST | `/signup` | 회원가입 |
| GET | `/oauth/kakao` | 카카오 로그인 |
| GET | `/oauth/naver` | 네이버 로그인 |
| GET | `/mypage` | 마이페이지 |

---

## 💡 핵심 기술 상세

### 1. Non-Blocking HTTP Client (WebClient)

기존 RestTemplate의 **Blocking I/O** 방식에서 **Non-Blocking** WebClient로 전환하여 대량 트래픽 처리 성능을 개선했습니다.

```java
// Before: RestTemplate (Blocking)
String result = restTemplate.getForObject(url, String.class);

// After: WebClient (Non-Blocking)
webClient.get()
    .uri(url)
    .retrieve()
    .bodyToMono(String.class)
    .subscribe(result -> processResult(result));
```

| 방식 | 특징 |
|------|------|
| RestTemplate | 요청당 스레드 점유, 스레드 풀 고갈 위험 |
| **WebClient** | Event Loop 방식, 단일 스레드로 다중 요청 처리 |

### 2. Redis Caching (Look-aside Pattern)

```
┌────────────────────────────────────────────────────────────────┐
│                     Cache-Aside Pattern                        │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│   [READ]                                                       │
│   Client → Redis (Cache Hit?) ─── Yes ──→ Return Data         │
│                      │                                         │
│                      No                                        │
│                      ▼                                         │
│                   Database → Redis (Cache 저장) → Return       │
│                                                                │
│   [WRITE]                                                      │
│   Client → Database (저장) → Redis (Cache 삭제/갱신)           │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

```java
// 조회 시 캐싱
@Cacheable(value = "bookClubList", key = "'latest:first'")
public List<BookClubVO> getBookClubList() {
    return bookClubMapper.selectList();
}

// 수정/삭제 시 캐시 무효화
@CacheEvict(value = "bookClubList", allEntries = true)
public void updateBookClub(BookClubVO vo) {
    bookClubMapper.update(vo);
}
```

**성능 개선**: 응답 시간 **500ms → 20ms** (96% 단축)

### 3. WebSocket 실시간 채팅

```
┌─────────────────────────────────────────────────────────────┐
│                    STOMP over WebSocket                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   Client A ──── SEND /pub/chat ────▶ ┌─────────────┐        │
│                                       │   Message   │        │
│   Client B ◀── SUBSCRIBE /sub/room ── │   Broker    │        │
│                                       │  (Pub/Sub)  │        │
│   Client C ◀── SUBSCRIBE /sub/room ── └─────────────┘        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 4. 안전결제 (Escrow) with Scheduler

```java
// 15일 후 자동 구매확정
@Scheduled(cron = "0 0 0 * * *")  // 매일 자정 실행
public void autoConfirmPurchase() {
    List<Trade> expiredTrades = tradeRepository
        .findByStatusAndDateBefore("PAID", LocalDate.now().minusDays(15));

    expiredTrades.forEach(trade -> {
        trade.confirmPurchase();  // 구매 확정
        settlementService.settle(trade);  // 판매자 정산
    });
}
```

### 5. Pessimistic Lock (동시성 제어)

독서모임 정원 초과 방지를 위한 비관적 락 적용:

```sql
-- 동시 가입 신청 시 데이터 정합성 보장
SELECT * FROM book_club WHERE book_club_seq = ? FOR UPDATE
```

---

## 🔧 트러블슈팅

### 1. N+1 Query Problem

**문제**: 판매글 목록 조회 시 각 책의 이미지를 위해 N번의 추가 쿼리 발생

**해결**: MyBatis `<foreach>`를 활용한 IN Query 최적화

```xml
<select id="selectTradeImages" resultType="ImageVO">
    SELECT * FROM book_image
    WHERE trade_seq IN
    <foreach collection="tradeSeqs" item="seq" open="(" close=")" separator=",">
        #{seq}
    </foreach>
</select>
```

**결과**: Query Count **21 → 2** (90% 감소)

### 2. 동시성 이슈 (Race Condition)

**문제**: 인기 독서모임 잔여 1석에 2명 동시 가입 시 정원 초과

**해결**: PostgreSQL Pessimistic Lock 적용

```java
@Transactional
public void joinBookClub(Long clubId, Long memberId) {
    // FOR UPDATE로 해당 row 잠금
    BookClub club = bookClubMapper.selectForUpdate(clubId);

    if (club.getCurrentMemberCount() >= club.getMaxMember()) {
        throw new FullCapacityException();
    }

    bookClubMemberMapper.insert(clubId, memberId);
}
```

**결과**: Data Integrity **100%** 보장

### 3. 브라우저 뒤로가기 시 로그인 상태 불일치

**문제**: 로그인 후 뒤로가기 시 캐시된 로그인 페이지 표시

**해결**: Cache-Control 헤더 + JavaScript 세션 체크

```java
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
```

```javascript
fetch('/api/session-check')
    .then(res => res.json())
    .then(data => {
        if (data.loggedIn) window.location.replace('/');
    });
```

---

## 🚀 CI/CD 파이프라인

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           CI/CD Pipeline                                     │
└─────────────────────────────────────────────────────────────────────────────┘

  ┌──────────┐     ┌─────────────────────────────────────────────────────────┐
  │ Developer│     │                   GitHub Actions                         │
  │          │     │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐       │
  │   Push   │────▶│  │Checkout │→│Setup JDK│→│ Create  │→│  Maven  │       │
  │  (main)  │     │  │         │ │   17    │ │  Props  │ │  Build  │       │
  └──────────┘     │  └─────────┘ └─────────┘ └─────────┘ └────┬────┘       │
                   │                                            │            │
                   │  ┌─────────┐ ┌─────────┐ ┌─────────┐      │            │
                   │  │CodeDeploy│←│Upload S3│←│  Zip    │◀─────┘            │
                   │  │  Start  │ │         │ │ Package │                   │
                   │  └────┬────┘ └─────────┘ └─────────┘                   │
                   └───────┼────────────────────────────────────────────────┘
                           │
                           ▼
  ┌─────────────────────────────────────────────────────────────────────────┐
  │                         AWS CodeDeploy                                   │
  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐       │
  │  │BeforeInstall│→│ AppStop     │→│ AppStart    │→│  Validate   │       │
  │  │ (cleanup)   │ │ (shutdown)  │ │ (startup)   │ │ (/health)   │       │
  │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘       │
  └─────────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
  ┌─────────────────────────────────────────────────────────────────────────┐
  │                    Auto Scaling Group (EC2)                              │
  │                                                                          │
  │   ┌─────────────┐              ┌─────────────┐                          │
  │   │    EC2-1    │              │    EC2-2    │                          │
  │   │  ✅ Deployed│              │  ✅ Deployed│                          │
  │   └─────────────┘              └─────────────┘                          │
  │                                                                          │
  └─────────────────────────────────────────────────────────────────────────┘
```

### 배포 스크립트 (appspec.yml)

```yaml
hooks:
  BeforeInstall:
    - scripts/before_install.sh   # 기존 파일 정리
  ApplicationStop:
    - scripts/stop_server.sh      # Tomcat 중지
  ApplicationStart:
    - scripts/start_server.sh     # WAR 배포, Tomcat 시작
  ValidateService:
    - scripts/validate_service.sh # /health 엔드포인트 확인
```

### GitHub Actions Workflow 상세

```yaml
name: Deploy to AWS

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'

      - name: Create application.properties
        run: |
          echo "${{ secrets.APPLICATION_PROPERTIES }}" > src/main/resources/application.properties

      - name: Build with Maven
        run: mvn clean package -DskipTests

      - name: Create deployment package
        run: |
          mkdir -p deploy
          cp target/*.war deploy/
          cp appspec.yml deploy/
          cp -r scripts deploy/
          cd deploy && zip -r ../deploy.zip .

      - name: Upload to S3 & Deploy
        run: |
          aws s3 cp deploy.zip s3://${{ secrets.S3_BUCKET }}/deploy/deploy.zip
          aws deploy create-deployment \
            --application-name SecondaryBook-App \
            --deployment-group-name SecondaryBook-DG \
            --s3-location bucket=${{ secrets.S3_BUCKET }},key=deploy/deploy.zip,bundleType=zip
```

---

## ☁️ AWS 인프라 상세

### VPC 네트워크 구성

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           VPC (10.0.0.0/16)                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌─────────────────────────────┐   ┌─────────────────────────────┐        │
│   │   Public Subnet A           │   │   Public Subnet C           │        │
│   │   (10.0.1.0/24)             │   │   (10.0.2.0/24)             │        │
│   │   - Internet Gateway        │   │   - NAT Gateway             │        │
│   │   - ALB                     │   │   - Bastion Host (optional) │        │
│   │   - AZ: ap-northeast-2a     │   │   - AZ: ap-northeast-2c     │        │
│   └─────────────────────────────┘   └─────────────────────────────┘        │
│                                                                              │
│   ┌─────────────────────────────┐   ┌─────────────────────────────┐        │
│   │   Private Subnet A          │   │   Private Subnet C          │        │
│   │   (10.0.10.0/24)            │   │   (10.0.20.0/24)            │        │
│   │   - EC2 (Auto Scaling)      │   │   - EC2 (Auto Scaling)      │        │
│   │   - RDS (Primary)           │   │   - RDS (Standby)           │        │
│   │   - ElastiCache             │   │   - ElastiCache             │        │
│   │   - AZ: ap-northeast-2a     │   │   - AZ: ap-northeast-2c     │        │
│   └─────────────────────────────┘   └─────────────────────────────┘        │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Auto Scaling 설정

| 설정 항목 | 값 | 설명 |
|----------|-----|------|
| **최소 인스턴스** | 1 | 비용 최적화 |
| **최대 인스턴스** | 2 | 트래픽 대응 |
| **희망 용량** | 1 | 기본 운영 |
| **스케일링 정책** | Target Tracking | CPU 70% 기준 |
| **쿨다운** | 120초 | 안정화 대기 |
| **헬스체크 유예** | 300초 | 앱 시작 대기 |

```
                    CPU 사용률
                         │
        100% ─┬──────────┼──────────────────────
              │          │       Scale Out
         70% ─┼──────────┼─────────────────────  ← Target
              │          │
         30% ─┼──────────┼─────────────────────
              │          │       Scale In
          0% ─┴──────────┴──────────────────────
                    시간 →
```

### ALB (Application Load Balancer)

| 기능 | 설정 |
|------|------|
| **리스너** | HTTP(80) → HTTPS(443) 리다이렉트 |
| **SSL 인증서** | ACM (AWS Certificate Manager) |
| **타겟 그룹** | EC2 인스턴스, 포트 8080 |
| **헬스체크** | `/health` 엔드포인트 |
| **Sticky Session** | 활성화 (1일), 세션 일관성 보장 |

---

## 📦 S3 & CloudFront (CDN)

### 이미지 저장 및 배포 흐름

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        이미지 업로드 및 조회 흐름                              │
└─────────────────────────────────────────────────────────────────────────────┘

  [업로드]
  ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
  │  Client  │────▶│   EC2    │────▶│   S3     │────▶│   DB     │
  │ (이미지)  │     │ (Spring) │     │ (저장)   │     │(URL저장) │
  └──────────┘     └──────────┘     └──────────┘     └──────────┘
                        │
                        ▼
                   S3Service.uploadFile()
                   → CloudFront URL 반환

  [조회]
  ┌──────────┐     ┌──────────────┐     ┌──────────┐
  │  Client  │────▶│  CloudFront  │────▶│    S3    │
  │ (브라우저)│     │  (CDN 캐시)   │     │  (원본)   │
  └──────────┘     └──────────────┘     └──────────┘
       │                  │
       │    Cache HIT     │    Cache MISS
       │◀─────────────────│─────────────────▶
       │   (빠른 응답)     │    (S3 조회)
```

### S3 버킷 구성

| 항목 | 값 |
|------|-----|
| **버킷명** | secondarybooksimages |
| **리전** | ap-northeast-2 (서울) |
| **접근 제어** | CloudFront OAC (Origin Access Control) |
| **버킷 정책** | CloudFront만 접근 허용 |

### CloudFront 설정

| 설정 | 값 |
|------|-----|
| **도메인** | d3p8m254izebr5.cloudfront.net |
| **Origin** | S3 버킷 |
| **캐시 정책** | CacheOptimized |
| **TTL** | 기본 24시간 |
| **WAF** | 활성화 (보안 보호) |
| **HTTPS** | 강제 리다이렉트 |

### S3Service 코드

```java
@Service
public class S3Service {

    @Value("${AWS_CLOUDFRONT_DOMAIN:}")
    private String cloudFrontDomain;

    public String uploadFile(MultipartFile file) throws IOException {
        String key = "images/" + UUID.randomUUID() + "." + ext;

        // S3 업로드
        s3Client.putObject(request, RequestBody.fromBytes(file.getBytes()));

        // CloudFront URL 반환 (설정된 경우)
        if (cloudFrontDomain != null && !cloudFrontDomain.isEmpty()) {
            return String.format("https://%s/%s", cloudFrontDomain, key);
        }
        return String.format("https://%s.s3.%s.amazonaws.com/%s", bucketName, region, key);
    }
}
```

**성능 개선 효과:**
- 이미지 로딩 속도: **S3 직접 300ms → CloudFront 50ms** (83% 단축)
- 글로벌 엣지 로케이션을 통한 지연 시간 최소화
- S3 직접 접근 차단으로 보안 강화

---

## 📊 CloudWatch 모니터링

### 모니터링 대시보드 구성

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        CloudWatch Dashboard                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────┐  ┌────────────────────────┐                    │
│  │   EC2 CPU Utilization  │  │   EC2 Memory Usage     │                    │
│  │   ████████░░░░ 65%     │  │   ██████░░░░░░ 45%     │                    │
│  └────────────────────────┘  └────────────────────────┘                    │
│                                                                              │
│  ┌────────────────────────┐  ┌────────────────────────┐                    │
│  │   ALB Request Count    │  │   ALB Response Time    │                    │
│  │   📈 1,234 req/min     │  │   ⏱️ 120ms avg         │                    │
│  └────────────────────────┘  └────────────────────────┘                    │
│                                                                              │
│  ┌────────────────────────┐  ┌────────────────────────┐                    │
│  │   RDS Connections      │  │   RDS CPU              │                    │
│  │   🔗 30/79 (38%)       │  │   ████░░░░░░░░ 25%     │                    │
│  └────────────────────────┘  └────────────────────────┘                    │
│                                                                              │
│  ┌────────────────────────┐  ┌────────────────────────┐                    │
│  │   ElastiCache Hits     │  │   ElastiCache Memory   │                    │
│  │   ✅ 95% hit rate      │  │   ██████████░░ 78%     │                    │
│  └────────────────────────┘  └────────────────────────┘                    │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 주요 모니터링 지표

| 서비스 | 지표 | 임계값 | 알람 |
|--------|------|--------|------|
| **EC2** | CPUUtilization | > 70% | Scale Out 트리거 |
| **EC2** | StatusCheckFailed | > 0 | 인스턴스 교체 |
| **ALB** | TargetResponseTime | > 3s | 성능 경고 |
| **ALB** | HTTPCode_Target_5XX | > 10/min | 서버 에러 경고 |
| **RDS** | DatabaseConnections | > 80% | 커넥션 풀 경고 |
| **RDS** | FreeStorageSpace | < 10GB | 스토리지 경고 |
| **ElastiCache** | CacheHitRate | < 80% | 캐시 효율 경고 |
| **ElastiCache** | CurrConnections | > 100 | 커넥션 경고 |

### Auto Scaling 이벤트 로그

```
[2025-01-15 10:30:00] Scale Out: CPU 75% → 인스턴스 추가 (1→2)
[2025-01-15 10:32:00] Instance i-0abc123 launched
[2025-01-15 10:35:00] Instance i-0abc123 InService
[2025-01-15 11:00:00] Scale In: CPU 25% → 인스턴스 제거 (2→1)
[2025-01-15 11:02:00] Instance i-0abc123 terminated
```

---

## 🧪 부하 테스트 (k6)

### 테스트 시나리오

```javascript
// k6 stress-test.js
export const options = {
    stages: [
        { duration: '2m', target: 100 },   // Ramp-up
        { duration: '5m', target: 400 },   // Stay at 400 VUs
        { duration: '2m', target: 1000 },  // Spike to 1000 VUs
        { duration: '5m', target: 1000 },  // Stay at peak
        { duration: '2m', target: 0 },     // Ramp-down
    ],
    thresholds: {
        http_req_duration: ['p(95)<3000'],  // 95% 요청 3초 이내
        http_req_failed: ['rate<0.05'],     // 실패율 5% 미만
    },
};
```

### 테스트 결과

| 지표 | 결과 |
|------|------|
| **최대 동시 사용자** | 1,000 VUs |
| **총 요청 수** | 125,847 |
| **성공률** | 99.2% |
| **평균 응답 시간** | 245ms |
| **p95 응답 시간** | 890ms |
| **p99 응답 시간** | 1,850ms |

```
     ┌─────────────────────────────────────────────────────┐
     │                  Response Time (ms)                  │
2000 ┤                           ╭──────╮                   │
     │                          ╱      ╲                    │
1500 ┤                    ╭────╯        ╰───╮               │
     │                   ╱                   ╲              │
1000 ┤              ╭───╯                     ╰──╮          │
     │             ╱                              ╲         │
 500 ┤      ╭─────╯                                ╰───╮    │
     │     ╱                                           ╲   │
   0 ┼────╯                                             ╰──┤
     └─────────────────────────────────────────────────────┘
          0    2    4    6    8   10   12   14   16 (min)
```

### Auto Scaling 동작 확인

| 시간 | VUs | 인스턴스 수 | CPU |
|------|-----|------------|-----|
| 0분 | 0 | 1 | 5% |
| 2분 | 100 | 1 | 35% |
| 4분 | 400 | 1 | 72% |
| 5분 | 400 | 2 | 45% (분산) |
| 7분 | 1000 | 2 | 78% |
| 14분 | 0 | 1 | 5% |

---

## 🔒 보안 설정

### Security Groups 상세

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          Security Group Flow                                 │
└─────────────────────────────────────────────────────────────────────────────┘

  Internet
      │
      ▼ (80, 443)
┌─────────────┐
│   ALB-SG    │ ◀── Inbound: 0.0.0.0/0 (HTTP/HTTPS)
└──────┬──────┘
       │
       ▼ (8080)
┌─────────────┐
│   EC2-SG    │ ◀── Inbound: ALB-SG only
└──────┬──────┘
       │
       ├────────────────┐
       ▼ (5432)         ▼ (6379)
┌─────────────┐   ┌─────────────┐
│   RDS-SG    │   │  Redis-SG  │
│ (PostgreSQL)│   │(ElastiCache)│
└─────────────┘   └─────────────┘
       ▲                 ▲
       └── Inbound: EC2-SG only ──┘
```

### IAM 역할

| 역할 | 권한 |
|------|------|
| **EC2 Instance Role** | S3 Read/Write, CloudWatch Logs |
| **CodeDeploy Role** | EC2 Full Access, S3 Read |
| **GitHub Actions** | S3 Upload, CodeDeploy Deploy |

---

## 👥 팀 구성

| 파트 | 담당자 | 역할 |
|------|--------|------|
| **Auth & Admin** | 김규태, 이승환 | Spring Security, 관리자 대시보드, 마이페이지, 소셜 로그인 |
| **Trade & Payment** | 이상원, 최범근 | 중고 거래, 에스크로 결제, 채팅, Scheduler |
| **BookClub** | 김도연, 이동희 | 독서모임 CRUD, 커뮤니티 게시판, UI/UX, Frontend |

---

## 📁 프로젝트 구조

```
src/main/java/project/
├── admin/          # 관리자 기능
├── bookclub/       # 독서모임
│   ├── controller/
│   ├── service/
│   ├── mapper/
│   └── vo/
├── chat/           # 실시간 채팅
├── common/         # 공통 유틸
├── config/         # 설정 (Security, WebSocket, Redis)
├── member/         # 회원 관리
├── payment/        # 결제 시스템
├── trade/          # 중고 거래
└── util/           # 유틸리티 (S3, 이미지 업로드)
```

---

## 🔗 Links

- **배포 URL**: https://www.shinhan6th.com
---

<p align="center">
  <b>Shinhan DS Academy - SecondHand Books Team</b>
</p>
