/**
 * 공통 페이징 렌더링 함수 (Apple Style UI 적용)
 * @param {string} containerId - 페이징 버튼이 들어갈 div ID
 * @param {number} total - 전체 데이터 개수
 * @param {number} curPage - 현재 페이지 번호
 * @param {number} size - 한 페이지당 데이터 개수
 * @param {string} callbackName - 페이지 클릭 시 호출할 함수 이름 (문자열)
 */
function renderCommonPagination(containerId, total, curPage, size, callbackName) {
    var container = document.getElementById(containerId);
    if (!container) return;
    container.innerHTML = '';

    var totalPages = Math.ceil(total / size);
    if (totalPages <= 1) return; // 페이지가 1개면 표시 안함

    // 컨테이너 스타일링 (배경색, 둥근 모서리, 그림자)
    var wrapper = document.createElement('div');
    wrapper.className = 'flex items-center gap-1 p-1 bg-white border border-gray-100 rounded-2xl shadow-sm inline-flex';

    // SVG 아이콘 (Chevron Left/Right)
    var iconLeft = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>';
    var iconRight = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>';

    // 이전 페이지 버튼
    var prevBtn = document.createElement('button');
    prevBtn.type = 'button';
    prevBtn.className = 'w-8 h-8 flex items-center justify-center rounded-xl text-gray-400 transition-all duration-200 ' +
                        (curPage > 1 ? 'hover:bg-blue-50 hover:text-blue-600' : 'opacity-30 cursor-not-allowed');
    prevBtn.innerHTML = iconLeft;
    prevBtn.disabled = curPage <= 1;
    if (curPage > 1) {
        prevBtn.onclick = function() { window[callbackName](curPage - 1); };
    }
    wrapper.appendChild(prevBtn);

    // 페이지 번호 계산
    var startPage = Math.max(1, curPage - 2);
    var endPage = Math.min(totalPages, startPage + 4);
    if (endPage - startPage < 4) {
        startPage = Math.max(1, endPage - 4);
    }
    startPage = Math.max(1, startPage);

    // 숫자 버튼 생성
    for (var i = startPage; i <= endPage; i++) {
        var pageBtn = document.createElement('button');
        pageBtn.type = 'button';

        // 공통 스타일
        var baseClass = 'min-w-[2rem] h-8 px-2 flex items-center justify-center rounded-xl text-xs font-bold transition-all duration-200 ';

        if (i === curPage) {
            // 활성 상태 (파란색 배경, 그림자)
            pageBtn.className = baseClass + 'bg-blue-600 text-white shadow-md shadow-blue-200 scale-105 z-10';
        } else {
            // 비활성 상태 (회색 텍스트, 호버 효과)
            pageBtn.className = baseClass + 'text-gray-500 hover:bg-gray-50 hover:text-gray-900';
        }

        pageBtn.innerText = i;
        pageBtn.setAttribute('data-page', i);
        pageBtn.onclick = function() {
            window[callbackName](parseInt(this.getAttribute('data-page')));
        };
        wrapper.appendChild(pageBtn);
    }

    // 다음 페이지 버튼
    var nextBtn = document.createElement('button');
    nextBtn.type = 'button';
    nextBtn.className = 'w-8 h-8 flex items-center justify-center rounded-xl text-gray-400 transition-all duration-200 ' +
                        (curPage < totalPages ? 'hover:bg-blue-50 hover:text-blue-600' : 'opacity-30 cursor-not-allowed');
    nextBtn.innerHTML = iconRight;
    nextBtn.disabled = curPage >= totalPages;
    if (curPage < totalPages) {
        nextBtn.onclick = function() { window[callbackName](curPage + 1); };
    }
    wrapper.appendChild(nextBtn);

    container.appendChild(wrapper);
}