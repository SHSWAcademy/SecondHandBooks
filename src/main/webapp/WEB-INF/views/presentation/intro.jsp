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
            background-color: #FAFAFA; /* Off-white background */
            color: #1D1D1F;
            overflow-x: hidden;
        }

        /* 텍스트 그라데이션 */
        .text-gradient {
            background: linear-gradient(135deg, #0071e3 0%, #00c6fb 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* 스크롤 애니메이션 클래스 */
        .reveal-text {
            opacity: 0;
            transform: translateY(30px);
            transition: all 1s cubic-bezier(0.165, 0.84, 0.44, 1);
        }
        .reveal-text.active {
            opacity: 1;
            transform: translateY(0);
        }

        .reveal-image {
            opacity: 0;
            transform: scale(0.95);
            transition: all 1.2s cubic-bezier(0.165, 0.84, 0.44, 1);
        }
        .reveal-image.active {
            opacity: 1;
            transform: scale(1);
        }

        /* Bento Grid Box Style */
        .bento-box {
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
        }
        .bento-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 32px rgba(0,0,0,0.08);
        }

        /* Code Block Style */
        .code-window {
            background: #1e1e1e;
            border-radius: 12px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.2);
            font-family: 'Menlo', 'Monaco', monospace;
            overflow: hidden;
        }
    </style>
