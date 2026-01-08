<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="common/header.jsp" />

<div class="max-w-6xl mx-auto">
    <h1 class="text-2xl font-bold mb-8">찜한 상품</h1>

    <c:choose>
        <c:when test="${not empty wishlistBooks}">
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-x-5 gap-y-8">
                <c:forEach var="book" items="${wishlistBooks}">
                    <div onclick="location.href='/productDetail?id=${book.id}'" class="group flex flex-col cursor-pointer">
                        <div class="relative aspect-[1/1.2] overflow-hidden bg-gray-100 rounded-lg border border-gray-200 mb-3 hover:shadow-md transition-all">
                            <img src="${book.images[0]}" alt="${book.title}" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105" />
                            <div class="absolute top-2 right-2">
                                <button onclick="event.stopPropagation(); removeWishlist('${book.id}')" class="bg-white p-1.5 rounded-full shadow-sm">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="red" stroke="red" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.29 1.51 4.04 3 5.5l7 7Z"/></svg>
                                </button>
                            </div>
                        </div>

                        <div class="flex-1 flex flex-col">
                            <h3 class="font-bold text-gray-900 text-base mb-1 line-clamp-1">${book.title}</h3>
                            <div class="text-xs text-gray-500 mb-2">${book.author}</div>
                            <div class="mt-auto">
                                <div class="flex items-baseline gap-1.5">
                                    <span class="font-bold text-lg text-gray-900"><fmt:formatNumber value="${book.price}" pattern="#,###" /></span>
                                    <span class="text-xs text-gray-500">원</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="py-20 text-center bg-white rounded-lg border border-gray-200">
                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mx-auto mb-4 text-gray-300"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.29 1.51 4.04 3 5.5l7 7Z"/></svg>
                <p class="text-gray-500 mb-4">찜한 상품이 없습니다</p>
                <a href="/home" class="inline-block bg-primary-500 text-white px-6 py-2.5 rounded-md font-bold hover:bg-primary-600 transition text-sm">
                    상품 둘러보기
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
function removeWishlist(bookId) {
    if (confirm('찜 목록에서 제거하시겠습니까?')) {
        // AJAX call to remove from wishlist
        location.reload();
    }
}
</script>

<jsp:include page="common/footer.jsp" />
