<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SecondHand Books - 프로젝트 발표</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        body {
            font-family: 'Pretendard', sans-serif;
            overflow: hidden; /* 스크롤바 숨김 */
        }
        /* PPT 슬라이드처럼 한 장씩 넘어가게 설정 */
        .snap-container {
            height: 100vh;
            overflow-y: scroll;
            scroll-snap-type: y mandatory;
            scroll-behavior: smooth;
        }
        .slide {
            height: 100vh;
            width: 100%;
            scroll-snap-align: start;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            background-color: #ffffff;
            color: #1a1a1a;
            padding: 0 5%;
        }
        /* 슬라이드 번호 */
        .slide-number {
            position: absolute;
            bottom: 30px;
            right: 40px;
            font-size: 14px;
            color: #888;
        }
        /* 강조 텍스트 */
        .highlight {
            color: #2563eb; /* Primary Blue */
            font-weight: 700;
        }
        /* 애니메이션 */
        .fade-in {
            opacity: 0;
            transform: translateY(20px);
            transition: all 0.8s ease-out;
        }
        .slide:focus-within .fade-in, .active .fade-in {
            opacity: 1;
            transform: translateY(0);
        }
        /* 커스텀 스크롤바 숨김 */
        .snap-container::-webkit-scrollbar {
            display: none;
        }
    </style>
