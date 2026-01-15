<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp" />

<div class="max-w-6xl mx-auto py-8">
    <!-- Breadcrumb -->
    <div class="text-xs text-gray-500 mb-4 flex items-center gap-2">
        <a href="/home" class="cursor-pointer hover:text-gray-900">홈</a>
        <span>&gt;</span>
        <span class="cursor-pointer hover:text-gray-900">도서</span>
        <span>&gt;</span>
        <span class="cursor-pointer hover:text-gray-900">${book.category}</span>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
        <!-- Left: Images -->
        <div class="space-y-4 select-none">
            <div class="aspect-[1/1.2] bg-gray-100 rounded-lg overflow-hidden border border-gray-200 relative group">
                <img id="mainImage" src="${book.images[0]}" alt="${book.title}" class="w-full h-full object-contain p-4 bg-white" />

                <c:if test="${book.type == 'PURCHASE_REQUEST'}">
                    <div class="absolute top-4 left-4 bg-teal-600 text-white font-bold px-3 py-1.5 rounded-md shadow-sm z-10">구합니다</div>
                </c:if>

                <!-- Slider Arrows -->
                <c:if test="${book.images.size() > 1}">
                    <button onclick="prevImage()" class="absolute left-2 top-1/2 -translate-y-1/2 bg-white/80 hover:bg-white text-gray-800 p-2 rounded-full shadow-md opacity-0 group-hover:opacity-100 transition-all duration-200 active:scale-95 z-20">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
                    </button>
                    <button onclick="nextImage()" class="absolute right-2 top-1/2 -translate-y-1/2 bg-white/80 hover:bg-white text-gray-800 p-2 rounded-full shadow-md opacity-0 group-hover:opacity-100 transition-all duration-200 active:scale-95 z-20">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>
                    </button>

                    <!-- Page Indicator -->
                    <div id="imageIndicator" class="absolute bottom-4 left-1/2 -translate-x-1/2 bg-black/50 text-white px-3 py-1 rounded-full text-xs font-bold backdrop-blur-sm z-10">
                        1 / ${book.images.size()}
                    </div>
                </c:if>
            </div>

            <!-- Thumbnail List -->
            <c:if test="${book.images.size() > 1}">
                <div class="flex gap-2 overflow-x-auto pb-1">
                    <c:forEach var="img" items="${book.images}" varStatus="status">
                        <div onclick="setImage(${status.index})" class="w-20 h-20 rounded-md overflow-hidden cursor-pointer border-2 flex-shrink-0 transition-all ${status.index == 0 ? 'border-primary-500 ring-2 ring-primary-100 opacity-100' : 'border-transparent opacity-60 hover:opacity-100'}" id="thumb-${status.index}">
                            <img src="${img}" alt="thumb-${status.index}" class="w-full h-full object-cover"/>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>

        <!-- Right: Info -->
        <div class="flex flex-col h-full">
            <div class="border-b border-gray-200 pb-6 mb-6">
                <div class="flex justify-between items-start mb-4">
                    <h1 class="text-2xl font-bold text-gray-900 leading-tight">
                        ${not empty book.postTitle ? book.postTitle : book.title}
                    </h1>
                    <div class="flex gap-3 text-gray-400 flex-shrink-0 ml-4">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="cursor-pointer hover:text-gray-600"><path d="M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8"/><polyline points="16 6 12 2 8 6"/><line x1="12" x2="12" y1="2" y2="15"/></svg>
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="cursor-pointer hover:text-gray-600"><path d="M3 3h7v7H3z"/><path d="M14 3h7v7h-7z"/><path d="M14 14h7v7h-7z"/><path d="M3 14h7v7H3z"/></svg>
                    </div>
                </div>

                <div class="flex items-center gap-2 text-sm text-gray-500 mb-6 bg-gray-50 p-3 rounded-lg border border-gray-100">
                    <span class="font-bold text-gray-800">${book.title}</span>
                    <span class="text-gray-300">|</span>
                    <span>${book.author}</span>
                    <span class="text-gray-300">|</span>
                    <span>${book.publisher}</span>
                </div>

                <div class="flex items-baseline gap-2 mb-2">
                    <span class="text-4xl font-bold ${book.type == 'PURCHASE_REQUEST' ? 'text-teal-600' : 'text-gray-900'}">
                        <fmt:formatNumber value="${book.price}" pattern="#,###" />
                    </span>
                    <span class="text-xl text-gray-500">원</span>
                    <c:if test="${book.type != 'PURCHASE_REQUEST'}">
                        <c:set var="discountRate" value="${((book.originalPrice - book.price) / book.originalPrice) * 100}" />
                        <c:if test="${discountRate > 0}">
                            <div class="ml-2 flex items-center text-red-500 gap-1">
                                <span class="text-2xl font-bold"><fmt:formatNumber value="${discountRate}" pattern="#" />%</span>
                                <span class="text-sm text-gray-400 line-through"><fmt:formatNumber value="${book.originalPrice}" pattern="#,###" />원</span>
                            </div>
                        </c:if>
                    </c:if>
                </div>

                <!-- Shipping & Condition -->
                <div class="flex flex-col gap-2 mt-4 text-sm text-gray-600">
                    <div class="flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2"/><path d="M15 18H9"/><path d="M19 18h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.624l-3.48-4.35A1 1 0 0 0 17.52 8H14"/><circle cx="17" cy="18" r="2"/><circle cx="7" cy="18" r="2"/></svg>
                        <span>배송비 ${book.shippingFee > 0 ? book.shippingFee : '무료'}<c:if test="${book.shippingFee > 0}">원</c:if></span>
                    </div>
                    <div class="flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>
                        <span>상태: <span class="font-bold text-primary-600">
                            <c:choose>
                                <c:when test="${book.condition == 'New'}">새상품</c:when>
                                <c:when test="${book.condition == 'Like New'}">사용감 없음</c:when>
                                <c:when test="${book.condition == 'Good'}">사용감 적음</c:when>
                                <c:otherwise>사용감 많음</c:otherwise>
                            </c:choose>
                        </span></span>
                    </div>
                    <div class="flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0"/><circle cx="12" cy="10" r="3"/></svg>
                        <span>거래지역: ${book.location}</span>
                    </div>
                </div>
            </div>

            <!-- Description -->
            <div class="mb-8 flex-1">
                <h3 class="font-bold text-gray-900 mb-3">상품 설명</h3>
                <p class="text-gray-700 leading-relaxed whitespace-pre-wrap">${book.description}</p>
            </div>

            <!-- Seller Info -->
            <div class="flex items-center gap-3 bg-gray-50 p-4 rounded-lg mb-6 border border-gray-100">
                <div class="w-12 h-12 bg-gray-200 rounded-full overflow-hidden flex-shrink-0">
                    <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=${book.sellerId}" alt="seller" class="w-full h-full object-cover"/>
                </div>
                <div>
                    <p class="text-xs text-gray-500 mb-0.5">판매자</p>
                    <p class="font-bold text-gray-900">${book.sellerName}</p>
                </div>
            </div>

            <c:if test="${book.type != 'PURCHASE_REQUEST'}">
                <div class="flex items-center gap-2 text-xs text-gray-400 bg-gray-50 p-3 rounded mb-6">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="flex-shrink-0"><circle cx="12" cy="12" r="10"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg>
                    <span>안전결제 시스템을 이용하지 않은 거래로 발생하는 피해에 대해서는 책임지지 않습니다.</span>
                </div>
            </c:if>

            <!-- Actions -->
            <div class="flex gap-3 sticky bottom-0 bg-white py-4 border-t border-gray-100 md:static md:border-0 md:py-0">
                <button onclick="toggleWishlist()" id="wishlistBtn" class="flex flex-col items-center justify-center w-16 h-14 border rounded-md transition border-gray-300 text-gray-400 hover:bg-gray-50">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" id="heartIcon"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.29 1.51 4.04 3 5.5l7 7Z"/></svg>
                    <span class="text-[10px] font-bold mt-0.5">${book.likes}</span>
                </button>
                <a href="${not empty user ? '/chat' : '/login'}" class="flex-1 bg-primary-600 text-white font-bold rounded-md hover:bg-primary-700 transition flex items-center justify-center gap-2 shadow-sm">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M7.9 20A9 9 0 1 0 4 16.1L2 22Z"/></svg>
                    채팅하기
                </a>
            </div>
        </div>
    </div>
