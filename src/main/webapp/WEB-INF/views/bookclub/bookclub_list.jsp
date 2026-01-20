<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <c:if test="${not empty _csrf}">
        <meta name="_csrf" content="${_csrf.token}">
        <meta name="_csrf_header" content="${_csrf.headerName}">
    </c:if>
    <title>독서모임 목록 - 신한북스</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bookclub.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="bookclub-main">
        <div class="container">
            <div class="page-header">
                <div class="page-title">
                <h1>독서모임</h1>
                <p class="page-subtitle">
                    함께 읽고, 나누고, 성장하는 즐거움
                </p>
                </div>

                <div class="page-action">
                    <c:if test="${not empty sessionScope.loginSess}">
                        <button id="openCreateModal" class="btn-primary">
                            + 모임 만들기
                        </button>
                    </c:if>
                    <c:if test="${empty sessionScope.loginSess}">
                        <button id="needLoginBtn" class="btn-primary">
                            + 모임 만들기
                        </button>
                    </c:if>
                </div>
            </div>

            <!-- 검색바
            <div class="search-wrapper">
                <input
                    type="text"
                    id="keyword"
                    placeholder="지역, 모임명으로 검색해 보세요."
                    class="search-input"
                >
            </div>
            -->
            <div class="search-bar">
                <form action="/bookclub/search" method="get">
                    <input
                        type="text"
                        id="keyword"
                        placeholder="지역, 모임명으로 검색해 보세요."
                    />
                    <!--
                    <button type="submit">검색</button>
                    -->
                </form>
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
                                <!-- 지역 태그 - 왼쪽 상단 -->
                                <span class="card-region-tag">
                                    <c:out value="${club.book_club_rg}"/>
                                </span>
                                <!-- 찜 버튼 - 오른쪽 상단 -->
                                <button type="button" class="btn-wish" onclick="alert('구현 예정입니다.'); return false;">
                                    <span class="wish-icon">♡</span>
                                </button>

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
                                        <div class="card-body-inner">
                                            <h3 class="card-title">
                                                <c:out value="${club.book_club_name}"/>
                                            </h3>
                                            <c:if test="${not empty club.book_club_desc}">
                                                <p class="card-desc">
                                                    <c:out value="${club.book_club_desc}"/>
                                                </p>
                                            </c:if>
                                            <div class="card-footer">
                                                <span class="card-schedule">
                                                    <c:out value="${club.book_club_schedule}"/>
                                                </span>
                                                <span class="card-members">
                                                    <c:out value="${club.book_club_max_member}"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </a>
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
    <div id="createBookClubModal" class="modal hidden">
        <div class="modal-overlay"></div>
        <div class="modal-content">
            <!-- 모달 헤더 -->
            <div class="modal-header">
                <h2>새 독서모임 만들기</h2>
                <button id="closeCreateModal" type="button" class="modal-close">&times;</button>
            </div>

            <form id="createBookClubForm" enctype="multipart/form-data">
                <!-- 이미지 업로드 -->
                <div class="image-upload-area" id="imageUploadArea">
                    <input type="file" name="banner_img" id="bannerImgInput" accept="image/*">
                    <div class="image-upload-icon">📷</div>
                    <div class="image-upload-text">이미지 업로드</div>
                </div>

                <!-- 모임 이름 -->
                <div class="form-group">
                    <input type="text" name="book_club_name" class="form-input" placeholder="모임 이름" required>
                </div>

                <!-- 활동 지역 -->
                <div class="form-group">
                    <label class="form-label">활동 지역</label>
                    <div class="toggle-group">
                        <button type="button" class="toggle-btn active" data-value="offline">오프라인</button>
                        <button type="button" class="toggle-btn" data-value="online">온라인</button>
                    </div>
                    <input type="hidden" name="book_club_type" id="bookClubType" value="offline">
                    <div class="detail-region show" id="detailRegion">
                        <input type="text" name="book_club_rg" class="form-input" placeholder="상세 지역 (예: 서울 강남구)">
                    </div>
                </div>

                <!-- 모임 소개 -->
                <div class="form-group">
                    <textarea name="book_club_desc" class="form-textarea" placeholder="모임 소개"></textarea>
                </div>

                <!-- 정기 모임 일정 -->
                <div class="form-group">
                    <label class="form-label">정기 모임 일정 (선택)</label>
                    <!-- 주기 선택 -->
                    <div class="schedule-row">
                        <div class="toggle-group schedule-cycle">
                            <button type="button" class="toggle-btn cycle-btn" data-value="매일">매일</button>
                            <button type="button" class="toggle-btn cycle-btn" data-value="매주">매주</button>
                            <button type="button" class="toggle-btn cycle-btn" data-value="매월">매월</button>
                        </div>
                    </div>
                    <!-- 주차 선택 (매월 선택시만 표시) -->
                    <div class="schedule-row week-select" id="weekSelect" style="display: none;">
                        <select class="form-input" id="scheduleWeek">
                            <option value="">주차 선택</option>
                            <option value="첫째주">첫째주</option>
                            <option value="둘째주">둘째주</option>
                            <option value="셋째주">셋째주</option>
                            <option value="넷째주">넷째주</option>
                            <option value="다섯째주">다섯째주</option>
                        </select>
                    </div>
                    <!-- 요일 선택 (매주/매월 선택시 표시) -->
                    <div class="schedule-row day-select" id="daySelect" style="display: none;">
                        <div class="day-group">
                            <button type="button" class="day-btn" data-value="월">월</button>
                            <button type="button" class="day-btn" data-value="화">화</button>
                            <button type="button" class="day-btn" data-value="수">수</button>
                            <button type="button" class="day-btn" data-value="목">목</button>
                            <button type="button" class="day-btn" data-value="금">금</button>
                            <button type="button" class="day-btn" data-value="토">토</button>
                            <button type="button" class="day-btn" data-value="일">일</button>
                        </div>
                    </div>
                    <!-- 시간 선택 -->
                    <div class="schedule-row time-select" id="timeSelect" style="display: none;">
                        <select class="form-input time-input" id="scheduleHour">
                            <option value="">시간 선택</option>
                            <option value="오전 6시">오전 6시</option>
                            <option value="오전 7시">오전 7시</option>
                            <option value="오전 8시">오전 8시</option>
                            <option value="오전 9시">오전 9시</option>
                            <option value="오전 10시">오전 10시</option>
                            <option value="오전 11시">오전 11시</option>
                            <option value="오후 12시">오후 12시</option>
                            <option value="오후 1시">오후 1시</option>
                            <option value="오후 2시">오후 2시</option>
                            <option value="오후 3시">오후 3시</option>
                            <option value="오후 4시">오후 4시</option>
                            <option value="오후 5시">오후 5시</option>
                            <option value="오후 6시">오후 6시</option>
                            <option value="오후 7시">오후 7시</option>
                            <option value="오후 8시">오후 8시</option>
                            <option value="오후 9시">오후 9시</option>
                            <option value="오후 10시">오후 10시</option>
                        </select>
                    </div>
                    <input type="hidden" name="book_club_schedule" id="bookClubSchedule">
                </div>

                <!-- 최대 인원 (고정) -->
                <div class="form-group">
                    <label class="form-label">최대 인원 (최대 10명)</label>
                    <input type="text" class="form-input-readonly" value="10" readonly>
                    <input type="hidden" name="book_club_max_member" value="10">
                </div>

                <!-- 모임 개설 버튼 -->
                <button type="submit" class="btn-submit">모임 개설하기</button>
            </form>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script src="${pageContext.request.contextPath}/resources/js/bookclub/bookclub.js"></script>
    <script>
        // 페이지별 초기화
        document.addEventListener('DOMContentLoaded', function() {
            BookClub.initList();
            initCreateModal();
        });
        // 로그인 세션 없이 모임 만들기 버튼 클릭 -> 로그인 요청 alert
        document.getElementById("needLoginBtn")?.addEventListener("click", () => {
            alert("로그인이 필요합니다.");
            location.href = "/login";
        });
    </script>
</body>
</html>