</head>
<body>

    <nav class="fixed top-0 w-full z-50 bg-white/80 backdrop-blur-md border-b border-gray-100 transition-all duration-300" id="navbar">
        <div class="max-w-7xl mx-auto px-6 h-14 flex items-center justify-between">
            <div class="font-bold text-lg tracking-tight">SecondHand Books</div>
            <div class="text-xs text-gray-500 font-medium">Shinhan DS Academy</div>
        </div>
    </nav>

    <section class="min-h-screen flex flex-col justify-center items-center text-center px-4 pt-20">
        <div class="reveal-text">
            <h2 class="text-xl md:text-2xl font-bold text-gray-500 mb-4">Project Overview</h2>
            <h1 class="text-5xl md:text-8xl font-black leading-tight tracking-tight mb-6">
                책의 두 번째 쓰임.<br>
                <span class="text-gradient">연결의 시작.</span>
            </h1>
            <p class="text-xl md:text-2xl text-gray-600 max-w-2xl mx-auto leading-relaxed">
                가장 안전하고, 가장 쉬운 중고 서적 거래 플랫폼.<br>
                단순 거래를 넘어 독서 모임 커뮤니티로 확장합니다.
            </p>
        </div>

        <div class="mt-16 w-full max-w-5xl reveal-image">
            <div class="aspect-video bg-gray-200 rounded-3xl shadow-2xl overflow-hidden relative">
                <img src="/img/presentation_hero.jpg" onerror="this.src='https://placehold.co/1200x675/e2e8f0/64748b?text=Service+Main+UI'" class="w-full h-full object-cover">
            </div>
        </div>
    </section>

    <section class="py-24 bg-white">
        <div class="max-w-5xl mx-auto px-6 text-center">
            <h2 class="text-4xl font-bold mb-16 reveal-text">Our Team.</h2>
            <div class="grid grid-cols-2 md:grid-cols-3 gap-12 reveal-text">
                <div class="flex flex-col items-center">
                    <div class="w-24 h-24 rounded-full bg-gray-200 mb-4 flex items-center justify-center font-bold text-2xl text-gray-500">K</div>
                    <h3 class="font-bold text-xl">김규태</h3>
                    <p class="text-gray-500 text-sm">Team Leader / Backend</p>
                </div>
                <div class="flex flex-col items-center">
                    <div class="w-24 h-24 rounded-full bg-gray-200 mb-4 flex items-center justify-center font-bold text-2xl text-gray-500">C</div>
                    <h3 class="font-bold text-xl">최범근</h3>
                    <p class="text-gray-500 text-sm">Full Stack / Architecture</p>
                </div>
                <div class="flex flex-col items-center">
                    <div class="w-24 h-24 rounded-full bg-gray-200 mb-4 flex items-center justify-center font-bold text-2xl text-gray-500">L</div>
                    <h3 class="font-bold text-xl">이상원</h3>
                    <p class="text-gray-500 text-sm">Backend / Security</p>
                </div>
                <div class="flex flex-col items-center">
                    <div class="w-24 h-24 rounded-full bg-gray-200 mb-4 flex items-center justify-center font-bold text-2xl text-gray-500">K</div>
                    <h3 class="font-bold text-xl">김도연</h3>
                    <p class="text-gray-500 text-sm">Frontend / UI/UX</p>
                </div>
                <div class="flex flex-col items-center">
                    <div class="w-24 h-24 rounded-full bg-gray-200 mb-4 flex items-center justify-center font-bold text-2xl text-gray-500">L</div>
                    <h3 class="font-bold text-xl">이승환</h3>
                    <p class="text-gray-500 text-sm">Backend / API</p>
                </div>
                <div class="flex flex-col items-center">
                    <div class="w-24 h-24 rounded-full bg-gray-200 mb-4 flex items-center justify-center font-bold text-2xl text-gray-500">L</div>
                    <h3 class="font-bold text-xl">이동희</h3>
                    <p class="text-gray-500 text-sm">Frontend / Community</p>
                </div>
            </div>
        </div>
    </section>

    <section class="py-32 bg-gray-50">
        <div class="max-w-4xl mx-auto px-6">
            <h2 class="text-4xl font-bold mb-16 text-center reveal-text">기존 거래의 마찰(Friction)을 없애다.</h2>

            <div class="space-y-24">
                <div class="flex flex-col md:flex-row items-center gap-12 reveal-text">
                    <div class="flex-1 text-right md:text-left">
                        <div class="text-blue-600 font-bold mb-2">01. Inconvenience</div>
                        <h3 class="text-3xl font-bold mb-4 text-gray-900">귀찮은 등록 과정</h3>
                        <p class="text-lg text-gray-500 leading-relaxed">
                            책 제목, 저자, 출판사, 정가...<br>
                            일일이 타이핑하는 경험은 판매 의지를 꺾습니다.
                        </p>
                    </div>
                    <div class="flex-1">
                        <div class="bg-white p-8 rounded-3xl shadow-sm border border-gray-100 h-64 flex items-center justify-center">
                            <span class="text-4xl text-gray-300 font-bold">Complex Input UI</span>
                        </div>
                    </div>
                </div>

                <div class="flex flex-col md:flex-row-reverse items-center gap-12 reveal-text">
                    <div class="flex-1 text-left md:text-right">
                        <div class="text-red-500 font-bold mb-2">02. Anxiety</div>
                        <h3 class="text-3xl font-bold mb-4 text-gray-900">거래의 불안함</h3>
                        <p class="text-lg text-gray-500 leading-relaxed">
                            "돈을 보냈는데 물건이 안 오면 어떡하지?"<br>
                            비대면 중고 거래의 가장 큰 진입 장벽입니다.
                        </p>
                    </div>
                    <div class="flex-1">
                        <div class="bg-white p-8 rounded-3xl shadow-sm border border-gray-100 h-64 flex items-center justify-center">
                            <i data-lucide="shield-alert" class="w-24 h-24 text-red-100"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="py-32 px-6">
        <div class="max-w-6xl mx-auto">
            <h2 class="text-5xl font-bold mb-6 text-center reveal-text">Seamless Solution.</h2>
            <p class="text-xl text-gray-500 text-center mb-20 reveal-text">우리가 제안하는 새로운 경험</p>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 auto-rows-[300px]">

                <div class="bento-box md:col-span-2 p-8 flex flex-col justify-between relative overflow-hidden group reveal-image">
                    <div class="z-10">
                        <div class="w-12 h-12 bg-blue-50 text-blue-600 rounded-full flex items-center justify-center mb-4">
                            <i data-lucide="scan-barcode" class="w-6 h-6"></i>
                        </div>
                        <h3 class="text-2xl font-bold mb-2">1초 자동 등록</h3>
                        <p class="text-gray-500">ISBN만 입력하세요.<br>Naver/Kakao API가 표지부터 출판사까지 자동으로 채워줍니다.</p>
                    </div>
                    <div class="absolute right-[-20px] bottom-[-20px] opacity-10 group-hover:opacity-20 transition-opacity">
                        <i data-lucide="book-open" class="w-64 h-64"></i>
                    </div>
                </div>

                <div class="bento-box p-8 bg-gray-900 text-white flex flex-col justify-between reveal-image transition-delay-100">
                    <div>
                        <div class="w-12 h-12 bg-gray-700 rounded-full flex items-center justify-center mb-4">
                            <i data-lucide="lock" class="w-6 h-6 text-green-400"></i>
                        </div>
                        <h3 class="text-2xl font-bold mb-2">Safe Payment</h3>
                        <p class="text-gray-400 text-sm">Toss Payments 에스크로 시스템으로 구매 확정 시까지 대금을 보호합니다.</p>
                    </div>
                </div>

                <div class="bento-box p-8 flex flex-col justify-center items-center text-center reveal-image transition-delay-200">
                    <div class="w-16 h-16 bg-green-50 text-green-600 rounded-2xl flex items-center justify-center mb-4 shadow-sm">
                        <i data-lucide="message-circle" class="w-8 h-8"></i>
                    </div>
                    <h3 class="text-xl font-bold">WebSocket Chat</h3>
                    <p class="text-sm text-gray-500 mt-2">Stomp 프로토콜을 활용한<br>지연 없는 실시간 대화</p>
                </div>

                <div class="bento-box md:col-span-2 p-8 flex flex-col md:flex-row items-center gap-8 reveal-image transition-delay-300">
                    <div class="flex-1">
                        <div class="w-12 h-12 bg-yellow-50 text-yellow-600 rounded-full flex items-center justify-center mb-4">
                            <i data-lucide="map-pin" class="w-6 h-6"></i>
                        </div>
                        <h3 class="text-2xl font-bold mb-2">로컬 독서 모임</h3>
                        <p class="text-gray-500">Kakao Map API 기반으로<br>내 주변 독서 모임을 직관적으로 탐색합니다.</p>
                    </div>
                    <div class="flex-1 w-full h-40 bg-gray-100 rounded-xl flex items-center justify-center text-gray-400">
                        (지도 UI Mockup)
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="py-32 bg-[#111] text-white">
        <div class="max-w-6xl mx-auto px-6">
            <h2 class="text-4xl font-bold mb-16 reveal-text">Engineering & Architecture</h2>

            <div class="flex flex-wrap gap-8 mb-20 opacity-70 grayscale hover:grayscale-0 transition-all duration-500 reveal-text">
                <span class="px-4 py-2 border border-gray-700 rounded-full">Java 11</span>
                <span class="px-4 py-2 border border-gray-700 rounded-full">Spring MVC</span>
                <span class="px-4 py-2 border border-gray-700 rounded-full">MyBatis</span>
                <span class="px-4 py-2 border border-gray-700 rounded-full text-blue-400 border-blue-900 bg-blue-900/20">Redis</span>
                <span class="px-4 py-2 border border-gray-700 rounded-full">PostgreSQL</span>
                <span class="px-4 py-2 border border-gray-700 rounded-full">AWS S3</span>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-16">
                <div class="reveal-text">
                    <h3 class="text-2xl font-bold mb-4 text-blue-400">01. WebClient 도입</h3>
                    <p class="text-gray-400 mb-6 leading-relaxed">
                        Legacy인 RestTemplate의 Blocking 방식을 개선하기 위해,
                        외부 API 통신(도서검색, 결제)에 <strong>Spring WebClient</strong>를 도입했습니다.
                        Non-blocking I/O를 통해 스레드 효율성을 극대화하고, Fluent API로 가독성을 높였습니다.
                    </p>
                    <div class="code-window p-4 text-xs text-green-400">
                        <pre>
