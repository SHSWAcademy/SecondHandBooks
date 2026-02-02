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

                /* Bento Grid Box Style */
                .bento-box {
                    background: #fff;
                    border-radius: 24px;
                    box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
                    border: 1px solid rgba(0, 0, 0, 0.05);
                    transition: transform 0.3s ease, box-shadow 0.3s ease;
                    overflow: hidden;
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
                    background: #27c93f;
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

            <section class="py-32 bg-white border-y border-gray-100">
                <div class="max-w-6xl mx-auto px-6 text-center">
                    <h2 class="text-4xl font-bold mb-4 reveal-text">We made this.</h2>
                    <p class="text-gray-500 mb-20 reveal-text">열정적인 6명의 팀원을 소개합니다.</p>

                    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-8">
                        <div class="reveal-card" style="transition-delay: 0ms;">
                            <div
                                class="w-24 h-24 rounded-full bg-gradient-to-br from-gray-100 to-gray-200 mx-auto mb-4 flex items-center justify-center text-2xl font-black text-gray-400 shadow-inner">
                                K</div>
                            <h3 class="font-bold text-lg text-gray-900">김규태</h3>
                            <p class="text-xs text-blue-600 font-bold mt-1">Team Leader</p>
                            <p class="text-xs text-gray-400 mt-1">Auth / Admin / MyPage</p>
                        </div>
                        <div class="reveal-card" style="transition-delay: 100ms;">
                            <div
                                class="w-24 h-24 rounded-full bg-gradient-to-br from-gray-100 to-gray-200 mx-auto mb-4 flex items-center justify-center text-2xl font-black text-gray-400 shadow-inner">
                                L</div>
                            <h3 class="font-bold text-lg text-gray-900">이승환</h3>
                            <p class="text-xs text-blue-600 font-bold mt-1">Backend</p>
                            <p class="text-xs text-gray-400 mt-1">Auth / Admin / MyPage</p>
                        </div>
                        <div class="reveal-card" style="transition-delay: 200ms;">
                            <div
                                class="w-24 h-24 rounded-full bg-gradient-to-br from-gray-100 to-gray-200 mx-auto mb-4 flex items-center justify-center text-2xl font-black text-gray-400 shadow-inner">
                                C</div>
                            <h3 class="font-bold text-lg text-gray-900">최범근</h3>
                            <p class="text-xs text-blue-600 font-bold mt-1">Full Stack</p>
                            <p class="text-xs text-gray-400 mt-1">Main / Pay / Chat</p>
                        </div>
                        <div class="reveal-card" style="transition-delay: 300ms;">
                            <div
                                class="w-24 h-24 rounded-full bg-gradient-to-br from-gray-100 to-gray-200 mx-auto mb-4 flex items-center justify-center text-2xl font-black text-gray-400 shadow-inner">
                                L</div>
                            <h3 class="font-bold text-lg text-gray-900">이상원</h3>
                            <p class="text-xs text-blue-600 font-bold mt-1">Backend</p>
                            <p class="text-xs text-gray-400 mt-1">Main / Pay / Chat</p>
                        </div>
                        <div class="reveal-card" style="transition-delay: 400ms;">
                            <div
                                class="w-24 h-24 rounded-full bg-gradient-to-br from-gray-100 to-gray-200 mx-auto mb-4 flex items-center justify-center text-2xl font-black text-gray-400 shadow-inner">
                                K</div>
                            <h3 class="font-bold text-lg text-gray-900">김도연</h3>
                            <p class="text-xs text-blue-600 font-bold mt-1">Frontend</p>
                            <p class="text-xs text-gray-400 mt-1">Book Club</p>
                        </div>
                        <div class="reveal-card" style="transition-delay: 500ms;">
                            <div
                                class="w-24 h-24 rounded-full bg-gradient-to-br from-gray-100 to-gray-200 mx-auto mb-4 flex items-center justify-center text-2xl font-black text-gray-400 shadow-inner">
                                L</div>
                            <h3 class="font-bold text-lg text-gray-900">이동희</h3>
                            <p class="text-xs text-blue-600 font-bold mt-1">Frontend</p>
                            <p class="text-xs text-gray-400 mt-1">Book Club</p>
                        </div>
                    </div>
                </div>
            </section>

            <section class="py-32 bg-gray-50">
                <div class="max-w-5xl mx-auto px-6">
                    <h2 class="text-4xl font-bold mb-16 text-center reveal-text">왜 이 프로젝트를 시작했나요?</h2>

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

            <section class="py-32 px-6">
                <div class="max-w-7xl mx-auto">
                    <div class="text-center mb-24 reveal-text">
                        <h2 class="text-5xl font-bold mb-6">Seamless Solution.</h2>
                        <p class="text-xl text-gray-500">우리가 제안하는 새로운 중고 거래 경험</p>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                        <div
                            class="bento-box p-8 md:col-span-2 flex flex-col md:flex-row items-center gap-8 reveal-card">
                            <div class="flex-1">
                                <span class="text-blue-600 font-bold mb-2 block">01. API Integration</span>
                                <h3 class="text-3xl font-bold mb-4">1초 자동 등록</h3>
                                <p class="text-gray-500 leading-relaxed">
                                    ISBN 스캔만으로 Naver/Kakao Book API를 통해 도서 정보를 자동으로 불러옵니다.
                                </p>
                            </div>
                            <div class="flex-1 w-full bg-blue-50 rounded-2xl h-48 flex items-center justify-center">
                                <i data-lucide="scan-barcode" class="w-16 h-16 text-blue-300"></i>
                            </div>
                        </div>

                        <div class="bento-box p-8 bg-gray-900 text-white reveal-card" style="transition-delay: 100ms;">
                            <div class="h-full flex flex-col justify-between">
                                <div>
                                    <span class="text-green-400 font-bold mb-2 block">02. Safe Payment</span>
                                    <h3 class="text-2xl font-bold mb-2">에스크로 결제</h3>
                                    <p class="text-gray-400 text-sm">구매 확정 시까지 대금을 안전하게 보호합니다.</p>
                                </div>
                                <i data-lucide="shield-check" class="w-10 h-10 text-green-400 mt-4"></i>
                            </div>
                        </div>

                        <div class="bento-box p-8 reveal-card" style="transition-delay: 200ms;">
                            <div class="h-full flex flex-col justify-between">
                                <div>
                                    <span class="text-yellow-500 font-bold mb-2 block">03. Community</span>
                                    <h3 class="text-2xl font-bold mb-2">로컬 독서 모임</h3>
                                    <p class="text-gray-500 text-sm">지도 기반으로 내 주변 독서 모임을 탐색합니다.</p>
                                </div>
                                <i data-lucide="map-pin" class="w-10 h-10 text-yellow-500 mt-4"></i>
                            </div>
                        </div>

                        <div class="bento-box p-8 md:col-span-2 flex flex-col md:flex-row-reverse items-center gap-8 reveal-card"
                            style="transition-delay: 300ms;">
                            <div class="flex-1">
                                <span class="text-purple-600 font-bold mb-2 block">04. Real-time Chat</span>
                                <h3 class="text-3xl font-bold mb-4">실시간 채팅</h3>
                                <p class="text-gray-500 leading-relaxed">
                                    WebSocket(STOMP)을 활용하여 지연 없는 대화 환경을 제공합니다.
                                </p>
                            </div>
                            <div class="flex-1 w-full bg-purple-50 rounded-2xl h-48 flex items-center justify-center">
                                <i data-lucide="message-circle" class="w-16 h-16 text-purple-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="py-32 bg-gray-50">
                <div class="max-w-6xl mx-auto px-6">
                    <h2 class="text-4xl font-bold mb-16 reveal-text">Feature Details</h2>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                        <div class="bento-box p-8 reveal-card">
                            <div
                                class="w-12 h-12 bg-indigo-50 text-indigo-600 rounded-2xl flex items-center justify-center mb-6">
                                <i data-lucide="user" class="w-6 h-6"></i>
                            </div>
                            <h3 class="text-xl font-bold mb-3">마이페이지</h3>
                            <ul class="space-y-2 text-sm text-gray-500">
                                <li class="flex items-center gap-2"><i data-lucide="check"
                                        class="w-4 h-4 text-green-500"></i> 구매/판매 내역 통합 관리</li>
                                <li class="flex items-center gap-2"><i data-lucide="check"
                                        class="w-4 h-4 text-green-500"></i> 찜한 상품 목록 확인</li>
                                <li class="flex items-center gap-2"><i data-lucide="check"
                                        class="w-4 h-4 text-green-500"></i> 회원 정보 및 주소록 관리</li>
                            </ul>
                        </div>
                        <div class="bento-box p-8 reveal-card" style="transition-delay: 100ms;">
                            <div
                                class="w-12 h-12 bg-yellow-50 text-yellow-600 rounded-2xl flex items-center justify-center mb-6">
                                <i data-lucide="star" class="w-6 h-6"></i>
                            </div>
                            <h3 class="text-xl font-bold mb-3">신뢰도 시스템</h3>
                            <p class="text-gray-500 text-sm mb-4">거래 완료 후 상호 평가를 통해 유저 신뢰도를 측정합니다.</p>
                            <div class="flex gap-1 text-yellow-400">
                                <i data-lucide="star" class="w-4 h-4 fill-current"></i>
                                <i data-lucide="star" class="w-4 h-4 fill-current"></i>
                                <i data-lucide="star" class="w-4 h-4 fill-current"></i>
                                <i data-lucide="star" class="w-4 h-4 fill-current"></i>
                                <i data-lucide="star" class="w-4 h-4 fill-current"></i>
                            </div>
                        </div>
                        <div class="bento-box p-8 reveal-card" style="transition-delay: 200ms;">
                            <div
                                class="w-12 h-12 bg-gray-800 text-white rounded-2xl flex items-center justify-center mb-6">
                                <i data-lucide="settings" class="w-6 h-6"></i>
                            </div>
                            <h3 class="text-xl font-bold mb-3">관리자 대시보드</h3>
                            <p class="text-gray-500 text-sm">
                                일별 방문자/매출 통계, 신고 접수 처리, 배너 관리 등 서비스 전반을 운영합니다.
                            </p>
                        </div>
                    </div>
                </div>
            </section>

            <section class="py-32 bg-[#111] text-white">
                <div class="max-w-6xl mx-auto px-6">
                    <h2 class="text-4xl font-bold mb-16 reveal-text border-l-4 border-blue-500 pl-6">Core Architecture
                    </h2>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-16">
                        <div class="reveal-text">
                            <div class="mb-6 inline-flex p-3 rounded-2xl bg-gray-800 border border-gray-700">
                                <i data-lucide="server" class="w-8 h-8 text-blue-400"></i>
                            </div>
                            <h3 class="text-2xl font-bold mb-4 text-blue-400">Non-Blocking I/O (WebClient)</h3>
                            <p class="text-gray-400 mb-6 leading-relaxed">
                                기존 <code>RestTemplate</code>의 Blocking 방식은 외부 API 지연 시 스레드 점유 문제를 야기합니다.
                                이를 해결하기 위해 <strong>WebClient</strong>를 도입하여 외부 API(도서, 결제) 통신의 효율성을 극대화했습니다.
                            </p>
                            <div class="code-window">
                                <div class="code-header">
                                    <div class="dot red"></div>
                                    <div class="dot yellow"></div>
                                    <div class="dot green"></div>
                                </div>
                                <div class="p-4 text-xs text-green-400 bg-[#1e1e1e] font-mono">
                                    <pre>
WebClient.create().get()
  .uri(naverApiUrl)
  .retrieve()
  .bodyToMono(String.class)
  .subscribe(); // Async Processing
</pre>
                                </div>
                            </div>
                        </div>

                        <div class="reveal-text" style="transition-delay: 200ms;">
                            <div class="mb-6 inline-flex p-3 rounded-2xl bg-gray-800 border border-gray-700">
                                <i data-lucide="clock" class="w-8 h-8 text-purple-400"></i>
                            </div>
                            <h3 class="text-2xl font-bold mb-4 text-purple-400">Reliability (Scheduler)</h3>
                            <p class="text-gray-400 mb-6 leading-relaxed">
                                <code>SafePaymentScheduler</code>가 백그라운드에서 실행되며 거래 상태의 무결성을 관리합니다.
                                결제 미완료 건 자동 취소(5분), 배송 완료 후 자동 구매 확정(15일) 로직을 수행합니다.
                            </p>
                            <ul class="space-y-3 text-sm text-gray-500">
                                <li class="flex items-center gap-2"><i data-lucide="check"
                                        class="w-4 h-4 text-green-500"></i> 미결제 데이터 자동 정리</li>
                                <li class="flex items-center gap-2"><i data-lucide="check"
                                        class="w-4 h-4 text-green-500"></i> 장기 미확정 거래 자동 정산</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </section>

            <section class="py-32 bg-gray-50">
                <div class="max-w-6xl mx-auto px-6">
                    <h2 class="text-4xl font-bold mb-4 reveal-text">DevOps & Performance</h2>
                    <p class="text-gray-500 mb-16 reveal-text">안정적인 서비스 운영을 위한 인프라 및 성능 최적화 전략</p>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 auto-rows-[380px]">

                        <div
                            class="bento-box md:col-span-2 p-10 reveal-card relative overflow-hidden group border border-gray-200">
                            <div class="relative z-10">
                                <div
                                    class="w-12 h-12 bg-gray-900 text-white rounded-2xl flex items-center justify-center mb-6 shadow-lg">
                                    <i data-lucide="git-merge" class="w-6 h-6"></i>
                                </div>
                                <h3 class="text-2xl font-bold mb-3 text-gray-900">Automated CI/CD Pipeline</h3>
                                <p class="text-gray-500 leading-relaxed mb-8 max-w-lg">
                                    <strong>GitHub Actions</strong>와 <strong>AWS CodeDeploy</strong>를 연동하여 코드 푸시부터 배포까지의
                                    과정을 자동화했습니다.
                                </p>
                                <div
                                    class="flex items-center gap-4 text-sm font-bold text-gray-600 bg-gray-100 p-4 rounded-xl w-fit">
                                    <span class="flex items-center gap-2"><i data-lucide="github" class="w-4 h-4"></i>
                                        Push</span>
                                    <i data-lucide="arrow-right" class="w-4 h-4 text-gray-400"></i>
                                    <span class="flex items-center gap-2"><i data-lucide="package" class="w-4 h-4"></i>
                                        Build (S3)</span>
                                    <i data-lucide="arrow-right" class="w-4 h-4 text-gray-400"></i>
                                    <span class="flex items-center gap-2"><i data-lucide="server" class="w-4 h-4"></i>
                                        Deploy (EC2)</span>
                                </div>
                            </div>
                            <div class="absolute right-[-40px] top-[-40px] opacity-[0.03]">
                                <i data-lucide="settings" class="w-96 h-96"></i>
                            </div>
                        </div>

                        <div
                            class="bento-box p-8 bg-gradient-to-br from-red-500 to-red-600 text-white reveal-card flex flex-col justify-between shadow-lg shadow-red-500/20">
                            <div>
                                <div
                                    class="w-12 h-12 bg-white/20 backdrop-blur-md rounded-2xl flex items-center justify-center mb-4">
                                    <i data-lucide="zap" class="w-6 h-6 text-white"></i>
                                </div>
                                <h3 class="text-xl font-bold mb-2">Redis Caching</h3>
                                <p class="text-white/80 text-sm leading-relaxed">
                                    조회 빈도가 높은 데이터를 <strong>Redis</strong>에 캐싱하여 응답 속도를 <strong>0.5s → 0.02s</strong>로
                                    단축했습니다.
                                </p>
                            </div>
                            <div class="mt-4 p-3 bg-white/10 rounded-lg text-xs font-mono border border-white/20">
                                @Cacheable(value="books")
                            </div>
                        </div>

                        <div class="bento-box p-8 border border-gray-200 reveal-card flex flex-col justify-between">
                            <div>
                                <div
                                    class="w-12 h-12 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center mb-4">
                                    <i data-lucide="database" class="w-6 h-6"></i>
                                </div>
                                <h3 class="text-xl font-bold mb-2">Query Optimization</h3>
                                <p class="text-gray-500 text-sm leading-relaxed">
                                    MyBatis Dynamic SQL 최적화 및 주요 조회 컬럼 인덱싱을 통해 검색 성능을 개선했습니다.
                                </p>
                            </div>
                            <div class="mt-4 flex gap-2">
                                <span
                                    class="px-2 py-1 bg-gray-100 text-gray-500 text-xs rounded font-mono">INDEXING</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="py-32 bg-white">
                <div class="max-w-6xl mx-auto px-6">
                    <h2 class="text-4xl font-bold mb-16 reveal-text">Security & Infrastructure</h2>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                        <div class="bento-box p-8 reveal-card border border-gray-100">
                            <div
                                class="w-12 h-12 bg-orange-50 text-orange-600 rounded-2xl flex items-center justify-center mb-6">
                                <i data-lucide="cloud" class="w-6 h-6"></i>
                            </div>
                            <h3 class="text-xl font-bold mb-3">AWS S3 Image Storage</h3>
                            <p class="text-gray-500 text-sm leading-relaxed">
                                사용자가 업로드한 도서 및 프로필 이미지를 S3 버킷에 안전하게 저장하고 CloudFront로 빠르게 제공합니다.
                            </p>
                        </div>
                        <div class="bento-box p-8 reveal-card border border-gray-100" style="transition-delay: 100ms;">
                            <div
                                class="w-12 h-12 bg-green-50 text-green-600 rounded-2xl flex items-center justify-center mb-6">
                                <i data-lucide="lock" class="w-6 h-6"></i>
                            </div>
                            <h3 class="text-xl font-bold mb-3">Spring Security</h3>
                            <p class="text-gray-500 text-sm leading-relaxed">
                                BCrypt 해싱을 이용한 비밀번호 암호화와 XSS 방지 필터를 적용하여 회원 정보를 보호합니다.
                            </p>
                        </div>
                        <div class="bento-box p-8 reveal-card border border-gray-100" style="transition-delay: 200ms;">
                            <div
                                class="w-12 h-12 bg-purple-50 text-purple-600 rounded-2xl flex items-center justify-center mb-6">
                                <i data-lucide="map" class="w-6 h-6"></i>
                            </div>
                            <h3 class="text-xl font-bold mb-3">Utility API</h3>
                            <p class="text-gray-500 text-sm leading-relaxed">
                                Daum 주소 API, Toss Payments API 등 검증된 외부 서비스를 연동하여 사용 편의성을 높였습니다.
                            </p>
                        </div>
                    </div>
                </div>
            </section>

            <section class="py-32 px-6 bg-gray-50">
                <div class="max-w-4xl mx-auto">
                    <h2 class="text-3xl font-bold mb-12 border-l-4 border-red-500 pl-4 reveal-text">Troubleshooting: 변수
                        스코프 충돌</h2>

                    <div class="bg-white p-8 rounded-3xl shadow-sm border border-gray-200 reveal-card">
                        <div class="mb-8">
                            <h4 class="font-bold text-red-500 mb-2 flex items-center gap-2">
                                <i data-lucide="alert-circle" class="w-5 h-5"></i> Problem
                            </h4>
                            <p class="text-gray-600 text-sm">
                                마이페이지 탭을 AJAX로 동적 로딩할 때, 전역 스코프 변수 재선언으로 인한 <strong>SyntaxError</strong> 발생.
                            </p>
                        </div>

                        <div>
                            <h4 class="font-bold text-green-600 mb-2 flex items-center gap-2">
                                <i data-lucide="check-circle" class="w-5 h-5"></i> Solution
                            </h4>
                            <p class="text-gray-600 text-sm mb-4">
                                <strong>IIFE (즉시 실행 함수)</strong> 패턴과 <strong>Namespace</strong> 객체를 도입하여
                                스크립트의 유효 범위를 격리했습니다.
                            </p>
                            <div class="code-window">
                                <div class="code-header">
                                    <div class="dot red"></div>
                                    <div class="dot yellow"></div>
                                    <div class="dot green"></div>
                                </div>
                                <div class="p-4 text-xs text-gray-300 bg-[#1e1e1e]">
                                    <pre>
<span class="text-gray-500">// IIFE로 스코프 격리</span>
(function() {
    let localState = [];

    const actions = { ... };
    <span class="text-blue-400">window.TabName</span> = actions;
})();
</pre>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section
                class="h-screen flex flex-col justify-center items-center text-center bg-white border-t border-gray-100">
                <div class="mb-8 reveal-text">
                    <div
                        class="w-24 h-24 bg-blue-600 rounded-[2rem] flex items-center justify-center mx-auto shadow-2xl mb-8 transform rotate-3">
                        <span class="text-white font-black text-4xl">S</span>
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
            </script>
        </body>

        </html>