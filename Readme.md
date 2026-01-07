# SecondaryBook - 중고책 거래 및 독서 모임 플랫폼

## 프로젝트 개요
중고책 판매/구매와 독서 모임을 결합한 온라인 플랫폼입니다.

---

## 주요 기능

### 1️⃣ 회원 관리 기능
- **회원가입** - 일반 회원가입
- **로그인** - 이메일 로그인
- **로그아웃**
- **아이디 찾기** - 이메일 기반 아이디 찾기
- **비밀번호 찾기** - 이메일 인증 후 비밀번호 재설정
- **회원 정보 수정** - 프로필, 주소, 연락처 수정
- **회원 탈퇴**

---

### 2️⃣ 중고책 거래 기능

#### 책 검색/조회
- **책 정보 조회** - 외부 API를 통한 책 메타데이터 조회
- **판매글 목록 조회** - 카테고리별, 검색어별 필터링
- **판매글 상세 조회** - 책 정보 + 판매자 정보 + 상품 상태

#### 판매 등록
- **책 판매 등록** - 외부 API에서 책 검색 후 판매글 작성
- **책 가격 설정** - 판매 가격 입력
- **책 상태 설정** - 새 책/중고(상/중/하) 선택
- **판매글 수정/삭제**

#### 구매
- **책 구매** - 장바구니 없이 바로 구매
- **1:1 채팅** - 판매자와 실시간 채팅
- **찜하기** - 관심 상품 저장

---

### 3️⃣ 주문/결제 기능
- **주문 생성** - 배송지 입력 및 주문 확인
- **Toss Payments 결제 연동**
- **주문 내역 조회** - 구매 내역 확인
- **판매 내역 조회** - 판매자 입장에서 판매 현황 확인
- **주문 상태 관리** - 결제 대기 / 결제 완료 / 배송 준비 / 배송 중 / 배송 완료

---

### 4️⃣ 독서 모임 기능
- **독서 모임 개설** - 모임명, 설명, 모집 인원 설정
- **독서 모임 목록 조회** - 진행 중인 모임 리스트
- **독서 모임 가입** - 관심 있는 모임 가입 신청
- **독서 모임 탈퇴**
- **모임 게시판** - 모임 내 공지사항 및 소통 게시판
- **모임 게시글 CRUD** - 작성, 조회, 수정, 삭제

---

### 5️⃣ 커뮤니티 기능
- **게시글 작성** - 독서 후기, 자유 게시판
- **게시글 목록 조회** - 카테고리별 필터링
- **게시글 상세 조회**
- **게시글 수정/삭제**
- **댓글 작성** - 게시글에 댓글 달기
- **댓글 수정/삭제**

---

### 6️⃣ 채팅 기능
- **1:1 실시간 채팅** - 구매자-판매자 간 실시간 대화
- **채팅방 목록** - 진행 중인 채팅 리스트
- **읽음/안 읽음 표시**

---

### 7️⃣ 마이페이지
- **판매 내역** - 내가 판매한 상품 리스트 및 상태
- **구매 내역** - 내가 구매한 주문 내역
- **찜 목록** - 찜한 상품 리스트
- **회원 정보 수정** - 프로필 수정
- **포인트 내역** - 적립/사용 내역
- **고객센터** - 공지사항, 1:1 문의

---

### 8️⃣ 알림 기능
- **실시간 알림** - 채팅, 주문 상태 변경, 찜한 상품 가격 변동 등
- **알림 조회** - 알림 리스트
- **알림 삭제**

---

### 9️⃣ 관리자 기능
- **회원 관리** - 블랙리스트, 회원 정지
- **로그인 이력 관리** - IP, 접속 시간 추적
- **상품 관리** - 부적절한 판매글 삭제
- **포인트 관리** - 포인트 지급/회수
- **모임 관리** - 모임 승인/삭제
- **게시판 관리** - 게시글/댓글 관리
- **공지사항 관리** - 공지 작성/수정/삭제

---

## 기술 스택
- **Backend**: Spring MVC 5.3.39, MyBatis 3.5.19
- **Database**: PostgreSQL (AWS RDS)
- **Build Tool**: Maven 3.6+
- **Java Version**: Java 17
- **Web Server**: Tomcat 9 (embedded via Cargo)
- **Connection Pool**: HikariCP 4.0.3
- **Payment**: Toss Payments API (예정)
- **External API**: 도서 정보 API (알라딘/교보문고) (예정)
- **Deployment**: AWS EC2, AWS RDS

---

## 개발 환경 설정

### 필수 요구사항
- **Java**: JDK 17 (정확히 17 버전 필요)
- **Maven**: 3.6.0 이상 (또는 프로젝트에 포함된 Maven Wrapper 사용)
- **Database**: PostgreSQL (AWS RDS 사용)

### 1️⃣ 프로젝트 클론
```bash
git clone <repository-url>
cd secondaryBook
```

### 2️⃣ 데이터베이스 설정
1. `src/main/resources/db.properties.example` 파일을 복사하여 `db.properties` 파일 생성:
   ```bash
   cp src/main/resources/db.properties.example src/main/resources/db.properties
   ```

2. `db.properties` 파일 열어서 실제 데이터베이스 정보 입력:
   ```properties
   db.driver=net.sf.log4jdbc.sql.jdbcapi.DriverSpy
   db.url=jdbc:log4jdbc:postgresql://your-database-host:5432/your-database-name
   db.username=your-username
   db.password=your-password
   ```

   ⚠️ **중요**: `db.properties` 파일은 `.gitignore`에 포함되어 있어 Git에 커밋되지 않습니다.

