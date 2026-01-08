<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="common/header.jsp" />

<div class="space-y-8">
    <!-- Carousel Hero Banner -->
    <div class="relative overflow-hidden rounded-lg shadow-lg h-[320px]" id="bannerCarousel">
        <div class="flex transition-transform duration-500 ease-out h-full" id="bannerSlider">
            <!-- Banner 1 -->
            <div class="w-full flex-shrink-0 bg-gradient-to-r from-primary-600 to-blue-500 p-12 flex items-center relative">
                <div class="z-10 text-white max-w-lg">
                    <svg class="w-12 h-12 text-blue-200 mb-4 opacity-80" xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10"/></svg>
                    <h1 class="text-4xl font-extrabold mb-4 leading-tight">신뢰할 수 있는 중고 거래</h1>
                    <p class="text-white/90 text-lg mb-8 font-medium">금융의 안전함을 책 거래에도 담았습니다.</p>
                    <a href="/safetyGuide" class="bg-white text-gray-900 px-6 py-3 rounded-md font-bold text-sm hover:bg-gray-100 transition shadow-md inline-block">안전결제 알아보기</a>
                </div>
            </div>

            <!-- Banner 2 -->
            <div class="w-full flex-shrink-0 bg-gradient-to-r from-emerald-500 to-teal-600 p-12 flex items-center relative">
                <div class="z-10 text-white max-w-lg">
                    <svg class="w-12 h-12 text-emerald-200 mb-4 opacity-80" xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9.937 15.5A2 2 0 0 0 8.5 14.063l-6.135-1.582a.5.5 0 0 1 0-.962L8.5 9.936A2 2 0 0 0 9.937 8.5l1.582-6.135a.5.5 0 0 1 .963 0L14.063 8.5A2 2 0 0 0 15.5 9.937l6.135 1.581a.5.5 0 0 1 0 .964L15.5 14.063a2 2 0 0 0-1.437 1.437l-1.582 6.135a.5.5 0 0 1-.963 0z"/></svg>
                    <h1 class="text-4xl font-extrabold mb-4 leading-tight">지금 팔면 수수료 0원</h1>
                    <p class="text-white/90 text-lg mb-8 font-medium">잠자는 책장을 깨우는 가장 현명한 방법</p>
                    <a href="/sellingGuide" class="bg-white text-gray-900 px-6 py-3 rounded-md font-bold text-sm hover:bg-gray-100 transition shadow-md inline-block">내 물건 팔기</a>
                </div>
            </div>

            <!-- Banner 3 -->
            <div class="w-full flex-shrink-0 bg-gradient-to-r from-violet-500 to-purple-600 p-12 flex items-center relative">
                <div class="z-10 text-white max-w-lg">
                    <svg class="w-12 h-12 text-violet-200 mb-4 opacity-80" xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20"/></svg>
                    <h1 class="text-4xl font-extrabold mb-4 leading-tight">Shinhan Books 오픈 이벤트</h1>
                    <p class="text-white/90 text-lg mb-8 font-medium">첫 거래 완료 시 스타벅스 쿠폰 증정!</p>
                    <a href="/event" class="bg-white text-gray-900 px-6 py-3 rounded-md font-bold text-sm hover:bg-gray-100 transition shadow-md inline-block">이벤트 참여하기</a>
                </div>
            </div>
        </div>

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
                <span class="text-sm font-normal text-gray-500 bg-gray-100 px-2 py-0.5 rounded-full">${books.size()}개</span>
            </h2>
            <div class="flex gap-4 text-sm text-gray-500 font-medium">
                <a href="/home?sort=newest" class="transition-colors ${param.sort == 'newest' || empty param.sort ? 'text-gray-900 font-bold' : 'hover:text-gray-700'}">최신순</a>
                <span class="text-gray-300">|</span>
                <a href="/home?sort=priceAsc" class="transition-colors ${param.sort == 'priceAsc' ? 'text-gray-900 font-bold' : 'hover:text-gray-700'}">낮은가격순</a>
                <span class="text-gray-300">|</span>
                <a href="/home?sort=likes" class="transition-colors ${param.sort == 'likes' ? 'text-gray-900 font-bold' : 'hover:text-gray-700'}">인기순</a>
            </div>
        </div>

        <!-- Filter Toolbar -->
        <div class="flex gap-3 -mt-2">
            <!-- Category Filter -->
            <div class="relative">
                <button onclick="toggleDropdown('category')" id="categoryBtn" class="px-4 py-2 rounded-lg text-sm font-medium transition flex items-center gap-2 border border-gray-200 bg-white text-gray-600 hover:bg-gray-50">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20"/></svg>
                    <span>카테고리</span>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="transition-transform duration-200"><path d="m6 9 6 6 6-6"/></svg>
                </button>

                <div id="categoryDropdown" class="hidden absolute top-full left-0 mt-2 w-48 bg-white rounded-lg shadow-xl border border-gray-100 z-30 py-1 max-h-[300px] overflow-y-auto">
                    <a href="/home?category=All" class="block w-full text-left px-4 py-2.5 text-sm hover:bg-gray-50 text-gray-700">전체</a>
                    <c:forEach var="category" items="${categories}">
                        <a href="/home?category=${category}" class="block w-full text-left px-4 py-2.5 text-sm hover:bg-gray-50 text-gray-700">${category}</a>
                    </c:forEach>
                </div>
            </div>

            <!-- Condition Filter -->
            <div class="relative">
                <button onclick="toggleDropdown('condition')" id="conditionBtn" class="px-4 py-2 rounded-lg text-sm font-medium transition flex items-center gap-2 border border-gray-200 bg-white text-gray-600 hover:bg-gray-50">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg>
                    <span>상품 상태</span>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="transition-transform duration-200"><path d="m6 9 6 6 6-6"/></svg>
                </button>

                <div id="conditionDropdown" class="hidden absolute top-full left-0 mt-2 w-48 bg-white rounded-lg shadow-xl border border-gray-100 z-30 py-1">
                    <a href="/home?condition=All" class="block w-full text-left px-4 py-2.5 text-sm hover:bg-gray-50 text-gray-700">전체보기</a>
                    <a href="/home?condition=New" class="block w-full text-left px-4 py-2.5 text-sm hover:bg-gray-50 text-gray-700">✨ 새상품</a>
                    <a href="/home?condition=Like New" class="block w-full text-left px-4 py-2.5 text-sm hover:bg-gray-50 text-gray-700">💎 사용감 없음</a>
                    <a href="/home?condition=Good" class="block w-full text-left px-4 py-2.5 text-sm hover:bg-gray-50 text-gray-700">👍 사용감 적음</a>
                    <a href="/home?condition=Fair" class="block w-full text-left px-4 py-2.5 text-sm hover:bg-gray-50 text-gray-700">🌿 사용감 많음</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Product Grid - 5 Columns -->
    <c:choose>
        <c:when test="${not empty books}">
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-x-5 gap-y-8">
                <c:forEach var="book" items="${books}">
                    <div onclick="location.href='/productDetail?id=${book.id}'" class="group flex flex-col cursor-pointer">
                        <!-- Image Container -->
                        <div class="relative aspect-[1/1.2] overflow-hidden bg-gray-100 rounded-lg border border-gray-200 mb-3 hover:shadow-md transition-all">
                            <img src="${book.images[0]}" alt="${book.title}" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105" />
                            <div class="absolute top-2 left-2 flex gap-1">
                                <c:choose>
                                    <c:when test="${book.resellState == 'SOLD'}">
                                        <div class="bg-gray-800/80 backdrop-blur-sm text-white text-[10px] font-bold px-2 py-1 rounded">판매완료</div>
                                    </c:when>
                                    <c:when test="${book.resellState == 'RESERVED'}">
                                        <div class="bg-orange-500/90 backdrop-blur-sm text-white text-[10px] font-bold px-2 py-1 rounded">예약중</div>
                                    </c:when>
                                    <c:when test="${book.resellState == 'ON_SALE'}">
                                        <div class="bg-green-600/90 backdrop-blur-sm text-white text-[10px] font-bold px-2 py-1 rounded">판매중</div>
                                    </c:when>
                                </c:choose>
                                <c:if test="${book.condition == 'New'}">
                                    <div class="bg-gray-900/80 backdrop-blur-sm text-white text-[10px] font-bold px-2 py-1 rounded">새상품</div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Content -->
                        <div class="flex-1 flex flex-col">
                            <h3 class="font-bold text-gray-900 text-base mb-1 line-clamp-1 leading-snug group-hover:text-primary-600 transition-colors">
                                ${book.title}
                            </h3>
                            <div class="text-xs text-gray-500 mb-2 truncate">
                                ${book.author} <c:if test="${not empty book.publisher}"><span class="mx-1 text-gray-300">|</span> ${book.publisher}</c:if>
                            </div>

                            <c:if test="${not empty book.postTitle}">
                                <p class="text-sm text-gray-700 font-medium mb-2 truncate">${book.postTitle}</p>
                            </c:if>

                            <div class="mt-auto">
                                <div class="flex items-baseline gap-1.5 mb-2">
                                    <span class="font-bold text-lg text-gray-900"><fmt:formatNumber value="${book.price}" pattern="#,###" /></span>
                                    <span class="text-xs text-gray-500">원</span>
                                </div>

                                <div class="flex items-center justify-between border-t border-gray-100 pt-2 text-[11px] text-gray-400">
                                    <div class="flex items-center">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-0.5"><path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0"/><circle cx="12" cy="10" r="3"/></svg>
                                        <span class="truncate max-w-[60px]">${book.location}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="py-20 text-center text-gray-500 bg-white rounded-lg border border-gray-200">
                <p>검색 결과가 없습니다.</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
// Banner carousel
let currentBanner = 0;
const totalBanners = 3;

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

<jsp:include page="common/footer.jsp" />
