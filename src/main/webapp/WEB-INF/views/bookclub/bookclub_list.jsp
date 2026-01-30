<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <c:if test="${not empty _csrf}">
                    <meta name="_csrf" content="${fn:escapeXml(_csrf.token)}">
                    <meta name="_csrf_header" content="${fn:escapeXml(_csrf.headerName)}">
                </c:if>
                <title>독서모임 목록 - 신한북스</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bookclub/bookclub.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bookclub/place_search.css">
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

                        <div class="search-bar">
                            <%--
                            <form action="/bookclub/search" method="get">
                            --%>
                            <form onsubmit="return false;">
                                <input type="text" id="keyword" placeholder="지역, 모임명으로 검색해 보세요." />
                            </form>
                        </div>

                        <!-- 결과 정보 및 정렬 -->
                        <div class="result-info">
                            <p id="resultCount">
                                모임 <span id="clubCount">0</span>개
                            </p>
                            <div class="sort-toggle">
                                <button type="button" class="sort-btn active" data-sort="latest">최신순</button>
                                <button type="button" class="sort-btn" data-sort="activity">최근 활동순</button>
                            </div>
                        </div>

                        <!-- 모임 카드 목록 -->
                        <div class="bookclub-grid" id="bookclubGrid">
                            <c:choose>
                                <c:when test="${empty bookclubList}">
                                    <div class="empty-state">
                                        <p>검색 결과가 없습니다.</p>
                                        <a href="${pageContext.request.contextPath}/bookclubs/create"
                                            class="btn btn-primary">
                                            첫 모임 만들기
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="club" items="${bookclubList}">
                                        <article class="bookclub-card" data-club-seq="${club.book_club_seq}">
                                            <!-- 지역 태그 - 왼쪽 상단 -->
                                            <span class="card-region-tag">
                                                <c:out value="${club.book_club_rg}" />
                                            </span>
                                            <!-- 찜 버튼 - 오른쪽 상단 -->
                                            <button type="button" class="btn-wish ${club.wished ? 'wished' : ''}"
                                                onclick="toggleWish(${club.book_club_seq}, this); event.preventDefault(); event.stopPropagation();"
                                                data-club-seq="${club.book_club_seq}">
                                                <svg class="wish-icon" width="18" height="18" viewBox="0 0 24 24" fill="${club.wished ? 'currentColor' : 'none'}" stroke="currentColor" stroke-width="2">
                                                    <path d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
                                                </svg>
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
                                                            <c:out value="${club.book_club_name}" />
                                                        </h3>
                                                        <c:if test="${not empty club.book_club_desc}">
                                                            <p class="card-desc">
                                                                <c:out value="${club.book_club_desc}" />
                                                            </p>
                                                        </c:if>
                                                        <div class="card-footer">
                                                            <span class="card-schedule">
                                                                <c:out value="${club.book_club_schedule}" />
                                                            </span>
                                                            <span class="card-members">
                                                                <c:out value="${club.joined_member_count}"/> / <c:out value="${club.book_club_max_member}"/>
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

                        <%-- <!-- 페이징 (기본 구현) -->
                            <c:if test="${totalCount > 0}">
                                <div class="pagination">
                                    <c:set var="totalPages"
                                        value="${(totalCount + bookclubList.size - 1) / bookclubList.size}" />
                                    <c:set var="currentPage" value="${bookclubList.page}" />

                                    <c:if test="${currentPage > 1}">
                                        <a href="?page=${currentPage - 1}&keyword=<c:out value='${keyword}'/>&region=<c:out value='${bookclubList.region}'/>&sort=${fn:escapeXml(bookclubList.sort)}"
                                            class="page-link">이전</a>
                                    </c:if>

                                    <span class="page-current">
                                        ${currentPage} / ${totalPages}
                                    </span>

                                    <c:if test="${currentPage < totalPages}">
                                        <a href="?page=${currentPage + 1}&keyword=<c:out value='${keyword}'/>&region=<c:out value='${bookclubList.region}'/>&sort=${fn:escapeXml(bookclubList.sort)}"
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
                                <input type="text" name="book_club_name" class="form-input" placeholder="모임 이름"
                                    required>
                            </div>

                            <!-- 활동 지역 -->
                            <div class="form-group">
                                <label class="form-label">활동 지역</label>
                                <div class="toggle-group">
                                    <button type="button" class="toggle-btn active" data-value="offline" id="offlineToggle">오프라인</button>
                                    <button type="button" class="toggle-btn" data-value="online" id="onlineToggle">온라인</button>
                                </div>
                                <input type="hidden" name="book_club_type" id="bookClubType" value="offline">
                                <input type="hidden" name="book_club_rg" id="bookClubRegion" value="">

                                <!-- 오프라인 장소 검색 영역 -->
                                <div class="place-search-container" id="modalPlaceSearchContainer">
                                    <div class="place-search-input-wrap">
                                        <input type="text" id="modalPlaceSearchInput" class="form-input"
                                            placeholder="장소를 검색하세요 (예: 스타벅스 강남)"
                                            autocomplete="off">
                                        <button type="button" id="modalPlaceSearchBtn" class="btn-place-search">검색</button>
                                    </div>

                                    <!-- 검색 결과 리스트 -->
                                    <div class="place-search-results" id="modalPlaceSearchResults" style="display:none;">
                                        <ul id="modalPlaceResultList"></ul>
                                    </div>

                                    <!-- 지도 영역 -->
                                    <div class="place-map-container">
                                        <div id="modalPlaceMap" class="place-map"></div>
                                    </div>

                                    <!-- 선택된 장소 표시 -->
                                    <div class="selected-place" id="modalSelectedPlace" style="display:none;">
                                        <div class="selected-place-info">
                                            <strong id="modalSelectedPlaceName"></strong>
                                            <span id="modalSelectedPlaceAddress"></span>
                                        </div>
                                        <button type="button" class="btn-remove-place" id="modalRemovePlaceBtn" title="장소 삭제">X</button>
                                    </div>
                                </div>
                            </div>

                            <!-- 모임 소개 -->
                            <div class="form-group">
                                <textarea name="book_club_desc" class="form-textarea" placeholder="모임 소개" maxlength="500"></textarea>
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
                                <%--
                                <label class="form-label">최대 인원 (최대 10명)</label>
                                <input type="text" class="form-input-readonly" value="10" readonly>
                                --%>
                                <label class="form-label">모임의 최대 인원은 10명입니다.</label>
                                <input type="hidden" name="book_club_max_member" value="10">
                            </div>

                            <!-- 모임 개설 버튼 -->
                            <button type="submit" class="btn-submit">모임 개설하기</button>
                        </form>
                    </div>
                </div>

                <jsp:include page="/WEB-INF/views/common/footer.jsp" />

                <!-- 카카오 지도 SDK -->
                <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${fn:escapeXml(kakaoJsKey)}&libraries=services"></script>
                <script src="${pageContext.request.contextPath}/resources/js/bookclub/kakaoPlaceSearch.js"></script>
                <script src="${pageContext.request.contextPath}/resources/js/bookclub/bookclub.js"></script>
                <script>
                    // 페이지별 초기화
                    document.addEventListener('DOMContentLoaded', function () {
                        BookClub.initList();
                        initCreateModal();
                        initModalPlaceSearch();
                    });
                    // 로그인 세션 없이 모임 만들기 버튼 클릭 -> 로그인 요청 alert
                    document.getElementById("needLoginBtn")?.addEventListener("click", () => {
                        alert("로그인이 필요합니다.");
                        redirectToLogin();
                    });

                    // 모달 장소 검색 초기화
                    function initModalPlaceSearch() {
                        var offlineToggle = document.getElementById('offlineToggle');
                        var onlineToggle = document.getElementById('onlineToggle');
                        var placeSearchContainer = document.getElementById('modalPlaceSearchContainer');
                        var placeSearchInput = document.getElementById('modalPlaceSearchInput');
                        var placeSearchBtn = document.getElementById('modalPlaceSearchBtn');
                        var placeResultList = document.getElementById('modalPlaceResultList');
                        var placeSearchResults = document.getElementById('modalPlaceSearchResults');
                        var selectedPlaceDiv = document.getElementById('modalSelectedPlace');
                        var selectedPlaceName = document.getElementById('modalSelectedPlaceName');
                        var selectedPlaceAddress = document.getElementById('modalSelectedPlaceAddress');
                        var removePlaceBtn = document.getElementById('modalRemovePlaceBtn');
                        var regionInput = document.getElementById('bookClubRegion');
                        var typeInput = document.getElementById('bookClubType');

                        var mapInitialized = false;

                        // 카카오 지도 초기화 함수
                        function initKakaoMap() {
                            if (mapInitialized) {
                                KakaoPlaceSearch.relayout();
                                return;
                            }

                            KakaoPlaceSearch.init('modalPlaceMap', function(place) {
                                var address = place.road_address_name || place.address_name || '';
                                selectedPlaceName.textContent = place.place_name;
                                selectedPlaceAddress.textContent = address;
                                selectedPlaceDiv.style.display = 'flex';
                                placeSearchResults.style.display = 'none';
                                regionInput.value = KakaoPlaceSearch.formatPlaceString(place);
                            });

                            mapInitialized = true;
                        }

                        // 모달 열릴 때 지도 초기화
                        document.getElementById('openCreateModal')?.addEventListener('click', function() {
                            setTimeout(function() {
                                if (typeInput.value === 'offline') {
                                    initKakaoMap();
                                }
                            }, 300);
                        });

                        // 오프라인/온라인 토글
                        offlineToggle?.addEventListener('click', function() {
                            offlineToggle.classList.add('active');
                            onlineToggle.classList.remove('active');
                            typeInput.value = 'offline';
                            placeSearchContainer.style.display = 'block';
                            if (selectedPlaceDiv.style.display !== 'flex') {
                                regionInput.value = '';
                            }
                            setTimeout(function() {
                                initKakaoMap();
                            }, 100);
                        });

                        onlineToggle?.addEventListener('click', function() {
                            onlineToggle.classList.add('active');
                            offlineToggle.classList.remove('active');
                            typeInput.value = 'online';
                            placeSearchContainer.style.display = 'none';
                            regionInput.value = '온라인';
                            selectedPlaceDiv.style.display = 'none';
                        });

                        // 검색 버튼 클릭
                        placeSearchBtn?.addEventListener('click', function() {
                            searchPlaces();
                        });

                        // Enter 키로 검색
                        placeSearchInput?.addEventListener('keypress', function(e) {
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
                        removePlaceBtn?.addEventListener('click', function() {
                            selectedPlaceDiv.style.display = 'none';
                            regionInput.value = '';
                            if (mapInitialized) {
                                KakaoPlaceSearch.clearSelection();
                            }
                        });
                    }

                    // 찜 토글
                    function toggleWish(clubSeq, btn) {
                        fetch('${pageContext.request.contextPath}/bookclubs/' + clubSeq + '/wish', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                                'X-Requested-With': 'XMLHttpRequest'
                            }
                        })
                        .then(function(res) { return res.json(); })
                        .then(function(data) {
                            if (data.needLogin) {
                                alert('로그인이 필요합니다.');
                                redirectToLogin();
                                return;
                            }
                            if (data.status === 'ok') {
                                // 버튼 상태 업데이트
                                var svg = btn.querySelector('svg');
                                if (data.wished) {
                                    btn.classList.add('wished');
                                    svg.setAttribute('fill', 'currentColor');
                                } else {
                                    btn.classList.remove('wished');
                                    svg.setAttribute('fill', 'none');
                                }
                            } else {
                                alert(data.message || '오류가 발생했습니다.');
                            }
                        })
                        .catch(function(err) {
                            console.error('찜 토글 실패:', err);
                            alert('오류가 발생했습니다.');
                        });
                    }
                </script>
            </body>

            </html>