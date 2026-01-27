<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="/resources/js/paging/paging.js"></script>

<jsp:include page="../common/header.jsp" />

<main class="bg-[#f9fafb] min-h-screen py-12">
    <div class="max-w-5xl mx-auto px-4">

        <div class="mb-10 ml-2">
            <h2 class="text-2xl md:text-3xl font-bold text-gray-900 tracking-tight">공지사항</h2>
            <p class="mt-2 text-gray-500 text-sm md:text-base">신한북스의 소식을 가장 빠르게 전달해 드립니다.</p>
        </div>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <div id="userNoticeList" class="divide-y divide-gray-50">
                <c:forEach var="notice" items="${result.list}">
                    <div class="group flex items-center justify-between py-5 px-6 md:px-8 cursor-pointer hover:bg-gray-50/80 transition-all"
                         onclick="location.href='/notice/view?notice_seq=${notice.notice_seq}'">

                        <div class="flex items-center gap-4 flex-1 min-w-0">
                            <c:if test="${notice.notice_priority == 1}">
                                <span class="flex-shrink-0 px-2 py-1 bg-red-50 text-red-500 text-[10px] font-bold rounded uppercase">중요</span>
                            </c:if>
                            <h3 class="text-base md:text-[17px] text-gray-800 font-medium group-hover:text-green-600 transition-colors truncate">
                                <c:out value="${notice.notice_title}" />
                            </h3>
                        </div>

                        <div class="flex-shrink-0 ml-4 text-[13px] text-gray-400 font-normal">
                            ${notice.crtDtmFormatted}
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty result.list}">
                    <div class="py-24 text-center">
                        <p class="text-gray-400">등록된 공지사항이 없습니다.</p>
                    </div>
                </c:if>
            </div>
        </div>

        <div id="userPagination" class="mt-10 flex justify-center"></div>
    </div>
</main>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 컨트롤러에서 model.addAttribute("result", result) 로 보냈을 경우
        renderCommonPagination(
            'userPagination',
            ${result.total},
            ${result.curPage},
            ${result.size},
            'goToPage'
        );
    });

    function goToPage(page) {
        // 기존 검색 조건이 유지되도록 location.search를 활용하는 것이 좋지만,
        // 지금은 검색이 없으므로 단순 이동도 괜찮습니다.
        location.href = '/notice?page=' + page;
    }
</script>