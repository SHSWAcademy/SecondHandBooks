<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SecondHand Books - Project Journey</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        body {
            font-family: 'Pretendard', sans-serif;
            background-color: #FAFAFA;
            color: #1D1D1F;
            overflow-x: hidden;
        }

        /* 텍스트 그라데이션 */
        .text-gradient {
            background: linear-gradient(135deg, #0071e3 0%, #00c6fb 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* 스크롤 애니메이션: 텍스트 */
        .reveal-text {
            opacity: 0;
            transform: translateY(50px);
            transition: all 1.2s cubic-bezier(0.165, 0.84, 0.44, 1);
        }
        .reveal-text.active {
            opacity: 1;
            transform: translateY(0);
        }

        /* 스크롤 애니메이션: 카드/이미지 */
        .reveal-card {
            opacity: 0;
            transform: scale(0.9) translateY(30px);
            transition: all 1s cubic-bezier(0.165, 0.84, 0.44, 1);
        }
        .reveal-card.active {
            opacity: 1;
            transform: scale(1) translateY(0);
        }

        /* Bento Grid Box Style */
        .bento-box {
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            overflow: hidden;
        }
        .bento-box:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.12);
        }

        /* Code Block Style */
        .code-window {
            background: #1e1e1e;
            border-radius: 12px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            font-family: 'Menlo', 'Monaco', monospace;
            position: relative;
            overflow: hidden;
        }
        .code-header {
            display: flex;
            gap: 6px;
            padding: 12px 16px;
            background: #252526;
            border-bottom: 1px solid #333;
        }
        .dot { width: 12px; height: 12px; border-radius: 50%; }
        .dot.red { background: #ff5f56; }
        .dot.yellow { background: #ffbd2e; }
        .dot.green { background: #27c93f; }
    </style>
</head>
<body>

    <nav class="fixed top-0 w-full z-50 bg-white/80 backdrop-blur-md border-b border-gray-100 transition-all duration-300">
        <div class="max-w-7xl mx-auto px-6 h-16 flex items-center justify-between">
            <div class="font-bold text-lg tracking-tight flex items-center gap-2">
                <span class="w-2 h-2 rounded-full bg-blue-600"></span>
                SecondHand Books
            </div>
            <div class="text-xs text-gray-500 font-medium">Shinhan DS Academy</div>
        </div>
    </nav>

    <section class="min-h-screen flex flex-col justify-center items-center text-center px-4 pt-24 pb-16 relative bg-white">
        <div class="reveal-text w-full max-w-4xl mx-auto">
            <div class="mb-10 inline-block">
                <span class="px-5 py-2 bg-blue-50 text-blue-600 rounded-full text-sm font-bold border border-blue-100 shadow-sm">Project Presentation</span>
            </div>
            <h1 class="text-5xl md:text-7xl lg:text-8xl font-black mb-8 leading-tight tracking-tight text-gray-900">
                책의 가치를 잇고,<br>
                <span class="text-gradient">독자를 연결하다.</span>
            </h1>
            <p class="text-xl md:text-2xl text-gray-500 max-w-2xl mx-auto leading-relaxed font-medium mb-12">
                중고 서적 거래 & 로컬 독서 커뮤니티 플랫폼
            </p>
            <div class="text-sm font-bold text-gray-400">
                발표자: 홍길동
            </div>
        </div>

        <div class="absolute bottom-8 animate-bounce text-gray-300">
            <i data-lucide="chevron-down" class="w-8 h-8"></i>
        </div>
    </section>

    <section class="py-32 bg-gray-50 border-y border-gray-200">
        <div class="max-w-7xl mx-auto px-6 text-center">
            <h2 class="text-4xl font-bold mb-6 reveal-text">We made this.</h2>
            <p class="text-gray-500 mb-20 reveal-text text-lg">열정적인 6명의 팀원을 소개합니다.</p>

            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-8">
                <div class="reveal-card group" style="transition-delay: 0ms;">
                    <div class="w-32 h-32 rounded-full mx-auto mb-6 overflow-hidden shadow-lg border-4 border-white group-hover:scale-105 transition-transform duration-300">
                        <img src="/img/team/kim_gt.jpg" onerror="this.src='https://api.dicebear.com/7.x/avataaars/svg?seed=KGT'" class="w-full h-full object-cover">
                    </div>
                    <h3 class="font-bold text-xl text-gray-900 mb-1">김규태</h3>
                    <p class="text-xs text-blue-600 font-bold uppercase tracking-wide mb-2">Team Leader</p>
                    <div class="text-xs text-gray-500 space-y-0.5">
                        <p>User Auth</p>
                        <p>MyPage</p>
                        <p>Admin Page</p>
                    </div>
                </div>

                <div class="reveal-card group" style="transition-delay: 100ms;">
                    <div class="w-32 h-32 rounded-full mx-auto mb-6 overflow-hidden shadow-lg border-4 border-white group-hover:scale-105 transition-transform duration-300">
                        <img src="/img/team/lee_sh.jpg" onerror="this.src='https://api.dicebear.com/7.x/avataaars/svg?seed=LSH'" class="w-full h-full object-cover">
                    </div>
                    <h3 class="font-bold text-xl text-gray-900 mb-1">이승환</h3>
                    <p class="text-xs text-blue-600 font-bold uppercase tracking-wide mb-2">Backend</p>
                    <div class="text-xs text-gray-500 space-y-0.5">
                        <p>User Auth</p>
                        <p>MyPage</p>
                        <p>Admin Page</p>
                    </div>
                </div>

                <div class="reveal-card group" style="transition-delay: 200ms;">
                    <div class="w-32 h-32 rounded-full mx-auto mb-6 overflow-hidden shadow-lg border-4 border-white group-hover:scale-105 transition-transform duration-300">
                        <img src="/img/team/choi_bk.jpg" onerror="this.src='https://api.dicebear.com/7.x/avataaars/svg?seed=CBK'" class="w-full h-full object-cover">
                    </div>
                    <h3 class="font-bold text-xl text-gray-900 mb-1">최범근</h3>
                    <p class="text-xs text-blue-600 font-bold uppercase tracking-wide mb-2">Full Stack</p>
                    <div class="text-xs text-gray-500 space-y-0.5">
                        <p>Main Core</p>
                        <p>Payment API</p>
                        <p>Chat System</p>
                    </div>
                </div>

                <div class="reveal-card group" style="transition-delay: 300ms;">
                    <div class="w-32 h-32 rounded-full mx-auto mb-6 overflow-hidden shadow-lg border-4 border-white group-hover:scale-105 transition-transform duration-300">
                        <img src="/img/team/lee_sw.jpg" onerror="this.src='https://api.dicebear.com/7.x/avataaars/svg?seed=LSW'" class="w-full h-full object-cover">
                    </div>
                    <h3 class="font-bold text-xl text-gray-900 mb-1">이상원</h3>
                    <p class="text-xs text-blue-600 font-bold uppercase tracking-wide mb-2">Backend</p>
                    <div class="text-xs text-gray-500 space-y-0.5">
                        <p>Main Logic</p>
                        <p>Payment Security</p>
                        <p>WebSocket Chat</p>
                    </div>
                </div>

                <div class="reveal-card group" style="transition-delay: 400ms;">
                    <div class="w-32 h-32 rounded-full mx-auto mb-6 overflow-hidden shadow-lg border-4 border-white group-hover:scale-105 transition-transform duration-300">
                        <img src="/img/team/kim_dy.jpg" onerror="this.src='https://api.dicebear.com/7.x/avataaars/svg?seed=KDY'" class="w-full h-full object-cover">
                    </div>
                    <h3 class="font-bold text-xl text-gray-900 mb-1">김도연</h3>
                    <p class="text-xs text-blue-600 font-bold uppercase tracking-wide mb-2">Frontend</p>
                    <div class="text-xs text-gray-500 space-y-0.5">
                        <p>Book Club UI</p>
                        <p>Community UX</p>
                        <p>Map Integration</p>
                    </div>
                </div>

                <div class="reveal-card group" style="transition-delay: 500ms;">
                    <div class="w-32 h-32 rounded-full mx-auto mb-6 overflow-hidden shadow-lg border-4 border-white group-hover:scale-105 transition-transform duration-300">
                        <img src="/img/team/lee_dh.jpg" onerror="this.src='https://api.dicebear.com/7.x/avataaars/svg?seed=LDH'" class="w-full h-full object-cover">
                    </div>
                    <h3 class="font-bold text-xl text-gray-900 mb-1">이동희</h3>
                    <p class="text-xs text-blue-600 font-bold uppercase tracking-wide mb-2">Frontend</p>
                    <div class="text-xs text-gray-500 space-y-0.5">
                        <p>Book Club Logic</p>
                        <p>Community Features</p>
                        <p>Search UI</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="py-32 bg-white">
        <div class="max-w-5xl mx-auto px-6">
            <h2 class="text-4xl font-bold mb-20 text-center reveal-text">기존 거래의 <span class="text-red-500">불편함</span>을 해결하다.</h2>

            <div class="space-y-32">
                <div class="flex flex-col md:flex-row items-center gap-16 reveal-text">
                    <div class="flex-1 text-right md:text-left order-2 md:order-1">
                        <span class="text-sm font-bold text-gray-400 mb-2 block tracking-widest">PROBLEM 01</span>
                        <h3 class="text-3xl font-bold mb-6 text-gray-900">입력의 번거로움</h3>
                        <p class="text-lg text-gray-600 leading-relaxed">
                            책 제목, 저자, 출판사, 정가...<br>
                            일일이 타이핑하는 경험은 판매자의 의지를 꺾습니다.<br>
                            우리는 이 과정을 <strong>단 1초</strong>로 줄이고 싶었습니다.
                        </p>
                    </div>
                    <div class="flex-1 order-1 md:order-2">
                        <div class="bg-gray-50 p-10 rounded-[2.5rem] shadow-sm border border-gray-100 aspect-video flex flex-col items-center justify-center transform rotate-2 hover:rotate-0 transition-transform duration-500">
                            <i data-lucide="keyboard" class="w-16 h-16 text-gray-300 mb-4"></i>
                            <span class="text-2xl text-gray-400 font-bold">Manual Typing...</span>
                        </div>
                    </div>
                </div>

                <div class="flex flex-col md:flex-row-reverse items-center gap-16 reveal-text">
                    <div class="flex-1 text-left md:text-right order-2 md:order-1">
                        <span class="text-sm font-bold text-gray-400 mb-2 block tracking-widest">PROBLEM 02</span>
                        <h3 class="text-3xl font-bold mb-6 text-gray-900">거래의 불안감</h3>
                        <p class="text-lg text-gray-600 leading-relaxed">
                            "돈을 보냈는데 물건이 안 오면 어떡하지?"<br>
                            비대면 중고 거래의 가장 큰 진입 장벽인 <strong>신뢰 문제</strong>를<br>
                            기술적으로 해결해야 했습니다.
                        </p>
                    </div>
                    <div class="flex-1 order-1 md:order-2">
                        <div class="bg-gray-50 p-10 rounded-[2.5rem] shadow-sm border border-gray-100 aspect-video flex flex-col items-center justify-center transform -rotate-2 hover:rotate-0 transition-transform duration-500">
                            <i data-lucide="shield-alert" class="w-16 h-16 text-red-200 mb-4"></i>
                            <span class="text-2xl text-red-300 font-bold">Risk & Scam</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="py-32 px-6 bg-gray-50">
        <div class="max-w-7xl mx-auto">
            <div class="text-center mb-24 reveal-text">
                <h2 class="text-5xl font-bold mb-6 text-gray-900">Seamless Solution.</h2>
                <p class="text-xl text-gray-500">우리가 제안하는 새로운 중고 거래 경험</p>
            </div>

            <div class="group bg-white rounded-[3rem] p-12 shadow-sm hover:shadow-xl transition-all duration-500 mb-12 reveal-card">
                <div class="flex flex-col md:flex-row items-center gap-12">
                    <div class="flex-1 space-y-6">
                        <div class="w-14 h-14 bg-blue-100 text-blue-600 rounded-2xl flex items-center justify-center">
                            <i data-lucide="scan-barcode" class="w-7 h-7"></i>
                        </div>
                        <h3 class="text-3xl font-bold">ISBN 스캔으로<br>1초 만에 자동 등록.</h3>
                        <p class="text-gray-500 text-lg leading-relaxed">
                            <strong>Naver/Kakao Book API</strong>와 연동하여 표지, 저자, 출판사 정보를 자동으로 불러옵니다.
                            Spring WebClient를 사용한 비동기 처리로 지연 없는 사용자 경험을 제공합니다.
                        </p>
                    </div>
                    <div class="flex-1 w-full bg-blue-50 rounded-3xl h-64 flex items-center justify-center group-hover:scale-[1.02] transition-transform duration-500">
                        <div class="text-center text-blue-300">
                            <i data-lucide="server" class="w-12 h-12 mx-auto mb-2"></i>
                            <span class="font-mono text-sm">API Response: 200 OK</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
                <div class="group bg-white rounded-[3rem] p-12 shadow-sm hover:shadow-xl transition-all duration-500 reveal-card" style="transition-delay: 100ms;">
                    <div class="w-14 h-14 bg-green-100 text-green-600 rounded-2xl flex items-center justify-center mb-8">
                        <i data-lucide="lock" class="w-7 h-7"></i>
                    </div>
                    <h3 class="text-2xl font-bold mb-4">에스크로 안전 결제</h3>
                    <p class="text-gray-500 leading-relaxed mb-8 h-24">
                        <strong>Toss Payments</strong>와 연동된 에스크로 시스템이 구매 확정 전까지 대금을 안전하게 보호합니다.
                        '먹튀' 걱정 없는 깨끗한 거래 환경을 만들었습니다.
                    </p>
                    <div class="bg-green-50 rounded-2xl h-48 w-full flex items-center justify-center group-hover:scale-[1.02] transition-transform duration-500">
                        <i data-lucide="credit-card" class="w-16 h-16 text-green-300"></i>
                    </div>
                </div>

                <div class="group bg-white rounded-[3rem] p-12 shadow-sm hover:shadow-xl transition-all duration-500 reveal-card" style="transition-delay: 200ms;">
                    <div class="w-14 h-14 bg-yellow-100 text-yellow-600 rounded-2xl flex items-center justify-center mb-8">
                        <i data-lucide="map-pin" class="w-7 h-7"></i>
                    </div>
                    <h3 class="text-2xl font-bold mb-4">로컬 독서 모임</h3>
                    <p class="text-gray-500 leading-relaxed mb-8 h-24">
                        <strong>Kakao Map API</strong>를 활용해 내 주변 독서 모임을 직관적으로 탐색합니다.
                        단순 거래를 넘어 책을 매개로 한 오프라인 연결을 지원합니다.
                    </p>
                    <div class="bg-yellow-50 rounded-2xl h-48 w-full flex items-center justify-center group-hover:scale-[1.02] transition-transform duration-500">
                        <i data-lucide="map" class="w-16 h-16 text-yellow-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="py-32 bg-[#111] text-white">
        <div class="max-w-6xl mx-auto px-6">
            <h2 class="text-4xl font-bold mb-20 reveal-text border-l-4 border-blue-500 pl-6">Engineering & Architecture</h2>

            <div class="grid grid-cols-1 lg:grid-cols-2 gap-20">
                <div class="reveal-text">
                    <h3 class="text-2xl font-bold mb-8 text-gray-300">Core Technologies</h3>
                    <div class="flex flex-wrap gap-4">
                        <span class="px-5 py-2.5 bg-gray-800 rounded-lg text-sm font-medium text-gray-300 border border-gray-700">Java 11</span>
                        <span class="px-5 py-2.5 bg-gray-800 rounded-lg text-sm font-medium text-gray-300 border border-gray-700">Spring Legacy</span>
                        <span class="px-5 py-2.5 bg-gray-800 rounded-lg text-sm font-medium text-gray-300 border border-gray-700">MyBatis</span>
                        <span class="px-5 py-2.5 bg-blue-900/30 rounded-lg text-sm font-bold text-blue-400 border border-blue-800">Redis</span>
                        <span class="px-5 py-2.5 bg-blue-900/30 rounded-lg text-sm font-bold text-blue-400 border border-blue-800">WebClient</span>
                        <span class="px-5 py-2.5 bg-gray-800 rounded-lg text-sm font-medium text-gray-300 border border-gray-700">PostgreSQL</span>
                        <span class="px-5 py-2.5 bg-gray-800 rounded-lg text-sm font-medium text-gray-300 border border-gray-700">AWS S3</span>
                    </div>
                    <div class="mt-12 space-y-8">
                        <div>
                            <h4 class="text-xl font-bold text-blue-400 mb-2">Why WebClient?</h4>
                            <p class="text-gray-400 leading-relaxed text-sm">
                                기존 <code>RestTemplate</code>의 Blocking 방식은 외부 API 지연 시 스레드 점유 문제를 야기합니다.
                                이를 해결하기 위해 <strong>Non-Blocking I/O</strong> 기반의 <code>WebClient</code>를 도입하여
                                네이버/카카오 도서 검색 및 토스 결제 승인 프로세스의 효율성을 극대화했습니다.
                            </p>
                        </div>
                        <div>
                            <h4 class="text-xl font-bold text-purple-400 mb-2">Reliability with Scheduler</h4>
                            <p class="text-gray-400 leading-relaxed text-sm">
                                <code>SafePaymentScheduler</code>가 백그라운드에서 실행되며
                                1. 결제 미완료 건 자동 취소 (5분) <br>
                                2. 배송 완료 후 미확정 건 자동 확정 (15일) <br>
                                등 거래 상태의 무결성을 자동으로 관리합니다.
                            </p>
                        </div>
                    </div>
                </div>

                <div class="reveal-card">
                    <div class="code-window h-full">
                        <div class="code-header">
                            <div class="dot red"></div><div class="dot yellow"></div><div class="dot green"></div>
                            <span class="ml-4 text-xs text-gray-500 font-mono">WebClientConfig.java</span>
                        </div>
                        <div class="p-6 text-sm text-green-400 bg-[#1e1e1e] font-mono leading-relaxed overflow-x-auto">
<pre>
@Bean
public WebClient webClient() {
    return WebClient.builder()
        .baseUrl(apiBaseUrl)
        .defaultHeader(HttpHeaders.CONTENT_TYPE,
                       MediaType.APPLICATION_JSON_VALUE)
        .build();
}

// Async API Call
public Mono&lt;BookInfo&gt; searchBook(String isbn) {
    return webClient.get()
        .uri(uriBuilder -> uriBuilder
            .path("/search/book")
            .queryParam("isbn", isbn)
            .build())
        .retrieve()
        .bodyToMono(BookInfo.class);
}
</pre>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="py-32 bg-white">
        <div class="max-w-6xl mx-auto px-6">
            <div class="flex flex-col lg:flex-row items-center gap-16 reveal-text">
                <div class="lg:w-1/3">
                    <span class="text-blue-600 font-bold text-sm uppercase tracking-wider mb-3 block">Operation</span>
                    <h2 class="text-4xl font-bold mb-6 text-gray-900">통합 관리자 대시보드</h2>
                    <p class="text-gray-600 mb-8 leading-relaxed">
                        서비스 운영을 위한 강력한 어드민 페이지를 구축했습니다.
                        방문자 통계, 거래 현황, 배너 관리, 공지사항 작성 등을 한 곳에서 직관적으로 처리할 수 있습니다.
                    </p>
                    <ul class="space-y-4 text-gray-600">
                        <li class="flex items-center gap-3">
                            <div class="w-8 h-8 rounded-lg bg-gray-100 flex items-center justify-center text-gray-500"><i data-lucide="bar-chart-2" class="w-4 h-4"></i></div>
                            <span>일별/월별 방문자 및 거래량 차트 시각화</span>
                        </li>
                        <li class="flex items-center gap-3">
                            <div class="w-8 h-8 rounded-lg bg-gray-100 flex items-center justify-center text-gray-500"><i data-lucide="image" class="w-4 h-4"></i></div>
                            <span>메인 배너 실시간 미리보기 및 수정</span>
                        </li>
                        <li class="flex items-center gap-3">
                            <div class="w-8 h-8 rounded-lg bg-gray-100 flex items-center justify-center text-gray-500"><i data-lucide="alert-octagon" class="w-4 h-4"></i></div>
                            <span>악성 유저 관리 및 신고 게시글 처리</span>
                        </li>
                    </ul>
                </div>
                <div class="lg:w-2/3 w-full shadow-2xl rounded-2xl overflow-hidden border border-gray-100 transform hover:scale-[1.01] transition-transform duration-500">
                    <img src="/img/admin_dashboard_mockup.jpg" onerror="this.src='https://placehold.co/1000x600/f8fafc/cbd5e1?text=Admin+Dashboard+UI'" class="w-full h-auto object-cover">
                </div>
            </div>
        </div>
    </section>

    <section class="py-32 bg-gray-50 px-6">
        <div class="max-w-4xl mx-auto">
            <h2 class="text-3xl font-bold mb-12 border-l-4 border-red-500 pl-6 reveal-text">Troubleshooting: 변수 스코프 충돌</h2>

            <div class="bg-white p-10 rounded-[2rem] shadow-lg border border-gray-100 reveal-card">
                <div class="mb-10 pb-10 border-b border-gray-100">
                    <h4 class="font-bold text-red-500 mb-4 flex items-center gap-2 text-lg">
                        <i data-lucide="x-circle" class="w-6 h-6"></i> Problem
                    </h4>
                    <p class="text-gray-600 leading-relaxed">
                        마이페이지 탭을 AJAX로 동적 로딩할 때, 전역 스코프에 선언된 변수(<code>let</code>, <code>const</code>)가
                        탭 전환 시 중복 선언되어 <strong>SyntaxError: Identifier has already been declared</strong> 오류가 발생했습니다.
                        SPA 같은 부드러운 화면 전환을 위해 AJAX를 사용했지만, 스크립트 관리의 복잡성이 증가했습니다.
                    </p>
                </div>

                <div>
                    <h4 class="font-bold text-green-600 mb-4 flex items-center gap-2 text-lg">
                        <i data-lucide="check-circle" class="w-6 h-6"></i> Solution
                    </h4>
                    <p class="text-gray-600 mb-6 leading-relaxed">
                        <strong>IIFE (즉시 실행 함수)</strong> 패턴과 <strong>Namespace</strong> 객체를 도입하여
                        스크립트의 유효 범위를 블록 단위로 격리하고, 필요한 함수만 전역 객체에 제한적으로 노출시키는 방식으로 해결했습니다.
                    </p>
                    <div class="code-window">
                        <div class="p-5 text-sm text-gray-300 bg-[#1e1e1e] font-mono">
<pre>
<span class="text-gray-500">// IIFE로 스코프 격리</span>
(function() {
    let localState = []; // 이 변수는 외부에서 접근 불가 (안전)

    const actions = {
        init: () => { ... },
        save: () => { ... }
    };

    // 필요한 메서드만 네임스페이스로 노출
    <span class="text-blue-400">window.ProfileTab</span> = actions;
})();
</pre>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="h-screen flex flex-col justify-center items-center text-center bg-white border-t border-gray-100 relative">
        <div class="reveal-text relative z-10">
            <div class="w-24 h-24 bg-blue-600 rounded-[2rem] flex items-center justify-center mx-auto shadow-2xl mb-10 transform rotate-6 hover:rotate-0 transition-all duration-500">
                <span class="text-white font-black text-4xl">S</span>
            </div>
            <h2 class="text-5xl md:text-8xl font-black mb-8 tracking-tight text-gray-900">
                Your Book's Second Life.
            </h2>
            <p class="text-xl md:text-2xl text-gray-500 mb-16 max-w-3xl mx-auto font-medium">
                기술적 고민을 통해, 책과 사람을 잇는<br>가장 안전하고 따뜻한 방법을 만들었습니다.
            </p>
            <a href="/home" class="group inline-flex items-center gap-3 bg-gray-900 text-white px-12 py-6 rounded-full font-bold text-xl hover:bg-black transition-all shadow-xl hover:shadow-2xl hover:-translate-y-1">
                서비스 시연 시작하기
                <i data-lucide="arrow-right" class="w-6 h-6 group-hover:translate-x-2 transition-transform"></i>
            </a>
        </div>

        <footer class="absolute bottom-10 text-sm text-gray-400 font-medium">
            &copy; 2026 SecondHand Books Team. All rights reserved.
        </footer>
    </section>

    <script>
        // Lucide 아이콘 초기화
        lucide.createIcons();

        // 스크롤 애니메이션 옵저버
        const observerOptions = {
            root: null,
            rootMargin: '0px',
            threshold: 0.1 // 요소가 10% 보일 때 트리거
        };

        const observer = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('active');
                    // observer.unobserve(entry.target); // 반복 실행을 원하면 주석 처리
                }
            });
        }, observerOptions);

        document.querySelectorAll('.reveal-text, .reveal-card, .reveal-image').forEach(el => {
            observer.observe(el);
        });
    </script>
</body>
</html>