WebClient.create().get()
  .uri(naverApiUrl)
  .header("X-Naver-Client-Id", id)
  .retrieve()
  .bodyToMono(String.class)
  .block(); // Needed for Sync logic
                        </pre>
                    </div>
                </div>

                <div class="reveal-text transition-delay-200">
                    <h3 class="text-2xl font-bold mb-4 text-purple-400">02. Reliability & Performance</h3>
                    <ul class="space-y-6 text-gray-400">
                        <li class="flex gap-4">
                            <i data-lucide="zap" class="w-6 h-6 text-yellow-400 shrink-0"></i>
                            <div>
                                <strong class="text-white block mb-1">Redis Caching</strong>
                                자주 조회되는 '베스트셀러', '카테고리 목록'을 Redis에 캐싱하여 DB 부하를 50% 이상 절감했습니다.
                            </div>
                        </li>
                        <li class="flex gap-4">
                            <i data-lucide="clock" class="w-6 h-6 text-blue-400 shrink-0"></i>
                            <div>
                                <strong class="text-white block mb-1">Automated Scheduler</strong>
                                <code>SafePaymentScheduler</code>가 백그라운드에서 동작하며,
                                결제 후 15일 경과 시 자동 구매 확정, 미결제 건 자동 취소 등을 처리하여 거래의 완결성을 보장합니다.
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <section class="py-32 px-6">
        <div class="max-w-5xl mx-auto">
            <h2 class="text-4xl font-bold mb-12 reveal-text">Frontend Challenge: SPA Experience</h2>

            <div class="flex flex-col md:flex-row gap-12 items-center reveal-text">
                <div class="flex-1">
                    <h3 class="text-2xl font-bold mb-4">JSP 환경에서의 부드러운 UX</h3>
                    <p class="text-gray-600 mb-6 leading-relaxed">
                        전통적인 SSR(Server Side Rendering) 방식은 페이지 이동 시 깜빡임이 발생합니다.
                        우리는 이를 해결하기 위해 <strong>AJAX + History API</strong>를 활용하여
                        마이페이지 내 탭 전환을 SPA(Single Page Application)처럼 구현했습니다.
                    </p>

                    <div class="p-6 bg-red-50 rounded-2xl border border-red-100 mb-6">
                        <h4 class="font-bold text-red-600 mb-2 flex items-center gap-2">
                            <i data-lucide="alert-circle" class="w-4 h-4"></i> Issue: 변수 충돌
                        </h4>
                        <p class="text-sm text-gray-600">
                            동적으로 HTML/JS를 로드할 때, 전역 스코프 오염으로 인한
                            <code>Identifier 'data' has already been declared</code> 오류 발생.
                        </p>
                    </div>

                    <div class="p-6 bg-green-50 rounded-2xl border border-green-100">
                        <h4 class="font-bold text-green-600 mb-2 flex items-center gap-2">
                            <i data-lucide="check-circle" class="w-4 h-4"></i> Solution: IIFE Pattern
                        </h4>
                        <p class="text-sm text-gray-600">
                            즉시 실행 함수(IIFE)로 스코프를 격리하고, Namespace 객체(<code>AddressTab</code>, <code>ProfileTab</code>)를 통해
                            메모리 누수와 충돌을 원천 차단했습니다.
                        </p>
                    </div>
                </div>

                <div class="flex-1 w-full">
                    <div class="code-window p-6 text-sm text-gray-300">
