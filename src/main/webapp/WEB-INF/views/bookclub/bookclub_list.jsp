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
                <a href="${pageContext.request.contextPath}/bookclubs/create" class="btn btn-primary">
                    모임 만들기
                </a>
            </div>

            <!-- 검색 및 필터 -->
            <form action="${pageContext.request.contextPath}/bookclubs" method="get" class="search-form">
                <div class="search-row">
                    <div class="search-field">
                        <label for="keyword" class="sr-only">검색어</label>
                        <input type="text"
                               id="keyword"
                               name="keyword"
                               placeholder="모임 이름 검색"
                               value="<c:out value='${query.keyword}'/>"
                               class="form-input">
                    </div>

                    <div class="search-field">
                        <label for="region" class="sr-only">지역</label>
                        <select id="region" name="region" class="form-select">
                            <option value="">전체 지역</option>
                            <option value="서울" ${query.region eq '서울' ? 'selected' : ''}>서울</option>
                            <option value="경기" ${query.region eq '경기' ? 'selected' : ''}>경기</option>
                            <option value="인천" ${query.region eq '인천' ? 'selected' : ''}>인천</option>
                            <option value="부산" ${query.region eq '부산' ? 'selected' : ''}>부산</option>
                            <option value="대구" ${query.region eq '대구' ? 'selected' : ''}>대구</option>
                            <option value="광주" ${query.region eq '광주' ? 'selected' : ''}>광주</option>
                            <option value="대전" ${query.region eq '대전' ? 'selected' : ''}>대전</option>
                            <option value="울산" ${query.region eq '울산' ? 'selected' : ''}>울산</option>
                            <option value="세종" ${query.region eq '세종' ? 'selected' : ''}>세종</option>
                            <option value="강원" ${query.region eq '강원' ? 'selected' : ''}>강원</option>
                            <option value="충북" ${query.region eq '충북' ? 'selected' : ''}>충북</option>
                            <option value="충남" ${query.region eq '충남' ? 'selected' : ''}>충남</option>
                            <option value="전북" ${query.region eq '전북' ? 'selected' : ''}>전북</option>
                            <option value="전남" ${query.region eq '전남' ? 'selected' : ''}>전남</option>
                            <option value="경북" ${query.region eq '경북' ? 'selected' : ''}>경북</option>
                            <option value="경남" ${query.region eq '경남' ? 'selected' : ''}>경남</option>
                            <option value="제주" ${query.region eq '제주' ? 'selected' : ''}>제주</option>
                            <option value="온라인" ${query.region eq '온라인' ? 'selected' : ''}>온라인</option>
                        </select>
                    </div>

                    <div class="search-field">
                        <label for="sort" class="sr-only">정렬</label>
                        <select id="sort" name="sort" class="form-select">
                            <option value="newest" ${query.sort eq 'newest' ? 'selected' : ''}>최신순</option>
                            <option value="popular" ${query.sort eq 'popular' ? 'selected' : ''}>인기순</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-secondary">검색</button>
                </div>
            </form>

            <!-- 결과 정보 -->
            <div class="result-info">
                <p>
                    <strong>${totalCount}</strong>개의 모임
                    <c:if test="${not empty query.keyword}">
                        - "<c:out value='${query.keyword}'/>" 검색 결과
                    </c:if>
                </p>
            </div>

            <!-- 모임 카드 목록 -->
            <div class="bookclub-grid" id="bookclubGrid">
                <c:choose>
                    <c:when test="${empty bookclubs}">
                        <div class="empty-state">
                            <p>검색 결과가 없습니다.</p>
                            <a href="${pageContext.request.contextPath}/bookclubs/create" class="btn btn-primary">
                                첫 모임 만들기
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="club" items="${bookclubs}">
                            <article class="bookclub-card" data-club-seq="${club.bookClubSeq}">
                                <a href="${pageContext.request.contextPath}/bookclubs/${club.bookClubSeq}"
                                   class="card-link">
                                    <div class="card-banner">
                                        <c:choose>
                                            <c:when test="${not empty club.bannerImgUrl}">
                                                <img src="<c:out value='${club.bannerImgUrl}'/>"
                                                     alt="<c:out value='${club.name}'/> 배너">
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
                                            <c:out value="${club.name}"/>
                                        </h3>
                                        <p class="card-meta">
                                            <span class="card-region"><c:out value="${club.region}"/></span>
                                            <span class="card-divider">•</span>
                                            <span class="card-schedule"><c:out value="${club.schedule}"/></span>
                                        </p>
                                        <p class="card-members">
                                            <span class="members-count">${club.memberCount}</span>
                                            <span class="members-max">/${club.maxMember}명</span>
                                        </p>
                                    </div>
                                </a>
                                <button type="button"
                                        class="btn-wish ${club.isWished ? 'wished' : ''}"
                                        data-club-seq="${club.bookClubSeq}"
                                        aria-label="${club.isWished ? '찜 취소' : '찜하기'}">
                                    <span class="wish-icon">${club.isWished ? '❤️' : '🤍'}</span>
                                </button>
                            </article>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 페이징 (기본 구현) -->
            <c:if test="${totalCount > 0}">
                <div class="pagination">
                    <c:set var="totalPages" value="${(totalCount + query.size - 1) / query.size}" />
                    <c:set var="currentPage" value="${query.page}" />

                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}&keyword=<c:out value='${query.keyword}'/>&region=<c:out value='${query.region}'/>&sort=${query.sort}"
                           class="page-link">이전</a>
                    </c:if>

                    <span class="page-current">
                        ${currentPage} / ${totalPages}
                    </span>

                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}&keyword=<c:out value='${query.keyword}'/>&region=<c:out value='${query.region}'/>&sort=${query.sort}"
                           class="page-link">다음</a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script src="${pageContext.request.contextPath}/resources/js/bookclub.js"></script>
    <script>
        // 페이지별 초기화
        document.addEventListener('DOMContentLoaded', function() {
            BookClub.initList();
        });
    </script>
</body>
</html>
