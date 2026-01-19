<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 홈 탭 본문 (fragment) -->
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