<pre>
<span class="text-gray-500">// Scope Isolation Pattern</span>
(function() {
    let state = { count: 0 };

    const actions = {
        init: () => { ... },
        save: () => { ... }
    };

    <span class="text-blue-400">window.ProfileTab</span> = actions;
})();
</pre>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="py-24 bg-gray-50 border-t border-gray-200">
        <div class="max-w-6xl mx-auto px-6 text-center reveal-text">
            <h2 class="text-3xl font-bold mb-10">Admin & Dashboard</h2>
            <div class="relative rounded-2xl overflow-hidden shadow-2xl border border-gray-200">
                <img src="/img/admin_dashboard_mockup.jpg" onerror="this.src='https://placehold.co/1200x600/ffffff/cccccc?text=Admin+Dashboard+UI'" class="w-full">
                <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent flex items-end justify-center pb-10">
                    <p class="text-white font-medium text-lg">실시간 방문자 통계, 거래 현황, 배너 관리 기능을 제공하는 통합 대시보드</p>
                </div>
            </div>
        </div>
    </section>

    <section class="h-screen flex flex-col justify-center items-center text-center bg-white">
        <div class="mb-8 reveal-text">
            <div class="w-20 h-20 bg-blue-600 rounded-3xl flex items-center justify-center mx-auto shadow-xl mb-6">
                <span class="text-white font-black text-3xl">S</span>
            </div>
            <h2 class="text-4xl md:text-6xl font-black mb-6 tracking-tight">Your Book's Second Life.</h2>
            <p class="text-xl text-gray-500 mb-10">
                기술적 고민을 통해, 책과 사람을 잇는 가장 따뜻한 방법을 만들었습니다.
            </p>
            <a href="/home" class="inline-flex items-center gap-2 bg-gray-900 text-white px-8 py-4 rounded-full font-bold text-lg hover:bg-black hover:scale-105 transition-all shadow-lg">
                서비스 시작하기 <i data-lucide="arrow-right" class="w-5 h-5"></i>
            </a>
        </div>

        <footer class="absolute bottom-8 text-sm text-gray-400">
            &copy; 2026 SecondHand Books Team. All rights reserved.
        </footer>
    </section>

    <script>
        // Lucide Icons Init
        lucide.createIcons();

        // Scroll Animation Logic using Intersection Observer
        const observerOptions = {
            root: null,
            rootMargin: '0px',
            threshold: 0.15 // 요소가 15% 보일 때 트리거
        };

        const observer = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('active');
                    // 한번 보이면 관찰 중지 (원할 경우 제거 가능)
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        document.querySelectorAll('.reveal-text, .reveal-image').forEach(el => {
            observer.observe(el);
        });
    </script>
</body>
</html>