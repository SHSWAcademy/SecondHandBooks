<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

                    <!DOCTYPE html>
                    <html lang="ko">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <sec:csrfMetaTags />
                        <title>
                            <c:out value="${bookclub.name}" /> 관리 - 신한북스
                        </title>
                        <link rel="stylesheet"
                            href="${pageContext.request.contextPath}/resources/css/bookclub/bookclub_manage.css">
                        <link rel="stylesheet"
                            href="${pageContext.request.contextPath}/resources/css/bookclub/place_search.css">
                    </head>

                    <body>
                        <jsp:include page="/WEB-INF/views/common/header.jsp" />

                        <main class="bookclub-main">
                            <div class="container">
                                <!-- 에러/성공 메시지 영역 -->
                                <div id="alertBanner" class="alert-banner" role="alert" aria-live="polite"
                                    style="display: none;"></div>

                                <div class="page-header">
                                    <div>
                                        <h1>모임 관리</h1>
                                        <p class="page-subtitle">
                                            <c:out value="${bookclub.name}" />
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
                                        <span class="summary-value"
                                            id="currentMemberCount">${bookclub.memberCount}</span>
                                        <span class="summary-max">/${bookclub.maxMember}명</span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">대기 중인 신청</span>
                                        <span class="summary-value" id="pendingRequestCount">
                                            <c:out value="${fn:length(pendingRequests)}" default="0" />

                                        </span>
                                    </div>
                                </div>

                                <!-- 탭 네비게이션 -->
                                <div class="manage-tabs">
                                    <nav class="tabs-nav" role="tablist">
                                        <button type="button" class="tab-btn active" role="tab" aria-selected="true"
                                            aria-controls="tabRequests" id="tabBtnRequests">
                                            가입 신청
                                            <c:if test="${not empty pendingRequests}">
                                                <span class="badge badge-count">${fn:length(pendingRequests)}</span>
                                            </c:if>
                                        </button>
                                        <button type="button" class="tab-btn" role="tab" aria-selected="false"
                                            aria-controls="tabMembers" id="tabBtnMembers">
                                            멤버 관리
                                        </button>
                                        <button type="button" class="tab-btn" role="tab" aria-selected="false"
                                            aria-controls="tabSettings" id="tabBtnSettings">
                                            모임 설정
                                        </button>
                                    </nav>

                                    <div class="tabs-content">
                                        <!-- 가입 신청 탭 -->
                                        <div class="tab-panel active" role="tabpanel" id="tabRequests"
                                            aria-labelledby="tabBtnRequests">
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
                                                            <div class="request-card"
                                                                data-request-seq="${request.requestSeq}">
                                                                <div class="request-header">
                                                                    <div class="request-user">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty request.profileImgUrl}">
                                                                                <img src="<c:out value='${request.profileImgUrl}'/>"
                                                                                    alt="프로필 이미지" class="user-avatar">
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <div
                                                                                    class="user-avatar user-avatar-placeholder">
                                                                                    <span>
                                                                                        <c:out
                                                                                            value="${fn:substring(request.nickname, 0, 1)}" />
                                                                                    </span>
                                                                                </div>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        <div class="user-info">
                                                                            <strong class="user-name">
                                                                                <c:out value="${request.nickname}" />
                                                                            </strong>
                                                                            <span class="request-date">
                                                                                ${request.requestDtmText}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="request-body">
                                                                    <p class="request-content">
                                                                        <c:out value="${request.requestCont}" />
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
                                        <div class="tab-panel" role="tabpanel" id="tabMembers"
                                            aria-labelledby="tabBtnMembers">
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
                                                                        <tr class="member-row"
                                                                            data-member-seq="${member.memberSeq}">
                                                                            <td>
                                                                                <div class="member-cell">
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${not empty member.profileImgUrl}">
                                                                                            <img src="<c:out value='${member.profileImgUrl}'/>"
                                                                                                alt="프로필"
                                                                                                class="user-avatar-sm">
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <div
                                                                                                class="user-avatar-sm user-avatar-placeholder">
                                                                                                <span>
                                                                                                    <c:out
                                                                                                        value="${fn:substring(member.nickname, 0, 1)}" />
                                                                                                </span>
                                                                                            </div>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                    <span class="member-name">
                                                                                        <c:out
                                                                                            value="${member.nickname}" />
                                                                                    </span>
                                                                                </div>
                                                                            </td>
                                                                            <td>
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${member.leaderYn eq 'Y'}">
                                                                                        <span
                                                                                            class="badge badge-primary">모임장</span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span
                                                                                            class="badge badge-secondary">멤버</span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                            <td>
                                                                                <span class="badge badge-success">활동
                                                                                    중</span>
                                                                            </td>
                                                                            <td>
                                                                                ${member.joinStUpdateDtmText}
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
                                        <div class="tab-panel" role="tabpanel" id="tabSettings"
                                            aria-labelledby="tabBtnSettings">

                                            <div class="settings-section">
                                                <!-- 대표 이미지 (파일 업로드 + URL 입력) -->
                                                <div class="form-section banner-upload-section">
                                                    <label for="bannerFile" class="banner-upload-label">
                                                        <div class="banner-preview-wrapper">
                                                            <c:choose>
                                                                <c:when test="${not empty bookclub.bannerImgUrl}">
                                                                    <img src="<c:out value='${bookclub.bannerImgUrl}'/>"
                                                                        alt="모임 대표 이미지" class="banner-image"
                                                                        id="bannerPreview">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="banner-placeholder" id="bannerPreview">
                                                                        📚
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <p class="banner-upload-hint">클릭해서 이미지 업로드</p>
                                                    </label>
                                                    <input type="file" id="bannerFile" class="banner-file-input"
                                                        accept="image/*">
                                                    <!-- 기존 배너 이미지 URL 보존용 hidden input -->
                                                    <input type="hidden" id="existingBannerUrl" value="<c:out value='${bookclub.bannerImgUrl}'/>">
                                                </div>

                                                <!-- 모임 이름 -->
                                                <div class="form-group">
                                                    <label for="clubName" class="form-label">모임 이름 <span
                                                            class="required">*</span></label>
                                                    <input type="text" id="clubName" class="form-input"
                                                        value="<c:out value='${bookclub.name}'/>" required
                                                        maxlength="50">
                                                </div>

                                                <!-- 모임 소개 -->
                                                <div class="form-group">
                                                    <label for="clubDescription" class="form-label">모임 소개 <span
                                                            class="required">*</span></label>
                                                    <textarea id="clubDescription" class="form-textarea" required
                                                        maxlength="500"><c:out value="${bookclub.description}" /></textarea>
                                                    <p class="form-help-text">모임의 특징과 목적을 자유롭게 소개해주세요 (최대 500자)</p>
                                                </div>

                                                <!-- 모임 장소 -->
                                                <div class="form-group">
                                                    <label class="form-label">모임 장소</label>

                                                    <!-- 온라인/오프라인 선택 -->
                                                    <div class="place-type-toggle">
                                                        <label class="radio-label">
                                                            <input type="radio" name="placeTypeManage" value="online"
                                                                ${bookclub.region eq '온라인' ? 'checked' : ''}>
                                                            <span>온라인</span>
                                                        </label>
                                                        <label class="radio-label">
                                                            <input type="radio" name="placeTypeManage" value="offline"
                                                                ${bookclub.region ne '온라인' ? 'checked' : ''}>
                                                            <span>오프라인</span>
                                                        </label>
                                                    </div>

                                                    <!-- 오프라인 장소 검색 영역 -->
                                                    <div class="place-search-container" id="placeSearchContainerManage"
                                                        style="${bookclub.region eq '온라인' ? 'display:none;' : ''}">
                                                        <div class="place-search-input-wrap">
                                                            <input type="text" id="placeSearchInputManage" class="form-input"
                                                                placeholder="장소를 검색하세요 (예: 스타벅스 강남)"
                                                                autocomplete="off">
                                                            <button type="button" id="placeSearchBtnManage" class="btn-place-search">검색</button>
                                                        </div>

                                                        <!-- 검색 결과 리스트 -->
                                                        <div class="place-search-results" id="placeSearchResultsManage" style="display:none;">
                                                            <ul id="placeResultListManage"></ul>
                                                        </div>

                                                        <!-- 지도 영역 -->
                                                        <div class="place-map-container">
                                                            <div id="placeMapManage" class="place-map"></div>
                                                        </div>

                                                        <!-- 선택된 장소 표시 -->
                                                        <div class="selected-place" id="selectedPlaceManage"
                                                            style="${not empty bookclub.region && bookclub.region ne '온라인' ? 'display:flex;' : 'display:none;'}">
                                                            <div class="selected-place-info">
                                                                <strong id="selectedPlaceNameManage"><c:out value="${bookclub.region}"/></strong>
                                                                <span id="selectedPlaceAddressManage"></span>
                                                            </div>
                                                            <button type="button" class="btn-remove-place" id="removePlaceBtnManage" title="장소 삭제">X</button>
                                                        </div>
                                                    </div>

                                                    <!-- 실제 값 저장용 hidden input -->
                                                    <input type="hidden" id="clubRegion" value="<c:out value='${bookclub.region}'/>">
                                                </div>

                                                <!-- 정기 일정 -->
                                                <div class="form-group">
                                                    <label class="form-label">정기 모임 일정 (선택)</label>
                                                    <!-- 주기 선택 -->
                                                    <div class="schedule-row">
                                                        <div class="toggle-group schedule-cycle">
                                                            <button type="button" class="toggle-btn cycle-btn-manage" data-value="매일">매일</button>
                                                            <button type="button" class="toggle-btn cycle-btn-manage" data-value="매주">매주</button>
                                                            <button type="button" class="toggle-btn cycle-btn-manage" data-value="매월">매월</button>
                                                        </div>
                                                    </div>
                                                    <!-- 주차 선택 (매월 선택시만 표시) -->
                                                    <div class="schedule-row week-select" id="weekSelectManage" style="display: none;">
                                                        <select class="form-input" id="scheduleWeekManage">
                                                            <option value="">주차 선택</option>
                                                            <option value="첫째주">첫째주</option>
                                                            <option value="둘째주">둘째주</option>
                                                            <option value="셋째주">셋째주</option>
                                                            <option value="넷째주">넷째주</option>
                                                            <option value="다섯째주">다섯째주</option>
                                                        </select>
                                                    </div>
                                                    <!-- 요일 선택 (매주/매월 선택시 표시) -->
                                                    <div class="schedule-row day-select" id="daySelectManage" style="display: none;">
                                                        <div class="day-group">
                                                            <button type="button" class="day-btn-manage" data-value="월">월</button>
                                                            <button type="button" class="day-btn-manage" data-value="화">화</button>
                                                            <button type="button" class="day-btn-manage" data-value="수">수</button>
                                                            <button type="button" class="day-btn-manage" data-value="목">목</button>
                                                            <button type="button" class="day-btn-manage" data-value="금">금</button>
                                                            <button type="button" class="day-btn-manage" data-value="토">토</button>
                                                            <button type="button" class="day-btn-manage" data-value="일">일</button>
                                                        </div>
                                                    </div>
                                                    <!-- 시간 선택 -->
                                                    <div class="schedule-row time-select" id="timeSelectManage" style="display: none;">
                                                        <select class="form-input time-input" id="scheduleHourManage">
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
                                                    <input type="hidden" id="clubSchedule" value="<c:out value='${bookclub.schedule}'/>">
                                                </div>

                                                <!-- 저장 버튼 -->
                                                <div class="form-actions">
                                                    <button type="button" id="btnSaveSettings" class="btn-submit">변경사항
                                                        저장</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </main>

                        <!-- 거절 사유 모달 -->
                        <div class="modal" id="rejectModal" role="dialog" aria-labelledby="rejectTitle"
                            aria-hidden="true">
                            <div class="modal-overlay" data-dismiss="modal"></div>
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h2 id="rejectTitle">가입 거절</h2>
                                    <button type="button" class="modal-close" data-dismiss="modal"
                                        aria-label="닫기">×</button>
                                </div>
                                <div class="modal-body">
                                    <form id="rejectForm">
                                        <input type="hidden" id="rejectRequestSeq" name="requestSeq">
                                        <input type="hidden" id="rejectClubSeq" name="clubSeq">
                                        <div class="form-group">
                                            <label for="rejectReason">거절 사유 (선택)</label>
                                            <textarea id="rejectReason" name="reason" rows="4" class="form-textarea"
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

                        <script>
                            // contextPath 전역 변수 설정 (JS에서 API URL 빌드에 사용)
                            window.contextPath = '${pageContext.request.contextPath}';
                        </script>
                        <!-- 카카오 지도 SDK -->
                        <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${fn:escapeXml(kakaoJsKey)}&libraries=services"></script>
                        <script src="${pageContext.request.contextPath}/resources/js/bookclub/kakaoPlaceSearch.js"></script>
                        <script
                            src="${pageContext.request.contextPath}/resources/js/bookclub/bookclub_manage.js"></script>
                        <script>
                            // 페이지별 초기화
                            document.addEventListener('DOMContentLoaded', function () {
                                BookClubManage.init(${ bookclub.bookClubSeq });
                                initPlaceSearchManage();
                                initScheduleManage();
                            });

                            function initScheduleManage() {
                                var cycleBtns = document.querySelectorAll('.cycle-btn-manage');
                                var weekSelect = document.getElementById('weekSelectManage');
                                var daySelect = document.getElementById('daySelectManage');
                                var timeSelect = document.getElementById('timeSelectManage');
                                var dayBtns = document.querySelectorAll('.day-btn-manage');
                                var scheduleWeek = document.getElementById('scheduleWeekManage');
                                var scheduleHour = document.getElementById('scheduleHourManage');
                                var clubSchedule = document.getElementById('clubSchedule');

                                var selectedCycle = '';
                                var selectedDay = '';

                                // 기존 값 파싱 및 UI 설정
                                var existingSchedule = clubSchedule.value || '';
                                if (existingSchedule) {
                                    parseAndSetSchedule(existingSchedule);
                                }

                                // 기존 일정 파싱하여 UI에 반영
                                function parseAndSetSchedule(schedule) {
                                    // 패턴: "매일 오후 2시", "매주 토요일 오후 2시", "매월 첫째주 토요일 오후 2시"
                                    var parts = schedule.split(' ');

                                    if (parts.length === 0) return;

                                    // 주기 (매일/매주/매월)
                                    var cycle = parts[0];
                                    if (['매일', '매주', '매월'].includes(cycle)) {
                                        selectedCycle = cycle;
                                        cycleBtns.forEach(function(btn) {
                                            if (btn.dataset.value === cycle) {
                                                btn.classList.add('active');
                                            }
                                        });

                                        timeSelect.style.display = 'block';

                                        if (cycle === '매주') {
                                            daySelect.style.display = 'block';
                                        } else if (cycle === '매월') {
                                            weekSelect.style.display = 'block';
                                            daySelect.style.display = 'block';
                                        }
                                    }

                                    // 주차 (매월인 경우)
                                    if (cycle === '매월' && parts.length > 1) {
                                        var weekOptions = ['첫째주', '둘째주', '셋째주', '넷째주', '다섯째주'];
                                        if (weekOptions.includes(parts[1])) {
                                            scheduleWeek.value = parts[1];
                                        }
                                    }

                                    // 요일 찾기
                                    var dayPattern = /(월|화|수|목|금|토|일)요일/;
                                    for (var i = 0; i < parts.length; i++) {
                                        var match = parts[i].match(dayPattern);
                                        if (match) {
                                            selectedDay = match[1] + '요일';
                                            dayBtns.forEach(function(btn) {
                                                if (btn.dataset.value === match[1]) {
                                                    btn.classList.add('active');
                                                }
                                            });
                                            break;
                                        }
                                    }

                                    // 시간 찾기 (오전/오후 X시)
                                    var timePattern = /(오전|오후)\s*(\d+)시/;
                                    var timeMatch = schedule.match(timePattern);
                                    if (timeMatch) {
                                        var timeValue = timeMatch[1] + ' ' + timeMatch[2] + '시';
                                        scheduleHour.value = timeValue;
                                    }
                                }

                                // 주기 선택
                                cycleBtns.forEach(function(btn) {
                                    btn.addEventListener('click', function() {
                                        cycleBtns.forEach(function(b) { b.classList.remove('active'); });
                                        btn.classList.add('active');

                                        selectedCycle = btn.dataset.value;

                                        // 초기화
                                        weekSelect.style.display = 'none';
                                        daySelect.style.display = 'none';
                                        scheduleWeek.value = '';
                                        selectedDay = '';
                                        dayBtns.forEach(function(b) { b.classList.remove('active'); });

                                        if (selectedCycle === '매주') {
                                            daySelect.style.display = 'block';
                                        } else if (selectedCycle === '매월') {
                                            weekSelect.style.display = 'block';
                                            daySelect.style.display = 'block';
                                        }

                                        timeSelect.style.display = 'block';
                                        updateScheduleValue();
                                    });
                                });

                                // 주차 선택
                                scheduleWeek.addEventListener('change', function() {
                                    updateScheduleValue();
                                });

                                // 요일 선택
                                dayBtns.forEach(function(btn) {
                                    btn.addEventListener('click', function() {
                                        dayBtns.forEach(function(b) { b.classList.remove('active'); });
                                        btn.classList.add('active');
                                        selectedDay = btn.dataset.value + '요일';
                                        updateScheduleValue();
                                    });
                                });

                                // 시간 선택
                                scheduleHour.addEventListener('change', function() {
                                    updateScheduleValue();
                                });

                                // 일정 값 조합
                                function updateScheduleValue() {
                                    var schedule = '';
                                    if (selectedCycle) {
                                        schedule = selectedCycle;
                                        if (selectedCycle === '매월' && scheduleWeek.value) {
                                            schedule += ' ' + scheduleWeek.value;
                                        }
                                        if ((selectedCycle === '매주' || selectedCycle === '매월') && selectedDay) {
                                            schedule += ' ' + selectedDay;
                                        }
                                        if (scheduleHour.value) {
                                            schedule += ' ' + scheduleHour.value;
                                        }
                                    }
                                    clubSchedule.value = schedule;
                                }
                            }

                            function initPlaceSearchManage() {
                                var placeTypeRadios = document.querySelectorAll('input[name="placeTypeManage"]');
                                var placeSearchContainer = document.getElementById('placeSearchContainerManage');
                                var placeSearchInput = document.getElementById('placeSearchInputManage');
                                var placeSearchBtn = document.getElementById('placeSearchBtnManage');
                                var placeResultList = document.getElementById('placeResultListManage');
                                var placeSearchResults = document.getElementById('placeSearchResultsManage');
                                var selectedPlaceDiv = document.getElementById('selectedPlaceManage');
                                var selectedPlaceName = document.getElementById('selectedPlaceNameManage');
                                var selectedPlaceAddress = document.getElementById('selectedPlaceAddressManage');
                                var removePlaceBtn = document.getElementById('removePlaceBtnManage');
                                var regionInput = document.getElementById('clubRegion');

                                // 탭 전환 시 지도 리사이즈를 위한 변수
                                var mapInitialized = false;

                                // 카카오 지도 초기화 함수
                                function initKakaoMap() {
                                    if (mapInitialized) {
                                        KakaoPlaceSearch.relayout();
                                        return;
                                    }

                                    KakaoPlaceSearch.init('placeMapManage', function(place) {
                                        var address = place.road_address_name || place.address_name || '';
                                        selectedPlaceName.textContent = place.place_name;
                                        selectedPlaceAddress.textContent = address;
                                        selectedPlaceDiv.style.display = 'flex';
                                        placeSearchResults.style.display = 'none';
                                        regionInput.value = KakaoPlaceSearch.formatPlaceString(place);
                                    });

                                    mapInitialized = true;

                                    // 기존 저장된 위치가 있으면 지도에 표시
                                    var savedRegion = regionInput.value;
                                    if (savedRegion && savedRegion !== '온라인') {
                                        KakaoPlaceSearch.displaySavedLocation(savedRegion);
                                    }
                                }

                                // 모임 설정 탭 클릭 시 지도 초기화
                                var settingsTabBtn = document.getElementById('tabBtnSettings');
                                if (settingsTabBtn) {
                                    settingsTabBtn.addEventListener('click', function() {
                                        setTimeout(function() {
                                            if (placeSearchContainer.style.display !== 'none') {
                                                initKakaoMap();
                                            }
                                        }, 100);
                                    });
                                }

                                // 온라인/오프라인 선택 변경
                                placeTypeRadios.forEach(function(radio) {
                                    radio.addEventListener('change', function() {
                                        if (this.value === 'online') {
                                            placeSearchContainer.style.display = 'none';
                                            regionInput.value = '온라인';
                                            selectedPlaceDiv.style.display = 'none';
                                        } else {
                                            placeSearchContainer.style.display = 'block';
                                            if (selectedPlaceDiv.style.display !== 'flex') {
                                                regionInput.value = '';
                                            }
                                            setTimeout(function() {
                                                initKakaoMap();
                                            }, 100);
                                        }
                                    });
                                });

                                // 검색 버튼 클릭
                                placeSearchBtn.addEventListener('click', function() {
                                    searchPlaces();
                                });

                                // Enter 키로 검색
                                placeSearchInput.addEventListener('keypress', function(e) {
                                    if (e.key === 'Enter') {
                                        e.preventDefault();
                                        searchPlaces();
                                    }
                                });

                                // 장소 검색 함수
                                function searchPlaces() {
                                    var keyword = placeSearchInput.value.trim();
                                    if (!keyword) {
                                        alert('장소를 입력해주세요.');
                                        return;
                                    }

                                    if (!mapInitialized) {
                                        initKakaoMap();
                                    }

                                    KakaoPlaceSearch.searchPlaces(keyword, function(results, status) {
                                        placeResultList.innerHTML = '';

                                        if (status === kakao.maps.services.Status.OK) {
                                            placeSearchResults.style.display = 'block';

                                            results.slice(0, 10).forEach(function(place) {
                                                var li = document.createElement('li');
                                                li.className = 'place-result-item';
                                                li.innerHTML = '<strong>' + place.place_name + '</strong>' +
                                                               '<span>' + (place.road_address_name || place.address_name) + '</span>';
                                                li.addEventListener('click', function() {
                                                    KakaoPlaceSearch.selectPlace(place);
                                                });
                                                placeResultList.appendChild(li);
                                            });
                                        } else {
                                            placeSearchResults.style.display = 'block';
                                            placeResultList.innerHTML = '<li class="no-result">검색 결과가 없습니다.</li>';
                                        }
                                    });
                                }

                                // 선택 장소 삭제
                                removePlaceBtn.addEventListener('click', function() {
                                    selectedPlaceDiv.style.display = 'none';
                                    regionInput.value = '';
                                    if (mapInitialized) {
                                        KakaoPlaceSearch.clearSelection();
                                    }
                                });
                            }
                        </script>
                    </body>

                    </html>

                    <style>
                        .settings-section {
                            max-width: 800px;
                            margin: 0 auto;
                        }
                    </style>