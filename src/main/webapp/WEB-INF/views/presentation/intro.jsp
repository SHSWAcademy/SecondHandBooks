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
            transform: translateY(40px);
            transition: all 1s cubic-bezier(0.165, 0.84, 0.44, 1);
        }
        .reveal-text.active {
            opacity: 1;
            transform: translateY(0);
        }

        /* 스크롤 애니메이션: 카드/이미지 */
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
            box-shadow: 0 4px 24px rgba(0,0,0,0.04);
            border: 1px solid rgba(0,0,0,0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            overflow: hidden;
        }
        .bento-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
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

    <section class="min-h-screen flex flex-col justify-center items-center text-center px-4 relative pt-10">
        <div class="reveal-text">
            <div class="mb-8 inline-block">
                <span class="px-4 py-1.5 bg-blue-50 text-blue-600 rounded-full text-sm font-bold border border-blue-100">Project Presentation</span>
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
                    <div class="w-24 h-24 rounded-full bg-gradient-to-br from-gray-100 to-gray-200 mx-auto mb-4 flex items-center justify-center text-2xl font-black text-gray-400 shadow-inner">K</div>
                    <h3 class="font-bold text-lg text-gray-900">김규태</h3>
                    <p class="text-xs text-blue-600 font-bold mt-1">Team Leader</p>
                    <p class="text-xs text-gray-400 mt-1">Backend Core</p>
                </div>
                <div class="reveal-card" style="transition-delay: 100ms;">
                    <div class="w-24 h-24 rounded-full bg-gradient-to-br from-gray-100 to-gray-200 mx-auto mb-4 flex items-center justify-center text-2xl font-black text-gray-400 shadow-inner">C</div>
                    <h3 class="font-bold text-lg text-gray-900">최범근</h3>
                    <p class="text-xs text-blue-600 font-bold mt-1">Full Stack</p>
                    <p class="text-xs text-gray-400 mt-1">Architecture</p>
                </div>
                <div class="reveal-card" style="transition-delay: 200ms;">
                    <div class="w-24 h-24 rounded-full bg-gradient-to-br from-gray-100 to-gray-200 mx-auto mb-4 flex items-center justify-center text-2xl font-black text-gray-400 shadow-inner">L</div>
                    <h3 class="font-bold text-lg text-gray-900">이상원</h3>
                    <p class="text-xs text-blue-600 font-bold mt-1">Backend</p>
                    <p class="text-xs text-gray-400 mt-1">Security / Infra</p>
                </div>
                <div class="reveal-card" style="transition-delay: 300ms;">
                    <div class="w-24 h-24 rounded-full bg-gradient-to-br from-gray-100 to-gray-200 mx-auto mb-4 flex items-center justify-center text-2xl font-black text-gray-400 shadow-inner">K</div>
                    <h3 class="font-bold text-lg text-gray-900">김도연</h3>
                    <p class="text-xs text-blue-600 font-bold mt-1">Frontend</p>
                    <p class="text-xs text-gray-400 mt-1">UI/UX Design</p>
                </div>
                <div class="reveal-card" style="transition-delay: 400ms;">
                    <div class="w-24 h-24 rounded-full bg-gradient-to-br from-gray-100 to-gray-200 mx-auto mb-4 flex items-center justify-center text-2xl font-black text-gray-400 shadow-inner">L</div>
                    <h3 class="font-bold text-lg text-gray-900">이승환</h3>
                    <p class="text-xs text-blue-600 font-bold mt-1">Backend</p>
                    <p class="text-xs text-gray-400 mt-1">API Integration</p>
                </div>
                <div class="reveal-card" style="transition-delay: 500ms;">
                    <div class="w-24 h-24 rounded-full bg-gradient-to-br from-gray-100 to-gray-200 mx-auto mb-4 flex items-center justify-center text-2xl font-black text-gray-400 shadow-inner">L</div>
                    <h3 class="font-bold text-lg text-gray-900">이동희</h3>
                    <p class="text-xs text-blue-600 font-bold mt-1">Frontend</p>
                    <p class="text-xs text-gray-400 mt-1">Community Logic</p>
                </div>
            </div>
        </div>
    </section>

    <section class="py-32 bg-gray-50">
        <div class="max-w-5xl mx-auto px-6">
            <h2 class="text-4xl font-bold mb-16 text-center reveal-text">왜 이 프로젝트를 시작했나요?</h2>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <div class="bento-box p-8 reveal-card">
                    <div class="w-12 h-12 bg-red-50 text-red-500 rounded-2xl flex items-center justify-center mb-6">
                        <i data-lucide="keyboard" class="w-6 h-6"></i>
                    </div>
                    <h3 class="text-xl font-bold mb-3">등록의 번거로움</h3>
                    <p class="text-gray-500 leading-relaxed text-sm">
                        책 제목, 저자, 출판사, 상태...<br>
                        하나하나 입력하는 귀찮은 과정은 판매를 포기하게 만듭니다.
                    </p>
                </div>
                <div class="bento-box p-8 reveal-card" style="transition-delay: 100ms;">
                    <div class="w-12 h-12 bg-orange-50 text-orange-500 rounded-2xl flex items-center justify-center mb-6">
                        <i data-lucide="alert-triangle" class="w-6 h-6"></i>
                    </div>
                    <h3 class="text-xl font-bold mb-3">거래의 불안감</h3>
                    <p class="text-gray-500 leading-relaxed text-sm">
                        "돈을 보냈는데 물건이 안 오면?"<br>
                        비대면 중고 거래의 가장 큰 진입 장벽인 신뢰 문제를 해결해야 했습니다.
                    </p>
                </div>
                <div class="bento-box p-8 reveal-card" style="transition-delay: 200ms;">
                    <div class="w-12 h-12 bg-gray-100 text-gray-600 rounded-2xl flex items-center justify-center mb-6">
                        <i data-lucide="users" class="w-6 h-6"></i>
                    </div>
                    <h3 class="text-xl font-bold mb-3">독서의 고립감</h3>
                    <p class="text-gray-500 leading-relaxed text-sm">
                        책을 읽고 난 후의 감동을 나눌 곳이 없습니다.<br>
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

            <div class="flex flex-col md:flex-row items-center gap-16 mb-32 reveal-text">
                <div class="flex-1">
                    <span class="text-blue-600 font-bold mb-2 block">01. Instant Listing</span>
                    <h3 class="text-4xl font-bold mb-6">ISBN 스캔으로<br>1초 만에 등록.</h3>
                    <p class="text-gray-500 text-lg leading-relaxed mb-8">
                        판매자는 ISBN만 입력하면 됩니다.<br>
                        <strong>Naver/Kakao Book API</strong>와 연동하여 표지, 저자, 출판사, 정가 정보를 자동으로 불러옵니다.
                        <code class="text-sm bg-gray-100 px-2 py-1 rounded ml-1 text-gray-700">BookApiService.java</code>
                    </p>
                    <div class="flex gap-3">
                        <span class="px-4 py-2 bg-gray-100 rounded-lg text-sm font-medium">WebClient</span>
                        <span class="px-4 py-2 bg-gray-100 rounded-lg text-sm font-medium">Async Processing</span>
                    </div>
                </div>
                <div class="flex-1 w-full bg-gray-100 rounded-[2rem] aspect-[4/3] flex items-center justify-center shadow-inner">
                    <i data-lucide="scan-barcode" class="w-32 h-32 text-gray-300"></i>
                </div>
            </div>

            <div class="flex flex-col md:flex-row-reverse items-center gap-16 mb-32 reveal-text">
                <div class="flex-1">
                    <span class="text-green-600 font-bold mb-2 block">02. Secure Transaction</span>
                    <h3 class="text-4xl font-bold mb-6">대화는 실시간으로,<br>결제는 안전하게.</h3>
                    <p class="text-gray-500 text-lg leading-relaxed mb-8">
                        <strong>WebSocket(STOMP)</strong> 기반 채팅방에서 흥정하고,
                        <strong>Toss Payments</strong> 에스크로 결제로 사기를 원천 차단합니다.<br>
                        구매자가 '구매 확정'을 눌러야만 판매자에게 정산됩니다.
                    </p>
                    <ul class="space-y-3 text-gray-600">
                        <li class="flex items-center gap-2"><i data-lucide="check-circle" class="w-5 h-5 text-green-500"></i> 실시간 1:1 채팅</li>
                        <li class="flex items-center gap-2"><i data-lucide="check-circle" class="w-5 h-5 text-green-500"></i> 에스크로 안전 결제</li>
                        <li class="flex items-center gap-2"><i data-lucide="check-circle" class="w-5 h-5 text-green-500"></i> 자동 구매 확정 (Scheduler)</li>
                    </ul>
                </div>
                <div class="flex-1 w-full bg-gray-900 rounded-[2rem] aspect-[4/3] flex items-center justify-center shadow-2xl relative overflow-hidden">
                    <div class="absolute inset-0 bg-gradient-to-br from-gray-800 to-black opacity-50"></div>
                    <div class="relative z-10 text-white text-center">
                        <i data-lucide="lock" class="w-16 h-16 mx-auto mb-4 text-green-400"></i>
                        <div class="text-2xl font-bold">Safe Payment Logic</div>
                    </div>
                </div>
            </div>

            <div class="flex flex-col md:flex-row items-center gap-16 reveal-text">
                <div class="flex-1">
                    <span class="text-yellow-500 font-bold mb-2 block">03. Local Community</span>
                    <h3 class="text-4xl font-bold mb-6">지도 위에서 만나는<br>우리 동네 독서 모임.</h3>
                    <p class="text-gray-500 text-lg leading-relaxed mb-8">
                        <strong>Kakao Map API</strong>를 활용하여 내 주변 독서 모임을 시각적으로 탐색합니다.
                        오프라인 모임 장소 검색부터 가입 신청까지, 책을 매개로 한 연결을 지원합니다.
                    </p>
                </div>
                <div class="flex-1 w-full bg-yellow-50 rounded-[2rem] aspect-[4/3] flex items-center justify-center border border-yellow-100">
                    <i data-lucide="map" class="w-32 h-32 text-yellow-300"></i>
                </div>
            </div>
        </div>
    </section>

    <section class="py-32 bg-[#111] text-white">
        <div class="max-w-6xl mx-auto px-6">
            <h2 class="text-4xl font-bold mb-16 reveal-text">Engineering & Architecture</h2>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
                <div class="reveal-text">
                    <h3 class="text-2xl font-bold mb-4 text-blue-400">Spring WebClient 도입</h3>
                    <p class="text-gray-400 mb-6 leading-relaxed text-sm">
                        기존의 Blocking 방식인 <code>RestTemplate</code> 대신,
                        Spring 5의 <strong>Non-Blocking I/O</strong> 클라이언트인 <code>WebClient</code>를 도입하여
                        외부 API(도서, 결제) 통신 성능과 확장성을 확보했습니다.
                    </p>
                    <div class="code-window">
                        <div class="code-header">
                            <div class="dot red"></div><div class="dot yellow"></div><div class="dot green"></div>
                        </div>
                        <div class="p-4 text-xs text-green-400 bg-[#1e1e1e]">
