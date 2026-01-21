<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- 상품 영역만 -->
<c:choose>
    <c:when test="${not empty trades}">
        <div class="grid grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-7 gap-x-4 gap-y-6">
            <c:forEach var="trade" items="${trades}">
                <div onclick="location.href='/trade/${trade.trade_seq}'"
                     class="group flex flex-col cursor-pointer">
                    <!-- 이미지 영역 -->
                    <div class="relative aspect-[1/1.2] overflow-hidden bg-gray-100 rounded-lg border border-gray-200 mb-2 hover:shadow-md transition-all">
                        <img src="${trade.book_img}" alt="${trade.book_title}"
                             class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105" />
                        <div class="absolute top-2 left-2 flex gap-1">
                            <c:choose>
                                <c:when test="${trade.sale_st == 'SOLD'}">
                                    <div class="bg-gray-800/80 backdrop-blur-sm text-white text-[10px] font-bold px-2 py-1 rounded">판매완료</div>
                                </c:when>
                                <c:when test="${trade.sale_st == 'RESERVED'}">
                                    <div class="bg-orange-500/90 backdrop-blur-sm text-white text-[10px] font-bold px-2 py-1 rounded">예약중</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="bg-green-600/90 backdrop-blur-sm text-white text-[10px] font-bold px-2 py-1 rounded">판매중</div>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${trade.book_st == 'NEW'}">
                                <div class="bg-gray-900/80 backdrop-blur-sm text-white text-[10px] font-bold px-2 py-1 rounded">새책</div>
                            </c:if>
                        </div>
                    </div>

                    <!-- 콘텐츠 -->
                    <div class="flex-1 flex flex-col">
                        <h3 class="font-bold text-gray-900 text-base mb-1 line-clamp-1 leading-snug group-hover:text-primary-600 transition-colors">
                            ${trade.book_title}
                        </h3>
                        <div class="text-xs text-gray-500 mb-2 truncate">
                            ${trade.book_author} <c:if test="${not empty trade.book_publisher}"><span class="mx-1 text-gray-300">|</span> ${trade.book_publisher}</c:if>
                        </div>

                        <c:if test="${not empty trade.sale_title}">
                            <p class="text-sm text-gray-700 font-medium mb-2 truncate">${trade.sale_title}</p>
                        </c:if>

                        <div class="mt-auto">
                            <div class="flex items-baseline gap-1.5 mb-2">
                                <span class="font-bold text-lg text-gray-900"><fmt:formatNumber value="${trade.sale_price}" pattern="#,###" /></span>
                                <span class="text-xs text-gray-500">원</span>
                            </div>

                            <div class="flex items-center justify-between border-t border-gray-100 pt-2 text-[11px] text-gray-400">
                                <div class="flex items-center">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-0.5">
                                        <path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0"/>
                                        <circle cx="12" cy="10" r="3"/>
                                    </svg>
                                    <span class="truncate max-w-[60px]">${trade.sale_rg}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- 페이징 -->
        <div class="flex justify-center gap-2 mt-8">
            <c:if test="${currentPage > 1}">
                <a href="javascript:goPage(${currentPage - 1})"
                   class="px-3 py-2 border rounded hover:bg-gray-100">
                    이전
                </a>
            </c:if>

            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="javascript:goPage(${i})"
                   class="px-3 py-2 border rounded ${i == currentPage ? 'bg-primary-500 text-white' : 'hover:bg-gray-100'}">
                    ${i}
                </a>
            </c:forEach>

            <c:if test="${currentPage < totalPages}">
                <a href="javascript:goPage(${currentPage + 1})"
                   class="px-3 py-2 border rounded hover:bg-gray-100">
                    다음
                </a>
            </c:if>
        </div>
    </c:when>
    <c:otherwise>
        <div class="py-20 text-center text-gray-500 bg-white rounded-lg border border-gray-200">
            <p>등록된 상품이 없습니다.</p>
        </div>
    </c:otherwise>
</c:choose>
