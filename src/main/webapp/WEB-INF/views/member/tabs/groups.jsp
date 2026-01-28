<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="space-y-10">
    <div class="space-y-4">
        <div class="flex justify-between items-center">
            <div>
                <h2 class="text-xl font-bold text-gray-900">참여 중인 모임</h2>
                <p class="text-xs text-gray-500 mt-1">현재 활동 중인 독서 모임입니다.</p>
            </div>
            <a href="/bookclubs" class="flex items-center gap-1.5 px-4 py-2 bg-gray-900 text-white rounded-lg text-xs font-bold hover:bg-gray-800 transition shadow-sm">
                <i data-lucide="plus" class="w-3.5 h-3.5"></i> 모임 만들기
            </a>
        </div>
        <div id="my-club-list" class="grid grid-cols-1 md:grid-cols-2 gap-5"></div>
    </div>

    <div class="border-t border-gray-100"></div>

    <div class="space-y-4">
        <div>
            <h2 class="text-xl font-bold text-gray-900 flex items-center gap-2">
                <i data-lucide="heart" class="w-5 h-5 text-red-500 fill-current"></i> 찜한 모임
            </h2>
            <p class="text-xs text-gray-500 mt-1">찜한 모임 목록입니다.</p>
        </div>
        <div id="wish-club-list" class="grid grid-cols-1 md:grid-cols-2 gap-5"></div>
    </div>
</div>

<script>
    $(document).ready(function() {
        loadMyClubs();   // 참여 모임 로드
        loadWishClubs(); // 찜한 모임 로드
    });

    function loadMyClubs() {
        $.ajax({
            url: '/profile/bookclub/list', // 컨트롤러가 해당 경로를 제공하는지 확인 필요
            method: 'GET',
            dataType: 'json',
            success: function(data) { renderClubs(data, '#my-club-list', 'joined'); },
            error: function() { $('#my-club-list').html('<div class="col-span-full text-center py-10 text-gray-400">참여 중인 모임이 없습니다.</div>'); }
        });
    }

    function loadWishClubs() {
        $.ajax({
            url: '/profile/wishlist/bookclub', // 컨트롤러가 해당 경로를 제공하는지 확인 필요
            method: 'GET',
            dataType: 'json',
            success: function(data) { renderClubs(data, '#wish-club-list', 'wish'); },
            error: function() { $('#wish-club-list').html('<div class="col-span-full text-center py-10 text-gray-400">찜한 모임이 없습니다.</div>'); }
        });
    }

    function renderClubs(data, containerId, type) {
        const container = $(containerId);
        let html = '';

        if (!data || data.length === 0) {
            const msg = type === 'joined' ? '가입한 모임이 없습니다.' : '찜한 모임이 없습니다.';
            html = `<div class="col-span-full py-12 text-center text-gray-400 bg-gray-50 rounded-xl">\${msg}</div>`;
        } else {
            data.forEach(club => {
                // [수정 2] 이미지 경로 처리 및 속성명 통일 (snake_case 가정)
                // club.banner_img_url, club.book_club_desc, club.book_club_schedule 등 확인 필요
                let img = 'https://via.placeholder.com/400x200/f3f4f6/9ca3af?text=ShinhanBooks';
                const bannerUrl = club.banner_img_url || club.bannerImgUrl; // 호환성 고려

                if (bannerUrl) {
                    if (bannerUrl.startsWith('/') || bannerUrl.startsWith('http')) {
                        img = bannerUrl;
                    } else {
                        img = '/upload/' + bannerUrl;
                    }
                }

                const clubId = club.book_club_seq || club.bookClubSeq;
                // [수정 3] 링크 생성 시 변수 결합 (/bookclub -> /bookclubs, {id} -> clubId)
                const link = '/bookclubs/' + clubId;

                // [수정 4] 찜 아이콘에 onclick 이벤트 추가 (찜 취소 기능)
                let wishIconHtml = '';
                if (type === 'wish') {
                    wishIconHtml = `
                        <div class="absolute top-3 right-3 z-10" onclick="toggleWish(event, \${clubId})">
                            <div class="bg-white/90 p-1.5 rounded-full text-red-500 shadow-sm hover:scale-110 transition cursor-pointer">
                                <i data-lucide="heart" class="w-4 h-4 fill-current"></i>
                            </div>
                        </div>`;
                }

                // 속성명 null 체크
                const rg = club.book_club_rg || '전국';
                const name = club.book_club_name || '이름 없음';
                const desc = club.book_club_desc || club.description || '';
                const schedule = club.book_club_schedule || club.schedule || '일정 미정';

                html += `
                    <div class="group bg-white border border-gray-200 rounded-xl overflow-hidden hover:shadow-lg transition cursor-pointer relative"
                         onclick="location.href='\${link}'">

                        \${wishIconHtml}

                        <div class="relative h-36 bg-gray-100 overflow-hidden">
                            <img src="\${img}" class="w-full h-full object-cover group-hover:scale-105 transition-transform" onerror="this.src='https://via.placeholder.com/400x200/f3f4f6/9ca3af?text=No+Image'">
                            <div class="absolute bottom-3 left-3 px-2 py-1 bg-white/90 rounded-md text-[10px] font-bold text-gray-600 backdrop-blur-sm">
                                <i data-lucide="map-pin" class="w-3 h-3 inline mr-1"></i>\${rg}
                            </div>
                        </div>
                        <div class="p-4">
                            <h3 class="font-bold text-gray-900 mb-1 truncate">\${name}</h3>
                            <p class="text-xs text-gray-500 line-clamp-1">\${desc}</p>
                            <div class="mt-3 pt-3 border-t border-gray-100 flex justify-between text-xs text-gray-400">
                                <span><i data-lucide="calendar" class="w-3 h-3 inline mr-1"></i>\${schedule}</span>
                                <span class="group-hover:text-primary-600 transition"><i data-lucide="chevron-right" class="w-4 h-4"></i></span>
                            </div>
                        </div>
                    </div>`;
            });
        }
        container.html(html);
        lucide.createIcons();
    }

    // [수정 5] 찜 취소 기능 추가
    function toggleWish(event, clubId) {
        event.stopPropagation(); // 카드 클릭 이동 방지

        if(!confirm('찜 목록에서 삭제하시겠습니까?')) return;

        fetch('/bookclubs/' + clubId + '/wish', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' }
        })
            .then(res => res.json())
            .then(data => {
                if (data.status === 'ok') {
                    loadWishClubs(); // 목록 새로고침
                } else {
                    alert(data.message || '오류가 발생했습니다.');
                }
            })
            .catch(err => {
                console.error(err);
                alert('오류가 발생했습니다.');
            });
    }
</script>