<pre>
// Fluent API & Non-Blocking
WebClient.create().get()
  .uri(naverApiUrl)
  .header("X-Naver-Client-Id", id)
  .retrieve()
  .bodyToMono(String.class)
  .subscribe(response -> ...);
</pre>
                        </div>
                    </div>
                </div>

                <div class="reveal-text" style="transition-delay: 200ms;">
                    <h3 class="text-2xl font-bold mb-4 text-purple-400">안정성 및 성능 최적화</h3>
                    <ul class="space-y-6 text-gray-400">
                        <li class="flex gap-4">
                            <div class="mt-1"><i data-lucide="zap" class="w-5 h-5 text-yellow-400"></i></div>
                            <div>
                                <strong class="text-white block mb-1">Redis Caching</strong>
                                <span class="text-sm">자주 조회되는 '베스트셀러', '카테고리' 데이터를 Redis에 캐싱하여 DB 부하를 50% 이상 절감했습니다. (RedisConfig.java)</span>
                            </div>
                        </li>
                        <li class="flex gap-4">
                            <div class="mt-1"><i data-lucide="clock" class="w-5 h-5 text-blue-400"></i></div>
                            <div>
                                <strong class="text-white block mb-1">Background Scheduler</strong>
                                <span class="text-sm"><code>SafePaymentScheduler</code>가 주기적으로 실행되어 결제 후 15일 경과 시 자동 구매 확정, 미결제 건 자동 취소 등을 처리합니다.</span>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <section class="py-32 bg-gray-50">
        <div class="max-w-6xl mx-auto px-6">
            <div class="flex flex-col md:flex-row items-center gap-12 reveal-text">
                <div class="flex-1">
                    <span class="text-gray-500 font-bold text-sm uppercase tracking-wider mb-2 block">For Operators</span>
                    <h2 class="text-4xl font-bold mb-6 text-gray-900">통합 관리자 대시보드</h2>
                    <p class="text-gray-600 mb-6 leading-relaxed">
                        서비스 운영을 위한 강력한 어드민 페이지를 구축했습니다.
                        방문자 통계, 거래 현황, 배너 관리, 공지사항 작성 등을 한 곳에서 처리할 수 있습니다.
                    </p>
                    <ul class="space-y-2 text-sm text-gray-600">
                        <li>• 일별/월별 방문자 및 거래량 차트 시각화</li>
                        <li>• 메인 배너 실시간 미리보기 및 수정</li>
                        <li>• 악성 유저 및 신고 게시글 관리</li>
                    </ul>
                </div>
                <div class="flex-1 w-full shadow-2xl rounded-xl overflow-hidden border border-gray-200">
                    <img src="/img/admin_dashboard_mockup.jpg" onerror="this.src='https://placehold.co/800x500/ffffff/cccccc?text=Admin+Dashboard+UI'" class="w-full h-auto">
                </div>
            </div>
        </div>
    </section>

    <section class="py-32 px-6">
        <div class="max-w-4xl mx-auto">
            <h2 class="text-3xl font-bold mb-12 border-l-4 border-red-500 pl-4 reveal-text">Troubleshooting: 변수 스코프 충돌</h2>

            <div class="bg-white p-8 rounded-2xl shadow-lg border border-gray-100 reveal-card">
                <div class="mb-8">
                    <h4 class="font-bold text-red-500 mb-2 flex items-center gap-2">
                        <i data-lucide="alert-circle" class="w-5 h-5"></i> Problem
                    </h4>
                    <p class="text-gray-600 text-sm">
                        마이페이지 탭을 AJAX로 동적 로딩할 때, 전역 스코프에 선언된 변수(<code>let</code>, <code>const</code>)가
                        탭 전환 시 중복 선언되어 <strong>SyntaxError: Identifier has already been declared</strong> 발생.
                    </p>
                </div>

                <div>
                    <h4 class="font-bold text-green-600 mb-2 flex items-center gap-2">
                        <i data-lucide="check-circle" class="w-5 h-5"></i> Solution
                    </h4>
                    <p class="text-gray-600 text-sm mb-4">
                        <strong>IIFE (즉시 실행 함수)</strong> 패턴과 <strong>Namespace</strong> 객체를 도입하여
                        스크립트의 유효 범위를 블록 단위로 격리하고, 필요한 함수만 전역 객체에 노출시켰습니다.
                    </p>
                    <div class="code-window">
                        <div class="code-header">
                            <div class="dot red"></div><div class="dot yellow"></div><div class="dot green"></div>
                        </div>
                        <div class="p-4 text-xs text-gray-300 bg-[#1e1e1e]">
