const BookClub = (() => {

    let debounceTimer = null;

    /** 초기화 */
    function initList() {
        const keywordInput = document.getElementById("keyword");
        if (!keywordInput) return;

        keywordInput.addEventListener("input", () => {
            clearTimeout(debounceTimer);

            debounceTimer = setTimeout(() => {
                const keyword = keywordInput.value.trim();
                search(keyword);
            }, 300); // 입력 멈춘 후 300ms
        });
    }
    // 초기 전체 조회
    search("");

    /** 서버 검색 요청 */
    function search(keyword) {
        const url = keyword
            ? `/bookclubs/search?keyword=${encodeURIComponent(keyword)}`
            : `/bookclubs/search`;

        fetch(url, {
            method: "GET",
            headers: {
                "Accept": "application/json"
            }
        })
            .then(res => res.json())
            .then(data => {
                renderList(data);
            })
            .catch(err => {
                console.error("검색 실패", err);
            });
    }

    /** 결과 렌더링 */
    function renderList(list) {
        const grid = document.getElementById("bookclubGrid");
        grid.innerHTML = "";

        if (!list || list.length === 0) {
            grid.innerHTML = `
                <div class="empty-state">
                    <p>검색 결과가 없습니다.</p>
                </div>
            `;
            return;
        }

        list.forEach(club => {
            grid.insertAdjacentHTML("beforeend", `
                <article class="bookclub-card" data-club-seq="${club.book_club_seq}">
                    <!-- 지역 태그 - 왼쪽 상단 -->
                    <span class="card-region-tag">${club.book_club_rg}</span>
                    <!-- 찜 버튼 - 오른쪽 상단 -->
                    <button type="button" class="btn-wish" onclick="alert('구현 예정입니다.'); return false;">
                        <span class="wish-icon">♡</span>
                    </button>

                    <a href="/bookclubs/${club.book_club_seq}" class="card-link">
                        <div class="card-banner">
                            ${
                                club.banner_img_url
                                    ? `<img src="${club.banner_img_url}" alt="${club.book_club_name} 배너">`
                                    : `<div class="card-banner-placeholder"><span>📚</span></div>`
                            }
                        </div>
                        <div class="card-body">
                            <div class="card-body-inner">
                                <h3 class="card-title">${club.book_club_name}</h3>
                                ${club.book_club_desc ? `<p class="card-desc">${club.book_club_desc}</p>` : ''}
                                <div class="card-footer">
                                    <span class="card-schedule">${club.book_club_schedule ?? ""}</span>
                                    <span class="card-members">${club.book_club_max_member}</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </article>
            `);
        });
    }
    // 외부에서 호출 가능한 메서드
    function reload() {
        const keywordInput = document.getElementById("keyword");
        const keyword = keywordInput ? keywordInput.value.trim() : "";
        search(keyword);
    }

    return {
        initList,
        reload
    };
})();

