<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- ========== 🔍 JSP 렌더링 디버깅 마커 ========== -->
<!-- JSP 파일: bookclub_detail.jsp -->
<!-- 렌더링 시각: <%= new java.util.Date() %> -->
<!-- bookClub 객체: ${bookClub} -->
<!-- errorMessage: ${errorMessage} -->
<!-- ============================================== -->

<style>
    /* 페이지 전용 CSS - bc- prefix 사용 */
    .bc-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
    }

    .bc-error {
        text-align: center;
        padding: 40px 20px;
        color: #e53e3e;
        font-size: 18px;
    }

    .bc-banner-wrapper {
        width: 100%;
        height: 300px;
        overflow: hidden;
        border-radius: 8px;
        margin-bottom: 20px;
        background-color: #f7fafc;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .bc-banner-wrapper img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .bc-banner-placeholder {
        font-size: 80px;
        color: #cbd5e0;
    }

    .bc-header {
        background: #fff;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        margin-bottom: 30px;
    }

    .bc-title {
        font-size: 28px;
        font-weight: bold;
        color: #2d3748;
        margin-bottom: 20px;
    }

    .bc-meta {
        display: flex;
        gap: 20px;
        flex-wrap: wrap;
        margin-bottom: 20px;
        color: #4a5568;
    }

    .bc-meta-item {
        display: flex;
        gap: 8px;
    }

    .bc-meta-item strong {
        color: #2d3748;
    }

    .bc-desc {
        line-height: 1.6;
        color: #4a5568;
        white-space: pre-wrap;
    }

    .bc-tabs-nav {
        display: flex;
        gap: 10px;
        border-bottom: 2px solid #e2e8f0;
        margin-bottom: 20px;
    }

    .bc-tab-btn {
        padding: 12px 24px;
        background: none;
        border: none;
        font-size: 16px;
        font-weight: 500;
        color: #718096;
        cursor: pointer;
        position: relative;
        transition: color 0.2s;
    }

    .bc-tab-btn:hover {
        color: #2d3748;
    }

    .bc-tab-btn.bc-active {
        color: #3182ce;
    }

    .bc-tab-btn.bc-active::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 0;
        right: 0;
        height: 2px;
        background-color: #3182ce;
    }

    .bc-tab-panel {
        display: none;
        padding: 20px;
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .bc-tab-panel.bc-active {
        display: block;
    }

    .bc-placeholder {
        text-align: center;
        padding: 40px 20px;
        color: #a0aec0;
        font-size: 16px;
    }

    .bc-info-list {
        display: grid;
        gap: 16px;
    }

    .bc-info-item {
        display: grid;
        grid-template-columns: 150px 1fr;
        gap: 20px;
    }

    .bc-info-label {
        font-weight: bold;
        color: #2d3748;
    }

    .bc-info-value {
        color: #4a5568;
    }

    .bc-action-buttons {
        margin-top: 20px;
        display: flex;
        gap: 12px;
    }

    .bc-btn {
        padding: 12px 24px;
        border: none;
        border-radius: 6px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
        text-decoration: none;
        display: inline-block;
    }

    .bc-btn-primary {
        background-color: #3182ce;
        color: white;
    }

    .bc-btn-primary:hover {
        background-color: #2c5aa0;
    }

    .bc-btn-secondary {
        background-color: #718096;
        color: white;
    }

    .bc-btn-secondary:hover {
        background-color: #4a5568;
    }

    .bc-btn-danger {
        background-color: #e53e3e;
        color: white;
    }

    .bc-btn-danger:hover {
        background-color: #c53030;
    }

    .bc-btn-outline {
        background-color: white;
        color: #3182ce;
        border: 2px solid #3182ce;
    }

    .bc-btn-outline:hover {
        background-color: #ebf8ff;
    }
</style>

<div class="bc-container">
        <!-- 🔍 디버깅: bc-container 렌더링됨 -->
        <c:choose>
            <c:when test="${not empty errorMessage}">
                <!-- 조회 실패 시 에러 메시지 -->
                <!-- 🔍 디버깅: errorMessage 블록 실행됨 -->
                <div class="bc-error">
                    <p>${errorMessage}</p>
                </div>
            </c:when>
            <c:when test="${not empty bookClub}">
                <!-- 🔍 디버깅: bookClub 블록 실행됨 -->
                <!-- 배너 이미지 영역 -->
                <div class="bc-banner-wrapper">
                    <c:choose>
                        <c:when test="${not empty bookClub.banner_img_url}">
                            <img id="bc-banner"
                                 src="${bookClub.banner_img_url}"
                                 alt="${bookClub.book_club_name} 배너">
                        </c:when>
                        <c:otherwise>
                            <div class="bc-banner-placeholder" id="bc-banner">📚</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 모임 정보 헤더 -->
                <div class="bc-header">
                    <h1 class="bc-title" id="bc-club-name">
                        ${bookClub.book_club_name}
                    </h1>

                    <div class="bc-meta">
                        <div class="bc-meta-item">
                            <strong>지역:</strong>
                            <span id="bc-club-region">
                                <c:choose>
                                    <c:when test="${not empty bookClub.book_club_rg}">
                                        ${bookClub.book_club_rg}
                                    </c:when>
                                    <c:otherwise>미설정</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="bc-meta-item">
                            <strong>정기 일정:</strong>
                            <span id="bc-club-schedule">
                                <c:choose>
                                    <c:when test="${not empty bookClub.book_club_schedule}">
                                        ${bookClub.book_club_schedule}
                                    </c:when>
                                    <c:otherwise>미설정</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="bc-meta-item">
                            <strong>참여 인원:</strong>
                            <span>
                                <span id="bc-joined-member-count">${joinedMemberCount}</span> /
                                <span id="bc-max-member">${bookClub.book_club_max_member}</span>명 참여중
                            </span>
                        </div>
                    </div>

                    <div class="bc-desc" id="bc-club-desc">
                        <c:choose>
                            <c:when test="${not empty bookClub.book_club_desc}">
                                ${bookClub.book_club_desc}
                            </c:when>
                            <c:otherwise>소개글이 없습니다.</c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 버튼 분기 처리 -->
                    <div class="bc-action-buttons">
                        <c:choose>
                            <%-- 1순위: 비로그인 상태 --%>
                            <c:when test="${not isLogin}">
                                <a href="/login" class="bc-btn bc-btn-secondary">
                                    로그인 후 이용
                                </a>
                            </c:when>

                            <%-- 2순위: 모임장 --%>
                            <c:when test="${isLeader}">
                                <a href="/bookclubs/${bookClub.book_club_seq}/edit" class="bc-btn bc-btn-primary">
                                    모임 관리하기
                                </a>
                                <span style="color: #718096; font-size: 14px; align-self: center;">
                                    (URL 연결만 완료, 관리 페이지는 TODO)
                                </span>
                            </c:when>

                            <%-- 3순위: 가입된 멤버 --%>
                            <c:when test="${isMember}">
                                <button type="button" class="bc-btn bc-btn-danger"
                                        onclick="if(confirm('정말 모임을 나가시겠습니까?')) { alert('TODO: 모임 나가기 API 구현 예정'); }">
                                    모임 나가기
                                </button>
                            </c:when>

                            <%-- 4순위: 비멤버 (로그인했지만 가입하지 않음) --%>
                            <c:otherwise>
                                <button type="button" class="bc-btn bc-btn-outline"
                                        onclick="alert('TODO: 가입 신청 기능 구현 예정')">
                                    가입하기
                                </button>
                            </c:otherwise>
                        </c:choose>

                        <!-- TODO: 찜하기 버튼 (book_club_wish 테이블 연동) -->
                    </div>
                </div>

                <!-- 탭 네비게이션 -->
                <div class="bc-tabs">
                    <nav class="bc-tabs-nav">
                        <button type="button"
                                class="bc-tab-btn bc-active"
                                data-tab="home">
                            홈
                        </button>
                        <button type="button"
                                class="bc-tab-btn"
                                data-tab="board">
                            게시판
                        </button>
                    </nav>

                    <!-- 홈 탭 -->
                    <div class="bc-tab-panel bc-active" data-panel="home">
                        <h2>모임 정보</h2>
                        <div class="bc-info-list">
                            <div class="bc-info-item">
                                <div class="bc-info-label">모임명</div>
                                <div class="bc-info-value">${bookClub.book_club_name}</div>
                            </div>
                            <div class="bc-info-item">
                                <div class="bc-info-label">지역</div>
                                <div class="bc-info-value">
                                    <c:choose>
                                        <c:when test="${not empty bookClub.book_club_rg}">
                                            ${bookClub.book_club_rg}
                                        </c:when>
                                        <c:otherwise>미설정</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="bc-info-item">
                                <div class="bc-info-label">정기 일정</div>
                                <div class="bc-info-value">
                                    <c:choose>
                                        <c:when test="${not empty bookClub.book_club_schedule}">
                                            ${bookClub.book_club_schedule}
                                        </c:when>
                                        <c:otherwise>미설정</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="bc-info-item">
                                <div class="bc-info-label">정원</div>
                                <div class="bc-info-value">${bookClub.book_club_max_member}명</div>
                            </div>
                            <div class="bc-info-item">
                                <div class="bc-info-label">생성일</div>
                                <div class="bc-info-value">
                                    ${bookClub.crt_dtm.toString().substring(0, 10).replace('-', '.')}
                                </div>
                            </div>
                        </div>
                        <!-- TODO: 멤버 미리보기 (프로필 이미지 3~5명) -->
                    </div>

                    <!-- 게시판 탭 -->
                    <div class="bc-tab-panel" data-panel="board">
                        <div class="bc-placeholder">
                            <p>게시판 기능은 추후 구현됩니다.</p>
                            <!-- TODO: book_club_board 테이블 조회 및 게시글 목록 출력 -->
                            <!-- TODO: 게시글 작성 버튼 (멤버만) -->
                            <!-- TODO: 게시글 상세 / 댓글 (parent_book_club_board_seq) -->
                            <!-- TODO: 페이징 처리 -->
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 🔍 디버깅: c:otherwise 블록 실행됨 (bookClub도 errorMessage도 없음) -->
                <div class="bc-error">
                    <p>독서모임을 찾을 수 없습니다.</p>
                    <p style="font-size: 14px; color: #718096; margin-top: 10px;">
                        (디버깅: bookClub = ${bookClub}, errorMessage = ${errorMessage})
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
</div>

<script>
    // 탭 전환 최소 구현
    document.addEventListener('DOMContentLoaded', function() {
        const tabBtns = document.querySelectorAll('.bc-tab-btn');
        const tabPanels = document.querySelectorAll('.bc-tab-panel');

        tabBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                const targetTab = this.getAttribute('data-tab');

                // 모든 탭/패널 비활성화
                tabBtns.forEach(b => b.classList.remove('bc-active'));
                tabPanels.forEach(p => p.classList.remove('bc-active'));

                // 클릭한 탭/패널 활성화
                this.classList.add('bc-active');
                document.querySelector(`[data-panel="${targetTab}"]`).classList.add('bc-active');
            });
        });
    });
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
