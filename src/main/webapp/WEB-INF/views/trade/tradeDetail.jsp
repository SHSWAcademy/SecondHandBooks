<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="common/header.jsp" />

<div class="max-w-6xl mx-auto py-8">
    <!-- Breadcrumb -->
    <div class="text-xs text-gray-500 mb-4 flex items-center gap-2">
        <a href="/" class="cursor-pointer hover:text-gray-900">홈</a>
        <span>&gt;</span>
        <span class="cursor-pointer hover:text-gray-900">도서</span>
        <span>&gt;</span>
        <span class="cursor-pointer hover:text-gray-900">${book.category_nm}</span>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
        <!-- Left: Images -->
        <div class="space-y-4 select-none">
            <div class="aspect-[1/1.2] bg-gray-100 rounded-lg overflow-hidden border border-gray-200 relative group">
                <!-- 대표 이미지 -->
                <c:choose>
                    <c:when test="${not empty book.imgUrls && book.imgUrls.size() > 0}">
                        <img id="mainImage" src="${book.imgUrls[0]}" alt="${book.book_title}" class="w-full h-full object-contain p-4 bg-white" />
                    </c:when>
                    <c:otherwise>
                        <img id="mainImage" src="${book.book_img}" alt="${book.book_title}" class="w-full h-full object-contain p-4 bg-white" />
                    </c:otherwise>
                </c:choose>

                <!-- 이미지 슬라이더 (여러 이미지가 있을 경우) -->
                <c:if test="${not empty book.imgUrls && book.imgUrls.size() > 1}">
                    <button onclick="prevImage()" class="absolute left-2 top-1/2 -translate-y-1/2 bg-white/80 hover:bg-white text-gray-800 p-2 rounded-full shadow-md opacity-0 group-hover:opacity-100 transition-all duration-200 active:scale-95 z-20">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m15 18-6-6 6-6"/></svg>
                    </button>
                    <button onclick="nextImage()" class="absolute right-2 top-1/2 -translate-y-1/2 bg-white/80 hover:bg-white text-gray-800 p-2 rounded-full shadow-md opacity-0 group-hover:opacity-100 transition-all duration-200 active:scale-95 z-20">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg>
                    </button>
                    <div id="imageIndicator" class="absolute bottom-4 left-1/2 -translate-x-1/2 bg-black/50 text-white px-3 py-1 rounded-full text-xs font-bold backdrop-blur-sm z-10">
                        1 / ${book.imgUrls.size()}
                    </div>
                </c:if>
            </div>

            <!-- Thumbnail List -->
            <c:if test="${not empty book.imgUrls && book.imgUrls.size() > 1}">
                <div class="flex gap-2 overflow-x-auto pb-1">
                    <c:forEach var="img" items="${book.imgUrls}" varStatus="status">
                        <div onclick="setImage(${status.index})" class="w-20 h-20 rounded-md overflow-hidden cursor-pointer border-2 flex-shrink-0 transition-all ${status.index == 0 ? 'border-blue-500 ring-2 ring-blue-100 opacity-100' : 'border-transparent opacity-60 hover:opacity-100'}" id="thumb-${status.index}">
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
                        ${book.sale_title}
                    </h1>
                </div>

                <!-- 도서 정보 -->
                <div class="flex items-center gap-2 text-sm text-gray-500 mb-6 bg-gray-50 p-3 rounded-lg border border-gray-100">
                    <span class="font-bold text-gray-800">${book.book_title}</span>
                    <span class="text-gray-300">|</span>
                    <span>${book.book_author}</span>
                    <span class="text-gray-300">|</span>
                    <span>${book.book_publisher}</span>
                </div>

                <!-- 가격 -->
                <div class="flex items-baseline gap-2 mb-2">
                    <span class="text-4xl font-bold text-gray-900">
                        <fmt:formatNumber value="${book.sale_price}" pattern="#,###" />
                    </span>
                    <span class="text-xl text-gray-500">원</span>
                    
                    <c:set var="discountRate" value="${((book.book_org_price - book.sale_price) / book.book_org_price) * 100}" />
                    <c:if test="${discountRate > 0}">
                        <div class="ml-2 flex items-center text-red-500 gap-1">
                            <span class="text-2xl font-bold"><fmt:formatNumber value="${discountRate}" pattern="#" />%</span>
                            <span class="text-sm text-gray-400 line-through">
                                <fmt:formatNumber value="${book.book_org_price}" pattern="#,###" />원
                            </span>
                        </div>
                    </c:if>
                </div>

                <!-- 배송 & 상태 -->
                <div class="flex flex-col gap-2 mt-4 text-sm text-gray-600">
                    <div class="flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2"/><circle cx="17" cy="18" r="2"/><circle cx="7" cy="18" r="2"/></svg>
                        <span>배송비 
                            <c:choose>
                                <c:when test="${book.delivery_co > 0}">
                                    <fmt:formatNumber value="${book.delivery_co}" pattern="#,###" />원
                                </c:when>
                                <c:otherwise>무료</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>
                        <span>상태: <span class="font-bold text-blue-600">${book.book_st}</span></span>
                    </div>
                    <div class="flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0"/><circle cx="12" cy="10" r="3"/></svg>
                        <span>거래지역: ${book.book_sale_region}</span>
                    </div>
                </div>
            </div>

            <!-- Description -->
            <div class="mb-8 flex-1">
                <h3 class="font-bold text-gray-900 mb-3">상품 설명</h3>
                <p class="text-gray-700 leading-relaxed whitespace-pre-wrap">${book.sale_cont}</p>
            </div>

            <!-- Seller Info -->
            <div class="flex items-center gap-3 bg-gray-50 p-4 rounded-lg mb-6 border border-gray-100">
                <div class="w-12 h-12 bg-gray-200 rounded-full overflow-hidden flex-shrink-0">
                    <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=${book.recipient_nm}" alt="seller" class="w-full h-full object-cover"/>
                </div>
                <div>
                    <p class="text-xs text-gray-500 mb-0.5">판매자</p>
                    <p class="font-bold text-gray-900">${book.recipient_nm}</p>
                </div>
            </div>

            <!-- Actions -->
            <div class="flex gap-3 sticky bottom-0 bg-white py-4 border-t border-gray-100 md:static md:border-0 md:py-0">
                <button onclick="toggleWishlist()" id="wishlistBtn" class="flex flex-col items-center justify-center w-16 h-14 border rounded-md transition border-gray-300 text-gray-400 hover:bg-gray-50">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" id="heartIcon">
                        <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.29 1.51 4.04 3 5.5l7 7Z"/>
                    </svg>
                    <span class="text-[10px] font-bold mt-0.5">${book.wish_cnt}</span>
                </button>
                <button class="flex-1 bg-blue-600 text-white font-bold rounded-md hover:bg-blue-700 transition flex items-center justify-center gap-2 shadow-sm">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M7.9 20A9 9 0 1 0 4 16.1L2 22Z"/>
                    </svg>
                    채팅하기
                </button>
            </div>
        </div>
    </div>
</div>

<script>
const bookImages = [
    <c:choose>
        <c:when test="${not empty book.imgUrls}">
            <c:forEach var="img" items="${book.imgUrls}" varStatus="status">
                "${img}"<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        </c:when>
        <c:otherwise>
            "${book.book_img}"
        </c:otherwise>
    </c:choose>
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
    const indicator = document.getElementById('imageIndicator');
    if (indicator) {
        indicator.textContent = (currentImageIndex + 1) + ' / ' + bookImages.length;
    }

    // Update thumbnails
    for (let i = 0; i < bookImages.length; i++) {
        const thumb = document.getElementById('thumb-' + i);
        if (thumb) {
            if (i === currentImageIndex) {
                thumb.className = 'w-20 h-20 rounded-md overflow-hidden cursor-pointer border-2 flex-shrink-0 transition-all border-blue-500 ring-2 ring-blue-100 opacity-100';
            } else {
                thumb.className = 'w-20 h-20 rounded-md overflow-hidden cursor-pointer border-2 flex-shrink-0 transition-all border-transparent opacity-60 hover:opacity-100';
            }
        }
    }
}

function toggleWishlist() {
    alert('찜하기 기능이 추가/제거되었습니다.');
}
</script>

<jsp:include page="common/footer.jsp" />