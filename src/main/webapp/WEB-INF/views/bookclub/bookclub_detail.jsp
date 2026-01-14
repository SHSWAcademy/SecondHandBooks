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
    <title><c:out value="${bookclub.name}"/> - 신한북스</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bookclub.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="bookclub-main">
        <div class="container">
            <!-- 상단 배너 영역 -->
            <div class="detail-header">
                <div class="detail-banner">
                    <c:choose>
                        <c:when test="${not empty bookclub.bannerImgUrl}">
                            <img src="<c:out value='${bookclub.bannerImgUrl}'/>"
                                 alt="<c:out value='${bookclub.name}'/> 배너">
                        </c:when>
                        <c:otherwise>
                            <div class="detail-banner-placeholder">
                                <span>📚</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="detail-info">
                    <h1 class="detail-title">
                        <c:out value="${bookclub.name}"/>
                    </h1>

                    <div class="detail-meta">
                        <span class="meta-item">
                            <strong>지역:</strong> <c:out value="${bookclub.region}"/>
                        </span>
                        <span class="meta-item">
                            <strong>일정:</strong> <c:out value="${bookclub.schedule}"/>
                        </span>
                        <span class="meta-item">
                            <strong>인원:</strong> ${bookclub.memberCount}/${bookclub.maxMember}명
                        </span>
                    </div>

                    <div class="detail-desc">
                        <p><c:out value="${bookclub.desc}"/></p>
                    </div>

                    <!-- CTA 버튼 -->
                    <div class="detail-actions">
                        <c:choose>
                            <c:when test="${bookclub.isLeader}">
                                <a href="${pageContext.request.contextPath}/bookclubs/${bookclub.bookClubSeq}/manage"
                                   class="btn btn-primary">
                                    모임 관리하기
                                </a>
                            </c:when>
                            <c:when test="${bookclub.isMember}">
                                <span class="badge badge-success">가입됨</span>
                            </c:when>
                            <c:otherwise>
                                <button type="button"
                                        class="btn btn-primary"
                                        id="btnJoinRequest"
                                        data-club-seq="${bookclub.bookClubSeq}">
                                    가입 신청
                                </button>
                            </c:otherwise>
                        </c:choose>

                        <button type="button"
                                class="btn-wish ${bookclub.isWished ? 'wished' : ''}"
                                data-club-seq="${bookclub.bookClubSeq}"
                                aria-label="${bookclub.isWished ? '찜 취소' : '찜하기'}">
                            <span class="wish-icon">${bookclub.isWished ? '❤️' : '🤍'}</span>
                            찜
                        </button>
                    </div>
                </div>
            </div>

            <!-- 게시판 탭 -->
            <div class="detail-tabs">
                <nav class="tabs-nav" role="tablist">
                    <button type="button"
                            class="tab-btn active"
                            role="tab"
                            aria-selected="true"
                            aria-controls="tabBoard"
                            id="tabBtnBoard">
                        게시판
                    </button>
                    <button type="button"
                            class="tab-btn"
                            role="tab"
                            aria-selected="false"
                            aria-controls="tabInfo"
                            id="tabBtnInfo">
                        모임 정보
                    </button>
                </nav>

                <div class="tabs-content">
                    <!-- 게시판 탭 -->
                    <div class="tab-panel active" role="tabpanel" id="tabBoard" aria-labelledby="tabBtnBoard">
                        <div class="board-header">
                            <h2>게시판</h2>
                            <c:if test="${bookclub.isMember}">
                                <button type="button" class="btn btn-secondary" id="btnWritePost">
                                    글쓰기
                                </button>
                            </c:if>
                        </div>

                        <div class="board-list">
                            <c:choose>
                                <c:when test="${empty posts}">
                                    <div class="empty-state">
                                        <p>아직 작성된 글이 없습니다.</p>
                                        <c:if test="${bookclub.isMember}">
                                            <button type="button" class="btn btn-primary" id="btnWritePostEmpty">
                                                첫 글 작성하기
                                            </button>
                                        </c:if>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <ul class="post-list">
                                        <c:forEach var="post" items="${posts}">
                                            <li class="post-item" data-post-seq="${post.boardSeq}">
                                                <div class="post-header">
                                                    <span class="post-author">
                                                        <c:out value="${post.memberNickname}"/>
                                                    </span>
                                                    <span class="post-date">
                                                        <fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd HH:mm"/>
                                                    </span>
                                                </div>
                                                <div class="post-body">
                                                    <c:if test="${not empty post.title}">
                                                        <h3 class="post-title">
                                                            <c:out value="${post.title}"/>
                                                        </h3>
                                                    </c:if>
                                                    <p class="post-content">
                                                        <c:out value="${post.cont}"/>
                                                    </p>
                                                    <c:if test="${not empty post.imgUrl}">
                                                        <div class="post-image">
                                                            <img src="<c:out value='${post.imgUrl}'/>" alt="게시글 이미지">
                                                        </div>
                                                    </c:if>
                                                </div>
                                                <div class="post-footer">
                                                    <button type="button"
                                                            class="btn-link"
                                                            data-action="comment"
                                                            data-post-seq="${post.boardSeq}">
                                                        댓글 (추후 구현)
                                                    </button>
                                                </div>
                                            </li>
                                        </c:forEach>
                                    </ul>

                                    <!-- 페이징 -->
                                    <c:if test="${pageInfo.totalCount > 0}">
                                        <div class="pagination">
                                            <c:set var="totalPages" value="${(pageInfo.totalCount + pageInfo.size - 1) / pageInfo.size}" />
                                            <c:set var="currentPage" value="${pageInfo.page}" />

                                            <c:if test="${currentPage > 1}">
                                                <a href="?page=${currentPage - 1}&size=${pageInfo.size}" class="page-link">이전</a>
                                            </c:if>

                                            <span class="page-current">
                                                ${currentPage} / ${totalPages}
                                            </span>

                                            <c:if test="${currentPage < totalPages}">
                                                <a href="?page=${currentPage + 1}&size=${pageInfo.size}" class="page-link">다음</a>
                                            </c:if>
                                        </div>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- 모임 정보 탭 -->
                    <div class="tab-panel" role="tabpanel" id="tabInfo" aria-labelledby="tabBtnInfo">
                        <div class="info-section">
                            <h2>모임 정보</h2>
                            <dl class="info-list">
                                <dt>모임 이름</dt>
                                <dd><c:out value="${bookclub.name}"/></dd>

                                <dt>지역</dt>
                                <dd><c:out value="${bookclub.region}"/></dd>

                                <dt>일정</dt>
                                <dd><c:out value="${bookclub.schedule}"/></dd>

                                <dt>정원</dt>
                                <dd>${bookclub.maxMember}명</dd>

                                <dt>현재 인원</dt>
                                <dd>${bookclub.memberCount}명</dd>

                                <dt>소개</dt>
                                <dd><c:out value="${bookclub.desc}"/></dd>
                            </dl>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- 가입 신청 모달 -->
    <div class="modal" id="joinRequestModal" role="dialog" aria-labelledby="joinRequestTitle" aria-hidden="true">
        <div class="modal-overlay" data-dismiss="modal"></div>
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="joinRequestTitle">가입 신청</h2>
                <button type="button" class="modal-close" data-dismiss="modal" aria-label="닫기">×</button>
            </div>
            <div class="modal-body">
                <form id="joinRequestForm">
                    <div class="form-group">
                        <label for="joinRequestCont">
                            신청 사유 <span class="required">*</span>
                        </label>
                        <textarea id="joinRequestCont"
                                  name="cont"
                                  rows="5"
                                  class="form-textarea"
                                  placeholder="가입 신청 사유를 작성해주세요"
                                  required></textarea>
                        <p class="form-help">최소 10자 이상 입력해주세요.</p>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                <button type="submit" class="btn btn-primary" form="joinRequestForm">신청하기</button>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script src="${pageContext.request.contextPath}/resources/js/bookclub.js"></script>
    <script>
        // 페이지별 초기화
        document.addEventListener('DOMContentLoaded', function() {
            BookClub.initDetail(${bookclub.bookClubSeq});
        });
    </script>
</body>
</html>