</head>
<body>

    <header class="fixed top-0 left-0 w-full p-6 z-50 flex justify-between items-center bg-white/90 backdrop-blur-sm border-b border-gray-100">
        <div class="text-xl font-bold tracking-tight">SecondHand Books</div>
        <div class="text-sm text-gray-500">Shinhan DS Financial SW Academy</div>
    </header>

    <div class="snap-container" id="mainContainer">

        <section class="slide bg-gray-50">
            <div class="max-w-4xl mx-auto text-center">
                <div class="mb-6 fade-in delay-100">
                    <span class="px-3 py-1 bg-blue-100 text-blue-700 rounded-full text-sm font-bold">Project Presentation</span>
                </div>
                <h1 class="text-5xl md:text-7xl font-black mb-6 leading-tight fade-in delay-200">
                    책의 가치를 잇고,<br>
                    <span class="text-blue-600">독자를 연결하다.</span>
                </h1>
                <p class="text-xl text-gray-600 mb-12 fade-in delay-300">
                    중고 서적 거래 & 로컬 독서 커뮤니티 플랫폼
                </p>
                <div class="fade-in delay-400">
                    <p class="text-sm text-gray-500 font-bold">발표자: 홍길동</p>
                </div>
            </div>
            <div class="slide-number">01</div>
        </section>

        <section class="slide">
            <div class="max-w-6xl mx-auto w-full">
                <h2 class="text-4xl font-bold mb-12 border-l-4 border-blue-600 pl-4 fade-in">기획 배경 및 문제 인식</h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8 fade-in delay-200">
                    <div class="p-8 border border-gray-200 rounded-2xl bg-gray-50 hover:shadow-lg transition-all">
                        <div class="w-12 h-12 bg-red-100 text-red-600 rounded-xl flex items-center justify-center mb-6">
                            <i data-lucide="keyboard" class="w-6 h-6"></i>
                        </div>
                        <h3 class="text-xl font-bold mb-3">등록의 번거로움</h3>
                        <p class="text-gray-600 leading-relaxed text-sm">
                            기존 중고 거래 시, 책 제목, 저자, 출판사, 상태 등 입력해야 할 정보가 너무 많아 판매자가 피로감을 느낌.
                        </p>
                    </div>
                    <div class="p-8 border border-gray-200 rounded-2xl bg-gray-50 hover:shadow-lg transition-all">
                        <div class="w-12 h-12 bg-orange-100 text-orange-600 rounded-xl flex items-center justify-center mb-6">
                            <i data-lucide="alert-triangle" class="w-6 h-6"></i>
                        </div>
                        <h3 class="text-xl font-bold mb-3">거래의 불안감</h3>
                        <p class="text-gray-600 leading-relaxed text-sm">
                            비대면 택배 거래 시 '벽돌 택배'나 '입금 후 잠적(먹튀)' 등 사기 피해에 대한 근본적인 불안 존재.
                        </p>
                    </div>
                    <div class="p-8 border border-gray-200 rounded-2xl bg-gray-50 hover:shadow-lg transition-all">
                        <div class="w-12 h-12 bg-gray-200 text-gray-600 rounded-xl flex items-center justify-center mb-6">
                            <i data-lucide="user-x" class="w-6 h-6"></i>
                        </div>
                        <h3 class="text-xl font-bold mb-3">독서의 고립감</h3>
                        <p class="text-gray-600 leading-relaxed text-sm">
                            단순히 책을 사고파는 행위를 넘어, 같은 책을 읽은 사람들과 소통하고 모임을 가질 수 있는 창구가 부족함.
                        </p>
                    </div>
                </div>
            </div>
            <div class="slide-number">02</div>
        </section>

        <section class="slide bg-gray-50">
            <div class="max-w-6xl mx-auto w-full">
                <h2 class="text-4xl font-bold mb-12 border-l-4 border-blue-600 pl-4 fade-in">핵심 해결 방안 (Solution)</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
                    <div class="space-y-8 fade-in delay-200">
                        <div class="flex gap-4">
                            <div class="flex-shrink-0 w-10 h-10 rounded-full bg-blue-600 text-white flex items-center justify-center font-bold">1</div>
                            <div>
                                <h3 class="text-xl font-bold mb-2">API 기반 1초 상품 등록</h3>
                                <p class="text-gray-600 text-sm">Naver/Kakao 도서 API를 연동하여 ISBN 입력만으로 책 정보를 자동 완성합니다.</p>
                            </div>
                        </div>
                        <div class="flex gap-4">
                            <div class="flex-shrink-0 w-10 h-10 rounded-full bg-blue-600 text-white flex items-center justify-center font-bold">2</div>
                            <div>
                                <h3 class="text-xl font-bold mb-2">에스크로 안전 결제</h3>
                                <p class="text-gray-600 text-sm">구매 확정 전까지 결제 대금을 플랫폼이 보관하여 거래 사기를 원천 차단합니다.</p>
                            </div>
                        </div>
                        <div class="flex gap-4">
                            <div class="flex-shrink-0 w-10 h-10 rounded-full bg-blue-600 text-white flex items-center justify-center font-bold">3</div>
                            <div>
                                <h3 class="text-xl font-bold mb-2">로컬 독서 커뮤니티</h3>
                                <p class="text-gray-600 text-sm">지도 기반으로 내 주변 독서 모임을 개설하고 참여하며 오프라인 연결을 지원합니다.</p>
                            </div>
                        </div>
                    </div>
                    <div class="bg-white p-6 rounded-2xl shadow-xl border border-gray-200 fade-in delay-300 transform rotate-2">
                        <div class="aspect-video bg-gray-100 rounded-lg flex items-center justify-center text-gray-400">
                            (서비스 주요 화면 캡쳐 이미지 배치)
                        </div>
                    </div>
                </div>
            </div>
            <div class="slide-number">03</div>
        </section>

        <section class="slide">
            <div class="max-w-6xl mx-auto w-full">
                <h2 class="text-4xl font-bold mb-10 border-l-4 border-blue-600 pl-4 fade-in">기술 스택 (Tech Stack)</h2>

                <div class="grid grid-cols-2 md:grid-cols-4 gap-6 fade-in delay-200">
                    <div class="p-6 border rounded-xl bg-white shadow-sm">
                        <h3 class="font-bold text-lg mb-4 text-blue-600">Frontend</h3>
                        <ul class="space-y-2 text-sm text-gray-700">
                            <li>• JSP / JSTL</li>
                            <li>• jQuery (AJAX)</li>
                            <li>• Tailwind CSS</li>
                            <li>• Lucide Icons</li>
                        </ul>
                    </div>
                    <div class="p-6 border rounded-xl bg-white shadow-sm">
                        <h3 class="font-bold text-lg mb-4 text-blue-600">Backend</h3>
                        <ul class="space-y-2 text-sm text-gray-700">
                            <li>• Java 11</li>
                            <li>• Spring Framework (Legacy)</li>
                            <li>• MyBatis</li>
                            <li>• Spring Security</li>
                        </ul>
                    </div>
                    <div class="p-6 border rounded-xl bg-white shadow-sm">
                        <h3 class="font-bold text-lg mb-4 text-blue-600">Database & Infra</h3>
                        <ul class="space-y-2 text-sm text-gray-700">
                            <li>• PostgreSQL</li>
                            <li>• AWS S3 (이미지 저장)</li>
                            <li>• Apache Tomcat 9</li>
                        </ul>
                    </div>
                    <div class="p-6 border rounded-xl bg-white shadow-sm">
                        <h3 class="font-bold text-lg mb-4 text-blue-600">Open API</h3>
                        <ul class="space-y-2 text-sm text-gray-700">
                            <li>• Naver/Kakao Book API</li>
                            <li>• Toss Payments API</li>
                            <li>• Kakao Map API</li>
                            <li>• Daum Postcode API</li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="slide-number">04</div>
        </section>

        <section class="slide bg-gray-900 text-white">
            <div class="max-w-5xl mx-auto w-full">
                <div class="mb-4 text-blue-400 font-bold fade-in">Technical Decision</div>
                <h2 class="text-4xl font-bold mb-10 fade-in delay-100">RestTemplate vs WebClient</h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-10 fade-in delay-200">
                    <div>
                        <h3 class="text-2xl font-bold mb-4 text-gray-400">Legacy: RestTemplate</h3>
                        <p class="text-gray-300 leading-relaxed mb-6">
                            기존에 많이 사용되던 동기(Blocking) 방식의 HTTP 클라이언트입니다.
                            요청이 끝날 때까지 스레드가 대기해야 하므로, 외부 API 응답이 늦어질 경우
                            전체 시스템의 성능 저하를 유발할 수 있습니다.
                        </p>
                        <div class="bg-gray-800 p-4 rounded-lg font-mono text-xs text-gray-400">
                            RestTemplate rest = new RestTemplate();<br>
                            // Thread Blocked...<br>
                            String res = rest.getForObject(url, String.class);
                        </div>
                    </div>

                    <div class="relative">
                        <div class="absolute -top-4 -left-4 bg-blue-600 text-white text-xs px-3 py-1 rounded-full">Adoption</div>
                        <h3 class="text-2xl font-bold mb-4 text-blue-400">Modern: Spring WebClient</h3>
                        <p class="text-gray-200 leading-relaxed mb-6">
                            Spring 5부터 도입된 <strong>Non-Blocking I/O</strong> 방식의 클라이언트입니다.
                            API 호출 시 스레드를 점유하지 않아 시스템 리소스를 효율적으로 사용하며,
                            Fluent API 스타일로 코드 가독성이 뛰어납니다.
                        </p>
                        <div class="bg-gray-800 p-4 rounded-lg font-mono text-xs text-green-400 border border-blue-500/30">
                            WebClient.create().get().uri(url)<br>
                            .retrieve()<br>
                            .bodyToMono(String.class)<br>
                            .subscribe(res -> process(res));
                        </div>
                    </div>
                </div>
            </div>
            <div class="slide-number">05</div>
        </section>

        <section class="slide">
            <div class="max-w-6xl mx-auto w-full flex flex-col md:flex-row gap-12 items-center">
                <div class="flex-1 fade-in">
                    <h2 class="text-3xl font-bold mb-6">완결성 있는 안전 거래 시스템</h2>
                    <p class="text-gray-600 mb-8 leading-relaxed">
                        사용자 간의 채팅부터 결제, 그리고 구매 확정까지 끊김 없는 프로세스를 구축했습니다.
                        특히 백그라운드 스케줄러를 통해 예외 상황을 자동으로 처리합니다.
                    </p>

                    <div class="space-y-6">
                        <div class="flex items-start gap-4">
                            <div class="p-2 bg-blue-50 rounded-lg text-blue-600"><i data-lucide="message-square" class="w-6 h-6"></i></div>
                            <div>
                                <h4 class="font-bold text-lg">실시간 채팅 (WebSocket/Stomp)</h4>
                                <p class="text-sm text-gray-500">별도 메신저 없이 플랫폼 내에서 흥정 및 주소 교환</p>
                            </div>
                        </div>
                        <div class="flex items-start gap-4">
                            <div class="p-2 bg-blue-50 rounded-lg text-blue-600"><i data-lucide="credit-card" class="w-6 h-6"></i></div>
                            <div>
                                <h4 class="font-bold text-lg">Toss Payments 연동</h4>
                                <p class="text-sm text-gray-500">결제 요청 시 즉시 결제창 호출 및 유효성 검증</p>
                            </div>
                        </div>
                        <div class="flex items-start gap-4">
                            <div class="p-2 bg-blue-50 rounded-lg text-blue-600"><i data-lucide="clock" class="w-6 h-6"></i></div>
                            <div>
                                <h4 class="font-bold text-lg">Scheduler 자동화</h4>
                                <p class="text-sm text-gray-500">결제 후 15일 경과 시 자동 구매 확정 처리 (Quartz)</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="flex-1 fade-in delay-200">
                    <img src="https://via.placeholder.com/600x400/f3f4f6/9ca3af?text=Safe+Payment+Flow" class="rounded-2xl shadow-xl w-full" alt="Process Flow">
                </div>
            </div>
            <div class="slide-number">06</div>
        </section>

        <section class="slide bg-gray-50">
            <div class="max-w-5xl mx-auto w-full">
                <h2 class="text-3xl font-bold mb-10 border-l-4 border-red-500 pl-4 fade-in">Troubleshooting: 변수 스코프 오염</h2>

                <div class="bg-white p-8 rounded-2xl shadow-sm border border-gray-200 fade-in delay-200">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div>
                            <h4 class="font-bold text-red-500 mb-2 flex items-center gap-2">
                                <i data-lucide="x-circle" class="w-5 h-5"></i> 문제 상황 (Problem)
                            </h4>
                            <p class="text-sm text-gray-600 mb-4">
                                마이페이지 탭을 AJAX로 동적 로딩할 때,
                                <code class="bg-gray-100 px-1 rounded">let</code>이나 <code class="bg-gray-100 px-1 rounded">const</code>로 선언된 변수가
                                탭 전환 시 중복 선언되어 <strong>SyntaxError</strong> 발생.
                            </p>
                            <pre class="bg-gray-900 text-gray-300 p-4 rounded-lg text-xs overflow-x-auto">
