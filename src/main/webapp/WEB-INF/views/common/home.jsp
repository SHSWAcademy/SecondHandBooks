<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script src="https://unpkg.com/lucide@latest"></script>

<jsp:include page="header.jsp" />

<div class="space-y-8">

    <div class="relative overflow-hidden rounded-lg shadow-lg h-[320px]" id="bannerCarousel">
        <div class="flex transition-transform duration-500 ease-out h-full" id="bannerSlider">
            <c:choose>
                <c:when test="${not empty bannerList}">
                    <c:forEach var="b" items="${bannerList}" varStatus="st">
                        <div class="w-full flex-shrink-0 p-12 flex items-center relative"
                             style="background: linear-gradient(to right, ${b.bgColorFrom}, ${b.bgColorTo});">

                            <%-- 텍스트 정렬 및 부제목 파싱 로직 (fn:split 버그 수정 버전) --%>
                            <c:set var="alignClass" value="text-left" />
                            <c:set var="realSubtitle" value="${b.subtitle}" />

                            <c:if test="${fn:contains(b.subtitle, '|||')}">
                                <c:set var="parts" value="${fn:split(b.subtitle, '|')}" />
                                <c:set var="alignClass" value="${parts[0]}" />
                                <%-- 배열의 가장 마지막 요소를 실제 내용으로 사용 --%>
                                <c:set var="lastIndex" value="${fn:length(parts) - 1}" />
                                <c:set var="realSubtitle" value="${parts[lastIndex]}" />
                            </c:if>

                            <div class="z-10 text-white max-w-lg w-full ${alignClass}">
                                <i data-lucide="${b.iconName != null ? b.iconName : 'star'}" class="w-12 h-12 text-white/80 mb-4 inline-block"></i>

                                <h1 class="text-4xl font-extrabold mb-4 leading-tight">${b.title}</h1>
                                <p class="text-white/90 text-lg mb-8 font-medium">${realSubtitle}</p>

                                <c:if test="${not empty b.btnLink}">
                                    <a href="${b.btnLink}" class="bg-white text-gray-900 px-6 py-3 rounded-md font-bold text-sm hover:bg-gray-100 transition shadow-md inline-block">
                                            ${b.btnText}
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <div class="w-full flex-shrink-0 bg-gradient-to-r from-gray-700 to-gray-900 p-12 flex items-center relative">
                        <div class="z-10 text-white max-w-lg">
                            <h1 class="text-4xl font-extrabold mb-4">Shinhan Books</h1>
                            <p class="text-white/90 text-lg mb-8">Welcome. Experience better trading.</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="absolute bottom-6 left-12 flex gap-2 z-20" id="bannerDots">
            <c:choose>
                <c:when test="${not empty bannerList}">
                    <c:forEach var="b" items="${bannerList}" varStatus="st">
                        <button onclick="setBanner(${st.index})" class="w-2 h-2 rounded-full transition-all ${st.first ? 'bg-white w-6' : 'bg-white/40 hover:bg-white/60'}"></button>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <button class="w-2 h-2 rounded-full bg-white w-6"></button>
                </c:otherwise>
            </c:choose>
        </div>

        <button onclick="prevBanner()" class="absolute left-4 top-1/2 -translate-y-1/2 bg-white/10 hover:bg-white/20 p-2 rounded-full text-white backdrop-blur-sm transition z-30">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        </button>
        <button onclick="nextBanner()" class="absolute right-4 top-1/2 -translate-y-1/2 bg-white/10 hover:bg-white/20 p-2 rounded-full text-white backdrop-blur-sm transition z-30">
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
                <a href="javascript:void(0)" id="sortNewest" class="transition-colors hover:text-gray-700" onclick="setSort('newest')">최신순</a>
                <span class="text-gray-300">|</span>
                <a href="javascript:void(0)" id="sortPrice" class="transition-colors hover:text-gray-700" onclick="setSort('priceAsc')">낮은가격순</a>
                <span class="text-gray-300">|</span>
                <a href="javascript:void(0)" id="sortLikes" class="transition-colors hover:text-gray-700" onclick="setSort('likeDesc')">인기순</a>
            </div>
        </div>

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
                <div id="conditionDropdown" class="hidden absolute top-full left-0 mt-2 w-48 bg-white rounded-lg shadow-xl border border-gray-100 z-30 py-1">
                    <a href="javascript:selectBookStatus(null, '전체보기')" class="block px-4 py-2.5 text-sm hover:bg-gray-50">전체보기</a>
                    <a href="javascript:selectBookStatus('NEW', '새책')" class="block px-4 py-2.5 text-sm hover:bg-gray-50">새책</a>
                    <a href="javascript:selectBookStatus('LIKE_NEW', '보통')" class="block px-4 py-2.5 text-sm hover:bg-gray-50">보통</a>
                    <a href="javascript:selectBookStatus('GOOD', '좋음')" class="block px-4 py-2.5 text-sm hover:bg-gray-50">좋음</a>
                    <a href="javascript:selectBookStatus('USED', '사용됨')" class="block px-4 py-2.5 text-sm hover:bg-gray-50">사용됨</a>
                </div>
            </div>

            <div class="relative">
                <button onclick="toggleDropdown('saleStatus')" id="saleStatusBtn" class="px-4 py-2 rounded-lg text-sm font-medium transition flex items-center gap-2 border border-gray-200 bg-white text-gray-600 hover:bg-gray-50">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    <span id="saleStatusText">판매중</span>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="transition-transform duration-200"><path d="m6 9 6 6 6-6"/></svg>
                </button>
                <div id="saleStatusDropdown" class="hidden absolute top-full left-0 mt-2 w-48 bg-white rounded-lg shadow-xl border border-gray-100 z-30 py-1">
                    <a href="javascript:selectSaleStatus('SALE', '판매중')" class="block px-4 py-2.5 text-sm hover:bg-gray-50">판매중</a>
                    <a href="javascript:selectSaleStatus('SOLD', '판매완료')" class="block px-4 py-2.5 text-sm hover:bg-gray-50">판매완료</a>
                    <a href="javascript:selectSaleStatus(null, '판매중 & 완료')" class="block px-4 py-2.5 text-sm hover:bg-gray-50">판매중 & 완료</a>
                </div>
            </div>
        </div>
    </div>

    <div id="tradelist" class="mt-10">
        <jsp:include page="/WEB-INF/views/trade/tradelist.jsp" />
    </div>
