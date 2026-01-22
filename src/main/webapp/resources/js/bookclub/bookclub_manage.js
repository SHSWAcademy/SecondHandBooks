/**
 * 독서모임 관리 페이지 - 탭 전환 기능만 구현
 * (서버 통신/fetch 로직은 추후 구현)
 */

const BookClubManage = (() => {

    let currentTab = 'tabRequests'; // 기본 활성 탭: 가입 신청

    /**
     * 탭 전환 초기화
     */
    function initTabs() {
        const tabBtns = document.querySelectorAll('.tab-btn');

        tabBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const targetId = btn.getAttribute('aria-controls');
                switchTab(targetId);
            });
        });
    }

    /**
     * 탭 전환 처리
     */
    function switchTab(targetId) {
        // 모든 탭 버튼 비활성화
        const allTabBtns = document.querySelectorAll('.tab-btn');
        allTabBtns.forEach(btn => {
            btn.classList.remove('active');
            btn.setAttribute('aria-selected', 'false');
        });

        // 모든 탭 패널 숨김
        const allPanels = document.querySelectorAll('.tab-panel');
        allPanels.forEach(panel => {
            panel.classList.remove('active');
        });

        // 선택한 탭 활성화
        const targetBtn = document.querySelector(`[aria-controls="${targetId}"]`);
        const targetPanel = document.getElementById(targetId);

        if (targetBtn && targetPanel) {
            targetBtn.classList.add('active');
            targetBtn.setAttribute('aria-selected', 'true');
            targetPanel.classList.add('active');
            currentTab = targetId;
        }
    }

    /**
     * 모달 초기화 (거절 사유 입력)
     */
    function initModal() {
        const modal = document.getElementById('rejectModal');
        if (!modal) return;

        const closeBtns = modal.querySelectorAll('[data-dismiss="modal"]');

        closeBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                closeModal();
            });
        });

        // 오버레이 클릭 시 닫기
        const overlay = modal.querySelector('.modal-overlay');
        overlay?.addEventListener('click', () => {
            closeModal();
        });
    }

    /**
     * 모달 열기
     */
    function openModal() {
        const modal = document.getElementById('rejectModal');
        if (modal) {
            modal.setAttribute('aria-hidden', 'false');
        }
    }

    /**
     * 모달 닫기
     */
    function closeModal() {
        const modal = document.getElementById('rejectModal');
        if (modal) {
            modal.setAttribute('aria-hidden', 'true');
            // 폼 초기화
            const form = document.getElementById('rejectForm');
            form?.reset();
        }
    }

    /**
     * 이미지 업로드 프리뷰
     */
    function initImageUpload() {
        const bannerUpload = document.getElementById('bannerUpload');
        const bannerPreview = document.getElementById('bannerPreview');

        if (!bannerUpload || !bannerPreview) return;

        bannerUpload.addEventListener('change', (e) => {
            const file = e.target.files[0];
            if (!file) return;

            // 파일 타입 검증
            if (!file.type.startsWith('image/')) {
                alert('이미지 파일만 업로드 가능합니다.');
                return;
            }

            // 파일 크기 검증 (5MB)
            if (file.size > 5 * 1024 * 1024) {
                alert('이미지 크기는 5MB 이하로 업로드해주세요.');
                return;
            }

            // 프리뷰 표시
            const reader = new FileReader();
            reader.onload = (event) => {
                // 기존 플레이스홀더를 이미지로 교체
                const newImg = document.createElement('img');
                newImg.src = event.target.result;
                newImg.alt = '모임 대표 이미지';
                newImg.className = 'banner-image';
                newImg.id = 'bannerPreview';

                bannerPreview.parentElement.replaceChild(newImg, bannerPreview);
            };
            reader.readAsDataURL(file);
        });
    }

    /**
     * 버튼 이벤트 초기화 (UI만 구현, fetch 로직은 추후)
     */
    function initButtons() {
        // 승인 버튼
        const approveBtns = document.querySelectorAll('.btn-approve');
        approveBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const requestSeq = btn.dataset.requestSeq;
                const clubSeq = btn.dataset.clubSeq;

                // TODO: 추후 fetch로 서버 승인 요청 구현
                console.log('승인 요청:', { requestSeq, clubSeq });

                // 임시 알림 (추후 실제 로직으로 교체)
                alert('승인 기능은 추후 구현 예정입니다.');
            });
        });

        // 거절 버튼
        const rejectBtns = document.querySelectorAll('.btn-reject');
        rejectBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const requestSeq = btn.dataset.requestSeq;
                const clubSeq = btn.dataset.clubSeq;

                // 모달 열고 hidden input에 값 설정
                const rejectRequestSeqInput = document.getElementById('rejectRequestSeq');
                const rejectClubSeqInput = document.getElementById('rejectClubSeq');

                if (rejectRequestSeqInput) rejectRequestSeqInput.value = requestSeq;
                if (rejectClubSeqInput) rejectClubSeqInput.value = clubSeq;

                openModal();
            });
        });

        // 거절 폼 제출
        const rejectForm = document.getElementById('rejectForm');
        rejectForm?.addEventListener('submit', (e) => {
            e.preventDefault();

            const requestSeq = document.getElementById('rejectRequestSeq').value;
            const clubSeq = document.getElementById('rejectClubSeq').value;
            const reason = document.getElementById('rejectReason').value;

            // TODO: 추후 fetch로 서버 거절 요청 구현
            console.log('거절 요청:', { requestSeq, clubSeq, reason });

            // 임시 알림 (추후 실제 로직으로 교체)
            alert('거절 기능은 추후 구현 예정입니다.');
            closeModal();
        });

        // 멤버 퇴장 버튼
        const kickBtns = document.querySelectorAll('.btn-kick');
        kickBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const memberSeq = btn.dataset.memberSeq;
                const clubSeq = btn.dataset.clubSeq;
                const memberName = btn.dataset.memberName;

                const confirmed = confirm(`정말로 ${memberName}님을 퇴장시키겠습니까?`);

                if (confirmed) {
                    // TODO: 추후 fetch로 서버 퇴장 요청 구현
                    console.log('퇴장 요청:', { memberSeq, clubSeq });

                    // 임시 알림 (추후 실제 로직으로 교체)
                    alert('퇴장 기능은 추후 구현 예정입니다.');
                }
            });
        });
    }

    /**
     * 페이지 초기화 (외부에서 호출)
     */
    function init(clubSeq) {
        console.log('BookClubManage 초기화:', clubSeq);

        // 탭 전환 기능 초기화
        initTabs();

        // 모달 초기화
        initModal();

        // 버튼 이벤트 초기화
        initButtons();

        // 이미지 업로드 초기화
        initImageUpload();
    }

    // 외부 공개 API
    return {
        init,
        switchTab,
        openModal,
        closeModal
    };
})();
