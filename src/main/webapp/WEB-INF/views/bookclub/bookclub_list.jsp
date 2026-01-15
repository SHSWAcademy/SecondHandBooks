<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <title>독서모임 목록 - 신한북스</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bookclub.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="bookclub-main">
        <div class="container">
            <div class="page-header">
                <h1>독서모임</h1>
                <%--
                <a href="${pageContext.request.contextPath}/bookclubs/create" class="btn btn-primary">
                    모임 만들기
                </a>
                --%>
                <a href="javascript:void(0)" id="openCreateModal" class="btn btn-primary">
                모임 만들기
                </a>
            </div>

            <!-- 검색 및 필터 -->
            <%--
            <form action="${pageContext.request.contextPath}/bookclubs" method="get" class="search-form">
                <div class="search-row">
                    <div class="search-field">
                        <label for="keyword" class="sr-only">검색어</label>
                        <input type="text"
                               id="keyword"
                               name="keyword"
                               placeholder="모임 이름 검색"
                               value="<c:out value='${keyword}'/>"
                               class="form-input">
                    </div>

                    <div class="search-field">
                        <label for="sort" class="sr-only">정렬</label>
                        <select id="sort" name="sort" class="form-select">

                            <option value="newest" ${bookclubList.sort eq 'newest' ? 'selected' : ''}>최신순</option>
                            <option value="popular" ${bookclubList.sort eq 'popular' ? 'selected' : ''}>인기순</option>

                        </select>
                    </div>

                    <button type="submit" class="btn btn-secondary">검색</button>
                </div>
            </form>
            --%>
            <input type="text" id="keyword" placeholder="모임 이름 검색" class="form-input">
            <!-- 결과 정보 -->
            <div class="result-info">
                <p>
                    모임 개수 출력할 예정
                    <%--
                    <strong>${totalCount}</strong>개의 모임
                    --%>
                    <c:if test="${not empty keyword}">
                        - "<c:out value='${keyword}'/>" 검색 결과
                    </c:if>
                </p>
            </div>

            <!-- 모임 카드 목록 -->
            <div class="bookclub-grid" id="bookclubGrid">
                <c:choose>
                    <c:when test="${empty bookclubList}">
                        <div class="empty-state">
                            <p>검색 결과가 없습니다.</p>
                            <a href="${pageContext.request.contextPath}/bookclubs/create" class="btn btn-primary">
                                첫 모임 만들기
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="club" items="${bookclubList}">
                            <article class="bookclub-card" data-club-seq="${club.book_club_seq}">
                                <a href="${pageContext.request.contextPath}/bookclubs/${club.book_club_seq}"
                                   class="card-link">
                                    <div class="card-banner">
                                        <c:choose>
                                            <c:when test="${not empty club.banner_img_url}">
                                                <img src="<c:out value='${club.banner_img_url}'/>"
                                                     alt="<c:out value='${club.book_club_name}'/> 배너">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="card-banner-placeholder">
                                                    <span>📚</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="card-body">
                                        <h3 class="card-title">
                                            <c:out value="${club.book_club_name}"/>
                                        </h3>
                                        <p class="card-meta">
                                            <span class="card-region"><c:out value="${club.book_club_rg}"/></span>
                                            <span class="card-divider">•</span>
                                            <span class="card-schedule"><c:out value="${club.book_club_schedule}"/></span>
                                        </p>
                                        <p class="card-members">
                                            <%--
                                            <span class="members-count">${club.memberCount}</span>
                                            --%>
                                            <span class="members-max">/${club.book_club_max_member}명</span>
                                        </p>
                                    </div>
                                </a>
                                <%--
                                <button type="button"
                                        class="btn-wish ${club.isWished ? 'wished' : ''}"
                                        data-club-seq="${club.book_club_seq}"
                                        aria-label="${club.isWished ? '찜 취소' : '찜하기'}">
                                    <span class="wish-icon">${club.isWished ? '❤️' : '🤍'}</span>
                                </button>
                                --%>
                            </article>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <%--
            <!-- 페이징 (기본 구현) -->
            <c:if test="${totalCount > 0}">
                <div class="pagination">
                    <c:set var="totalPages" value="${(totalCount + bookclubList.size - 1) / bookclubList.size}" />
                    <c:set var="currentPage" value="${bookclubList.page}" />

                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}&keyword=<c:out value='${keyword}'/>&region=<c:out value='${bookclubList.region}'/>&sort=${bookclubList.sort}"
                           class="page-link">이전</a>
                    </c:if>

                    <span class="page-current">
                        ${currentPage} / ${totalPages}
                    </span>

                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}&keyword=<c:out value='${keyword}'/>&region=<c:out value='${bookclubList.region}'/>&sort=${bookclubList.sort}"
                           class="page-link">다음</a>
                    </c:if>
                </div>
            </c:if>
            --%>
        </div>
    </main>
    <!-- 모임 생성 팝업 -->
    <%--
    <div id="createBookClubModal" class="modal hidden">
        <div class="modal-overlay"></div>
        <div class="modal-content">
            <button class="modal-close">x</button>
            <h2 class="modal-title">새 독서모임 만들기</h2>
            <form id="createBookClubForm" enctype="multipart/form-data"></form>
        </div>
    </div>
    --%>
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script src="${pageContext.request.contextPath}/resources/js/bookclub/bookclub.js"></script>
    <script>
        // 페이지별 초기화
        document.addEventListener('DOMContentLoaded', function() {
            BookClub.initList();
        });
    </script>
</body>
</html>
