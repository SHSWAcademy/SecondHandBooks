<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!-- 게시판 탭 본문 (fragment) - header/footer 없음 -->
                <div class="bc-content-wrapper">
                    <!-- 상단: 타이틀 + 글쓰기 버튼 -->
                    <div
                        style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                        <h2 class="bc-card-title" style="margin: 0;">
                            <svg width="24" height="24" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                                style="display: inline-block; vertical-align: middle; margin-right: 0.5rem;">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                            </svg>
                            게시판
                        </h2>
                        <button type="button" onclick="alert('TODO: 글쓰기 페이지로 이동 예정')"
                            style="display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.625rem 1rem; background: #4299e1; color: white; border: none; border-radius: 0.5rem; font-size: 0.875rem; font-weight: 600; cursor: pointer; transition: background 0.2s;">
                            <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M12 4v16m8-8H4" />
                            </svg>
                            글쓰기
                        </button>
                    </div>

                    <!-- 게시글 목록 -->
                    <c:choose>
                        <c:when test="${empty boards}">
                            <!-- 빈 상태 -->
                            <div class="bc-card" style="text-align: center; padding: 3rem 1.5rem;">
                                <svg width="48" height="48" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                                    style="margin: 0 auto 1rem; opacity: 0.3;">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                                </svg>
                                <p style="color: #a0aec0; font-size: 0.875rem; margin: 0;">등록된 게시글이 없습니다.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- 게시글 카드 리스트 -->
                            <div style="display: flex; flex-direction: column; gap: 1rem;">
                                <c:forEach var="board" items="${boards}">
                                    <a href="${pageContext.request.contextPath}/bookclubs/${bookClubId}/posts/${board.book_club_board_seq}"
                                        style="text-decoration: none; color: inherit;">
                                        <div class="bc-card"
                                            style="cursor: pointer; transition: transform 0.2s, box-shadow 0.2s;"
                                            onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06)';"
                                            onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 1px 3px 0 rgba(0,0,0,0.1), 0 1px 2px 0 rgba(0,0,0,0.06)';">

                                            <!-- 제목 -->
                                            <h3
                                                style="font-size: 1rem; font-weight: 600; color: #2d3748; margin: 0 0 0.5rem 0; line-height: 1.5;">
                                                ${fn:escapeXml(board.board_title)}
                                            </h3>

                                        <!-- 본문 미리보기 -->
                                        <c:if test="${not empty board.board_cont}">
                                            <p
                                                style="color: #718096; font-size: 0.875rem; line-height: 1.6; margin: 0 0 0.75rem 0; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;">
                                                ${fn:escapeXml(board.board_cont)}
                                            </p>
                                        </c:if>

                                        <!-- 이미지 썸네일 (있을 경우) -->
                                        <c:if test="${not empty board.board_img_url}">
                                            <div
                                                style="margin-bottom: 0.75rem; border-radius: 0.5rem; overflow: hidden; max-height: 200px;">
                                                <c:choose>
                                                    <c:when
                                                        test="${board.board_img_url.startsWith('http://') or board.board_img_url.startsWith('https://')}">
                                                        <img src="${board.board_img_url}" alt="게시글 이미지"
                                                            style="width: 100%; height: auto; object-fit: cover;">
                                                    </c:when>
                                                    <c:when test="${board.board_img_url.startsWith('/')}">
                                                        <img src="${pageContext.request.contextPath}${board.board_img_url}"
                                                            alt="게시글 이미지"
                                                            style="width: 100%; height: auto; object-fit: cover;">
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                        </c:if>

                                        <!-- 메타 정보 (작성자 + 작성일) -->
                                        <div
                                            style="display: flex; align-items: center; gap: 0.75rem; font-size: 0.75rem; color: #a0aec0;">
                                            <span style="display: flex; align-items: center; gap: 0.25rem;">
                                                <svg width="14" height="14" fill="none" stroke="currentColor"
                                                    viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                                                </svg>
                                                ${fn:escapeXml(board.member_nicknm)}
                                            </span>
                                            <span style="display: flex; align-items: center; gap: 0.25rem;">
                                                <svg width="14" height="14" fill="none" stroke="currentColor"
                                                    viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                </svg>
                                                <c:choose>
                                                    <c:when test="${not empty board.board_crt_dtm_text}">
                                                        ${board.board_crt_dtm_text}
                                                    </c:when>
                                                    <c:otherwise>
                                                        방금
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        </div>
                                    </a>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>