<pre>
<span class="text-gray-500">// IIFE로 스코프 격리</span>
(function() {
    let localState = []; // 안전한 지역 변수

    const actions = {
        init: () => { ... },
        save: () => { ... }
    };

    <span class="text-blue-400">window.TabName</span> = actions; // 네임스페이스 노출
})();
</pre>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="h-screen flex flex-col justify-center items-center text-center bg-white border-t border-gray-100">
        <div class="mb-8 reveal-text">
            <div class="w-20 h-20 bg-blue-600 rounded-3xl flex items-center justify-center mx-auto shadow-xl mb-8 transform rotate-3">
                <span class="text-white font-black text-3xl">S</span>
            </div>
            <h2 class="text-5xl md:text-7xl font-black mb-8 tracking-tight text-gray-900">
                Your Book's Second Life.
            </h2>
            <p class="text-xl text-gray-500 mb-12 max-w-2xl mx-auto">
                기술적 고민을 통해, 책과 사람을 잇는 가장 안전하고 따뜻한 방법을 만들었습니다.
            </p>
            <a href="/home" class="group inline-flex items-center gap-3 bg-gray-900 text-white px-10 py-5 rounded-full font-bold text-lg hover:bg-black transition-all shadow-xl hover:shadow-2xl hover:-translate-y-1">
                서비스 시연 시작하기
                <i data-lucide="arrow-right" class="w-5 h-5 group-hover:translate-x-1 transition-transform"></i>
            </a>
        </div>

        <footer class="absolute bottom-8 text-sm text-gray-400">
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
                    observer.unobserve(entry.target); // 한 번만 실행
                }
            });
        }, observerOptions);

        document.querySelectorAll('.reveal-text, .reveal-card, .reveal-image').forEach(el => {
            observer.observe(el);
        });
    </script>
</body>
</html>