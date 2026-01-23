<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp" />
<!-- 다음 주소 API -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- 내가 만든 JS -->
<script src="<c:url value='/resources/js/trade/openDaumPostcode.js'/>"></script>

<div class="max-w-4xl mx-auto py-8">
    <!-- Page Title -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">판매글 등록</h1>
        <p class="text-gray-600">책 정보와 판매 조건을 입력해주세요</p>
    </div>

    <!-- Form -->
    <form action="/trade" method="post" enctype="multipart/form-data" class="space-y-8">

        <!-- 책 정보 섹션 -->
        <div class="bg-white rounded-lg border border-gray-200 p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20"/></svg>
                책 정보
            </h2>

            <div class="space-y-4">
                <div class="relative flex gap-2">
                    <input type="text" id="bookSearch"
                           placeholder="책 제목을 입력하세요"
                           class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500" />
                    <button type="button" id="searchBtn"
                            class="px-6 py-3 bg-primary-500 text-white rounded-lg hover:bg-primary-600 transition font-bold">
                        검색
                    </button>

                    <div id="searchResults" class="absolute left-0 z-50 w-full mt-12 bg-white border border-gray-300 rounded-lg shadow-lg hidden max-h-80 overflow-y-auto">
                    </div>
                </div>


                <!-- 선택된 책 미리보기 -->
                <div id="selectedBookPreview" class="hidden p-4 bg-gray-50 rounded-lg border border-gray-200">
                    <div class="flex gap-4">
                        <img id="previewImg" src="" alt="책 표지" class="w-20 h-28 object-cover rounded shadow" />
                        <div class="flex-1">
                            <h3 id="previewTitle" class="font-bold text-gray-900"></h3>
                            <p id="previewAuthor" class="text-sm text-gray-600"></p>
                            <p id="previewPublisher" class="text-sm text-gray-500"></p>
                            <p id="previewPrice" class="text-sm text-primary-600 font-bold mt-1"></p>
                        </div>
                        <button type="button" id="clearBookBtn" class="self-start text-gray-400 hover:text-red-500">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
                        </button>
                    </div>
                </div>

                <!-- Hidden inputs for form submission -->
                <input type="hidden" id="isbn" name="isbn" required />
                <input type="hidden" id="book_title" name="book_title" required />
                <input type="hidden" id="book_author" name="book_author" required />
                <input type="hidden" id="book_publisher" name="book_publisher" required />
                <input type="hidden" id="book_org_price" name="book_org_price" />
                <input type="hidden" id="book_img" name="book_img" required />
            </div>
        </div>

        <!-- 판매 정보 섹션 -->
        <div class="bg-white rounded-lg border border-gray-200 p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
                판매 정보
            </h2>

            <div class="space-y-4">
                <!-- 판매글 제목 -->
                <div>
                    <label for="sale_title" class="block text-sm font-bold text-gray-700 mb-2">
                        판매글 제목 <span class="text-red-500">*</span>
                    </label>
                    <input type="text" id="sale_title" name="sale_title" required
                           placeholder="클린 코드 판매합니다 (거의 새책)"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500" />
                </div>

                <!-- 카테고리 -->
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">
                        카테고리 <span class="text-red-500">*</span>
                    </label>

                    <select id="categorySelect" name="category_seq" required
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg">
                        <option value="">카테고리 선택</option>

                        <c:forEach var="cat" items="${category}">
                            <option value="${cat.category_seq}"
                                    data-nm="${cat.category_nm}">
                                ${cat.category_nm}
                            </option>
                        </c:forEach>
                    </select>
                    <!-- 카테고리 네임 히든으로 보내기 위에는 seq보냄 -->
                    <input type="hidden" name="category_nm" id="category_nm">
                </div>

                <!-- 판매가격 -->
                <div>
                    <label for="sale_price" class="block text-sm font-bold text-gray-700 mb-2">
                        판매가격 (원)
                    </label>
                    <input type="number" id="sale_price" name="sale_price"
                           placeholder="25000"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500" />
                </div>

                <!-- 배송비 -->
                <div>
                    <label for="delivery_cost" class="block text-sm font-bold text-gray-700 mb-2">
                        배송비 (원)
                    </label>
                    <input type="number" id="delivery_cost" name="delivery_cost"
                           placeholder="3000"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500" />
                    <p class="text-xs text-gray-500 mt-1">무료배송인 경우 0을 입력하세요</p>
                </div>

                <!-- 책 상태 -->
                <div>
                    <label for="book_st" class="block text-sm font-bold text-gray-700 mb-2">
                        책 상태
                    </label>
                    <select id="book_st" name="book_st"
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500">
                        <option value="">선택하세요</option>
                        <option value="NEW">새책</option>
                        <option value="LIKE_NEW">거의 새책</option>
                        <option value="GOOD">좋음</option>
                        <option value="USED">사용됨</option>
                    </select>
                </div>

                <!-- 거래방법 -->
                <div>
                    <label for="payment_type" class="block text-sm font-bold text-gray-700 mb-2">
                        거래방법
                    </label>
                    <select id="payment_type" name="payment_type"
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500">
                        <option value="">선택하세요</option>
                        <option value="account">계좌이체</option>
                        <option value="tosspay">토스페이</option>
                    </select>
                </div>

                <!-- 판매지역 -->
                <div>
                    <label for="sale_rg" class="block text-sm font-bold text-gray-700 mb-2">
                        판매지역 [시, 군, 구만 표기됩니다.]
                    </label>
                    <div class="flex">
                        <input type="text" id="sale_rg" name="sale_rg" readonly
                               placeholder="주소 검색을 클릭하세요"
                               class="flex-1 px-4 py-3 border border-gray-300 rounded-l-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500" />
                        <button type="button" onclick="searchRG()"
                                class="px-6 py-3 bg-gray-900 text-white rounded-r-lg hover:bg-gray-800 transition font-bold">
                            주소 검색
                        </button>
                    </div>
                </div>

                <!-- 상세설명 -->
                <div>
                    <label for="sale_cont" class="block text-sm font-bold text-gray-700 mb-2">
                        상세설명 <span class="text-red-500">*</span>
                    </label>
                    <textarea id="sale_cont" name="sale_cont" required rows="6"
                              placeholder="책의 상태, 특이사항 등을 자세히 설명해주세요"
                              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 resize-none"></textarea>
                </div>
            </div>
        </div>

        <!-- 추가 이미지 섹션 -->
        <div class="bg-white rounded-lg border border-gray-200 p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="3" rx="2" ry="2"/><circle cx="9" cy="9" r="2"/><path d="m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21"/></svg>
                추가 이미지 (최대 3장 업로드 가능합니다.)
            </h2>

            <div class="space-y-3">
                <input type="file" name="uploadFiles" accept="image/*" multiple
                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:bg-primary-500 file:text-white file:font-bold hover:file:bg-primary-600" />
                <p id="fileMsg" class="text-xs text-gray-500">여러 이미지를 한 번에 선택할 수 있습니다. (Ctrl/Cmd + 클릭)</p>
            </div>
        </div>

        <!-- 제출 버튼 -->
        <div class="flex gap-3">
            <button type="button" onclick="history.back()"
                    class="flex-1 px-6 py-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition font-bold">
                취소
            </button>
            <button type="submit"
                    class="flex-1 px-6 py-4 bg-primary-500 text-white rounded-lg hover:bg-primary-600 transition font-bold shadow-sm">
                등록하기
            </button>
        </div>
    </form>
