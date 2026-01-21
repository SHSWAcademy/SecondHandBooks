<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div>
    <h2 class="text-xl font-bold text-gray-900 mb-6">찜한 상품</h2>

    <c:choose>
        <c:when test="${empty wishlist}">
            <div class="text-center py-12 bg-white border border-gray-200 border-dashed rounded-lg text-gray-500 text-sm">
                <i data-lucide="heart" class="w-16 h-16 text-gray-300 mx-auto mb-3"></i>
                <p class="text-gray-500 text-sm">찜한 상품이 없습니다.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                <c:forEach var="item" items="${wishlist}">
                    <!-- 상품 카드 -->
                    <div class="bg-white border border-gray-200 rounded-lg p-4">
                        <div class="aspect-square bg-gray-100 rounded mb-3 flex items-center justify-center">
                            <i data-lucide="book" class="w-12 h-12 text-gray-300"></i>
                        </div>
                        <h3 class="font-bold text-sm mb-1">${item.product_title}</h3>
                        <p class="text-sm text-gray-700">${item.product_price}원</p>
                     </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    lucide.createIcons();
</script>