function initCreateModal() {
    const openBtn = document.getElementById("openCreateModal");
    const modal = document.getElementById("createBookClubModal");
    const closeBtn = document.getElementById("closeCreateModal");
    const overlay = modal?.querySelector(".modal-overlay");
    const form = document.getElementById("createBookClubForm");

    if (!modal || !form) return;

    // 모달 열기
    openBtn?.addEventListener("click", () => {
        modal.classList.remove("hidden");
    });

    // 모달 닫기
    closeBtn?.addEventListener("click", () => {
        modal.classList.add("hidden");
        resetForm();
    });

    overlay?.addEventListener("click", () => {
        modal.classList.add("hidden");
        resetForm();
    });

    // 이미지 업로드 기능
    const imageUploadArea = document.getElementById("imageUploadArea");
    const bannerImgInput = document.getElementById("bannerImgInput");

    imageUploadArea?.addEventListener("click", () => {
        bannerImgInput?.click();
    });

    bannerImgInput?.addEventListener("change", (e) => {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = (event) => {
                // 기존 미리보기 이미지 제거
                const existingImg = imageUploadArea.querySelector("img");
                if (existingImg) {
                    existingImg.remove();
                }
                // 아이콘, 텍스트 숨기기
                const icon = imageUploadArea.querySelector(".image-upload-icon");
                const text = imageUploadArea.querySelector(".image-upload-text");
                if (icon) icon.style.display = "none";
                if (text) text.style.display = "none";
                // 미리보기 이미지 추가 (input은 유지)
                const img = document.createElement("img");
                img.src = event.target.result;
                img.alt = "미리보기";
                imageUploadArea.appendChild(img);
                imageUploadArea.classList.add("has-image");
            };
            reader.readAsDataURL(file);
        }
    });

    // 오프라인/온라인 토글 버튼
    const regionToggleBtns = document.querySelectorAll(".toggle-group:not(.schedule-cycle) .toggle-btn");
    const bookClubType = document.getElementById("bookClubType");
    const detailRegion = document.getElementById("detailRegion");
    const regionInput = detailRegion?.querySelector("input[name='book_club_rg']");

    regionToggleBtns.forEach(btn => {
        btn.addEventListener("click", () => {
            regionToggleBtns.forEach(b => b.classList.remove("active"));
            btn.classList.add("active");

            const value = btn.dataset.value;
            bookClubType.value = value;

            if (value === "offline") {
                detailRegion.classList.add("show");
                regionInput.required = true;
            } else {
                detailRegion.classList.remove("show");
                regionInput.required = false;
                regionInput.value = "온라인";
            }
        });
    });

    // 정기 일정 선택
    const cycleBtns = document.querySelectorAll(".cycle-btn");
    const weekSelect = document.getElementById("weekSelect");
    const daySelect = document.getElementById("daySelect");
    const timeSelect = document.getElementById("timeSelect");
    const dayBtns = document.querySelectorAll(".day-btn");
    const scheduleWeek = document.getElementById("scheduleWeek");
    const scheduleHour = document.getElementById("scheduleHour");
    const bookClubSchedule = document.getElementById("bookClubSchedule");

    let selectedCycle = "";
    let selectedDay = "";

    // 주기 선택
    cycleBtns.forEach(btn => {
        btn.addEventListener("click", () => {
            cycleBtns.forEach(b => b.classList.remove("active"));
            btn.classList.add("active");

            selectedCycle = btn.dataset.value;

            // 초기화
            weekSelect.style.display = "none";
            daySelect.style.display = "none";
            scheduleWeek.value = "";
            selectedDay = "";
            dayBtns.forEach(b => b.classList.remove("active"));

            if (selectedCycle === "매주") {
                // 매주: 요일만 표시
                daySelect.style.display = "block";
            } else if (selectedCycle === "매월") {
                // 매월: 주차 + 요일 표시
                weekSelect.style.display = "block";
                daySelect.style.display = "block";
            }
            // 매일: 추가 선택 없음

            // 시간 선택 표시
            timeSelect.style.display = "block";
            updateScheduleValue();
        });
    });

    // 주차 선택
    scheduleWeek?.addEventListener("change", () => {
        updateScheduleValue();
    });

    // 요일 선택
    dayBtns.forEach(btn => {
        btn.addEventListener("click", () => {
            dayBtns.forEach(b => b.classList.remove("active"));
            btn.classList.add("active");
            selectedDay = btn.dataset.value + "요일";
            updateScheduleValue();
        });
    });

    // 시간 선택
    scheduleHour?.addEventListener("change", () => {
        updateScheduleValue();
    });

    // 일정 값 조합
    function updateScheduleValue() {
        let schedule = "";
        if (selectedCycle) {
            schedule = selectedCycle;
            if (selectedCycle === "매월" && scheduleWeek?.value) {
                schedule += " " + scheduleWeek.value;
            }
            if ((selectedCycle === "매주" || selectedCycle === "매월") && selectedDay) {
                schedule += " " + selectedDay;
            }
            if (scheduleHour?.value) {
                schedule += " " + scheduleHour.value;
            }
        }
        bookClubSchedule.value = schedule;
    }

    // 폼 리셋 함수
    function resetForm() {
        form.reset();
        // 이미지 업로드 영역 초기화
        const existingImg = imageUploadArea.querySelector("img");
        if (existingImg) {
            existingImg.remove();
        }
        // 아이콘, 텍스트 다시 표시
        const icon = imageUploadArea.querySelector(".image-upload-icon");
        const text = imageUploadArea.querySelector(".image-upload-text");
        if (icon) icon.style.display = "";
        if (text) text.style.display = "";
        imageUploadArea.classList.remove("has-image");
        // 활동 지역 토글 버튼 초기화
        regionToggleBtns.forEach(b => b.classList.remove("active"));
        document.querySelector(".toggle-btn[data-value='offline']")?.classList.add("active");
        bookClubType.value = "offline";
        detailRegion.classList.add("show");
        regionInput.required = true;
        regionInput.value = "";
        // 정기 일정 초기화
        cycleBtns.forEach(b => b.classList.remove("active"));
        dayBtns.forEach(b => b.classList.remove("active"));
        weekSelect.style.display = "none";
        daySelect.style.display = "none";
        timeSelect.style.display = "none";
        selectedCycle = "";
        selectedDay = "";
        scheduleWeek.value = "";
        scheduleHour.value = "";
        bookClubSchedule.value = "";
    }

    // 폼 제출
    form.addEventListener("submit", e => {
        e.preventDefault();

        const formData = new FormData(form);

        // 온라인인 경우 지역을 "온라인"으로 설정
        if (bookClubType.value === "online") {
            formData.set("book_club_rg", "온라인");
        }

        console.log("=== submit form data ===");
        for (let [k, v] of formData.entries()) {
            console.log(k, v);
        }

        fetch("/bookclubs", {
            method: "POST",
            body: formData
        })
        .then(async res => {
            if (!res.ok) {
                throw new Error("HTTP_ERROR_" + res.status);
            }
            const text = await res.text();
            return text ? JSON.parse(text) : {};
        })
        .then(data => {
            if (data.status === "fail") {
                if (data.message === "LOGIN_REQUIRED") {
                    alert("로그인이 필요합니다.");
                    return;
                }
                alert(data.message);
                return;
            }

            alert("모임이 생성되었습니다.");
            modal.classList.add("hidden");
            resetForm();
            BookClub.reload();
        })
        .catch(err => {
            console.error("create error", err);
            alert("모임 생성 중 오류가 발생했습니다.");
        });
    });
}