// Tab 1 Script
let data = []; // First Load: OK
// Tab Reload
let data = []; // Error: Identifier 'data' has already been declared
                            </pre>
                        </div>

                        <div class="border-l border-gray-200 pl-8 md:border-l-0 md:pl-0">
                            <h4 class="font-bold text-green-600 mb-2 flex items-center gap-2">
                                <i data-lucide="check-circle" class="w-5 h-5"></i> 해결 방법 (Solution)
                            </h4>
                            <p class="text-sm text-gray-600 mb-4">
                                <strong>IIFE (즉시 실행 함수)</strong> 패턴과 <strong>Namespace</strong> 객체를 도입하여
                                스크립트의 유효 범위를 블록 단위로 격리시킴.
                            </p>
                            <pre class="bg-gray-900 text-green-400 p-4 rounded-lg text-xs overflow-x-auto">
(function() { // Scope Isolation
    let data = [];

    const actions = { ... };
    window.TabName = actions; // Expose only necessary methods
})();
                            </pre>
                        </div>
                    </div>
                </div>
            </div>
            <div class="slide-number">07</div>
        </section>

        <section class="slide">
            <div class="text-center fade-in">
                <div class="mb-8 flex justify-center">
                    <div class="w-24 h-24 bg-blue-600 text-white rounded-3xl flex items-center justify-center text-4xl font-bold shadow-2xl">
                        S
                    </div>
                </div>
                <h2 class="text-5xl font-black mb-6 text-gray-900">감사합니다.</h2>
                <p class="text-xl text-gray-500 mb-12">SecondHand Books 시연을 시작합니다.</p>

                <div class="flex justify-center gap-4">
                    <a href="/home" class="px-8 py-4 bg-gray-900 text-white rounded-full font-bold hover:bg-black transition shadow-lg flex items-center gap-2">
                        <i data-lucide="play" class="w-5 h-5"></i> 시연 시작하기
                    </a>
                </div>
            </div>
            <div class="slide-number">08</div>
        </section>

    </div>

    <script>
        // Lucide 아이콘 초기화
        lucide.createIcons();

        // 스크롤 시 페이드인 효과 트리거
        const observerOptions = {
            root: null,
            rootMargin: '0px',
            threshold: 0.1
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('active');
                    // 해당 슬라이드 내부의 fade-in 요소들도 활성화
                    const children = entry.target.querySelectorAll('.fade-in');
                    children.forEach((child, index) => {
                        setTimeout(() => {
                            child.style.opacity = '1';
                            child.style.transform = 'translateY(0)';
                        }, index * 100);
                    });
                }
            });
        }, observerOptions);

        document.querySelectorAll('.slide').forEach(section => {
            observer.observe(section);
        });
    </script>
</body>
</html>