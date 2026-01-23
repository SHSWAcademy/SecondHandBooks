<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />

<div class="space-y-8">
    <!-- Carousel Hero Banner -->
    <div class="relative overflow-hidden rounded-lg shadow-lg h-[320px]" id="bannerCarousel">
        <div class="flex transition-transform duration-500 ease-out h-full" id="bannerSlider">

            <c:forEach var="b" items="${bannerList}" varStatus="st">
                <div class="w-full flex-shrink-0 p-12 flex items-center relative"
                     style="background: linear-gradient(to right, ${b.bgColorFrom}, ${b.bgColorTo});">

                        <%-- 텍스트 정렬 파싱 (트릭: text-center|||내용) --%>
                    <c:set var="alignClass" value="text-left" />
                    <c:set var="realSubtitle" value="${b.subtitle}" />
                    <c:if test="${fn:contains(b.subtitle, '|||')}">
                        <c:set var="parts" value="${fn:split(b.subtitle, '|||')}" />
                        <c:set var="alignClass" value="${parts[0]}" />
                        <c:set var="realSubtitle" value="${parts[1]}" />
                    </c:if>

                    <div class="z-10 text-white max-w-lg w-full ${alignClass}">
                        <i data-lucide="${b.iconName}" class="w-12 h-12 text-white/80 mb-4 inline-block"></i>

                        <h1 class="text-4xl font-extrabold mb-4 leading-tight">${b.title}</h1>
                        <p class="text-white/90 text-lg mb-8 font-medium">${realSubtitle}</p>

                        <a href="${b.btnLink}" class="bg-white text-gray-900 px-6 py-3 rounded-md font-bold text-sm hover:bg-gray-100 transition shadow-md inline-block">
                                ${b.btnText}
                        </a>
                    </div>
                </div>
            </c:forEach>

        <!-- Carousel Controls -->
        <div class="absolute bottom-6 left-12 flex gap-2 z-20" id="bannerDots">
            <button onclick="setBanner(0)" class="w-2 h-2 rounded-full transition-all bg-white w-6"></button>
            <button onclick="setBanner(1)" class="w-2 h-2 rounded-full transition-all bg-white/40 hover:bg-white/60"></button>
            <button onclick="setBanner(2)" class="w-2 h-2 rounded-full transition-all bg-white/40 hover:bg-white/60"></button>
        </div>

        <button onclick="prevBanner()" class="absolute left-4 top-1/2 -translate-y-1/2 bg-white/10 hover:bg-white/20 p-2 rounded-full text-white backdrop-blur-sm transition">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        </button>
        <button onclick="nextBanner()" class="absolute right-4 top-1/2 -translate-y-1/2 bg-white/10 hover:bg-white/20 p-2 rounded-full text-white backdrop-blur-sm transition">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>
        </button>
    </div>

    <div class="flex flex-col gap-6">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between border-b border-gray-200 pb-4 gap-4">
            <h2 class="text-xl font-bold text-gray-900 flex items-center gap-2">
                전체 상품
                    <c:if test="${not empty totalCount}">
                        <span id="tradeTotalCount" class="text-sm font-normal text-gray-500 bg-gray-100 px-2 py-0.5 rounded-full">
                            ${totalCount}개
                        </span>
                    </c:if>
            </h2>
            <div class="hidden md:flex flex-1 max-w-3xl relative">
                <input type="text"
                       id="searchInput"
                       placeholder="찾고 싶은 도서나 저자를 검색해보세요"
                       class="w-full pl-5 pr-14 py-3 bg-gray-50 border border-gray-200 rounded-full focus:outline-none focus:ring-2 focus:ring-primary-200 focus:border-primary-500 transition-all text-sm placeholder-gray-400 shadow-sm"
                />
                <button type="button"
                        onclick="searchTrade()"
                        class="absolute right-2 top-1.5 h-10 w-10 bg-primary-500 rounded-full flex items-center justify-center text-white hover:bg-primary-600 transition-shadow shadow-md">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="11" cy="11" r="8"/>
                        <path d="m21 21-4.35-4.35"/>
                    </svg>
                </button>
            </div>

            <div class="flex gap-4 text-sm text-gray-500 font-medium">
                <a href="javascript:void(0)"
                   id="sortNewest"
                   class="transition-colors hover:text-gray-700"
                   onclick="setSort('newest')">최신순</a>
                <span class="text-gray-300">|</span>
                <a href="javascript:void(0)"
                   id="sortPrice"
                   class="transition-colors hover:text-gray-700"
                   onclick="setSort('priceAsc')">낮은가격순</a>
                <span class="text-gray-300">|</span>
                <a href="javascript:void(0)"
                   id="sortLikes"
                   class="transition-colors hover:text-gray-700"
                   onclick="setSort('likeDesc')">인기순</a>
            </div>
        </div>

        <!-- Filter Toolbar -->
        <div class="flex gap-3 mt-4">
            <div class="relative">
                <button onclick="toggleDropdown('category')" id="categoryBtn" class="px-4 py-2 rounded-lg text-sm font-medium transition flex items-center gap-2 border border-gray-200 bg-white text-gray-600 hover:bg-gray-50">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20"/></svg>
                    <span id="categoryText">카테고리</span>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="transition-transform duration-200"><path d="m6 9 6 6 6-6"/></svg>
                </button>

                <div id="categoryDropdown" class="hidden absolute top-full left-0 mt-2 w-48 bg-white rounded-lg shadow-xl border border-gray-100 z-30 py-1 max-h-[300px] overflow-y-auto">
                    <a href="javascript:selectCategory(null, '전체')" class="block px-4 py-2.5 text-sm hover:bg-gray-50">전체</a>
                    <c:forEach var="cat" items="${category}">
                        <a href="javascript:selectCategory(${cat.category_seq}, '${cat.category_nm}')" class="block px-4 py-2.5 text-sm hover:bg-gray-50">
                            ${cat.category_nm}
                        </a>
                    </c:forEach>
                </div>
            </div>

            <div class="relative">
                <button onclick="toggleDropdown('condition')" id="conditionBtn" class="px-4 py-2 rounded-lg text-sm font-medium transition flex items-center gap-2 border border-gray-200 bg-white text-gray-600 hover:bg-gray-50">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg>
                    <span id="conditionText">상품 상태</span>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="transition-transform duration-200"><path d="m6 9 6 6 6-6"/></svg>
                </button>

                <div id="conditionDropdown"
                     class="hidden absolute top-full left-0 mt-2 w-48 bg-white rounded-lg shadow-xl border border-gray-100 z-30 py-1">

                    <a href="javascript:selectBookStatus(null, '전체보기')"
                       class="block px-4 py-2.5 text-sm hover:bg-gray-50">전체보기</a>

                    <a href="javascript:selectBookStatus('NEW', '새책')"
                       class="block px-4 py-2.5 text-sm hover:bg-gray-50">새책</a>

                    <a href="javascript:selectBookStatus('LIKE_NEW', '보통')"
                       class="block px-4 py-2.5 text-sm hover:bg-gray-50">보통</a>

                    <a href="javascript:selectBookStatus('GOOD', '좋음')"
                       class="block px-4 py-2.5 text-sm hover:bg-gray-50">좋음</a>

                    <a href="javascript:selectBookStatus('USED', '사용됨')"
                       class="block px-4 py-2.5 text-sm hover:bg-gray-50">사용됨</a>
                </div>
            </div>

            <div class="relative">
                <button onclick="toggleDropdown('saleStatus')" id="saleStatusBtn" class="px-4 py-2 rounded-lg text-sm font-medium transition flex items-center gap-2 border border-gray-200 bg-white text-gray-600 hover:bg-gray-50">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    <span id="saleStatusText">판매중</span>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="transition-transform duration-200"><path d="m6 9 6 6 6-6"/></svg>
                </button>

                <div id="saleStatusDropdown"
                     class="hidden absolute top-full left-0 mt-2 w-48 bg-white rounded-lg shadow-xl border border-gray-100 z-30 py-1">

                    <a href="javascript:selectSaleStatus('SALE', '판매중')"
                       class="block px-4 py-2.5 text-sm hover:bg-gray-50">판매중</a>

                    <a href="javascript:selectSaleStatus('SOLD', '판매완료')"
                       class="block px-4 py-2.5 text-sm hover:bg-gray-50">판매완료</a>

                    <a href="javascript:selectSaleStatus(null, '판매중 & 완료')"
                       class="block px-4 py-2.5 text-sm hover:bg-gray-50">판매중 & 완료</a>
                </div>
            </div>
        </div>
    </div>

    <!-- 상품영역 jsp로 별도 분리 비동기 처리를 위함 -->
    <div id="tradelist" class="mt-10">
        <jsp:include page="/WEB-INF/views/trade/tradelist.jsp" />
    </div>
    <script>
        // 페이지 로딩 시 AJAX 호출
        $(document).ready(function() {
            loadTrade();  // tradeFilter.sale_st = 'SALE' 기본값 적용됨
        });
    </script>
