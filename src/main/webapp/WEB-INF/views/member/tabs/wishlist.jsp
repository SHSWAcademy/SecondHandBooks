<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div>
    <h2 class="text-xl font-bold text-gray-900 mb-6">찜한 상품</h2>

    <c:choose>
        <c:when test="${empty wishlist}">
            <div class="text-center py-12 bg-white border border-gray-200 border-dashed rounded-lg text-gray-500 text-sm">
                찜한 상품이 없습니다.
            </div>
        </c:when>
        <c:otherwise>
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                <c:forEach var="item" items="${wishlist}">
                    <!-- 상품 카드 -->
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>