</div>

<script>
const bookImages = [
    <c:forEach var="img" items="${book.images}" varStatus="status">
        "${img}"<c:if test="${!status.last}">,</c:if>
    </c:forEach>
];
let currentImageIndex = 0;

function setImage(index) {
    currentImageIndex = index;
    updateImage();
}

function prevImage() {
    currentImageIndex = (currentImageIndex - 1 + bookImages.length) % bookImages.length;
    updateImage();
}

function nextImage() {
    currentImageIndex = (currentImageIndex + 1) % bookImages.length;
    updateImage();
}

function updateImage() {
    document.getElementById('mainImage').src = bookImages[currentImageIndex];
    document.getElementById('imageIndicator').textContent = (currentImageIndex + 1) + ' / ' + bookImages.length;

    // Update thumbnails
    for (let i = 0; i < bookImages.length; i++) {
        const thumb = document.getElementById('thumb-' + i);
        if (i === currentImageIndex) {
            thumb.className = 'w-20 h-20 rounded-md overflow-hidden cursor-pointer border-2 flex-shrink-0 transition-all border-primary-500 ring-2 ring-primary-100 opacity-100';
        } else {
            thumb.className = 'w-20 h-20 rounded-md overflow-hidden cursor-pointer border-2 flex-shrink-0 transition-all border-transparent opacity-60 hover:opacity-100';
        }
    }
}

function toggleWishlist() {
    <c:choose>
        <c:when test="${empty user}">
            if (confirm('찜하기 기능은 로그인이 필요합니다. 로그인 하시겠습니까?')) {
                location.href = '/login';
            }
        </c:when>
        <c:otherwise>
            // AJAX call to toggle wishlist
            alert('찜하기 기능이 추가/제거되었습니다.');
        </c:otherwise>
    </c:choose>
}
</script>

<jsp:include page="../common/footer.jsp" />