</div>

<script>
// 책 검색 기능
const searchInput = document.getElementById('bookSearch');
const searchBtn = document.getElementById('searchBtn');
const searchResults = document.getElementById('searchResults');
const selectedBookPreview = document.getElementById('selectedBookPreview');
const clearBookBtn = document.getElementById('clearBookBtn');

bindCategoryName('categorySelect', 'category_nm');
// 카테고리 선택시 input타입의 카테고리 네임도 넣기
function bindCategoryName(selectId, hiddenId) {
    const select = document.getElementById(selectId);
    const hidden = document.getElementById(hiddenId);

    if (!select || !hidden) return;

    select.addEventListener('change', function () {
        const option = this.options[this.selectedIndex];
        hidden.value = option.dataset.nm || '';
    });
}

// 첨부파일 갯수제한
function limitFileUploadTo3(inputEl, msgEl) {
    inputEl.addEventListener('change', () => {
        const files = inputEl.files;
        // 3개로 제한
        if (files.length > 3) { // 최대 3개
            msgEl.textContent = `최대 3개까지 업로드 가능합니다.`;

            // 스타일 적용
            msgEl.style.color = 'red';
            msgEl.style.fontWeight = 'bold';
            msgEl.style.fontSize = '1rem'; // 원하면 더 키울 수 있음
            inputEl.value = ''; // 선택 초기화
        } else {
            msgEl.textContent = ''; // 메시지 초기화

            // 스타일 초기화
            msgEl.style.color = '';
            msgEl.style.fontWeight = '';
            msgEl.style.fontSize = '';
        }
    });
}

// 적용
const fileInput = document.querySelector('input[name="uploadFiles"]');
const msg = document.getElementById('fileMsg');
limitFileUploadTo3(fileInput, msg);


// 검색 버튼 클릭
searchBtn.addEventListener('click', searchBooks);

