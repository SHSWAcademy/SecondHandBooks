<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="space-y-6">
    <div class="flex justify-between items-center">
        <div>
            <h2 class="text-xl font-bold text-gray-900">찜한 상품</h2>
            <p class="text-xs text-gray-500 mt-1">내가 관심 등록한 중고 서적 목록입니다.</p>
        </div>
        <a href="/trade/list" class="flex items-center gap-1 px-3 py-2 bg-gray-900 text-white rounded-lg text-xs font-bold hover:bg-gray-800 transition">
            <i data-lucide="shopping-bag" class="w-3.5 h-3.5"></i> 상품 더보기
        </a>
    </div>

    <div id="wish-trade-list" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5">
        <div class="col-span-full py-20 flex justify-center">
            <span class="loading loading-spinner text-gray-300"></span>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        loadWishTrades();
    });

    function loadWishTrades() {
        $.ajax({
            url: '/profile/wishlist/trade',
            method: 'GET',
            dataType: 'json',
            success: function(data) {
                let html = '';

                if (!data || data.length === 0) {
                    html = `
                        <div class="col-span-full py-16 text-center border-2 border-dashed border-gray-200 rounded-xl bg-gray-50/50">
                            <div class="w-12 h-12 bg-white rounded-full flex items-center justify-center mx-auto mb-3 text-gray-300 shadow-sm">
                                <i data-lucide="heart-off" class="w-6 h-6"></i>
                            </div>
                            <p class="text-sm text-gray-500 mb-2">찜한 상품이 없습니다.</p>
                            <a href="/trade/list" class="text-primary-600 font-bold text-xs hover:underline">상품 구경하러 가기</a>
                        </div>`;
                } else {
                    data.forEach(item => {
                        // 중요: VO 필드명(스네이크 케이스)에 맞춰 수정
                        // TradeVO 구조상 trade_img는 List<TradeImageVO>로 반환될 수 있음.
                        // Mapper에서 서브쿼리로 가져온 값은 VO에 매핑하기 어려우므로,
                        // VO에 private String thumbImgUrl; 필드를 추가하는 것을 강력 추천함.
                        // 현재 상태에선 trade_img 배열의 첫번째 요소나, 매퍼에서 매핑된 필드를 찾아야 함.

                        // 임시 방편: 썸네일 URL을 가져오기 위해 console.log로 데이터 구조 확인 필요
                        // 우선 기본 이미지 로직 적용
                        let rawImg = item.thumbImgUrl;

                        let img = 'https://via.placeholder.com/300x400/f3f4f6/9ca3af?text=No+Image';

                        if (rawImg) {
                            if (rawImg.startsWith('http') || rawImg.startsWith('/')) {
                                img = rawImg;
                            } else {
                                img = '/upload' + rawImg;
                            }
                        }

                        // 상태 뱃지
                        let statusBadge = '';
                        if (item.sale_st === 'SALE') {
                            statusBadge = '<span class="absolute top-2 right-2 bg-green-500 text-white text-[10px] px-2 py-0.5 rounded-full font-bold shadow-sm">판매중</span>';
                        } else if (item.sale_st === 'RESERVED') {
                            statusBadge = '<span class="absolute top-2 right-2 bg-orange-500 text-white text-[10px] px-2 py-0.5 rounded-full font-bold shadow-sm">예약중</span>';
                        } else {
                            statusBadge = '<span class="absolute top-2 right-2 bg-gray-600 text-white text-[10px] px-2 py-0.5 rounded-full font-bold shadow-sm">판매완료</span>';
                        }

                        html += `
                            <div class="group bg-white border border-gray-200 rounded-xl overflow-hidden hover:shadow-lg transition-all duration-300 cursor-pointer relative"
                                 onclick="location.href='/trade/\${item.trade_seq}'"> <div class="aspect-[3/4] bg-gray-100 relative overflow-hidden">
                                    <img src="\${img}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                                    \${statusBadge}
                                </div>

                                <div class="p-4">
                                    <h4 class="font-bold text-gray-900 text-sm mb-1 truncate group-hover:text-primary-600 transition-colors">
                                        \${item.sale_title} </h4>
                                    <div class="flex justify-between items-end">
                                        <p class="font-black text-gray-900 text-base">\${Number(item.sale_price).toLocaleString()}원</p>
                                        <span class="text-[10px] text-gray-400 mb-0.5">\${item.sale_rg || '지역미정'}</span>
                                    </div>
                                </div>
                            </div>
                        `;
                    });
                }

                $('#wish-trade-list').html(html);
                lucide.createIcons();
            },
            error: function(xhr) {
                console.log(xhr);
                $('#wish-trade-list').html('<div class="col-span-full text-center py-10 text-red-500 text-sm">목록을 불러오지 못했습니다.</div>');
            }
        });
    }
</script>