</div>

<script>
    // --- [1. 배너 로직 (Source 1)] ---
    let currentBanner = 0;
    // JSTL fn:length를 사용하여 리스트 크기를 동적으로 할당 (EL 에러 방지)
    const totalBanners = ${not empty bannerList ? fn:length(bannerList) : 1};
    let openDropdown = null;

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
        if (slider) {
            slider.style.transform = `translateX(-\${currentBanner * 100}%)`;
        }

        const dotsContainer = document.getElementById('bannerDots');
        if (dotsContainer) {
            const dots = dotsContainer.children;
            for (let i = 0; i < dots.length; i++) {
                if (i === currentBanner) {
                    dots[i].className = 'w-2 h-2 rounded-full transition-all bg-white w-6';
                } else {
                    dots[i].className = 'w-2 h-2 rounded-full transition-all bg-white/40 hover:bg-white/60';
                }
            }
        }
    }

    // 배너 자동 롤링
    setInterval(nextBanner, 5000);


    // --- [2. 검색 및 필터 로직 (Source 2)] ---
    const tradeFilter = {
        categorySeq: null,
        book_st: null,
        search_word: null,
        sale_st: 'SALE', // 기본값: 판매중
        page: 1,
        sort: null
    };

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
            data.sort = tradeFilter.sort;
        }

        $.ajax({
            url: '/home',
            type: 'GET',
            data: data,
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            },
            success: function (html, status, xhr) {
                $('#tradelist').html(html);
                const totalCount = xhr.getResponseHeader('X-Total-Count');
                if(totalCount !== null) {
                    $('#tradeTotalCount').text(totalCount + '개');
                }
                openDropdown = null;
            },
            error: function (xhr, status, error) {
                console.error('AJAX 오류:', error);
            }
        });
    }

    // 정렬(Sort) 설정
    function setSort(sortKey) {
        tradeFilter.sort = sortKey === 'newest' ? null : sortKey;
        tradeFilter.page = 1;
        updateSortCss();
        loadTrade();
    }

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
            } else if (tradeFilter.sort === null && link.key === null) {
                el.classList.add('text-gray-900', 'font-bold');
                el.classList.remove('hover:text-gray-700');
            } else {
                el.classList.remove('text-gray-900', 'font-bold');
                el.classList.add('hover:text-gray-700');
            }
        });
    }

    // 카테고리 선택
    function selectCategory(seq, name) {
        tradeFilter.categorySeq = seq;
        tradeFilter.page = 1;
        document.getElementById('categoryText').innerText = name;
        document.getElementById('categoryDropdown').classList.add('hidden');
        openDropdown = null;
        loadTrade();
    }

    // 상태 선택
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

    // 검색 실행
    function searchTrade() {
        const keyword = document.getElementById('searchInput').value;
        tradeFilter.search_word = keyword;
        tradeFilter.page = 1;
        loadTrade();
    }

    // 엔터키 검색 지원
    document.getElementById('searchInput').addEventListener('keydown', function (e) {
        if (e.key === 'Enter') {
            searchTrade();
        }
    });

    // 드롭다운 토글
    function toggleDropdown(type) {
        const dropdown = document.getElementById(type + 'Dropdown');
        if (openDropdown && openDropdown !== dropdown) {
            openDropdown.classList.add('hidden');
        }
        dropdown.classList.toggle('hidden');
        openDropdown = dropdown.classList.contains('hidden') ? null : dropdown;
    }

    // 외부 클릭 시 드롭다운 닫기
    document.addEventListener('click', function(event) {
        if (!event.target.closest('.relative')) {
            if (openDropdown) {
                openDropdown.classList.add('hidden');
                openDropdown = null;
            }
        }
    });

    // 초기화 실행
    updateSortCss();
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }

    // 페이지 로딩 시 초기 데이터 로드 (AJAX)
    $(document).ready(function() {
        loadTrade();
    });
</script>

<jsp:include page="footer.jsp" />