// 엔터키로 검색
searchInput.addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        searchBooks();
    }
});

// 책 검색 API 호출
function searchBooks() {
    const query = searchInput.value.trim();
    if (!query) {
        alert('검색어를 입력하세요');
        return;
    }

    fetch('/trade/book?query=' + encodeURIComponent(query))
        .then(response => response.json())
        .then(books => {
            displaySearchResults(books);
        })
        .catch(error => {
            console.error('검색 오류:', error);
            alert('검색 중 오류가 발생했습니다');
        });
}

// 검색 결과 표시
function displaySearchResults(books) {
    searchResults.innerHTML = '';

    if (!books || books.length === 0) {
        searchResults.innerHTML = '<div class="p-4 text-center text-gray-500">검색 결과가 없습니다</div>';
        searchResults.classList.replace('hidden', 'block');
        return;
    }
    books.forEach(book => {
        // 디버깅용
        console.log("서버 데이터:", book);

        const item = document.createElement('div');
        item.className = 'flex gap-3 p-3 hover:bg-gray-50 cursor-pointer border-b border-gray-100 last:border-b-0 text-left';

        // 데이터 변수에 담기 (jstl 코드화 혼용하지 말것)
        const bTitle = book.book_title;
        const bIsbn = book.isbn || "isbn 조회 불가";
        const bAuthor = book.book_author;
        const bImg = book.book_img;
        const bPrice = book.book_org_price;

        // html데이터에 삽입
        item.innerHTML =
            '<img src="' + (bImg ? bImg : '/resources/images/no-image.png') + '" ' +
            '     alt="' + bTitle + '" ' +
            '     class="w-12 h-16 object-cover rounded shadow-sm" />' +
            '<div class="flex-1 min-w-0">' +
            '    <p class="font-bold text-gray-900 truncate">' + bTitle + '</p>' +
            '    <p class="text-sm text-gray-600 truncate">' + bAuthor + '</p>' +
            '    <p class="text-sm text-gray-600 truncate">' + bIsbn + '</p>' +
            '    <p class="text-sm text-primary-600 font-bold mt-1">' +
                 (bPrice ? bPrice.toLocaleString() + '원' : '가격 정보 없음') +
            '    </p>' +
            '</div>';

        item.addEventListener('click', () => selectBook(book));
        searchResults.appendChild(item);
    });

    // 드롭다운 보이게 전환
    searchResults.classList.remove('hidden');
    searchResults.classList.add('block');
}

// 책 선택
function selectBook(book) {
    // hidden input에 값 설정
    document.getElementById('isbn').value = book.isbn || '';
    document.getElementById('book_title').value = book.book_title || '';
    document.getElementById('book_author').value = book.book_author || '';
    document.getElementById('book_publisher').value = book.book_publisher || '';
    document.getElementById('book_org_price').value = book.book_org_price || '';
    document.getElementById('book_img').value = book.book_img || '';

    // 미리보기 표시
    document.getElementById('previewImg').src = book.book_img || '/resources/images/no-image.png';
    document.getElementById('previewTitle').textContent = book.book_title || '';
    document.getElementById('previewAuthor').textContent = book.book_author || '';
    document.getElementById('previewPublisher').textContent = book.book_publisher || '';
    document.getElementById('previewPrice').textContent = book.book_org_price ? '정가: ' + book.book_org_price.toLocaleString() + '원' : '';

    selectedBookPreview.classList.remove('hidden');
    searchResults.classList.add('hidden');
    searchInput.value = '';
}

// 선택 취소
clearBookBtn.addEventListener('click', function() {
    document.getElementById('isbn').value = '';
    document.getElementById('book_title').value = '';
    document.getElementById('book_author').value = '';
    document.getElementById('book_publisher').value = '';
    document.getElementById('book_org_price').value = '';
    document.getElementById('book_img').value = '';
    selectedBookPreview.classList.add('hidden');
});

// 검색 결과 외부 클릭시 닫기
document.addEventListener('click', function(e) {
    if (!searchResults.contains(e.target) && e.target !== searchInput && e.target !== searchBtn) {
        searchResults.classList.add('hidden');
    }
});

// 판매지역 검색 (다음 우편번호 API)
function searchRG() {
    new daum.Postcode({
        oncomplete: function(data) {
            var region = data.sido + ' ' + data.sigungu;
            document.getElementById('sale_rg').value = region;
        }
    }).open();
}

// 폼 제출 전 검증
document.querySelector('form').addEventListener('submit', function(e) {
    // 필수 필드 체크는 HTML5 required 속성으로 자동 처리됨
});


</script>
<jsp:include page="../common/footer.jsp" />
