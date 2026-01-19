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
                    <a href="/bookclubs/${club.book_club_seq}" class="card-link">
                        <div class="card-banner">
                            ${
                                club.banner_img_url
                                    ? `<img src="${club.banner_img_url}" alt="${club.book_club_name} 배너">`
                                    : `<div class="card-banner-placeholder"><span>📚</span></div>`
                            }
                        </div>
                        <div class="card-body">
                            <h3 class="card-title">${club.book_club_name}</h3>
                            <p class="card-meta">
                                <span>${club.book_club_rg}</span>
                                <span class="card-divider">•</span>
                                <span>${club.book_club_schedule ?? ""}</span>
                            </p>
                            <p class="card-members">
                                /${club.book_club_max_member}명
                            </p>
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

    if (!openBtn || !modal || !closeBtn || !overlay || !form) return;

    openBtn.addEventListener("click", () => {
        modal.classList.remove("hidden");
    });

    closeBtn.addEventListener("click", () => {
        modal.classList.add("hidden");
    });

    overlay.addEventListener("click", () => {
        modal.classList.add("hidden");
    });

    form.addEventListener("submit", e=> {
        e.preventDefault();

        const formData = new FormData(form);

        console.log("=== submit form data ===");
        for (let [k, v] of formData.entries()) {
            console.log(k, v);
        }

        fetch("/bookclubs", {
            method: "POST",
            body: formData
        })
//        .then(res => res.json())
        .then(async res => {
            // status 기준 판단
            if (!res.ok) {
                throw new Error("HTTP_ERROR_" + res.status);
            }
            // body가 없을 수도 있으므로 안전 처리
            const text = await res.text();
            return text ? JSON.parse(text) : {};
        })
        .then(data => {
            if (data.status === "fail") {
                if (data.message === "LOGIN_REQUIRED") {
                    alert("로그인이 필요합니다.");
                    return;
                }

                alert(data.message); // 중복 모임명 메시지
                return;
            }

            // 성공
            alert("모임이 생성되었습니다.");
            modal.classList.add("hidden");

            // 목록 새로고침 (비동기)
            BookClub.reload();
//            BookClub.initList();
//            search(""); // 전체 목록 다시 로딩
        })
        .catch(err => {
            console.error("create error", err);
            alert("모임 생성 중 오류가 발생했습니다.");
        })
//        .then(res => {
//            console.log("status:", res.status);
//            if (!res.ok) {
//                throw new Error("create failed");
//            }
//        })
////        .then(() => {
////            modal.classList.add("hidden");
////            location.reload();
////        })
//        .catch(err => {
//            console.error("create error", err);
//        })

    });
}
