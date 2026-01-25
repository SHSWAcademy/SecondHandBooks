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

    /**
     * 가입 신청 모달
     */
    (function initApplyModal() {
        var btnOpen = document.getElementById('btnOpenApplyModal');
        var modal = document.getElementById('applyModal');

        if (!btnOpen || !modal) {
            return;
        }

        var overlay = modal.querySelector('.bc-apply-modal-overlay');
        var btnCancel = document.getElementById('btnCancelApply');
        var btnSubmit = document.getElementById('btnSubmitApply');
        var reasonInput = document.getElementById('applyReasonInput');

        function openModal() {
            modal.classList.add('bc-apply-modal-active');
            document.body.style.overflow = 'hidden';
        }

        function closeModal() {
            modal.classList.remove('bc-apply-modal-active');
            document.body.style.overflow = '';
            reasonInput.value = '';
        }

        btnOpen.addEventListener('click', openModal);
        btnCancel.addEventListener('click', closeModal);
        overlay.addEventListener('click', closeModal);

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && modal.classList.contains('bc-apply-modal-active')) {
                closeModal();
            }
        });

        btnSubmit.addEventListener('click', function () {
            var reason = reasonInput.value.trim();

            if (!reason) {
                alert('지원 동기를 입력해주세요.');
                reasonInput.focus();
                return;
            }

            btnSubmit.disabled = true;
            btnSubmit.textContent = '신청 중...';

            var url = ctx + '/bookclubs/' + bookClubId + '/join';

            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify({ reason: reason })
            })
            .then(function (res) {
                if (!res.ok) throw new Error('HTTP ' + res.status);
                return res.json();
            })
            .then(function () {
                alert('가입 신청이 완료되었습니다.');
                closeModal();
                location.reload();
            })
            .catch(function (err) {
                console.error('[bookclub_detail.js] 가입 신청 실패:', err);
                alert('가입 신청에 실패했습니다. 잠시 후 다시 시도해주세요.');
            })
            .finally(function () {
                btnSubmit.disabled = false;
                btnSubmit.textContent = '가입 신청';
            });
        });
    })();
})();
