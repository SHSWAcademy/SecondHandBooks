<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>SecondHand Books - Project Journey</title>
            <link rel="stylesheet" as="style" crossorigin
                href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
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

                /* 스크롤 애니메이션 */
                .reveal-text {
                    opacity: 0;
                    transform: translateY(40px);
                    transition: all 1s cubic-bezier(0.165, 0.84, 0.44, 1);
                }

                .reveal-text.active {
                    opacity: 1;
                    transform: translateY(0);
                }

                .reveal-card {
                    opacity: 0;
                    transform: scale(0.95) translateY(20px);
                    transition: all 0.8s cubic-bezier(0.165, 0.84, 0.44, 1);
                }

                .reveal-card.active {
                    opacity: 1;
                    transform: scale(1) translateY(0);
                }

                /* Bento Grid Box Style - Clean & Readable */
                .bento-box {
                    background: #fff;
                    border-radius: 24px;
                    box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
                    border: 1px solid rgba(0, 0, 0, 0.05);
                    transition: transform 0.3s ease, box-shadow 0.3s ease;
                    overflow: hidden;
                    z-index: 10;
                }

                .bento-box:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
                }

                /* Code Block Style */
                .code-window {
                    background: #1e1e1e;
                    border-radius: 12px;
                    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
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

                .dot {
                    width: 12px;
                    height: 12px;
                    border-radius: 50%;
                }

                .dot.red {
                    background: #ff5f56;
                }

                .dot.yellow {
                    background: #ffbd2e;
                }

                .dot.green {
                    background: #28c93f;
                }

                /* --- INTERACTIVE 3D & MOTION --- */
                .interactive-container {
                    perspective: 1000px;
                    transform-style: preserve-3d;
                }

                .interactive-card {
                    will-change: transform;
                    transform-style: preserve-3d;
                    transition: transform 0.1s cubic-bezier(0.03, 0.98, 0.52, 0.99);
                }

                .interactive-content {
                    transform: translateZ(20px);
                }

                /* Spotlight Effect */
                .spotlight-overlay {
                    pointer-events: none;
                    position: absolute;
                    inset: 0;
                    opacity: 0;
                    background: radial-gradient(800px circle at var(--mouse-x) var(--mouse-y), rgba(255, 255, 255, 0.15), transparent 40%);
                    z-index: 50;
                    transition: opacity 0.3s;
                    border-radius: inherit;
                    mix-blend-mode: overlay;
                }

                .bento-box:hover .spotlight-overlay,
                .reveal-card:hover .spotlight-overlay {
                    opacity: 1;
                }

                /* Hero Floating Animation */
                @keyframes heroFloat {

                    0%,
                    100% {
                        transform: translateY(0) rotate(3deg);
                    }

                    50% {
                        transform: translateY(-15px) rotate(6deg) scale(1.05);
                    }
                }

                .hero-floater {
                    animation: heroFloat 6s ease-in-out infinite;
                }

                /* Custom Cursor Glow */
                .cursor-glow {
                    width: 400px;
                    height: 400px;
                    background: radial-gradient(circle, rgba(59, 130, 246, 0.15), transparent 70%);
                    position: fixed;
                    pointer-events: none;
                    transform: translate(-50%, -50%);
                    z-index: 9999;
                    mix-blend-mode: screen;
                    transition: transform 0.1s;
                }
            </style>
        </head>

        <body>

            <nav
                class="fixed top-0 w-full z-50 bg-white/80 backdrop-blur-md border-b border-gray-100 transition-all duration-300">
                <div class="max-w-7xl mx-auto px-6 h-16 flex items-center justify-between">
                    <div class="font-bold text-lg tracking-tight flex items-center gap-2">
                        <span class="w-2 h-2 rounded-full bg-blue-600"></span>
                        SecondHand Books
                    </div>
                    <div class="text-xs text-gray-500 font-medium">Shinhan DS Academy</div>
                </div>
            </nav>

            <!-- Original HERO Section -->
            <section class="min-h-screen flex flex-col justify-center items-center text-center px-4 relative pt-10">
                <div class="reveal-text">
                    <div class="mb-8 inline-block">
                        <span
                            class="px-4 py-1.5 bg-blue-50 text-blue-600 rounded-full text-sm font-bold border border-blue-100">Project
                            Presentation</span>
                    </div>
                    <h1 class="text-6xl md:text-8xl font-black mb-8 leading-tight tracking-tight text-gray-900">
                        책의 가치를 잇고,<br>
                        <span class="text-gradient">독자를 연결하다.</span>
                    </h1>
                    <p class="text-xl md:text-2xl text-gray-500 max-w-2xl mx-auto leading-relaxed font-medium">
                        중고 서적 거래 & 로컬 독서 커뮤니티 플랫폼
                    </p>
                    <div class="mt-12 text-sm font-bold text-gray-400">
                        발표자: 홍길동
                    </div>
                </div>
                <div class="absolute bottom-10 animate-bounce text-gray-300">
                    <i data-lucide="chevron-down" class="w-8 h-8"></i>
                </div>
            </section>

            <!-- Partitioned TEAM Section -->
            <section class="py-32 bg-white border-y border-gray-100">
                <div class="max-w-7xl mx-auto px-6 text-center">
                    <h2 class="text-4xl font-bold mb-4 reveal-text">Our Team</h2>
                    <p class="text-gray-500 mb-20 reveal-text">각 분야의 전문가들이 모여 최고의 시너지를 냈습니다.</p>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-12 text-left">
                        <!-- Group 1 -->
                        <div
                            class="reveal-card group p-8 rounded-3xl bg-gray-50 hover:bg-white hover:shadow-xl transition-all border border-transparent hover:border-gray-100">
                            <div class="flex items-center gap-4 mb-6">
                                <div class="p-3 bg-blue-100 text-blue-600 rounded-xl">
                                    <i data-lucide="shield-check" class="w-6 h-6"></i>
                                </div>
                                <div>
                                    <h3 class="font-bold text-lg">Auth & Admin</h3>
                                    <p class="text-xs text-gray-400">Security / User Mgmt</p>
                                </div>
                            </div>
                            <div class="space-y-6">
                                <div class="flex items-center gap-4">
                                    <div
                                        class="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center font-bold text-gray-500">
                                        K</div>
                                    <div>
                                        <p class="font-bold text-gray-900">김규태</p>
                                        <p class="text-xs text-blue-600 font-bold">Team Leader</p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-4">
                                    <div
                                        class="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center font-bold text-gray-500">
                                        L</div>
                                    <div>
                                        <p class="font-bold text-gray-900">이승환</p>
                                        <p class="text-xs text-gray-500">Backend Dev</p>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-6 pt-6 border-t border-gray-200">
                                <p class="text-xs text-gray-500 leading-relaxed">
                                    Spring Security 인증/인가 구조 설계, 관리자 운영 대시보드 및 마이페이지 통합 관리를 구현했습니다.
                                </p>
                            </div>
                        </div>

                        <!-- Group 2 -->
                        <div class="reveal-card group p-8 rounded-3xl bg-gray-50 hover:bg-white hover:shadow-xl transition-all border border-transparent hover:border-gray-100"
                            style="transition-delay: 100ms;">
                            <div class="flex items-center gap-4 mb-6">
                                <div class="p-3 bg-purple-100 text-purple-600 rounded-xl">
                                    <i data-lucide="credit-card" class="w-6 h-6"></i>
                                </div>
                                <div>
                                    <h3 class="font-bold text-lg">Core Business</h3>
                                    <p class="text-xs text-gray-400">Trade / Pay / Chat</p>
                                </div>
                            </div>
                            <div class="space-y-6">
                                <div class="flex items-center gap-4">
                                    <div
                                        class="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center font-bold text-gray-500">
                                        C</div>
                                    <div>
                                        <p class="font-bold text-gray-900">최범근</p>
                                        <p class="text-xs text-gray-500">Full Stack</p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-4">
                                    <div
                                        class="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center font-bold text-gray-500">
                                        L</div>
                                    <div>
                                        <p class="font-bold text-gray-900">이상원</p>
                                        <p class="text-xs text-gray-500">Backend Dev</p>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-6 pt-6 border-t border-gray-200">
                                <p class="text-xs text-gray-500 leading-relaxed">
                                    중고 거래 핵심 로직, 에스크로 안전 결제(Scheduler), STOMP 기반 실시간 채팅을 담당했습니다.
                                </p>
                            </div>
                        </div>

                        <!-- Group 3 -->
                        <div class="reveal-card group p-8 rounded-3xl bg-gray-50 hover:bg-white hover:shadow-xl transition-all border border-transparent hover:border-gray-100"
                            style="transition-delay: 200ms;">
                            <div class="flex items-center gap-4 mb-6">
                                <div class="p-3 bg-green-100 text-green-600 rounded-xl">
                                    <i data-lucide="users" class="w-6 h-6"></i>
                                </div>
                                <div>
                                    <h3 class="font-bold text-lg">Community</h3>
                                    <p class="text-xs text-gray-400">Book Club / Board</p>
                                </div>
                            </div>
                            <div class="space-y-6">
                                <div class="flex items-center gap-4">
                                    <div
                                        class="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center font-bold text-gray-500">
                                        K</div>
                                    <div>
                                        <p class="font-bold text-gray-900">김도연</p>
                                        <p class="text-xs text-gray-500">Frontend</p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-4">
                                    <div
                                        class="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center font-bold text-gray-500">
                                        L</div>
                                    <div>
                                        <p class="font-bold text-gray-900">이동희</p>
                                        <p class="text-xs text-gray-500">Frontend</p>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-6 pt-6 border-t border-gray-200">
                                <p class="text-xs text-gray-500 leading-relaxed">
                                    위치 기반 독서 모임 찾기, 커뮤니티 게시판 및 Frontend 전반의 UI/UX를 고도화했습니다.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- MOTIVATION Section -->
            <section class="py-32 bg-gray-50 relative overflow-hidden">
                <div class="max-w-5xl mx-auto px-6 relative z-10">
                    <h2 class="text-4xl font-bold mb-16 text-center reveal-text">Why SecondHand Books?</h2>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                        <div class="bento-box p-8 reveal-card">
                            <div
                                class="w-12 h-12 bg-red-50 text-red-500 rounded-2xl flex items-center justify-center mb-6">
                                <i data-lucide="keyboard" class="w-6 h-6"></i>
                            </div>
                            <h3 class="text-xl font-bold mb-3">등록의 번거로움</h3>
                            <p class="text-gray-500 leading-relaxed text-sm">
                                책 제목, 저자, 출판사... 하나하나 입력하는 과정은 사용자를 지치게 만듭니다.
                            </p>
                        </div>
                        <div class="bento-box p-8 reveal-card" style="transition-delay: 100ms;">
                            <div
                                class="w-12 h-12 bg-orange-50 text-orange-500 rounded-2xl flex items-center justify-center mb-6">
                                <i data-lucide="alert-triangle" class="w-6 h-6"></i>
                            </div>
                            <h3 class="text-xl font-bold mb-3">거래의 불안감</h3>
                            <p class="text-gray-500 leading-relaxed text-sm">
                                "돈을 보냈는데 물건이 안 오면?" 비대면 중고 거래의 가장 큰 진입 장벽입니다.
                            </p>
                        </div>
                        <div class="bento-box p-8 reveal-card" style="transition-delay: 200ms;">
                            <div
                                class="w-12 h-12 bg-gray-100 text-gray-600 rounded-2xl flex items-center justify-center mb-6">
                                <i data-lucide="users" class="w-6 h-6"></i>
                            </div>
                            <h3 class="text-xl font-bold mb-3">독서의 고립감</h3>
                            <p class="text-gray-500 leading-relaxed text-sm">
                                단순 거래를 넘어 취향을 공유하는 커뮤니티가 필요했습니다.
                            </p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- TECHNICAL DEEP DIVE Section (Light Mode Redesign) -->
            <section class="py-32 px-6 bg-white border-t border-gray-100">
                <div class="max-w-7xl mx-auto">
                    <div class="text-center mb-20 reveal-text">
                        <span class="text-blue-600 font-bold tracking-wider text-sm uppercase mb-2 block">Technical Deep
                            Dive</span>
                        <h2 class="text-5xl font-bold text-gray-900">Evolution to Non-Blocking I/O</h2>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
                        <!-- Legacy Card -->
                        <div class="reveal-card">
                            <div
                                class="bg-white p-8 rounded-3xl border border-gray-200 shadow-xl mb-8 relative overflow-hidden group hover:-translate-y-1 transition-all duration-300">
                                <div
                                    class="absolute top-0 right-0 p-6 opacity-10 font-black text-9xl text-gray-300 pointer-events-none select-none">
                                    BIO
                                </div>
                                <div class="flex items-center justify-between mb-6 relative z-10">
                                    <h3 class="text-2xl font-bold text-gray-800">Legacy: RestTemplate</h3>
                                    <span
                                        class="px-3 py-1 bg-red-100 text-red-600 text-xs font-bold rounded-full border border-red-200">Blocking</span>
                                </div>
                                <p class="text-gray-500 leading-relaxed mb-6 relative z-10">
                                    전통적인 동기(Synchronous) 방식입니다. 외부 API 요청 시 응답이 올 때까지 스레드가 대기(Block)합니다.
                                    대량 트래픽 발생 시 스레드 풀 고갈(Thread Pool Exhaustion)로 이어질 수 있습니다.
                                </p>
                                <div
                                    class="font-mono text-xs text-gray-400 bg-gray-50 p-4 rounded-xl border border-gray-100 relative z-10">
                                    Thread-1: Wait... (Blocked 3s)<br>
                                    Thread-2: Wait... (Blocked 3s)<br>
                                    <span class="text-red-500 font-bold">Error: Connection Timeout</span>
                                </div>
                            </div>
                        </div>

                        <!-- Modern Card -->
                        <div class="reveal-card relative">
                            <div
                                class="absolute -inset-1 bg-gradient-to-r from-blue-400 to-cyan-400 rounded-3xl opacity-20 blur-xl">
                            </div>
                            <div
                                class="relative bg-white p-8 rounded-3xl border border-blue-100 shadow-2xl group hover:-translate-y-1 transition-all duration-300">
                                <div
                                    class="absolute top-0 right-0 p-6 opacity-5 font-black text-9xl text-blue-500 pointer-events-none select-none">
                                    NIO
                                </div>
                                <div class="flex items-center justify-between mb-6 relative z-10">
                                    <h3 class="text-2xl font-bold text-gray-900">Adoption: WebClient</h3>
                                    <span
                                        class="px-3 py-1 bg-blue-100 text-blue-600 text-xs font-bold rounded-full border border-blue-200">Non-Blocking</span>
                                </div>
                                <p class="text-gray-600 leading-relaxed mb-6 relative z-10">
                                    Spring WebFlux 기반의 비동기 클라이언트입니다. Event Loop 방식을 사용하여 단일 스레드로도 수많은 동시 요청을 효율적으로
                                    처리합니다.
                                </p>
                                <div class="code-window relative z-10 shadow-lg">
                                    <div class="code-header bg-gray-800 border-gray-700">
                                        <div class="dot red"></div>
                                        <div class="dot yellow"></div>
                                        <div class="dot green"></div>
                                        <span class="ml-2 text-xs text-gray-400">ReactiveStream.java</span>
                                    </div>
                                    <div class="p-4 text-xs font-mono text-blue-300 bg-[#1e1e1e]">
                                        <pre>
webClient.get().uri(url)
    .retrieve()
    .bodyToMono(String.class)
    .subscribe(); <span class="text-green-400">// Async Callback</span>
</pre>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- CORE FEATURES Section -->
            <section class="py-32 px-6">
                <div class="max-w-7xl mx-auto">
                    <div class="text-center mb-24 reveal-text">
                        <h2 class="text-5xl font-bold mb-6">Seamless Solution.</h2>
                        <p class="text-xl text-gray-500">기술로 완성된 새로운 경험</p>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                        <div
                            class="bento-box p-8 md:col-span-2 flex flex-col md:flex-row items-center gap-8 reveal-card shadow-lg rounded-3xl bg-white border border-gray-100">
                            <div class="flex-1">
                                <span class="text-blue-600 font-bold mb-2 block">01. API Integration</span>
                                <h3 class="text-3xl font-bold mb-4">1초 자동 등록 (WebClient)</h3>
                                <p class="text-gray-500 leading-relaxed mb-4">
                                    ISBN이나 책 제목만 입력하세요. Naver/Kakao Book API를 통해 저자, 출판사, 가격, 표지 이미지를 자동으로 불러옵니다.
                                    Blocking 방식의 RestTemplate 대신 <strong>Non-blocking WebClient</strong>를 사용하여 대량 요청에도
                                    서버 성능 저하 없이 안정적으로 동작합니다.
                                </p>
                            </div>
                            <div class="flex-1 w-full bg-blue-50 rounded-2xl h-48 flex items-center justify-center">
                                <i data-lucide="book-open" class="w-16 h-16 text-blue-300"></i>
                            </div>
                        </div>

                        <div class="bento-box p-8 bg-gray-900 text-white reveal-card rounded-3xl shadow-lg"
                            style="transition-delay: 100ms;">
                            <div class="h-full flex flex-col justify-between">
                                <div>
                                    <span class="text-green-400 font-bold mb-2 block">02. Safe Payment</span>
                                    <h3 class="text-2xl font-bold mb-2">Escrow System</h3>
                                    <p class="text-gray-400 text-sm">
                                        구매 확정 시까지 대금을 플랫폼 보호합니다.
                                        <strong>Pessimistic Lock</strong>으로 중복 결제를 방지하고, <strong>Scheduler</strong>로
                                        미입금/미확정 건을 자동 관리합니다.
                                    </p>
                                </div>
                                <i data-lucide="shield-check" class="w-10 h-10 text-green-400 mt-4"></i>
                            </div>
                        </div>

                        <div class="bento-box p-8 reveal-card border border-gray-200 rounded-3xl bg-white"
                            style="transition-delay: 200ms;">
                            <div class="h-full flex flex-col justify-between">
                                <div>
                                    <span class="text-yellow-500 font-bold mb-2 block">03. Real-time</span>
                                    <h3 class="text-2xl font-bold mb-2">WebSocket Chat</h3>
                                    <p class="text-gray-500 text-sm">STOMP 프로토콜과 Pub/Sub 모델을 적용하여 1:N 실시간 채팅을 지연 없이
                                        제공합니다.</p>
                                </div>
                                <i data-lucide="message-circle" class="w-10 h-10 text-yellow-500 mt-4"></i>
                            </div>
                        </div>

                        <div class="bento-box p-8 md:col-span-2 flex flex-col md:flex-row-reverse items-center gap-8 reveal-card border border-gray-200 rounded-3xl bg-white"
                            style="transition-delay: 300ms;">
                            <div class="flex-1">
                                <span class="text-purple-600 font-bold mb-2 block">04. Performance</span>
                                <h3 class="text-3xl font-bold mb-4">Redis Caching</h3>
                                <p class="text-gray-500 leading-relaxed">
                                    메인 페이지 및 검색 결과에 <strong>Look-aside Caching</strong> 전략을 적용했습니다.
                                    응답 속도를 <strong>0.5s에서 0.02s</strong>로 96% 단축시켰으며, JSON Serializer를 사용하여 사람이 읽을 수 있는
                                    데이터로 저장, 디버깅 효율을 높였습니다.
                                </p>
                            </div>
                            <div class="flex-1 w-full bg-purple-50 rounded-2xl h-48 flex items-center justify-center">
                                <i data-lucide="zap" class="w-16 h-16 text-purple-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Project Management (GitHub) -->
            <section class="py-32 bg-gray-50">
                <div class="max-w-[1440px] mx-auto px-6">
                    <h2 class="text-4xl font-bold mb-16 text-center reveal-text">Collaboration & Workflow</h2>

                    <div class="space-y-24">
                        <!-- Part 1: Issue & Branch Board -->
                        <div class="flex flex-col md:flex-row items-center gap-12 reveal-card">
                            <div class="flex-1 space-y-6">
                                <div
                                    class="inline-flex items-center gap-2 px-4 py-2 bg-gray-900 text-white rounded-full text-sm font-bold">
                                    <i data-lucide="trello" class="w-4 h-4"></i>
                                    Kanban Board
                                </div>
                                <h3 class="text-3xl font-bold text-gray-900">투명한 진행 상황 공유</h3>
                                <p class="text-gray-500 leading-relaxed text-lg">
                                    GitHub Projects를 활용하여 모든 기능을 이슈 단위로 관리했습니다.
                                    Ready -> In Progress -> In Review -> Done 파이프라인을 구축하여
                                    팀원 간의 진행 상황을 실시간으로 동기화했습니다.
                                </p>
                            </div>
                            <div class="flex-[2] rounded-3xl overflow-hidden shadow-2xl border border-gray-200 transform hover:scale-[1.02] transition-transform duration-500 cursor-pointer"
                                onclick="openLightbox('${pageContext.request.contextPath}/resources/presentation/img/github_board.png')">
                                <img src="${pageContext.request.contextPath}/resources/presentation/img/github_board.png"
                                    alt="GitHub Project Board" class="w-full h-auto">
                            </div>
                        </div>

                        <!-- Part 2: Table View & Labels -->
                        <div class="flex flex-col md:flex-row-reverse items-center gap-12 reveal-card">
                            <div class="flex-1 space-y-6">
                                <div
                                    class="inline-flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-full text-sm font-bold">
                                    <i data-lucide="table" class="w-4 h-4"></i>
                                    Structured Issues
                                </div>
                                <h3 class="text-3xl font-bold text-gray-900">체계적인 이슈 트래킹</h3>
                                <p class="text-gray-500 leading-relaxed text-lg">
                                    P0(Critical), P1(High) 등 우선순위 라벨링과 [FEAT], [FIX] 헤더 규칙을 통해
                                    개발의 방향성을 명확히 했습니다. PR과 이슈를 연동하여 코드 변경 사항을 히스토리로 남겼습니다.
                                </p>
                            </div>
                            <div class="flex-[2] rounded-3xl overflow-hidden shadow-2xl border border-gray-200 transform hover:scale-[1.02] transition-transform duration-500 cursor-pointer"
                                onclick="openLightbox('${pageContext.request.contextPath}/resources/presentation/img/github_table.png')">
                                <img src="${pageContext.request.contextPath}/resources/presentation/img/github_table.png"
                                    alt="GitHub Issue Table" class="w-full h-auto">
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- TROUBLESHOOTING Section -->
            <section class="py-32 bg-white">
                <div class="max-w-6xl mx-auto px-6">
                    <h2 class="text-4xl font-bold mb-16 reveal-text border-l-4 border-red-500 pl-6">Troubleshooting
                        Challenges</h2>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
                        <!-- N+1 -->
                        <div class="bento-box p-10 reveal-card border border-gray-100 rounded-3xl shadow-sm bg-white hover:shadow-xl transition-all cursor-pointer group"
                            onclick="openDiffModal('n1')">
                            <div class="flex items-center justify-between mb-6">
                                <div class="flex items-center gap-4">
                                    <div
                                        class="p-3 bg-red-100 text-red-600 rounded-xl group-hover:bg-red-600 group-hover:text-white transition-colors">
                                        <i data-lucide="database" class="w-6 h-6"></i>
                                    </div>
                                    <h3 class="text-2xl font-bold group-hover:text-blue-600 transition-colors">N+1
                                        Problem</h3>
                                </div>
                                <i data-lucide="arrow-right-circle"
                                    class="w-6 h-6 text-gray-300 group-hover:text-blue-500 transition-colors"></i>
                            </div>
                            <div class="space-y-6">
                                <div>
                                    <p class="text-sm font-bold text-gray-400 mb-1">ISSUE</p>
                                    <p class="text-gray-700">판매글 목록 조회 시, 각 책의 썸네일 이미지를 위해 N번의 추가 쿼리 발생</p>
                                </div>
                                <div class="pointer-events-none">
                                    <p class="text-sm font-bold text-blue-500 mb-1">SOLUTION</p>
                                    <p class="text-gray-700 mb-4">MyBatis <code>&lt;foreach&gt;</code>를 활용한 <strong>IN
                                            Query</strong> 최적화</p>
                                    <div class="code-window">
                                        <div class="p-3 text-xs bg-[#1e1e1e] text-green-400 font-mono">
                                            SELECT ... WHERE trade_seq IN (1, 2, ..., 20)
                                        </div>
                                    </div>
                                </div>
                                <div
                                    class="inline-flex items-center gap-2 text-sm font-bold text-green-600 bg-green-50 px-4 py-2 rounded-lg">
                                    <i data-lucide="arrow-down" class="w-4 h-4"></i>
                                    Query Count: 21 → 2
                                </div>
                            </div>
                        </div>

                        <!-- Concurrency -->
                        <div class="bento-box p-10 reveal-card border border-gray-100 rounded-3xl shadow-sm bg-white hover:shadow-xl transition-all cursor-pointer group"
                            style="transition-delay: 100ms;" onclick="openDiffModal('concurrency')">
                            <div class="flex items-center justify-between mb-6">
                                <div class="flex items-center gap-4">
                                    <div
                                        class="p-3 bg-orange-100 text-orange-600 rounded-xl group-hover:bg-orange-500 group-hover:text-white transition-colors">
                                        <i data-lucide="lock" class="w-6 h-6"></i>
                                    </div>
                                    <h3 class="text-2xl font-bold group-hover:text-blue-600 transition-colors">
                                        Concurrency Control</h3>
                                </div>
                                <i data-lucide="arrow-right-circle"
                                    class="w-6 h-6 text-gray-300 group-hover:text-blue-500 transition-colors"></i>
                            </div>
                            <div class="space-y-6">
                                <div>
                                    <p class="text-sm font-bold text-gray-400 mb-1">ISSUE</p>
                                    <p class="text-gray-700">인기 독서모임(잔여 1석)에 0.01초 차이로 2명 동시 가입 시도 시 정원 초과</p>
                                </div>
                                <div class="pointer-events-none">
                                    <p class="text-sm font-bold text-blue-500 mb-1">SOLUTION</p>
                                    <p class="text-gray-700 mb-4">PostgreSQL <strong>Pessimistic Lock</strong> 적용</p>
                                    <div class="code-window">
                                        <div class="p-3 text-xs bg-[#1e1e1e] text-yellow-400 font-mono">
                                            SELECT ... FOR UPDATE
                                        </div>
                                    </div>
                                </div>
                                <div
                                    class="inline-flex items-center gap-2 text-sm font-bold text-green-600 bg-green-50 px-4 py-2 rounded-lg">
                                    <i data-lucide="check" class="w-4 h-4"></i>
                                    Data Integrity 100%
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Expanded Usage & Infrastructure Section -->
            <section class="py-32 bg-gray-50">
                <div class="max-w-6xl mx-auto px-6">
                    <h2 class="text-4xl font-bold mb-16 reveal-text">Infrastructure & Reliability</h2>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 auto-rows-fr">

                        <!-- DevOps -->
                        <div class="bento-box md:col-span-2 p-8 reveal-card flex flex-col justify-between">
                            <div>
                                <div
                                    class="w-12 h-12 bg-gray-900 text-white rounded-2xl flex items-center justify-center mb-6">
                                    <i data-lucide="git-merge" class="w-6 h-6"></i>
                                </div>
                                <h3 class="text-2xl font-bold mb-2">Automated CI/CD</h3>
                                <p class="text-gray-500 leading-relaxed mb-6">
                                    GitHub Actions와 AWS CodeDeploy로 배포 자동화를 구축했습니다. 개발자는 코드 작성에만 집중할 수 있으며,
                                    <code>start_server.sh</code> 스크립트를 통해 무중단 배포를 지향합니다.
                                </p>
                            </div>
                            <div class="p-4 bg-gray-100 rounded-xl text-sm font-mono text-gray-600">
                                git push origin main -> Build -> Deploy to EC2
                            </div>
                        </div>

                        <!-- Security -->
                        <div class="bento-box p-8 reveal-card border border-green-100 bg-green-50/50">
                            <div
                                class="w-12 h-12 bg-green-100 text-green-600 rounded-2xl flex items-center justify-center mb-6">
                                <i data-lucide="lock" class="w-6 h-6"></i>
                            </div>
                            <h3 class="text-xl font-bold mb-3">Strong Security</h3>
                            <ul class="space-y-3 text-sm text-gray-600">
                                <li class="flex items-center gap-2"><i data-lucide="check" class="w-4 h-4"></i>
                                <li class="flex items-center gap-2"><i data-lucide="check" class="w-4 h-4"></i>
                                    <strong>BCrypt</strong> 비밀번호 암호화
                                </li>
                                <li class="flex items-center gap-2"><i data-lucide="check" class="w-4 h-4"></i>
                                    <strong>XSS</strong> 방지 필터 적용
                                </li>
                                <li class="flex items-center gap-2"><i data-lucide="check" class="w-4 h-4"></i>
                                    <strong>CSRF</strong> 토큰 검증
                                </li>
                            </ul>
                        </div>

                        <!-- AWS S3 -->
                        <div class="bento-box p-8 reveal-card">
                            <div
                                class="w-12 h-12 bg-orange-50 text-orange-600 rounded-2xl flex items-center justify-center mb-6">
                                <i data-lucide="cloud" class="w-6 h-6"></i>
                            </div>
                            <h3 class="text-xl font-bold mb-3">AWS S3 Storage</h3>
                            <p class="text-gray-500 text-sm leading-relaxed">
                                이미지 파일은 DB가 아닌 S3에 저장하여 웹 서버 부하를 줄이고 확장성을 확보했습니다. 트랜잭션 롤백 시 S3 이미지를 정리하는 로직도 포함되어 있습니다.
                            </p>
                        </div>

                        <!-- Scheduler -->
                        <div class="bento-box md:col-span-2 p-8 reveal-card bg-[#111] text-white">
                            <div class="flex items-start justify-between">
                                <div>
                                    <div
                                        class="w-12 h-12 bg-white/20 rounded-2xl flex items-center justify-center mb-6">
                                        <i data-lucide="clock" class="w-6 h-6 text-white"></i>
                                    </div>
                                    <h3 class="text-2xl font-bold mb-2">Background Scheduler</h3>
                                    <p class="text-gray-400 text-sm leading-relaxed mb-4 max-w-lg">
                                        시스템 신뢰성을 위해 24시간 작동하는 스케줄러를 구현했습니다.
                                    </p>
                                </div>
                                <div class="text-right">
                                    <div class="text-xs font-mono text-gray-500 mb-1">TASK MONITOR</div>
                                    <div class="text-green-400 font-bold animate-pulse">RUNNING</div>
                                </div>
                            </div>
                            <div class="grid grid-cols-2 gap-4 mt-4">
                                <div class="p-3 bg-white/10 rounded-lg">
                                    <div class="text-xs text-gray-400 mb-1">Every 1 min</div>
                                    <div class="font-bold text-sm">Expired Pay Cleanup</div>
                                </div>
                                <div class="p-3 bg-white/10 rounded-lg">
                                    <div class="text-xs text-gray-400 mb-1">Daily 00:00</div>
                                    <div class="font-bold text-sm">Auto Purchase Confirm</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- QA Reports Section (Separated) -->
            <section class="py-32 bg-gray-50 border-t border-gray-200">
                <div class="max-w-7xl mx-auto px-6">
                    <h2 class="text-4xl font-bold mb-16 text-center reveal-text">Quality Assurance</h2>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
                        <!-- Functional Test -->
                        <div class="cursor-pointer reveal-card group"
                            onclick="openLightbox('${pageContext.request.contextPath}/resources/presentation/img/excel_test_func.jpg')">
                            <div class="overflow-hidden rounded-2xl shadow-xl border border-gray-200 bg-white">
                                <img src="${pageContext.request.contextPath}/resources/presentation/img/excel_test_func.jpg"
                                    alt="Functional Test Report"
                                    class="w-full h-64 object-cover object-top transform group-hover:scale-105 transition-transform duration-500">
                                <div class="p-6">
                                    <h3 class="text-xl font-bold mb-2">기능 테스트 리포트</h3>
                                    <p class="text-gray-500 text-sm">기능별 성공/실패 내역과 해결 방안을 엑셀로 상세히 관리했습니다.</p>
                                </div>
                            </div>
                        </div>

                        <!-- UI/UX Test -->
                        <div class="cursor-pointer reveal-card group"
                            onclick="openLightbox('${pageContext.request.contextPath}/resources/presentation/img/excel_test_uiux.jpg')"
                            style="transition-delay: 100ms;">
                            <div class="overflow-hidden rounded-2xl shadow-xl border border-gray-200 bg-white">
                                <img src="${pageContext.request.contextPath}/resources/presentation/img/excel_test_uiux.jpg"
                                    alt="UI/UX Test Report"
                                    class="w-full h-64 object-cover object-top transform group-hover:scale-105 transition-transform duration-500">
                                <div class="p-6">
                                    <h3 class="text-xl font-bold mb-2">UI/UX 개선 내역</h3>
                                    <p class="text-gray-500 text-sm">사용자 피드백을 반영한 화면 개선 사항을 기록하고 추적했습니다.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Query Optimization Section -->
            <section class="py-32 bg-white">
                <div class="max-w-7xl mx-auto px-6">
                    <h3 class="text-2xl font-bold mb-8 pl-4 border-l-4 border-green-500">Query Optimization Data
                    </h3>
                    <div class="overflow-x-auto rounded-2xl shadow-xl border border-gray-200">
                        <table class="w-full text-sm text-left bg-white">
                            <thead class="text-xs text-gray-500 uppercase bg-gray-100 border-b">
                                <tr>
                                    <th class="px-6 py-4 font-bold">기능명</th>
                                    <th class="px-6 py-4 font-bold">Mapper ID</th>
                                    <th class="px-6 py-4 font-bold">기존 성능 (ms)</th>
                                    <th class="px-6 py-4 font-bold">개선 성능 (ms)</th>
                                    <th class="px-6 py-4 font-bold text-center">Efficiency</th>
                                    <th class="px-6 py-4 font-bold">Improvement Key</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-100">
                                <!-- Row 1: Main Page -->
                                <tr class="hover:bg-blue-50/50 transition-colors cursor-pointer"
                                    onclick="openDiffModal('main')">
                                    <td class="px-6 py-4 font-bold text-gray-900">메인 페이지 조회</td>
                                    <td class="px-6 py-4 font-mono text-xs text-gray-500">findAllWithPaging</td>
                                    <td class="px-6 py-4 text-red-500 font-medium">150.4</td>
                                    <td class="px-6 py-4 text-blue-600 font-bold">128.4</td>
                                    <td class="px-6 py-4 text-center">
                                        <span
                                            class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                            +14.6%
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 text-gray-500">서브쿼리 제거 (SELECT COUNT -> LEFT JOIN)</td>
                                </tr>

                                <!-- Row 3: Purchase History -->
                                <tr class="hover:bg-blue-50/50 transition-colors cursor-pointer"
                                    onclick="openDiffModal('purchase')">
                                    <td class="px-6 py-4 font-bold text-gray-900">구매내역 조회</td>
                                    <td class="px-6 py-4 font-mono text-xs text-gray-500">selectPurchase...</td>
                                    <td class="px-6 py-4 text-red-500 font-medium">4,885.0</td>
                                    <td class="px-6 py-4 text-blue-600 font-bold">355.0</td>
                                    <td class="px-6 py-4 text-center">
                                        <span
                                            class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                            +1376%
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 text-gray-500">N번 호출 → IN 절 단일 호출 (Bulk Select)</td>
                                </tr>

                                <!-- Row 4: Chat Room -->
                                <tr class="hover:bg-blue-50/50 transition-colors cursor-pointer"
                                    onclick="openDiffModal('chat')">
                                    <td class="px-6 py-4 font-bold text-gray-900">채팅방 목록</td>
                                    <td class="px-6 py-4 font-mono text-xs text-gray-500">findAllByMember...</td>
                                    <td class="px-6 py-4 text-red-500 font-medium">143.0</td>
                                    <td class="px-6 py-4 text-blue-600 font-bold">140.3</td>
                                    <td class="px-6 py-4 text-center">
                                        <span
                                            class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                            -
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 text-gray-500">닉네임 서브쿼리 → JOIN, EXISTS → GroupBy</td>
                                </tr>

                                <!-- Row 5: Payment Entry -->
                                <tr class="hover:bg-blue-50/50 transition-colors cursor-pointer"
                                    onclick="openDiffModal('payment')">
                                    <td class="px-6 py-4 font-bold text-gray-900">결제창 진입</td>
                                    <td class="px-6 py-4 font-mono text-xs text-gray-500">getPaymentCheckInfo</td>
                                    <td class="px-6 py-4 text-red-500 font-medium">168.0</td>
                                    <td class="px-6 py-4 text-blue-600 font-bold">132.0</td>
                                    <td class="px-6 py-4 text-center">
                                        <span
                                            class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                            +21%
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 text-gray-500">3회 Select → 1회 통합 조회</td>
                                </tr>

                                <!-- Row 6: Redis -->
                                <tr class="hover:bg-blue-50/50 transition-colors bg-purple-50/30 cursor-pointer"
                                    onclick="openDiffModal('redis')">
                                    <td class="px-6 py-4 font-bold text-gray-900">메인(Redis)</td>
                                    <td class="px-6 py-4 font-mono text-xs text-gray-500">Cacheable</td>
                                    <td class="px-6 py-4 text-red-500 font-medium">111.0</td>
                                    <td class="px-6 py-4 text-blue-600 font-bold">62.0</td>
                                    <td class="px-6 py-4 text-center">
                                        <span
                                            class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                            +44%
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 text-gray-500">Local Cache (Redis Look-aside)</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                </div>
            </section>

            <!-- Responsive Holo Lightbox (Inline Implementation) -->
            <!-- Simple Fullscreen Lightbox -->
            <div id="simpleLightbox"
                class="fixed inset-0 z-[99999] hidden flex items-center justify-center bg-black/95 transition-opacity duration-300 opacity-0"
                onclick="closeLightbox()">
                <button onclick="closeLightbox()"
                    class="absolute top-6 right-8 text-white/50 hover:text-white transition-colors z-[100000]">
                    <i data-lucide="x" class="w-12 h-12"></i>
                </button>
                <div class="relative w-full h-full p-4 flex items-center justify-center">
                    <img id="lightboxImg" src="" alt="Full Screen View"
                        class="max-w-full max-h-full object-contain shadow-2xl select-none">
                </div>
            </div>

            <!-- Code Diff Modal -->
            <div id="diffModal"
                class="fixed inset-0 z-[99990] hidden flex items-center justify-center bg-black/60 backdrop-blur-sm transition-opacity duration-300 opacity-0"
                onclick="closeDiffModal(event)">
                <div class="bg-[#1e1e1e] w-[90vw] max-w-6xl rounded-2xl shadow-2xl overflow-hidden transform transition-all duration-300 scale-95 opacity-0 flex flex-col max-h-[90vh]"
                    id="diffModalContent">

                    <!-- Header -->
                    <div class="flex items-center justify-between px-6 py-4 border-b border-gray-800 bg-[#252526]">
                        <div class="flex items-center gap-4">
                            <h3 class="text-white font-bold text-lg flex items-center gap-2">
                                <i data-lucide="git-compare" class="w-5 h-5 text-blue-400"></i>
                                Code Optimization Diff
                            </h3>
                            <span id="diffTitle"
                                class="px-3 py-1 bg-gray-700 text-gray-300 text-xs rounded-full font-mono"></span>
                        </div>
                        <button onclick="closeDiffModal()" class="text-gray-400 hover:text-white transition-colors">
                            <i data-lucide="x" class="w-6 h-6"></i>
                        </button>
                    </div>

                    <!-- Diff Content -->
                    <div
                        class="flex-1 overflow-auto p-0 grid grid-cols-1 md:grid-cols-2 divide-y md:divide-y-0 md:divide-x divide-gray-800">

                        <!-- Legacy Code -->
                        <div class="flex flex-col">
                            <div
                                class="px-4 py-2 bg-[#2d2d2d] border-b border-gray-800 flex justify-between items-center sticky top-0">
                                <span class="text-red-400 text-xs font-bold uppercase tracking-wider">Before
                                    (Legacy)</span>
                                <span class="text-gray-500 text-xs font-mono" id="legacyTime"></span>
                            </div>
                            <pre
                                class="p-6 text-sm font-mono text-gray-300 overflow-x-auto bg-[#1e1e1e] leading-relaxed"><code id="legacyCode"></code></pre>
                        </div>

                        <!-- Optimized Code -->
                        <div class="flex flex-col">
                            <div
                                class="px-4 py-2 bg-[#2d2d32] border-b border-gray-800 flex justify-between items-center sticky top-0">
                                <span class="text-green-400 text-xs font-bold uppercase tracking-wider">After
                                    (Optimized)</span>
                                <span class="text-gray-500 text-xs font-mono" id="optimizedTime"></span>
                            </div>
                            <pre
                                class="p-6 text-sm font-mono text-gray-300 overflow-x-auto bg-[#1e1e1e] leading-relaxed"><code id="optimizedCode"></code></pre>
                        </div>
                    </div>

                    <!-- Footer hint -->
                    <div class="px-6 py-3 bg-[#252526] border-t border-gray-800 text-right">
                        <span class="text-xs text-gray-500">Press ESC to close</span>
                    </div>
                </div>
            </div>

            <script>
                // Simple Lightbox Logic
                const sLightbox = document.getElementById('simpleLightbox');
                const sLbImg = document.getElementById('lightboxImg');

                window.openLightbox = function (src) {
                    sLbImg.src = src;
                    sLightbox.classList.remove('hidden');
                    void sLightbox.offsetWidth;
                    sLightbox.classList.remove('opacity-0');
                    document.body.style.overflow = 'hidden';
                };

                window.closeLightbox = function () {
                    sLightbox.classList.add('opacity-0');
                    setTimeout(() => {
                        sLightbox.classList.add('hidden');
                        sLbImg.src = '';
                        document.body.style.overflow = '';
                    }, 300);
                };

                // Diff Modal Logic
                const diffModal = document.getElementById('diffModal');
                const diffModalContent = document.getElementById('diffModalContent');

                const diffData = {
                    'main': {
                        title: 'Main Page List Query',
                        legacyTime: '150.4ms',
                        optimizedTime: '128.4ms',
                        legacy: `SELECT b.*,
                            (SELECT count(*)
                             FROM review r
                             WHERE r.book_id = b.id) as r_cnt
                     FROM book b
                     ORDER BY b.id DESC
                         LIMIT 20 OFFSET 0`,
                        optimized: `SELECT b.*, count(r.id) as r_cnt
                        FROM book b
                                 LEFT JOIN review r
                                           ON b.id = r.book_id
                        GROUP BY b.id
                        ORDER BY b.id DESC
                            LIMIT 20 OFFSET 0`
                    },
                    'purchase': {
                        title: 'Purchase History N+1',
                        legacyTime: '4,885ms',
                        optimizedTime: '355ms',
                        legacy: `// Service Layer (N+1 Problem)
List<Trade> trades = mapper.findAll(userId);

for(Trade t : trades) {
    // Queries DB loop times (blocking)
    Image thumb = 
      imgMapper.findById(t.getId());
    t.setThumbnail(thumb);
}`,
                        optimized: `// Service Layer (Bulk Select)
List<Trade> trades = mapper.findAll(userId);
List<Long> ids = trades.map(Trade::getId);

// Single Query with IN Clause
List<Image> images = 
  imgMapper.findAllByIds(ids);

matchImagesToTrades(trades, images);`
                    },
                    'chat': {
                        title: 'Chat Room List',
                        legacyTime: '143.0ms',
                        optimizedTime: '140.3ms',
                        legacy: `SELECT c.*,
                            (SELECT nick FROM member m
                             WHERE m.id = c.partner_id) as nick
                     FROM chat_room c
                     WHERE c.owner_id = ?`,
                        optimized: `SELECT c.*, m.nick
                        FROM chat_room c
                                 INNER JOIN member m
                                            ON c.partner_id = m.id
                        WHERE c.owner_id = ?
-- Converted Subquery to Join`
                    },
                    'payment': {
                        title: 'Payment Page Entry',
                        legacyTime: '168.0ms',
                        optimizedTime: '132.0ms',
                        legacy: `// Controller
User u = userMapper.findById(uid);
Book b = bookMapper.findById(bid);
Addr a = addrMapper.findByUser(uid);

// 3 Separate Round-trips to DB`,
                        optimized: `<select id="getPaymentCheckInfo">
  SELECT *
  FROM book b
  JOIN users u ON u.id = \u0023{uid}
  LEFT JOIN address a 
    ON a.user_id = u.id
  WHERE b.id = \u0023{bid}
</select>
<!-- Single Round-trip -->`
                    },
                    'redis': {
                        title: 'Main Page Caching',
                        legacyTime: '111.0ms',
                        optimizedTime: '62.0ms',
                        legacy: `public List<Book> getMainBooks() {
    // Always hits Database
    return bookRepo.findAllDesc(); 
}`,
                        optimized: `@Cacheable(value = "mainBooks")
public List<Book> getMainBooks() {
    // Hits Redis first (Look-aside)
    // Only hits DB on cache miss
    return bookRepo.findAllDesc();
}`
                    },
                    'n1': {
                        title: 'N+1 Problem: Thumbnails',
                        legacyTime: '21 Queries',
                        optimizedTime: '2 Queries',
                        legacy: `// Service Layer (N+1 Issue)
List<Trade> trades = mapper.findAll();
for (Trade t : trades) {
    // Executes 1 query PER iteration
    // Total 20+1 queries responsible for heavy load
    Image img = imgMapper.findByTradeId(t.getId()); 
    t.setThumbnail(img);
}`,
                        optimized: `<!-- MyBatis Mapper (Optimization) -->
<select id="findAllImagesByTradeIds">
    SELECT * FROM trade_image
    WHERE trade_id IN
    <foreach item="id" collection="list" 
             open="(" separator="," close=")">
        \u0023{id}
    </foreach>
</select>
<!-- Single query utilizing IN clause -->`
                    },
                    'concurrency': {
                        title: 'Concurrency Assurance (Lock)',
                        legacyTime: 'Overbooking',
                        optimizedTime: 'Safe',
                        legacy: `// Service Layer (Race Condition)
@Transactional
public void joinClub(Long clubId, User user) {
    Club club = mapper.findById(clubId); 
    // If 2 users read same 'currentCount' here...
    if (club.getCurrentCount() < club.getMaxCount()) {
        mapper.insertMember(clubId, user.getId());
        mapper.incrementCount(clubId);
    }
}
// Result: 5/5 capacity becomes 6/5`,
                        optimized: `<!-- PostgreSQL: Pessimistic Lock -->
<select id="findByIdForUpdate" resultType="Club">
    SELECT * FROM club 
    WHERE id = \u0023{id} 
    FOR UPDATE
</select> 
<!-- Locks row until transaction commit.
Other transactions wait here. -->`
                    }
                };

                window.openDiffModal = function (key) {
                    const data = diffData[key];
                    if (!data) return;

                    document.getElementById('diffTitle').innerText = data.title;
                    document.getElementById('legacyTime').innerText = data.legacyTime;
                    document.getElementById('optimizedTime').innerText = data.optimizedTime;
                    document.getElementById('legacyCode').innerText = data.legacy;
                    document.getElementById('optimizedCode').innerText = data.optimized;

                    diffModal.classList.remove('hidden');
                    // Force reflow
                    void diffModal.offsetWidth;
                    diffModal.classList.remove('opacity-0');
                    diffModalContent.classList.remove('scale-95', 'opacity-0');
                    diffModalContent.classList.add('scale-100', 'opacity-100');

                    document.body.style.overflow = 'hidden';

                    if (window.lucide) lucide.createIcons();
                };

                window.closeDiffModal = function (e) {
                    if (e && e.target !== diffModal && !e.target.closest('button')) return;

                    diffModal.classList.add('opacity-0');
                    diffModalContent.classList.remove('scale-100', 'opacity-100');
                    diffModalContent.classList.add('scale-95', 'opacity-0');

                    setTimeout(() => {
                        diffModal.classList.add('hidden');
                        document.body.style.overflow = '';
                    }, 300);
                };

                document.addEventListener('keydown', function (e) {
                    if (e.key === "Escape") {
                        closeLightbox();
                        closeDiffModal();
                    }
                });
            </script>
            <style>
                /* CSS for 3D perspective and spotlight overlay */
                .interactive-card {
                    position: relative;
                    transform-style: preserve-3d;
                    transition: transform 0.2s ease-out;
                }

                .spotlight-overlay {
                    position: absolute;
                    inset: 0;
                    background: radial-gradient(circle at var(--mouse-x) var(--mouse-y), rgba(255, 255, 255, 0.15) 0%, transparent 80%);
                    opacity: 0;
                    transition: opacity 0.3s ease;
                    pointer-events: none;
                    border-radius: inherit;
                    /* Inherit border-radius from parent */
                }

                .interactive-card:hover .spotlight-overlay {
                    opacity: 1;
                }

                /* Hero Float Animation */
                .hero-floater {
                    animation: float 3s ease-in-out infinite;
                }

                @keyframes float {
                    0% {
                        transform: translateY(0) rotate(3deg);
                    }

                    50% {
                        transform: translateY(-10px) rotate(3deg);
                    }

                    100% {
                        transform: translateY(0) rotate(3deg);
                    }
                }

                /* Hero Text Glass Panel */
                .hero-glass-panel {
                    background: rgba(255, 255, 255, 0.4);
                    backdrop-filter: blur(8px);
                    -webkit-backdrop-filter: blur(8px);
                    padding: 3rem;
                    border-radius: 2rem;
                    border: 1px solid rgba(255, 255, 255, 0.5);
                    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.05);
                }
            </style>
            <!-- Hero Section with Spline 3D Background -->
            <section class="h-screen flex flex-col justify-center items-center text-center relative overflow-hidden">

                <!-- Spline 3D Iframe Background -->
                <!-- Spline 3D Background (Glassmorph Landing Page) -->
                <div class="absolute inset-0 z-0">
                    <iframe src='https://my.spline.design/glassmorphlandingpage-90h3MsIfBV9EbtGXOm6Tt8iP/'
                        frameborder='0' width='100%' height='100%' class="w-full h-full scale-105"></iframe>
                    <!-- Light Overlay for Glass Effect -->
                    <div class="absolute inset-0 bg-white/30 backdrop-blur-[2px] pointer-events-none"></div>
                </div>

                <div class="mb-8 reveal-text relative z-10">
                    <div
                        class="hero-floater relative w-24 h-24 bg-blue-600 rounded-[2rem] flex items-center justify-center mx-auto shadow-2xl mb-8 transform rotate-3 z-10">
                        <span class="text-white font-black text-4xl drop-shadow-lg">S</span>
                        <div class="absolute inset-0 bg-white opacity-20 rounded-[2rem] blur-sm -z-10"></div>
                    </div>
                    <h2 class="text-5xl md:text-7xl font-black mb-8 tracking-tight text-gray-900">
                        Your Book's Second Life.
                    </h2>
                    <p class="text-xl text-gray-500 mb-12 max-w-2xl mx-auto">
                        기술적 고민을 통해, 책과 사람을 잇는 가장 안전하고 따뜻한 방법을 만들었습니다.
                    </p>
                    <a href="/home"
                        class="group inline-flex items-center gap-3 bg-gray-900 text-white px-10 py-5 rounded-full font-bold text-lg hover:bg-black transition-all shadow-xl hover:shadow-2xl hover:-translate-y-1">
                        서비스 시연 시작하기
                        <i data-lucide="arrow-right" class="w-5 h-5 group-hover:translate-x-1 transition-transform"></i>
                    </a>
                </div>

                <footer class="absolute bottom-8 text-sm text-gray-400">
                    &copy; 2026 SecondHand Books Team. All rights reserved.
                </footer>
            </section>

            <script>
                if (typeof lucide !== 'undefined') lucide.createIcons();

                const observerOptions = {
                    root: null,
                    rootMargin: '0px',
                    threshold: 0.1
                };

                const observer = new IntersectionObserver((entries, observer) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('active');
                            observer.unobserve(entry.target);
                        }
                    });
                }, observerOptions);

                document.querySelectorAll('.reveal-text, .reveal-card, .reveal-image').forEach(el => {
                    observer.observe(el);
                });

                /* --- INTERACTIVE 3D ENGINE --- */
                class InteractiveManager {
                    constructor() {
                        // Apply to Bento Boxes and Deep Dive Cards
                        this.targets = document.querySelectorAll('.bento-box, .reveal-card > div');
                        this.init();
                        this.initCursor();
                    }

                    init() {
                        this.targets.forEach(card => {
                            if (!card.classList.contains('interactive-card')) {
                                card.classList.add('interactive-card');

                                // Spotlight Container
                                const spotlight = document.createElement('div');
                                spotlight.classList.add('spotlight-overlay');
                                card.appendChild(spotlight);

                                card.addEventListener('mousemove', (e) => this.handleTilt(e, card));
                                card.addEventListener('mouseleave', () => this.resetTilt(card));
                            }
                        });
                    }

                    handleTilt(e, card) {
                        const rect = card.getBoundingClientRect();
                        const x = e.clientX - rect.left;
                        const y = e.clientY - rect.top;

                        // Set CSS Vars for Spotlight
                        card.style.setProperty('--mouse-x', `${x}px`);
                        card.style.setProperty('--mouse-y', `${y}px`);

                        // Calculate Tilt
                        const centerX = rect.width / 2;
                        const centerY = rect.height / 2;
                        const rotateX = ((y - centerY) / centerY) * -8; // Max 8deg
                        const rotateY = ((x - centerX) / centerX) * 8;

                        card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale3d(1.02, 1.02, 1.02)`;
                    }

                    resetTilt(card) {
                        card.style.transform = 'perspective(1000px) rotateX(0) rotateY(0) scale3d(1, 1, 1)';
                    }

                    initCursor() {
                        const cursor = document.createElement('div');
                        cursor.classList.add('cursor-glow');
                        document.body.appendChild(cursor);

                        document.addEventListener('mousemove', (e) => {
                            cursor.style.left = e.clientX + 'px';
                            cursor.style.top = e.clientY + 'px';
                        });
                    }
                }

                // Initialize after DOM load
                document.addEventListener('DOMContentLoaded', () => {
                    new InteractiveManager();
                });
            </script>
        </body>

        </html>