### 3️⃣ Java 17 설치 확인
```bash
java -version
# 출력: openjdk version "17.x.x" 또는 java version "17.x.x"
```

Java 17이 설치되어 있지 않다면:
- **macOS**: `brew install openjdk@17`
- **Windows**: [Oracle JDK 17](https://www.oracle.com/java/technologies/downloads/#java17) 또는 [OpenJDK 17](https://adoptium.net/) 다운로드
- **Linux**: `sudo apt install openjdk-17-jdk` (Ubuntu/Debian)

### 4️⃣ 프로젝트 빌드 및 실행

#### 방법 1: Maven Wrapper 사용 (권장)
프로젝트에 Maven Wrapper가 포함되어 있어 Maven 설치 없이 실행 가능합니다:

**macOS/Linux:**
```bash
# 빌드
./mvnw clean package

# Tomcat 서버 실행 (http://localhost:8080)
./mvnw cargo:run
```

**Windows:**
```cmd
# 빌드
mvnw.cmd clean package

# Tomcat 서버 실행
mvnw.cmd cargo:run
```

#### 방법 2: 로컬 Maven 사용
```bash
# 빌드
mvn clean package

# Tomcat 서버 실행
mvn cargo:run
```

### 5️⃣ 접속 확인
- **홈페이지**: http://localhost:8080/
- **테스트 페이지**: http://localhost:8080/test/list

서버 종료: `Ctrl + C`

---

## 프로젝트 구조
```
secondaryBook/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── project/               # 메인 패키지
│   │   │       ├── config/            # Spring 설정
│   │   │       ├── util/testing/      # 테스트 기능
│   │   │       └── HomeController.java
│   │   ├── resources/
│   │   │   ├── project/               # MyBatis Mapper XML
│   │   │   ├── db.properties          # DB 설정 (gitignore)
│   │   │   ├── db.properties.example  # DB 설정 예제
│   │   │   └── logback.xml            # 로그 설정
│   │   └── webapp/
│   │       └── WEB-INF/
│   │           ├── spring/            # Spring 설정 XML
│   │           └── views/             # JSP 뷰
│   └── test/
├── pom.xml                            # Maven 설정
├── mvnw, mvnw.cmd                     # Maven Wrapper
└── Readme.md

---

## 외부 API (Third-party APIs)

### 1. 도서 정보 API ⭐ 필수
**용도**: 책 검색, 메타데이터 조회 (ISBN, 제목, 저자, 출판사, 표지 등)

#### 옵션
- **알라딘 API** (메인)
  - URL: https://blog.aladin.co.kr/openapi
  - 무료, 일일 5,000건
  - 국내 도서 정보 풍부
  
- **카카오 책 검색 API** (서브/폴백)
  - URL: https://developers.kakao.com/docs/latest/ko/daum-search/dev-guide#search-book
  - 무료, 하루 300,000건
  - 간단하지만 정보 부족할 수 있음

- **네이버 책 검색 API**
  - URL: https://developers.naver.com/docs/serviceapi/search/book/book.md
  - 무료, 하루 25,000건
  - 네이버 쇼핑 연동 가능

---

### 2. 결제 API ⭐ 필수
**Toss Payments API**
- URL: https://docs.tosspayments.com/
- 카드 결제, 간편 결제, 가상계좌
- 수수료: 2.9% + VAT
- **테스트 키 무료 제공** (실제 결제 없이 개발/테스트 가능)

**필요한 API**:
- `POST /v1/payments/confirm` - 결제 승인
- `GET /v1/payments/{paymentKey}` - 결제 조회
- `POST /v1/payments/{paymentKey}/cancel` - 결제 취소

---

### 3. 이메일 발송 API (선택)
**용도**: 회원가입 인증, 비밀번호 찾기, 주문 확인

#### 옵션
- **AWS SES (Simple Email Service)** (추천)
  - 월 62,000통 무료
  - 이후 $0.10/1,000통
  - EC2와 통합 쉬움
  
- **Gmail SMTP**
  - 무료
  - 하루 500통 제한
  
- **SendGrid**
  - 하루 100통 무료
  - 유료 플랜 제공

---

### 4. SMS 인증 API (선택)
**용도**: 회원가입 본인 인증, 비밀번호 찾기

#### 옵션
- **Coolsms** (추천)
  - 건당 20원
  - 한국 전화번호 특화
  
- **AWS SNS**
  - 건당 $0.00645
  
- **NHN Cloud SMS**
  - 건당 9원

**참고**: 초기엔 이메일 인증만으로도 충분

---

### 5. 파일 저장소 API (선택)
**용도**: 책 이미지, 게시글 이미지 업로드

#### 옵션
- **AWS S3** (추천)
  - 월 5GB 무료 (12개월)
  - 이후 GB당 $0.023
  - EC2, RDS와 통합 용이
  
- **Cloudinary**
  - 월 25GB 무료
  - 이미지 자동 최적화

---

### 6. 주소 검색 API (선택)
**용도**: 배송지 입력 시 우편번호/주소 검색

**Daum 우편번호 서비스**
- URL: https://postcode.map.daum.net/guide
- 무료
- 프론트엔드 라이브러리 제공

---

## ERD
![erd_ver2.png](../../Desktop/erd_ver2.png)