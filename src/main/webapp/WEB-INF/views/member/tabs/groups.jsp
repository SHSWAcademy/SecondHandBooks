<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="space-y-6">
    <div class="flex justify-between items-center">
        <h2 class="text-xl font-bold text-gray-900">내 모임</h2>
        <a href="/bookclub/create" class="text-xs bg-gray-900 text-white px-3 py-2 rounded font-bold hover:bg-gray-800 flex items-center gap-1">
            <i data-lucide="plus" class="w-3.5 h-3.5"></i> 모임 만들기
        </a>
    </div>

    <div id="my-club-list" class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="col-span-full text-center py-20 text-gray-400 text-sm">
            <span class="loading loading-spinner loading-md"></span>
            <p class="mt-2">모임 정보를 불러오는 중입니다...</p>
        </div>
    </div>
</div>

<script>
    // 페이지 로드 시 실행
    loadMyClubs();

    function loadMyClubs() {
        $.ajax({
            url: '/profile/bookclub/list', // MemberController에 이 매핑이 있어야 합니다.
            method: 'GET',
            dataType: 'json',
            success: function(data) {
                let html = '';

                if (!data || data.length === 0) {
                    // 데이터가 없을 때
                    html = '<div class="col-span-full text-center py-16 bg-white border border-gray-200 border-dashed rounded-lg">' +
                        '  <div class="mb-3 text-gray-300"><i data-lucide="users" class="w-10 h-10 mx-auto"></i></div>' +
                        '  <p class="text-gray-500 text-sm mb-2">가입한 독서 모임이 없습니다.</p>' +
                        '  <a href="/bookclub/list" class="text-primary-600 font-bold text-sm hover:underline">모임 찾아보기 &rarr;</a>' +
                        '</div>';
                } else {
                    // 데이터가 있을 때 반복문
                    data.forEach(function(club) {
                        // 이미지 없을 때 기본 이미지 처리
                        let imgUrl = club.banner_img_url ? '/upload/' + club.banner_img_url : '/resources/img/default_club.png';

                        // 날짜/일정 텍스트 처리
                        let schedule = club.book_club_schedule ? club.book_club_schedule : '일정 미정';

                        // 지역 태그
                        let region = club.book_club_rg ? '<span class="text-[10px] bg-gray-100 text-gray-600 px-1.5 py-0.5 rounded font-bold">' + club.book_club_rg + '</span>' : '';

                        html += '<div class="bg-white border border-gray-200 rounded-lg overflow-hidden hover:shadow-md transition cursor-pointer group" onclick="location.href=\'/bookclub/detail?book_club_seq=' + club.book_club_seq + '\'">' +
                            '  <div class="h-32 bg-gray-100 overflow-hidden relative">' +
                            '    <img src="' + imgUrl + '" alt="모임 커버" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" onerror="this.src=\'https://via.placeholder.com/400x200?text=No+Image\'">' +
                            '    <div class="absolute top-2 right-2">' + region + '</div>' +
                            '  </div>' +
                            '  <div class="p-4">' +
                            '    <h3 class="font-bold text-gray-900 truncate mb-1">' + club.book_club_name + '</h3>' +
                            '    <p class="text-xs text-gray-500 line-clamp-2 mb-3 h-8">' + (club.book_club_desc || '') + '</p>' +
                            '    <div class="flex items-center text-xs text-gray-400 gap-1">' +
                            '      <i data-lucide="calendar" class="w-3 h-3"></i>' +
                            '      <span>' + schedule + '</span>' +
                            '    </div>' +
                            '  </div>' +
                            '</div>';
                    });
                }

                $('#my-club-list').html(html);

                // 아이콘 새로고침 (ajax로 추가된 요소에 아이콘 적용)
                if(window.lucide) lucide.createIcons();
            },
            error: function(err) {
                console.error(err);
                $('#my-club-list').html('<div class="col-span-full text-center text-red-500 py-10 text-sm">목록을 불러오지 못했습니다.<br>잠시 후 다시 시도해주세요.</div>');
            }
        });
    }
</script>