</div>

<script>
// Banner carousel
let currentBanner = 0;
const totalBanners = 3;

// 카테고리, 상품상태, 검색어 조합 처리를 위한 객체
const tradeFilter = {
    categorySeq: null,   // 카테고리
    book_st: null,        // 상품상태
    search_word: null,       // 검색어
    sale_st: 'SALE', // 판매상태 (기본값: 판매중)
    page: 1              // 페이지
};



// AJAX 호출 함수
function loadTrade() {
    const data = {
        page: tradeFilter.page
    };

    if (tradeFilter.categorySeq !== null && tradeFilter.categorySeq !== '') {
        data.category_seq = tradeFilter.categorySeq;
    }

    if (tradeFilter.book_st !== null && tradeFilter.book_st !== '') {
        data.book_st = tradeFilter.book_st;
    }

    if (tradeFilter.search_word !== null && tradeFilter.search_word.trim() !== '') {
        data.search_word = tradeFilter.search_word;
    }


    data.sale_st = tradeFilter.sale_st;


    if (tradeFilter.sort) {
        data.sort = tradeFilter.sort; // 정렬 정보 포함
    }

    $.ajax({
        url: '/home',
        type: 'GET',
        data: data,
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        },
        success: function (html, status, xhr) {
                    // 게시물 리스트 교체
                    $('#tradelist').html(html);

                    // 헤더의 totalCount 업데이트 (서버가 header에 보내주는 방식)
                    const totalCount = xhr.getResponseHeader('X-Total-Count');
                    if(totalCount !== null) {
                        $('#tradeTotalCount').text(totalCount + '개');
                    }
                },
        error: function (xhr, status, error) {
            console.error('AJAX 오류:', error);
        }
    });
}

