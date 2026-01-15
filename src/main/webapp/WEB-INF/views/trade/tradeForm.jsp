<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../mockup/common/header.jsp" />

<div class="max-w-4xl mx-auto py-8">
    <!-- Page Title -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">판매글 등록</h1>
        <p class="text-gray-600">책 정보와 판매 조건을 입력해주세요</p>
    </div>

    <!-- Form -->
    <form action="/trade" method="post" class="space-y-8">
        
        <!-- 책 정보 섹션 -->
        <div class="bg-white rounded-lg border border-gray-200 p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20"/></svg>
                책 정보
            </h2>

            <div class="space-y-4">
                <!-- 책 검색 -->
                <div class="relative">
                    <label for="bookSearch" class="block text-sm font-bold text-gray-700 mb-2">
                        책 검색 <span class="text-red-500">*</span>
                    </label>
                    <div class="flex gap-2">
                        <input type="text" id="bookSearch"
                               placeholder="책 제목을 입력하세요"
                               class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500" />
                        <button type="button" id="searchBtn"
                                class="px-6 py-3 bg-primary-500 text-white rounded-lg hover:bg-primary-600 transition font-bold">
                            검색
                        </button>
                    </div>
                    <p class="text-xs text-gray-500 mt-1">책 제목으로 검색하여 도서를 선택하세요</p>

                    <!-- 검색 결과 드롭다운 -->
                    <div id="searchResults" class="absolute z-10 w-full mt-1 bg-white border border-gray-300 rounded-lg shadow-lg hidden max-h-80 overflow-y-auto">
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
                    <label for="category_nm" class="block text-sm font-bold text-gray-700 mb-2">
                        카테고리 <span class="text-red-500">*</span>
                    </label>
                    <input type="text" id="category_nm" name="category_nm" required
                           placeholder="IT/컴퓨터"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500" />
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
                        <option value="tossPay">토스페이</option>
                    </select>
                </div>

                <!-- 판매지역 -->
                <div>
                    <label for="sale_rg" class="block text-sm font-bold text-gray-700 mb-2">
                        판매지역
                    </label>
                    <input type="text" id="sale_rg" name="sale_rg"
                           placeholder="서울 강남구"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500" />
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
                추가 이미지 (선택사항)
            </h2>

            <div id="imageUrlsContainer" class="space-y-3">
                <div class="image-url-input flex gap-2">
                    <input type="text" name="imgUrls" 
                           placeholder="https://example.com/image1.jpg"
                           class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500" />
                    <button type="button" onclick="removeImageUrl(this)" 
                            class="px-4 py-3 bg-red-50 text-red-600 rounded-lg hover:bg-red-100 transition font-bold">
                        삭제
                    </button>
                </div>
            </div>

            <button type="button" onclick="addImageUrl()" 
                    class="mt-4 w-full px-4 py-3 bg-gray-50 text-gray-700 border border-gray-300 rounded-lg hover:bg-gray-100 transition font-bold flex items-center justify-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="M12 5v14"/></svg>
                이미지 URL 추가
            </button>
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

    if (books.length === 0) {
        searchResults.innerHTML = '<div class="p-4 text-center text-gray-500">검색 결과가 없습니다</div>';
        searchResults.classList.remove('hidden');
        return;
    }

    books.forEach(book => {
        const item = document.createElement('div');
        item.className = 'flex gap-3 p-3 hover:bg-gray-50 cursor-pointer border-b border-gray-100 last:border-b-0';
        item.innerHTML = `
            <img src="${book.book_img || '/resources/images/no-image.png'}" alt="${book.book_title}" class="w-12 h-16 object-cover rounded" onerror="this.src='/resources/images/no-image.png'" />
            <div class="flex-1 min-w-0">
                <p class="font-bold text-gray-900 truncate">${book.book_title}</p>
                <p class="text-sm text-gray-600">${book.book_author}</p>
                <p class="text-sm text-gray-500">${book.book_publisher}</p>
                <p class="text-sm text-primary-600 font-bold">${book.book_org_price ? book.book_org_price.toLocaleString() + '원' : ''}</p>
            </div>
        `;
        item.addEventListener('click', () => selectBook(book));
        searchResults.appendChild(item);
    });

    searchResults.classList.remove('hidden');
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

// 이미지 URL 추가
function addImageUrl() {
    const container = document.getElementById('imageUrlsContainer');
    const newInput = document.createElement('div');
    newInput.className = 'image-url-input flex gap-2';
    newInput.innerHTML = `
        <input type="text" name="imgUrls" 
               placeholder="https://example.com/image.jpg"
               class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500" />
        <button type="button" onclick="removeImageUrl(this)" 
                class="px-4 py-3 bg-red-50 text-red-600 rounded-lg hover:bg-red-100 transition font-bold">
            삭제
        </button>
    `;
    container.appendChild(newInput);
}

// 이미지 URL 삭제
function removeImageUrl(button) {
    const container = document.getElementById('imageUrlsContainer');
    const inputs = container.querySelectorAll('.image-url-input');
    
    // 최소 1개는 남겨둠
    if (inputs.length > 1) {
        button.closest('.image-url-input').remove();
    } else {
        alert('최소 1개의 이미지 입력 필드는 유지되어야 합니다.');
    }
}

// 폼 제출 전 검증
document.querySelector('form').addEventListener('submit', function(e) {
    // 필수 필드 체크는 HTML5 required 속성으로 자동 처리됨
    
    // 빈 이미지 URL 제거
    const imgUrlInputs = document.querySelectorAll('input[name="imgUrls"]');
    imgUrlInputs.forEach(input => {
        if (!input.value.trim()) {
            input.remove();
        }
    });
});
</script>

<jsp:include page="../mockup/common/footer.jsp" />
