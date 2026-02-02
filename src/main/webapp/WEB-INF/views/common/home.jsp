<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script src="https://unpkg.com/lucide@latest"></script>

<jsp:include page="header.jsp" />

<style>
    /* 3D Carousel Styles */
    .carousel-container {
        perspective: 1200px;
        position: relative;
        height: 460px; /* 높이 확보 */
        overflow: hidden;
        padding-top: 40px;
        padding-bottom: 80px; /* 하단 여백 넉넉하게 */
        user-select: none;

        /* 하단 자연스러운 그라데이션 마스크 */
        mask-image: linear-gradient(to bottom, black 80%, transparent 100%);
        -webkit-mask-image: linear-gradient(to bottom, black 80%, transparent 100%);
    }

    .carousel-item {
        position: absolute;
        top: 0;
        left: 50%;
        width: 70%;
        height: 100%;
        transform: translateX(-50%) scale(0.85);
        transition: all 0.6s cubic-bezier(0.25, 0.8, 0.25, 1);
        opacity: 0;
        z-index: 0;
        border-radius: 2.5rem;
        box-shadow: 0 25px 60px -15px rgba(0,0,0,0.15);
        overflow: hidden;
        pointer-events: none;
        will-change: transform, opacity; /* 성능 최적화 */
    }

    /* Active (Center) */
    .carousel-item.active {
        transform: translateX(-50%) scale(1);
        opacity: 1;
        z-index: 20;
        pointer-events: auto;
        box-shadow: 0 30px 60px -12px rgba(0, 0, 0, 0.25);
    }

    /* Previous (Left) */
    .carousel-item.prev {
        transform: translateX(-110%) scale(0.85) rotateY(15deg);
        opacity: 0.5;
        z-index: 10;
        filter: blur(1px);
    }

    /* Next (Right) */
    .carousel-item.next {
        transform: translateX(10%) scale(0.85) rotateY(-15deg);
        opacity: 0.5;
        z-index: 10;
        filter: blur(1px);
    }

    /* 애니메이션 클래스 */
    .animate-fade-in-up { animation: fadeInUp 0.5s ease-out forwards; }
    .animate-fade-in-down { animation: fadeInDown 0.2s ease-out forwards; }

    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }
    @keyframes fadeInDown {
        from { opacity: 0; transform: translateY(-5px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>

<div class="space-y-12 font-sans text-gray-900 animate-fade-in-up pb-20">

    <div class="carousel-container relative" id="bannerContainer">

        <c:choose>
            <c:when test="${not empty bannerList}">
                <c:forEach var="b" items="${bannerList}" varStatus="st">
                    <div class="carousel-item flex items-center px-12 relative"
                         data-index="${st.index}"
                         style="background: linear-gradient(135deg, ${b.bgColorFrom}, ${b.bgColorTo});">

                            <%-- 텍스트 정렬 및 부제목 처리 --%>
                        <c:set var="alignClass" value="text-left" />
                        <c:set var="posClass" value="mr-auto" />
                        <c:set var="realSubtitle" value="${b.subtitle}" />

                        <c:if test="${fn:contains(b.subtitle, '|||')}">
                            <c:set var="parts" value="${fn:split(b.subtitle, '|')}" />
                            <c:set var="alignClass" value="${parts[0]}" />
                            <c:choose>
                                <c:when test="${alignClass eq 'text-center'}"><c:set var="posClass" value="mx-auto" /></c:when>
                                <c:when test="${alignClass eq 'text-right'}"><c:set var="posClass" value="ml-auto" /></c:when>
                            </c:choose>
                            <c:set var="lastIndex" value="${fn:length(parts) - 1}" />
                            <c:set var="realSubtitle" value="${parts[lastIndex]}" />
                        </c:if>

                        <div class="z-10 text-white max-w-2xl w-full ${alignClass} ${posClass} space-y-6">
                            <div class="inline-flex items-center justify-center w-14 h-14 rounded-2xl bg-white/20 backdrop-blur-md mb-2 shadow-inner border border-white/10">
                                <i data-lucide="${b.iconName != null ? b.iconName : 'star'}" class="w-7 h-7 text-white"></i>
                            </div>

                            <h1 class="text-4xl md:text-5xl font-black tracking-tight leading-tight drop-shadow-sm">${b.title}</h1>
                            <p class="text-white/90 text-lg font-medium tracking-wide leading-relaxed">${realSubtitle}</p>

                            <c:if test="${not empty b.btnLink}">
                                <a href="${b.btnLink}" class="inline-flex items-center gap-2 bg-white text-gray-900 px-8 py-3.5 rounded-full font-bold text-sm hover:bg-gray-50 transition-all shadow-lg hover:shadow-xl hover:-translate-y-0.5">
                                        ${b.btnText}
                                    <i data-lucide="arrow-right" class="w-4 h-4 text-blue-600 transition-transform group-hover:translate-x-1"></i>
                                </a>
                            </c:if>
                        </div>

                        <div class="absolute -right-20 -bottom-40 w-96 h-96 bg-white/10 rounded-full blur-3xl pointer-events-none"></div>
                    </div>
                </c:forEach>
            </c:when>

            <c:otherwise>
                <div class="carousel-item active flex items-center px-16 relative bg-gradient-to-br from-blue-600 to-indigo-800" data-index="0">
                    <div class="z-10 text-white max-w-2xl">
                        <h1 class="text-5xl font-black mb-4 tracking-tight">Secondary Books</h1>
                        <p class="text-white/80 text-xl font-medium">Welcome. Experience better trading.</p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <button onclick="prevBanner()" class="absolute left-4 md:left-8 top-1/2 -translate-y-1/2 z-30 w-12 h-12 bg-white/20 hover:bg-white/40 backdrop-blur-md border border-white/20 rounded-full text-white flex items-center justify-center transition-all hover:scale-110 shadow-lg">
            <i data-lucide="chevron-left" class="w-6 h-6"></i>
        </button>
        <button onclick="nextBanner()" class="absolute right-4 md:right-8 top-1/2 -translate-y-1/2 z-30 w-12 h-12 bg-white/20 hover:bg-white/40 backdrop-blur-md border border-white/20 rounded-full text-white flex items-center justify-center transition-all hover:scale-110 shadow-lg">
            <i data-lucide="chevron-right" class="w-6 h-6"></i>
        </button>

        <div class="absolute bottom-6 left-1/2 transform -translate-x-1/2 flex gap-2 z-30" id="bannerDots">
            <c:if test="${not empty bannerList}">
                <c:forEach var="b" items="${bannerList}" varStatus="st">
                    <button onclick="setBanner(${st.index})" class="h-1.5 rounded-full transition-all duration-300 shadow-sm ${st.first ? 'bg-white w-8' : 'bg-white/40 w-2 hover:bg-white/60'}"></button>
                </c:forEach>
            </c:if>
        </div>
    </div>

    <div class="flex flex-col gap-8 px-4 md:px-0">

        <div class="flex flex-col xl:flex-row xl:items-center justify-between gap-6">
            <div class="flex items-center gap-3">
                <h2 class="text-3xl font-black text-gray-900 tracking-tight">전체 상품</h2>
                <c:if test="${not empty totalCount}">
                    <span id="tradeTotalCount" class="text-sm font-bold text-blue-600 bg-blue-50 px-3 py-1 rounded-full shadow-sm border border-blue-100">
                            ${totalCount}
                    </span>
                </c:if>
            </div>

            <div class="flex-1 max-w-2xl relative group">
                <input type="text" id="searchInput"
                       placeholder="찾고 싶은 도서나 저자를 검색해보세요"
                       class="w-full pl-6 pr-14 py-4 bg-gray-50 border border-gray-200 rounded-full text-base font-medium text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-4 focus:ring-blue-100 focus:border-blue-500 focus:bg-white transition-all shadow-sm hover:shadow-md" />
                <button type="button" onclick="searchTrade()"
                        class="absolute right-2 top-1/2 transform -translate-y-1/2 w-10 h-10 bg-blue-600 rounded-full flex items-center justify-center text-white hover:bg-blue-700 hover:scale-105 active:scale-95 transition-all shadow-md">
                    <i data-lucide="search" class="w-5 h-5"></i>
                </button>
            </div>

            <div class="flex bg-gray-100 p-1.5 rounded-xl self-start xl:self-center">
                <a href="javascript:void(0)" id="sortNewest" onclick="setSort('newest')" class="px-4 py-2 rounded-lg text-sm font-bold transition-all text-gray-500 hover:text-gray-900">최신순</a>
                <a href="javascript:void(0)" id="sortPrice" onclick="setSort('priceAsc')" class="px-4 py-2 rounded-lg text-sm font-bold transition-all text-gray-500 hover:text-gray-900">낮은가격</a>
                <a href="javascript:void(0)" id="sortLikes" onclick="setSort('likeDesc')" class="px-4 py-2 rounded-lg text-sm font-bold transition-all text-gray-500 hover:text-gray-900">인기순</a>
            </div>
        </div>

        <div class="flex flex-wrap items-center gap-3">
            <c:set var="btnBaseClass" value="px-5 py-2.5 rounded-full text-sm font-bold transition-all flex items-center gap-2 border border-transparent bg-gray-100 text-gray-600 hover:bg-gray-200 hover:text-gray-900 active:scale-95" />

            <div class="relative">
                <button onclick="toggleDropdown('category')" id="categoryBtn" class="${btnBaseClass}">
                    <span id="categoryText">카테고리</span>
                    <i data-lucide="chevron-down" class="w-4 h-4 text-gray-400"></i>
                </button>
                <div id="categoryDropdown" class="hidden absolute top-full left-0 mt-2 w-56 bg-white/95 backdrop-blur-xl rounded-2xl shadow-xl border border-gray-100 z-30 py-2 max-h-[300px] overflow-y-auto animate-fade-in-down">
                    <a href="javascript:selectCategory(null, '전체')" class="block px-5 py-2.5 text-sm font-medium text-gray-700 hover:bg-blue-50 hover:text-blue-600">전체</a>
                    <c:forEach var="cat" items="${category}">
                        <a href="javascript:selectCategory(${cat.category_seq}, '${cat.category_nm}')" class="block px-5 py-2.5 text-sm font-medium text-gray-700 hover:bg-blue-50 hover:text-blue-600">
                                ${cat.category_nm}
                        </a>
                    </c:forEach>
                </div>
            </div>

            <div class="relative">
                <button onclick="toggleDropdown('condition')" id="conditionBtn" class="${btnBaseClass}">
                    <span id="conditionText">상품 상태</span>
                    <i data-lucide="chevron-down" class="w-4 h-4 text-gray-400"></i>
                </button>
                <div id="conditionDropdown" class="hidden absolute top-full left-0 mt-2 w-48 bg-white/95 backdrop-blur-xl rounded-2xl shadow-xl border border-gray-100 z-30 py-2 animate-fade-in-down">
                    <a href="javascript:selectBookStatus(null, '전체보기')" class="block px-5 py-2.5 text-sm font-medium text-gray-700 hover:bg-blue-50 hover:text-blue-600">전체보기</a>
                    <a href="javascript:selectBookStatus('NEW', '새책')" class="block px-5 py-2.5 text-sm font-medium text-gray-700 hover:bg-blue-50 hover:text-blue-600">새책</a>
                    <a href="javascript:selectBookStatus('LIKE_NEW', '보통')" class="block px-5 py-2.5 text-sm font-medium text-gray-700 hover:bg-blue-50 hover:text-blue-600">보통</a>
                    <a href="javascript:selectBookStatus('GOOD', '좋음')" class="block px-5 py-2.5 text-sm font-medium text-gray-700 hover:bg-blue-50 hover:text-blue-600">좋음</a>
                    <a href="javascript:selectBookStatus('USED', '사용됨')" class="block px-5 py-2.5 text-sm font-medium text-gray-700 hover:bg-blue-50 hover:text-blue-600">사용됨</a>
                </div>
            </div>

            <div class="relative">
                <button onclick="toggleDropdown('saleStatus')" id="saleStatusBtn" class="${btnBaseClass}">
                    <span id="saleStatusText">판매중</span>
                    <i data-lucide="chevron-down" class="w-4 h-4 text-gray-400"></i>
                </button>
                <div id="saleStatusDropdown" class="hidden absolute top-full left-0 mt-2 w-48 bg-white/95 backdrop-blur-xl rounded-2xl shadow-xl border border-gray-100 z-30 py-2 animate-fade-in-down">
                    <a href="javascript:selectSaleStatus('SALE', '판매중')" class="block px-5 py-2.5 text-sm font-medium text-gray-700 hover:bg-blue-50 hover:text-blue-600">판매중</a>
                    <a href="javascript:selectSaleStatus('SOLD', '판매완료')" class="block px-5 py-2.5 text-sm font-medium text-gray-700 hover:bg-blue-50 hover:text-blue-600">판매완료</a>
                    <a href="javascript:selectSaleStatus(null, '판매중 & 완료')" class="block px-5 py-2.5 text-sm font-medium text-gray-700 hover:bg-blue-50 hover:text-blue-600">판매중 & 완료</a>
                </div>
            </div>

            <button type="button" onclick="resetFilters()" class="ml-auto px-4 py-2.5 rounded-full text-sm font-bold transition-all flex items-center gap-1.5 text-gray-400 hover:text-blue-600 hover:bg-blue-50">
                <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
                초기화
            </button>
        </div>
    </div>

    <div id="tradelist" class="mt-8 min-h-[500px]">
        <jsp:include page="/WEB-INF/views/trade/tradelist.jsp" />
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {

        // --- 1. 3D Carousel Logic ---
        let currentBanner = 0;
        let autoPlayInterval;
        let openDropdown = null;

        function updateCarousel() {
            const slides = document.querySelectorAll('.carousel-item');
            const count = slides.length;
            if (count === 0) return;

            slides.forEach((slide, index) => {
                // Reset styles
                slide.className = 'carousel-item flex items-center px-12 relative';
                slide.style.opacity = '0';
                slide.style.zIndex = '0';
                slide.style.pointerEvents = 'none';
                slide.style.transform = 'translateX(-50%) scale(0.8)';

                // Apply states
                if (index === currentBanner) {
                    slide.classList.add('active');
                    slide.style.opacity = '1';
                    slide.style.zIndex = '20';
                    slide.style.pointerEvents = 'auto';
                    slide.style.transform = 'translateX(-50%) scale(1)';
                } else if (index === (currentBanner - 1 + count) % count) {
                    slide.classList.add('prev');
                    slide.style.opacity = '0.4';
                    slide.style.zIndex = '10';
                    slide.style.transform = 'translateX(-120%) scale(0.85) rotateY(15deg)';
                } else if (index === (currentBanner + 1) % count) {
                    slide.classList.add('next');
                    slide.style.opacity = '0.4';
                    slide.style.zIndex = '10';
                    slide.style.transform = 'translateX(20%) scale(0.85) rotateY(-15deg)';
                }
            });

            // Update Dots
            const dotsContainer = document.getElementById('bannerDots');
            if (dotsContainer) {
                const dots = dotsContainer.children;
                if (dots.length === count) {
                    for (let i = 0; i < count; i++) {
                        if (i === currentBanner) {
                            dots[i].classList.remove('bg-white/40', 'w-2');
                            dots[i].classList.add('bg-white', 'w-8');
                        } else {
                            dots[i].classList.remove('bg-white', 'w-8');
                            dots[i].classList.add('bg-white/40', 'w-2');
                        }
                    }
                }
            }
        }

        // Global Carousel Functions (for onclick binding)
        window.setBanner = function(index) {
            currentBanner = index;
            updateCarousel();
        };

        window.prevBanner = function() {
            const slides = document.querySelectorAll('.carousel-item');
            if (slides.length > 0) {
                currentBanner = (currentBanner - 1 + slides.length) % slides.length;
                updateCarousel();
            }
        };

        window.nextBanner = function() {
            const slides = document.querySelectorAll('.carousel-item');
            if (slides.length > 0) {
                currentBanner = (currentBanner + 1) % slides.length;
                updateCarousel();
            }
        };

        // Auto Play
        autoPlayInterval = setInterval(window.nextBanner, 5000);
        const container = document.getElementById('bannerContainer');
        if(container) {
            container.addEventListener('mouseenter', () => clearInterval(autoPlayInterval));
            container.addEventListener('mouseleave', () => {
                clearInterval(autoPlayInterval);
                autoPlayInterval = setInterval(window.nextBanner, 5000);
            });
        }

        // --- 2. Search & Filter Logic ---
        const tradeFilter = {
            categorySeq: null,
            book_st: null,
            search_word: null,
            sale_st: 'SALE',
            page: 1,
            sort: null
        };

        function loadTrade() {
            const data = { page: tradeFilter.page };
            if (tradeFilter.categorySeq) data.category_seq = tradeFilter.categorySeq;
            if (tradeFilter.book_st) data.book_st = tradeFilter.book_st;
            if (tradeFilter.search_word) data.search_word = tradeFilter.search_word;
            data.sale_st = tradeFilter.sale_st;
            if (tradeFilter.sort) data.sort = tradeFilter.sort;

            // jQuery usage for AJAX (make sure jQuery is loaded in header.jsp)
            if (typeof $ !== 'undefined') {
                $.ajax({
                    url: '/home',
                    type: 'GET',
                    data: data,
                    headers: { 'X-Requested-With': 'XMLHttpRequest' },
                    success: function (html, status, xhr) {
                        $('#tradelist').html(html);
                        const totalCount = xhr.getResponseHeader('X-Total-Count');
                        if(totalCount !== null) $('#tradeTotalCount').text(totalCount);
                        openDropdown = null;
                        if (typeof lucide !== 'undefined') lucide.createIcons();
                    },
                    error: function (xhr) { console.error('AJAX 오류:', xhr); }
                });
            } else {
                console.error("jQuery is not loaded!");
            }
        }

        // Global Filter Functions
        window.setSort = function(sortKey) {
            tradeFilter.sort = sortKey === 'newest' ? null : sortKey;
            tradeFilter.page = 1;
            updateSortCss();
            loadTrade();
        };

        window.updateSortCss = function() {
            const ids = ['sortNewest', 'sortPrice', 'sortLikes'];
            ids.forEach(id => {
                const el = document.getElementById(id);
                if(el) el.className = 'px-4 py-2 rounded-lg text-sm font-bold transition-all text-gray-500 hover:text-gray-900 hover:bg-gray-200/50';
            });

            let activeId = 'sortNewest';
            if (tradeFilter.sort === 'priceAsc') activeId = 'sortPrice';
            if (tradeFilter.sort === 'likeDesc') activeId = 'sortLikes';

            const activeEl = document.getElementById(activeId);
            if(activeEl) activeEl.className = 'px-4 py-2 rounded-lg text-sm font-bold transition-all bg-white text-gray-900 shadow-sm ring-1 ring-black/5';
        };

        window.updateFilterBtnStyle = function(btnId, isActive) {
            const btn = document.getElementById(btnId);
            if(!btn) return;
            const baseClass = "px-5 py-2.5 rounded-full text-sm font-bold transition-all flex items-center gap-2 border border-transparent bg-gray-100 text-gray-600 hover:bg-gray-200 hover:text-gray-900 active:scale-95";
            if (isActive) {
                btn.className = "px-5 py-2.5 rounded-full text-sm font-bold transition-all flex items-center gap-2 border border-transparent bg-blue-600 text-white shadow-md hover:bg-blue-700 active:scale-95";
                const icon = btn.querySelector('svg');
                if(icon) icon.classList.replace('text-gray-400', 'text-white/80');
            } else {
                btn.className = baseClass;
                const icon = btn.querySelector('svg');
                if(icon) icon.classList.replace('text-white/80', 'text-gray-400');
            }
        };

        window.selectCategory = function(seq, name) {
            tradeFilter.categorySeq = seq;
            tradeFilter.page = 1;
            document.getElementById('categoryText').innerText = name;
            document.getElementById('categoryDropdown').classList.add('hidden');
            window.updateFilterBtnStyle('categoryBtn', seq !== null);
            loadTrade();
        };

        window.selectBookStatus = function(st, name) {
            tradeFilter.book_st = st;
            tradeFilter.page = 1;
            document.getElementById('conditionText').innerText = name;
            document.getElementById('conditionDropdown').classList.add('hidden');
            window.updateFilterBtnStyle('conditionBtn', st !== null);
            loadTrade();
        };

        window.selectSaleStatus = function(st, name) {
            tradeFilter.sale_st = st;
            tradeFilter.page = 1;
            document.getElementById('saleStatusText').innerText = name;
            document.getElementById('saleStatusDropdown').classList.add('hidden');
            window.updateFilterBtnStyle('saleStatusBtn', st !== 'SALE');
            loadTrade();
        };

        window.searchTrade = function() {
            const searchInput = document.getElementById('searchInput');
            if(searchInput) {
                tradeFilter.search_word = searchInput.value;
                tradeFilter.page = 1;
                loadTrade();
            }
        };

        window.toggleDropdown = function(id) {
            const el = document.getElementById(id + 'Dropdown');
            if(!el) return;

            if (openDropdown && openDropdown !== el) openDropdown.classList.add('hidden');
            el.classList.toggle('hidden');
            openDropdown = el.classList.contains('hidden') ? null : el;
        };

        window.resetFilters = function() {
            tradeFilter.categorySeq = null;
            tradeFilter.book_st = null;
            tradeFilter.search_word = null;
            tradeFilter.sale_st = 'SALE';
            tradeFilter.page = 1;
            tradeFilter.sort = null;

            const sInput = document.getElementById('searchInput');
            if(sInput) sInput.value = '';

            document.getElementById('categoryText').innerText = '카테고리';
            document.getElementById('conditionText').innerText = '상품 상태';
            document.getElementById('saleStatusText').innerText = '판매중';

            ['categoryBtn', 'conditionBtn', 'saleStatusBtn'].forEach(id => window.updateFilterBtnStyle(id, false));
            if(openDropdown) openDropdown.classList.add('hidden');

            window.updateSortCss();
            loadTrade();
        };

        // Pagination Global Function (used in tradelist.jsp)
        window.goPage = function(page) {
            tradeFilter.page = page;
            loadTrade();
        };

        // --- Init ---
        const sInput = document.getElementById('searchInput');
        if(sInput) {
            sInput.addEventListener('keydown', e => { if(e.key === 'Enter') window.searchTrade() });
        }

        document.addEventListener('click', e => {
            if (!e.target.closest('.relative') && openDropdown) {
                openDropdown.classList.add('hidden');
                openDropdown = null;
            }
        });

        if (typeof lucide !== 'undefined') lucide.createIcons();

        updateCarousel();
        window.updateSortCss();
        loadTrade(); // Initial Data Load
    });
</script>

<jsp:include page="footer.jsp" />