// 초기 정렬값 세팅
tradeFilter.sort = null; // 최신순 기본값

function setSort(sortKey) {
    tradeFilter.sort = sortKey === 'newest' ? null : sortKey;
    tradeFilter.page = 1; // 정렬 변경 시 1페이지로
    updateSortCss();
    loadTrade();
}

// CSS 클래스 갱신
function updateSortCss() {
    const sortLinks = [
        {id: 'sortNewest', key: null},
        {id: 'sortPrice', key: 'priceAsc'},
        {id: 'sortLikes', key: 'likeDesc'}
    ];

    sortLinks.forEach(link => {
        const el = document.getElementById(link.id);
        if (tradeFilter.sort === link.key) {
            el.classList.add('text-gray-900', 'font-bold');
            el.classList.remove('hover:text-gray-700');
        } else if (tradeFilter.sort === null && link.key === null) { // 최신순 처리
            el.classList.add('text-gray-900', 'font-bold');
            el.classList.remove('hover:text-gray-700');
        } else {
            el.classList.remove('text-gray-900', 'font-bold');
            el.classList.add('hover:text-gray-700');
        }
    });
}

// 페이지 로드 시 초기 CSS 적용
updateSortCss();


// 카테고리 선택
function selectCategory(seq, name) {
    tradeFilter.categorySeq = seq;
    tradeFilter.page = 1;

    // 선택 시 카테고리 영역 hidden처리
    document.getElementById('categoryText').innerText = name;
    document.getElementById('categoryDropdown').classList.add('hidden');
    openDropdown = null;

    loadTrade();
}
// 페이징 처리
function goPage(page) {
    tradeFilter.page = page;
    loadTrade();
}

// 상품 상태 선택
function selectBookStatus(book_st, name) {
    tradeFilter.book_st = book_st;
    tradeFilter.page = 1;

    document.getElementById('conditionText').innerText = name;
    document.getElementById('conditionDropdown').classList.add('hidden');
    openDropdown = null;

    loadTrade();
}

// 판매 상태 선택
function selectSaleStatus(sale_st, name) {
    tradeFilter.sale_st = sale_st;
    tradeFilter.page = 1;

    document.getElementById('saleStatusText').innerText = name;
    document.getElementById('saleStatusDropdown').classList.add('hidden');
    openDropdown = null;

    loadTrade();
}

// 검색버튼
function searchTrade() {
    const keyword = document.getElementById('searchInput').value;

    tradeFilter.search_word = keyword;
    tradeFilter.page = 1; // 검색 시 항상 1페이지부터

    loadTrade();
}

document.getElementById('searchInput').addEventListener('keydown', function (e) {
    if (e.key === 'Enter') {
        searchTrade();
    }
});

function setBanner(index) {
    currentBanner = index;
    updateBanner();
}

function prevBanner() {
    currentBanner = (currentBanner - 1 + totalBanners) % totalBanners;
    updateBanner();
}

function nextBanner() {
    currentBanner = (currentBanner + 1) % totalBanners;
    updateBanner();
}

function updateBanner() {
    const slider = document.getElementById('bannerSlider');
    slider.style.transform = `translateX(-${currentBanner * 100}%)`;

    const dots = document.getElementById('bannerDots').children;
    for (let i = 0; i < dots.length; i++) {
        if (i === currentBanner) {
            dots[i].className = 'w-2 h-2 rounded-full transition-all bg-white w-6';
        } else {
            dots[i].className = 'w-2 h-2 rounded-full transition-all bg-white/40 hover:bg-white/60';
        }
    }
}

// Auto-rotate banner
setInterval(nextBanner, 5000);

// Dropdown functionality
let openDropdown = null;

function toggleDropdown(type) {
    const dropdown = document.getElementById(type + 'Dropdown');

    if (openDropdown && openDropdown !== dropdown) {
        openDropdown.classList.add('hidden');
    }

    dropdown.classList.toggle('hidden');
    openDropdown = dropdown.classList.contains('hidden') ? null : dropdown;
}

// Close dropdowns when clicking outside
document.addEventListener('click', function(event) {
    if (!event.target.closest('.relative')) {
        if (openDropdown) {
            openDropdown.classList.add('hidden');
            openDropdown = null;
        }
    }
});
</script>

<jsp:include page="footer.jsp" />
