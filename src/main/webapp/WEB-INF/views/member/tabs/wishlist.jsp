<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="space-y-8 animate-[fadeIn_0.3s_ease-out]">
    <div class="flex justify-between items-center px-1">
        <div>
            <h2 class="text-2xl font-black text-gray-900 tracking-tight flex items-center gap-2">
                찜한 상품 <span id="trade-total-count" class="text-sm font-bold text-primary-600 bg-primary-50 px-2.5 py-0.5 rounded-full">0</span>
            </h2>
            <p class="text-sm font-medium text-gray-500 mt-1">관심 등록한 중고 서적 목록</p>
        </div>
    </div>

    <div id="wish-trade-list" class="grid grid-cols-1 gap-4"></div>

    <div id="trade-load-more" class="hidden text-center mt-12 pb-10">
        <button onclick="WishlistTab.loadMore()" class="px-10 py-3.5 bg-white border border-gray-200 rounded-full text-sm font-bold text-gray-600 hover:text-gray-900 transition-all shadow-sm hover:shadow-md">
            더 많은 상품 보기 <i data-lucide="plus" class="w-4 h-4 inline ml-1"></i>
        </button>
    </div>
</div>

<script>
    (function() { // IIFE: 전역 변수 충돌 방지
        const PAGE_SIZE = 8;
        let wishTradeData = [];
        let tradeCursor = 0;

        const actions = {
            init: () => {
                actions.loadWishTrades();
            },

            loadWishTrades: () => {
                $.ajax({
                    url: '/profile/wishlist/trade',
                    method: 'GET',
                    dataType: 'json',
                    success: (data) => {
                        wishTradeData = data || [];
                        $('#trade-total-count').text(wishTradeData.length);
                        $('#wish-trade-list').empty();
                        tradeCursor = 0;
                        actions.render();
                    },
                    error: () => $('#wish-trade-list').html('<div class="col-span-full text-center py-16 text-red-500 font-bold">목록을 불러오지 못했습니다.</div>')
                });
            },

            render: () => {
                const container = $('#wish-trade-list');
                const btn = $('#trade-load-more');

                if (wishTradeData.length === 0) {
                    container.html(`
                    <div class="col-span-full py-24 text-center border-2 border-dashed border-gray-200 rounded-[2rem] bg-gray-50/50">
                        <div class="w-16 h-16 bg-white rounded-full flex items-center justify-center mx-auto mb-5 text-gray-300 shadow-sm">
                            <i data-lucide="heart-off" class="w-8 h-8"></i>
                        </div>
                        <p class="text-base text-gray-500 font-bold mb-4">찜한 상품이 없습니다.</p>
                        <a href="/trade/list" class="inline-flex items-center gap-1.5 text-primary-600 font-bold text-sm hover:underline bg-white border border-gray-200 px-5 py-2.5 rounded-full transition hover:shadow-sm">
                            상품 구경하러 가기 <i data-lucide="arrow-right" class="w-4 h-4"></i>
                        </a>
                    </div>`);
                    btn.addClass('hidden');
                    return;
                }

                const nextCursor = tradeCursor + PAGE_SIZE;
                const slice = wishTradeData.slice(tradeCursor, nextCursor);

                let html = '';
                slice.forEach(item => {
                    let img = 'https://placehold.co/200x300?text=No+Image';
                    if (item.book_img) {
                        img = (item.book_img.startsWith('http') || item.book_img.startsWith('/'))
                            ? item.book_img : '/upload/' + item.book_img;
                    }

                    // 상태 뱃지 디자인 (판매/구매 내역과 통일)
                    let statusBadge = '';
                    if (item.sale_st === 'SALE') {
                        statusBadge = '<span class="text-[10px] font-bold text-blue-600 bg-blue-50 px-2 py-0.5 rounded-md">판매중</span>';
                    } else if (item.sale_st === 'RESERVED') {
                        statusBadge = '<span class="text-[10px] font-bold text-orange-600 bg-orange-50 px-2 py-0.5 rounded-md">예약중</span>';
                    } else {
                        statusBadge = '<span class="text-[10px] font-bold text-gray-600 bg-gray-100 px-2 py-0.5 rounded-md">판매완료</span>';
                    }

                    html += `
                    <div class="group bg-white border border-gray-100 rounded-3xl p-5 hover:shadow-lg hover:border-primary-100 transition-all duration-300 cursor-pointer flex gap-5 items-center relative"
                         onclick="location.href='/trade/\${item.trade_seq}'">

                        <div class="w-20 h-24 bg-gray-50 rounded-2xl border border-gray-100 flex-shrink-0 overflow-hidden shadow-inner">
                            <img src="\${img}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                                 onerror="this.src='https://placehold.co/200x300?text=No+Image'" loading="lazy">
                        </div>

                        <div class="flex-1 min-w-0 py-1">
                            <div class="flex items-center gap-2 mb-1">
                                \${statusBadge}
                                <span class="text-[10px] font-bold text-gray-400 bg-gray-100 px-2 py-0.5 rounded-md">\${item.sale_rg || '지역미정'}</span>
                            </div>
                            <h4 class="text-base font-bold text-gray-900 truncate group-hover:text-primary-600 transition-colors">\${item.sale_title}</h4>
                            <p class="text-xs font-medium text-gray-500 mt-0.5 truncate">\${item.book_title || ''}</p>

                            <div class="mt-2 flex items-baseline">
                                <span class="font-black text-lg text-gray-900 tracking-tight">\${Number(item.sale_price).toLocaleString()}</span>
                                <span class="text-xs font-bold text-gray-400 ml-0.5">원</span>
                            </div>
                        </div>

                        <div class="text-right pr-1">
                            <div class="p-2.5 bg-red-50 border border-red-100 rounded-full text-red-500 shadow-sm transition transform group-hover:scale-110">
                                <i data-lucide="heart" class="w-4 h-4 fill-current"></i>
                            </div>
                        </div>
                    </div>`;
                });

                container.append(html);
                tradeCursor = nextCursor;

                if (tradeCursor >= wishTradeData.length) btn.addClass('hidden');
                else btn.removeClass('hidden');

                if(window.lucide) lucide.createIcons();
            },

            loadMore: () => actions.render()
        };

        window.WishlistTab = actions;
        actions.init();
    })();
</script>