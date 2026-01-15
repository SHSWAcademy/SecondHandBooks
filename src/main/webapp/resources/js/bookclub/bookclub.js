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

    return {
        initList
    };
})();
