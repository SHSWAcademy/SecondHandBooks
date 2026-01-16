<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- 독서모임 상세 페이지 전용 CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bookclub_detail.css">

<c:choose>
    <c:when test="${not empty errorMessage}">
        <!-- 에러 메시지 -->
        <div class="bc-error">
            <p>${errorMessage}</p>
        </div>
    </c:when>
    <c:when test="${not empty bookClub}">
        <!-- 페이지 래퍼 -->
        <div class="bc-page-wrapper">
            <!-- 배너(히어로) 섹션 -->
            <section class="bc-hero-section">
                <!-- 배경 이미지 또는 기본 그라데이션 -->
                <c:choose>
                    <c:when test="${not empty bookClub.banner_img_url}">
                        <c:choose>
                            <%-- HTTP/HTTPS로 시작하면 그대로 사용 --%>
                            <c:when test="${bookClub.banner_img_url.startsWith('http://') or bookClub.banner_img_url.startsWith('https://')}">
                                <img class="bc-hero-background"
                                     src="${bookClub.banner_img_url}"
                                     alt="${bookClub.book_club_name} 배너">
                            </c:when>
                            <%-- /로 시작하는 상대경로면 contextPath 붙이기 --%>
                            <c:when test="${bookClub.banner_img_url.startsWith('/')}">
                                <img class="bc-hero-background"
                                     src="${pageContext.request.contextPath}${bookClub.banner_img_url}"
                                     alt="${bookClub.book_club_name} 배너">
                            </c:when>
                            <%-- 그 외 --%>
                            <c:otherwise>
                                <div class="bc-hero-gradient"></div>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <!-- 배너가 없으면 기본 그라데이션 -->
                        <div class="bc-hero-gradient"></div>
                    </c:otherwise>
                </c:choose>

                <!-- 오버레이 -->
                <div class="bc-hero-overlay">
                    <!-- 상단: 뒤로가기 + 찜 버튼 -->
                    <div class="bc-hero-top">
                        <button class="bc-back-btn" onclick="history.back()" aria-label="뒤로가기">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                            </svg>
                        </button>
                        <button class="bc-wish-btn" onclick="alert('TODO: 찜하기 기능 구현 예정')" aria-label="찜하기">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
                            </svg>
                        </button>
                    </div>

                    <!-- 하단: 지역 뱃지 + 모임명 + 메타 -->
                    <div class="bc-hero-bottom">
                        <c:if test="${not empty bookClub.book_club_rg}">
                            <span class="bc-region-badge">${bookClub.book_club_rg}</span>
                        </c:if>
                        <h1 class="bc-hero-title">${bookClub.book_club_name}</h1>
                        <div class="bc-hero-meta">
                            <div class="bc-meta-item">
                                <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                                </svg>
                                <span>${empty joinedMemberCount ? 0 : joinedMemberCount} / ${bookClub.book_club_max_member}명</span>
                            </div>
                            <div class="bc-meta-item">
                                <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
                                </svg>
                                <span>${wishCount} 찜</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- 탭 네비게이션 -->
            <div class="bc-tabs-wrapper">
                <nav class="bc-tabs-nav">
                    <a href="/bookclubs/${bookClub.book_club_seq}"
                       class="bc-tab-link ${requestScope['javax.servlet.forward.request_uri'].contains('/board') ? '' : 'active'}">
                        홈
                    </a>
                    <a href="#"
                       class="bc-tab-link ${requestScope['javax.servlet.forward.request_uri'].contains('/board') ? 'active' : ''}"
                       onclick="alert('TODO: 게시판 기능 구현 예정'); return false;">
                        게시판
                    </a>
                </nav>
            </div>

            <!-- 본문 콘텐츠 -->
            <div class="bc-content-wrapper">
                <!-- 카드1: 모임 소개 -->
                <div class="bc-card">
                    <h2 class="bc-card-title">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        모임 소개
                    </h2>
                    <p class="bc-intro-text">
                        <c:choose>
                            <c:when test="${not empty bookClub.book_club_desc}">
                                ${bookClub.book_club_desc}
                            </c:when>
                            <c:otherwise>소개글이 없습니다.</c:otherwise>
                        </c:choose>
                    </p>

                    <c:if test="${not empty bookClub.book_club_schedule}">
                        <div class="bc-schedule-box">
                            <div class="bc-schedule-label">정기 모임 일정</div>
                            <div class="bc-schedule-text">${bookClub.book_club_schedule}</div>
                        </div>
                    </c:if>
                </div>

                <!-- 카드2: 함께하는 멤버 -->
                <div class="bc-card">
                    <h2 class="bc-card-title">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                        </svg>
                        함께하는 멤버
                    </h2>

                    <!-- TODO: 실제 멤버 리스트로 교체 (현재는 Mock 데이터) -->
                    <!-- 추후 members 리스트를 model로 받아 c:forEach로 교체 -->
                    <div class="bc-members-grid">
                        <!-- Mock 멤버 1 (모임장) -->
                        <div class="bc-member-item">
                            <div class="bc-member-avatar">
                                👤
                                <span class="bc-leader-badge">모임장</span>
                            </div>
                            <div class="bc-member-name">우주여행자</div>
                        </div>

                        <!-- Mock 멤버 2 -->
                        <div class="bc-member-item">
                            <div class="bc-member-avatar">👤</div>
                            <div class="bc-member-name">모낭커피</div>
                        </div>

                        <!-- Mock 멤버 3 -->
                        <div class="bc-member-item">
                            <div class="bc-member-avatar">👤</div>
                            <div class="bc-member-name">외계인</div>
                        </div>

                        <!-- 빈 슬롯 (최대 10개 중 나머지는 비워둠) -->
                    </div>
                </div>
            </div>

            <!-- 하단 고정 바 -->
            <div class="bc-bottom-bar">
                <div class="bc-bottom-content">
                    <div class="bc-bottom-info">
                        <div class="bc-bottom-label">현재 참여 인원</div>
                        <div class="bc-bottom-count">
                            <span class="current">${empty joinedMemberCount ? 0 : joinedMemberCount}</span>
                            / ${bookClub.book_club_max_member}명 참여 중
                        </div>
                    </div>

                    <!-- 버튼 분기 처리 (기존 로직 유지) -->
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
                        </c:when>

                        <%-- 3순위: 가입된 멤버 --%>
                        <c:when test="${isMember}">
                            <button type="button" class="bc-btn bc-btn-danger"
                                    onclick="if(confirm('정말 모임을 나가시겠습니까?')) { alert('TODO: 모임 나가기 API 구현 예정'); }">
                                모임 나가기
                            </button>
                        </c:when>

                        <%-- 4순위: 신청중 상태 (request_st='WAIT') --%>
                        <c:when test="${hasPendingRequest}">
                            <button type="button" class="bc-btn bc-btn-secondary" disabled>
                                신청중
                            </button>
                        </c:when>

                        <%-- 5순위: 비멤버 (로그인했지만 가입하지 않음, 신청하지도 않음) --%>
                        <c:otherwise>
                            <form method="post" action="/bookclubs/${bookClub.book_club_seq}/join-requests"
                                  style="display: inline;">
                                <button type="submit" class="bc-btn bc-btn-primary">
                                    가입 신청하기
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <!-- bookClub도 errorMessage도 없는 경우 -->
        <div class="bc-error">
            <p>독서모임을 찾을 수 없습니다.</p>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
