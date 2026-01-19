<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- 독서모임 게시글 상세 페이지 전용 CSS -->
<style>
    .bc-post-detail-wrapper {
        max-width: 900px;
        margin: 0 auto;
        padding: 2rem 1rem;
    }

    .bc-back-link {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        color: #4299e1;
        text-decoration: none;
        font-size: 0.875rem;
        font-weight: 600;
        margin-bottom: 1.5rem;
        transition: color 0.2s;
    }

    .bc-back-link:hover {
        color: #2b6cb0;
    }

    .bc-post-card {
        background: white;
        border-radius: 0.75rem;
        box-shadow: 0 1px 3px 0 rgba(0,0,0,0.1), 0 1px 2px 0 rgba(0,0,0,0.06);
        padding: 2rem;
    }

    .bc-post-title {
        font-size: 1.875rem;
        font-weight: 700;
        color: #1a202c;
        margin: 0 0 1rem 0;
        line-height: 1.3;
    }

    .bc-post-meta {
        display: flex;
        align-items: center;
        gap: 1rem;
        padding-bottom: 1.5rem;
        margin-bottom: 1.5rem;
        border-bottom: 1px solid #e2e8f0;
    }

    .bc-post-meta-item {
        display: flex;
        align-items: center;
        gap: 0.375rem;
        font-size: 0.875rem;
        color: #718096;
    }

    .bc-post-content {
        color: #2d3748;
        font-size: 1rem;
        line-height: 1.75;
        white-space: pre-wrap;
        word-break: break-word;
        margin-bottom: 2rem;
    }

    .bc-post-image {
        margin: 1.5rem 0;
        border-radius: 0.5rem;
        overflow: hidden;
        max-width: 100%;
    }

    .bc-post-image img {
        width: 100%;
        height: auto;
        display: block;
    }

    .bc-comments-section {
        margin-top: 3rem;
        padding-top: 2rem;
        border-top: 2px solid #e2e8f0;
    }

    .bc-comments-title {
        font-size: 1.25rem;
        font-weight: 600;
        color: #2d3748;
        margin-bottom: 1rem;
    }

    .bc-comments-empty {
        background: #f7fafc;
        border: 1px dashed #cbd5e0;
        border-radius: 0.5rem;
        padding: 2rem;
        text-align: center;
        color: #718096;
        font-size: 0.875rem;
    }

    .bc-comment-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .bc-comment-item {
        background: #f7fafc;
        border: 1px solid #e2e8f0;
        border-radius: 0.5rem;
        padding: 1rem 1.25rem;
        margin-bottom: 0.75rem;
    }

    .bc-comment-header {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        margin-bottom: 0.5rem;
    }

    .bc-comment-author {
        font-weight: 600;
        color: #2d3748;
        font-size: 0.875rem;
    }

    .bc-comment-date {
        font-size: 0.75rem;
        color: #a0aec0;
    }

    .bc-comment-content {
        color: #4a5568;
        font-size: 0.875rem;
        line-height: 1.6;
        white-space: pre-wrap;
        word-break: break-word;
        margin: 0;
    }

    .bc-error-message {
        max-width: 900px;
        margin: 2rem auto;
        padding: 1rem;
        background: #fff5f5;
        border: 1px solid #fc8181;
        border-radius: 0.5rem;
        color: #c53030;
        text-align: center;
    }
</style>

<c:choose>
    <c:when test="${not empty errorMessage}">
        <!-- 에러 메시지 -->
        <div class="bc-error-message">
            <p>${errorMessage}</p>
            <a href="${pageContext.request.contextPath}/bookclubs/${bookClubId}"
               style="color: #4299e1; text-decoration: none; font-weight: 600; margin-top: 0.5rem; display: inline-block;">
                독서모임으로 돌아가기
            </a>
        </div>
    </c:when>
    <c:when test="${not empty post}">
        <!-- 게시글 상세 -->
        <div class="bc-post-detail-wrapper">
            <!-- 뒤로가기 링크 -->
            <a href="${pageContext.request.contextPath}/bookclubs/${bookClubId}" class="bc-back-link">
                <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                </svg>
                독서모임으로 돌아가기
            </a>

            <!-- 게시글 카드 -->
            <div class="bc-post-card">
                <!-- 제목 -->
                <h1 class="bc-post-title">${fn:escapeXml(post.board_title)}</h1>

                <!-- 메타 정보 (작성자 + 작성일) -->
                <div class="bc-post-meta">
                    <div class="bc-post-meta-item">
                        <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                        <span>${fn:escapeXml(post.member_nicknm)}</span>
                    </div>
                    <div class="bc-post-meta-item">
                        <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        <span>
                            <c:choose>
                                <c:when test="${not empty post.board_crt_dtm_text}">
                                    ${post.board_crt_dtm_text}
                                </c:when>
                                <c:otherwise>
                                    방금
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <!-- 이미지 (있을 경우) -->
                <c:if test="${not empty post.board_img_url}">
                    <div class="bc-post-image">
                        <c:choose>
                            <c:when test="${post.board_img_url.startsWith('http://') or post.board_img_url.startsWith('https://')}">
                                <img src="${post.board_img_url}" alt="게시글 이미지">
                            </c:when>
                            <c:when test="${post.board_img_url.startsWith('/')}">
                                <img src="${pageContext.request.contextPath}${post.board_img_url}" alt="게시글 이미지">
                            </c:when>
                        </c:choose>
                    </div>
                </c:if>

                <!-- 본문 -->
                <div class="bc-post-content">
                    ${fn:escapeXml(post.board_cont)}
                </div>

                <!-- 댓글 영역 -->
                <div class="bc-comments-section">
                    <h2 class="bc-comments-title">
                        <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                             style="display: inline-block; vertical-align: middle; margin-right: 0.5rem;">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/>
                        </svg>
                        댓글
                    </h2>

                    <c:choose>
                        <c:when test="${empty comments}">
                            <!-- 댓글 없음 -->
                            <div class="bc-comments-empty">
                                <p style="margin: 0;">댓글이 없습니다</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- 댓글 목록 -->
                            <ul class="bc-comment-list">
                                <c:forEach var="c" items="${comments}">
                                    <li class="bc-comment-item">
                                        <div class="bc-comment-header">
                                            <span class="bc-comment-author">${fn:escapeXml(c.member_nicknm)}</span>
                                            <span class="bc-comment-date">
                                                <c:choose>
                                                    <c:when test="${not empty c.board_crt_dtm_text}">
                                                        ${c.board_crt_dtm_text}
                                                    </c:when>
                                                    <c:otherwise>
                                                        방금
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <p class="bc-comment-content">${fn:escapeXml(c.board_cont)}</p>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </c:when>
</c:choose>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
