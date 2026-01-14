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
    <title><c:out value="${bookclub.name}"/> 관리 - 신한북스</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bookclub.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="bookclub-main">
        <div class="container">
            <!-- 에러/성공 메시지 영역 -->
            <div id="alertBanner" class="alert-banner" role="alert" aria-live="polite" style="display: none;"></div>

            <div class="page-header">
                <div>
                    <h1>모임 관리</h1>
                    <p class="page-subtitle">
                        <c:out value="${bookclub.name}"/>
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/bookclubs/${bookclub.bookClubSeq}"
                   class="btn btn-secondary">
                    모임으로 돌아가기
                </a>
            </div>

            <!-- 모임 현황 -->
            <div class="manage-summary">
                <div class="summary-item">
                    <span class="summary-label">현재 인원</span>
                    <span class="summary-value" id="currentMemberCount">${bookclub.memberCount}</span>
                    <span class="summary-max">/${bookclub.maxMember}명</span>
                </div>
                <div class="summary-item">
                    <span class="summary-label">대기 중인 신청</span>
                    <span class="summary-value" id="pendingRequestCount">
                        <c:out value="${fn:length(pendingRequests)}" default="0"/>
                    </span>
                </div>
            </div>

            <!-- 탭 네비게이션 -->
            <div class="manage-tabs">
                <nav class="tabs-nav" role="tablist">
                    <button type="button"
                            class="tab-btn active"
                            role="tab"
                            aria-selected="true"
                            aria-controls="tabRequests"
                            id="tabBtnRequests">
                        가입 신청
                        <c:if test="${not empty pendingRequests}">
                            <span class="badge badge-count">${fn:length(pendingRequests)}</span>
                        </c:if>
                    </button>
                    <button type="button"
                            class="tab-btn"
                            role="tab"
                            aria-selected="false"
                            aria-controls="tabMembers"
                            id="tabBtnMembers">
                        멤버 관리
                    </button>
                    <button type="button"
                            class="tab-btn"
                            role="tab"
                            aria-selected="false"
                            aria-controls="tabSettings"
                            id="tabBtnSettings">
                        모임 설정
                    </button>
                </nav>

                <div class="tabs-content">
                    <!-- 가입 신청 탭 -->
                    <div class="tab-panel active" role="tabpanel" id="tabRequests" aria-labelledby="tabBtnRequests">
                        <div class="panel-header">
                            <h2>가입 신청 목록</h2>
                        </div>

                        <div class="request-list" id="requestList">
                            <c:choose>
                                <c:when test="${empty pendingRequests}">
                                    <div class="empty-state">
                                        <p>대기 중인 가입 신청이 없습니다.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="request" items="${pendingRequests}">
                                        <div class="request-card" data-request-seq="${request.requestSeq}">
                                            <div class="request-header">
                                                <div class="request-user">
                                                    <c:if test="${not empty request.profileImgUrl}">
                                                        <img src="<c:out value='${request.profileImgUrl}'/>"
                                                             alt="프로필 이미지"
                                                             class="user-avatar">
                                                    </c:if>
                                                    <div class="user-info">
                                                        <strong class="user-name">
                                                            <c:out value="${request.nickname}"/>
                                                        </strong>
                                                        <span class="request-date">
                                                            <fmt:formatDate value="${request.requestDtm}"
                                                                          pattern="yyyy.MM.dd HH:mm"/>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="request-body">
                                                <p class="request-content">
                                                    <c:out value="${request.requestCont}"/>
                                                </p>
                                            </div>
                                            <div class="request-actions">
                                                <button type="button"
                                                        class="btn btn-success btn-approve"
                                                        data-request-seq="${request.requestSeq}"
                                                        data-club-seq="${bookclub.bookClubSeq}">
                                                    승인
                                                </button>
                                                <button type="button"
                                                        class="btn btn-danger btn-reject"
                                                        data-request-seq="${request.requestSeq}"
                                                        data-club-seq="${bookclub.bookClubSeq}">
                                                    거절
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- 멤버 관리 탭 -->
                    <div class="tab-panel" role="tabpanel" id="tabMembers" aria-labelledby="tabBtnMembers">
                        <div class="panel-header">
                            <h2>멤버 목록</h2>
                        </div>

                        <div class="member-list" id="memberList">
                            <c:choose>
                                <c:when test="${empty members}">
                                    <div class="empty-state">
                                        <p>멤버가 없습니다.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="member-table-wrapper">
                                        <table class="member-table">
                                            <thead>
                                                <tr>
                                                    <th>멤버</th>
                                                    <th>권한</th>
                                                    <th>상태</th>
                                                    <th>가입일</th>
                                                    <th>작업</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="member" items="${members}">
                                                    <tr class="member-row" data-member-seq="${member.memberSeq}">
                                                        <td>
                                                            <div class="member-cell">
                                                                <c:if test="${not empty member.profileImgUrl}">
                                                                    <img src="<c:out value='${member.profileImgUrl}'/>"
                                                                         alt="프로필"
                                                                         class="user-avatar-sm">
                                                                </c:if>
                                                                <span class="member-name">
                                                                    <c:out value="${member.nickname}"/>
                                                                </span>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${member.leaderYn eq 'Y'}">
                                                                    <span class="badge badge-primary">모임장</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-secondary">멤버</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="badge badge-success">활동 중</span>
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate value="${member.joinStUpdateDtm}"
                                                                          pattern="yyyy.MM.dd"/>
                                                        </td>
                                                        <td>
                                                            <c:if test="${member.leaderYn ne 'Y'}">
                                                                <button type="button"
                                                                        class="btn btn-sm btn-danger btn-kick"
                                                                        data-member-seq="${member.memberSeq}"
                                                                        data-club-seq="${bookclub.bookClubSeq}"
                                                                        data-member-name="<c:out value='${member.nickname}'/>">
                                                                    퇴장
                                                                </button>
                                                            </c:if>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- 모임 설정 탭 -->
                    <div class="tab-panel" role="tabpanel" id="tabSettings" aria-labelledby="tabBtnSettings">
                        <div class="panel-header">
                            <h2>모임 설정</h2>
                        </div>

                        <div class="settings-section">
                            <div class="alert alert-info">
                                <p>모임 설정 기능은 추후 구현 예정입니다.</p>
                            </div>

                            <div class="settings-preview">
                                <dl class="info-list">
                                    <dt>모임 이름</dt>
                                    <dd><c:out value="${bookclub.name}"/></dd>

                                    <dt>지역</dt>
                                    <dd><c:out value="${bookclub.region}"/></dd>

                                    <dt>정원</dt>
                                    <dd>${bookclub.maxMember}명</dd>

                                    <dt>일정</dt>
                                    <dd><c:out value="${bookclub.schedule}"/></dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- 거절 사유 모달 -->
    <div class="modal" id="rejectModal" role="dialog" aria-labelledby="rejectTitle" aria-hidden="true">
        <div class="modal-overlay" data-dismiss="modal"></div>
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="rejectTitle">가입 거절</h2>
                <button type="button" class="modal-close" data-dismiss="modal" aria-label="닫기">×</button>
            </div>
            <div class="modal-body">
                <form id="rejectForm">
                    <input type="hidden" id="rejectRequestSeq" name="requestSeq">
                    <input type="hidden" id="rejectClubSeq" name="clubSeq">
                    <div class="form-group">
                        <label for="rejectReason">거절 사유 (선택)</label>
                        <textarea id="rejectReason"
                                  name="reason"
                                  rows="4"
                                  class="form-textarea"
                                  placeholder="거절 사유를 입력하면 신청자에게 전달됩니다."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                <button type="submit" class="btn btn-danger" form="rejectForm">거절하기</button>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script src="${pageContext.request.contextPath}/resources/js/bookclub.js"></script>
    <script>
        // 페이지별 초기화
        document.addEventListener('DOMContentLoaded', function() {
            BookClub.initManage(${bookclub.bookClubSeq});
        });
    </script>
</body>
</html>
