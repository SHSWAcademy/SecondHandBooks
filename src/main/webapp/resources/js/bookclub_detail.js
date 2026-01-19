/**
 * 독서모임 상세 페이지 - 탭 전환 (비동기 로딩)
 * - 홈 탭: 서버 첫 렌더, 클릭 시 DOM 토글만
 * - 게시판 탭: 첫 클릭 시 fetch로 fragment 로드, 이후 캐싱
 */

(function () {
    'use strict';

    // contextPath (JSP에서 window.__CTX 주입)
    const ctx = window.__CTX || '';

    // DOM 요소
    const pageWrapper = document.querySelector('.bc-page-wrapper');
    const tabLinks = document.querySelectorAll('.bc-tab-link');
    const homeContainer = document.getElementById('bc-home-container');
    const boardContainer = document.getElementById('bc-board-container');

    // 게시판 fragment 캐싱 플래그
    let boardLoaded = false;

    // bookClubId 가져오기
    const bookClubId = pageWrapper ? pageWrapper.dataset.bookclubId : null;

    if (!bookClubId) {
        console.error('[bookclub_detail.js] data-bookclub-id를 찾을 수 없습니다.');
        return;
    }

    /**
     * 탭 전환 처리
     * @param {string} tabName - 'home' 또는 'board'
     */
    function switchTab(tabName) {
        // active 클래스 토글
        tabLinks.forEach(function (link) {
            const isActive = link.dataset.tab === tabName;
            if (isActive) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });

        // 컨테이너 표시/숨김
        if (tabName === 'home') {
            homeContainer.style.display = 'block';
            boardContainer.style.display = 'none';
        } else if (tabName === 'board') {
            homeContainer.style.display = 'none';
            boardContainer.style.display = 'block';

            // 게시판 첫 클릭 시 fetch로 로드
            if (!boardLoaded) {
                loadBoardFragment();
            }
        }
    }

    /**
     * 게시판 fragment fetch로 로드
     */
    function loadBoardFragment() {
        // 로딩 메시지 표시
        boardContainer.innerHTML = '<div class="bc-content-wrapper"><div class="bc-card"><p style="color: #718096;">게시판을 불러오는 중...</p></div></div>';

        const url = ctx + '/bookclubs/' + bookClubId + '/board-fragment';

        fetch(url, {
            method: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error('HTTP ' + response.status);
                }
                return response.text();
            })
            .then(function (html) {
                // fragment 삽입
                boardContainer.innerHTML = html;
                boardLoaded = true; // 캐싱 플래그 설정
            })
            .catch(function (error) {
                console.error('[bookclub_detail.js] 게시판 로드 실패:', error);
                boardContainer.innerHTML = '<div class="bc-content-wrapper"><div class="bc-card"><p style="color: #e53e3e;">게시판을 불러오지 못했습니다. 잠시 후 다시 시도해주세요.</p></div></div>';
            });
    }

    /**
     * 탭 클릭 이벤트 등록
     */
    tabLinks.forEach(function (link) {
        link.addEventListener('click', function (event) {
            event.preventDefault();
            const tabName = link.dataset.tab;
            switchTab(tabName);
        });
    });

    // 초기 상태: 홈 탭 활성화 (서버에서 이미 렌더링됨)
    console.log('[bookclub_detail.js] 탭 전환 스크립트 초기화 완료');
})();
