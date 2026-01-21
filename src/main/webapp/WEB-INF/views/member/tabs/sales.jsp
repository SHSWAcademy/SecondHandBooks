<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="space-y-4">
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-bold text-gray-900">판매 내역</h2>

        <select id="status-filter"
                class="text-sm border border-gray-300 rounded px-3 py-2 outline-none focus:border-primary-500">
            <option value="all" ${selectedStatus == 'all' ? 'selected' : ''}>전체</option>
            <option value="PENDING" ${selectedStatus == 'SALES' ? 'selected' : ''}>판매중</option>
            <option value="SHIPPING" ${selectedStatus == 'RESERVE' ? 'selected' : ''}>예약중</option>
            <option value="COMPLETED" ${selectedStatus == 'SOLD' ? 'selected' : ''}>판매완료</option>
        </select>
    </div>

    <!-- 데이터가 없을 때 -->
    <c:if test="${empty saleList}">
        <div class="text-center py-12 bg-white border border-gray-200 border-dashed rounded-lg">
            <i data-lucide="store" class="w-16 h-16 text-gray-300 mx-auto mb-3"></i>
            <p class="text-gray-500 text-sm">판매 내역이 없습니다.</p>
        </div>
    </c:if>

    <!-- 데이터가 있을 때 -->
    <c:forEach var="trade" items="${saleList}">
        <div class="bg-white p-5 rounded-lg border border-gray-200 flex gap-4 items-center">
            <div class="w-16 h-20 bg-gray-100 rounded border border-gray-100 flex items-center justify-center text-gray-400">
                <c:choose>
                    <%-- 업로드한 이미지 우선 --%>
                    <c:when test="${not empty trade.trade_img and not empty trade.trade_img[0].img_url}">
                        <img src="${trade.trade_img[0].img_url}" alt="${trade.sale_title}"
                             class="w-full h-full object-cover rounded" />
                    </c:when>
                    <%-- 없으면 책 표지 이미지 --%>
                    <c:when test="${not empty trade.book_img}">
                        <img src="${trade.book_img}" alt="${trade.sale_title}"
                             class="w-full h-full object-cover rounded" />
                    </c:when>
                    <%-- 둘 다 없으면 아이콘 --%>
                    <c:otherwise>
                        <i data-lucide="book" class="w-6 h-6"></i>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="flex-1">
                <div class="flex justify-between mb-1">
                    <span class="text-xs font-bold text-gray-500">
                        <c:choose>
                            <c:when test="${not empty trade.sale_st_dtm}">
                                <fmt:formatDate value="${trade.sale_st_dtm}" pattern="yyyy.MM.dd" />
                            </c:when>
                            <c:otherwise>
                                <fmt:formatDate value="${trade.crt_dtm}" pattern="yyyy.MM.dd"/>
                            </c:otherwise>
                        </c:choose>
                    </span>

                    <span class="text-xs font-bold px-2 py-0.5 rounded bg-primary-50 text-primary-600">
                        <c:choose>
                            <c:when test="${trade.sale_st == 'SALE'}">판매중</c:when>
                            <c:when test="${trade.sale_st == 'RESERVE'}">예약중</c:when>
                            <c:when test="${trade.sale_st == 'SOLD'}">판매완료</c:when>
                            <c:otherwise>${trade.sale_st}</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <h3 class="font-bold text-gray-900 mb-1">${trade.sale_title}</h3>

                <p class="text-sm text-gray-700">
                    <fmt:formatNumber value="${trade.sale_price}" pattern="#,###" />원
                </p>
            </div>

            <button onclick="location.href='/trade/${trade.trade_seq}'"
                    class="text-xs bg-primary-600 text-white px-3 py-2 rounded font-bold hover:bg-primary-700">상세보기</button>
        </div>
    </c:forEach>
</div>

<script>
    document.getElementById('status-filter').addEventListener('change', function() {
        const status = this.value;
        window.loadTab('sales', {status: status});
     });
    lucide.createIcons();
</script>