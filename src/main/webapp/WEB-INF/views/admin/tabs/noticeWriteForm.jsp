<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="max-w-4xl mx-auto py-8">
    <!-- Page Title -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">공지사항 작성</h1>
        <p class="text-gray-600">회원들에게 전달할 공지사항을 작성해주세요</p>
    </div>

    <!-- Form -->
    <form id="noticeForm" enctype="multipart/form-data" class="space-y-8" autocomplete="off">

        <!-- 기본 정보 섹션 -->
        <div class="bg-white rounded-lg border border-gray-200 p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/>
                    <polyline points="14 2 14 8 20 8"/>
                </svg>
                기본 정보
            </h2>

            <div class="space-y-4">
                <!-- 공지사항 제목 -->
                <div>
                    <label for="notice_title" class="block text-sm font-bold text-gray-700 mb-2">
                        제목 <span class="text-red-500">*</span>
                    </label>
                    <input type="text" id="notice_title" name="notice_title" required
                           placeholder="공지사항 제목을 입력하세요"
                           maxlength="100"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500" />
                    <p class="text-xs text-gray-500 mt-1">최대 100자까지 입력 가능합니다.</p>
                </div>

                <!-- 중요 공지 여부 및 공개 상태 -->
                <div class="grid grid-cols-2 gap-4">
                    <!-- 중요 공지 -->
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-2">
                            공지 유형
                        </label>
                        <div class="flex items-center gap-4 p-3 bg-gray-50 rounded-lg border border-gray-200">
                            <label class="flex items-center gap-2 cursor-pointer">
                                <input type="checkbox" id="is_important" name="is_important" value="true"
                                       class="w-4 h-4 text-red-600 bg-gray-100 border-gray-300 rounded focus:ring-red-500" />
                                <span class="text-sm text-gray-700 flex items-center gap-1">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-red-500">
                                        <circle cx="12" cy="12" r="10"/>
                                        <line x1="12" x2="12" y1="8" y2="12"/>
                                        <line x1="12" x2="12.01" y1="16" y2="16"/>
                                    </svg>
                                    중요 공지로 표시
                                </span>
                            </label>
                        </div>
                        <p class="text-xs text-gray-500 mt-1">중요 공지는 목록 상단에 고정됩니다.</p>
                    </div>

                    <!-- 공개 상태 -->
                    <div>
                        <label for="active" class="block text-sm font-bold text-gray-700 mb-2">
                            공개 상태 <span class="text-red-500">*</span>
                        </label>
                        <select id="active" name="active" required
                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500">
                            <option value="true" selected>공개</option>
                            <option value="false">비공개</option>
                        </select>
                        <p class="text-xs text-gray-500 mt-1">비공개는 관리자만 볼 수 있습니다.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- 내용 섹션 -->
        <div class="bg-white rounded-lg border border-gray-200 p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                </svg>
                공지 내용
            </h2>

            <div class="space-y-4">
                <!-- 내용 입력 -->
                <div>
                    <label for="notice_cont" class="block text-sm font-bold text-gray-700 mb-2">
                        내용 <span class="text-red-500">*</span>
                    </label>
                    <textarea id="notice_cont" name="notice_cont" required rows="15"
                              placeholder="공지사항 내용을 작성해주세요."
                              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 resize-none font-mono text-sm"></textarea>
                    <div class="flex items-center justify-between mt-2">
                        <p class="text-xs text-gray-500">작성하신 내용은 회원들에게 바로 노출됩니다.</p>
                        <p id="charCount" class="text-xs text-gray-500">0자</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- 첨부파일 섹션 -->
        <div class="bg-white rounded-lg border border-gray-200 p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="m21.44 11.05-9.19 9.19a6 6 0 0 1-8.49-8.49l8.57-8.57A4 4 0 1 1 18 8.84l-8.59 8.57a2 2 0 0 1-2.83-2.83l8.49-8.48"/>
                </svg>
                첨부파일 (선택사항)
            </h2>

            <div class="space-y-3">
                <input type="file" name="attachments" accept=".pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.zip,.jpg,.jpeg,.png,.gif" multiple
                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:bg-primary-500 file:text-white file:font-bold hover:file:bg-primary-600" />
                <p id="fileMsg" class="text-xs text-gray-500">
                    PDF, 문서, 이미지, 압축파일 등을 첨부할 수 있습니다. (최대 5개, 파일당 10MB 이하)
                </p>

                <!-- 선택된 파일 미리보기 -->
                <div id="filePreview" class="hidden mt-3">
                    <p class="text-sm font-bold text-gray-700 mb-2">선택된 파일:</p>
                    <div id="fileList" class="space-y-2"></div>
                </div>
            </div>
        </div>

        <!-- 제출 버튼 -->
        <div class="flex gap-3 sticky bottom-4 bg-white p-4 rounded-lg border border-gray-200 shadow-lg">
            <button type="button" onclick="switchView('notice')"
                    class="flex-1 px-6 py-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition font-bold">
                취소
            </button>
            <button type="button" onclick="saveDraft()"
                    class="flex-1 px-6 py-4 bg-white border-2 border-primary-500 text-primary-600 rounded-lg hover:bg-primary-50 transition font-bold">
                임시저장
            </button>
            <button type="submit"
                    class="flex-1 px-6 py-4 bg-primary-500 text-white rounded-lg hover:bg-primary-600 transition font-bold shadow-sm">
                등록하기
            </button>
        </div>
    </form>
</div>

<script>
// 글자 수 카운터
const contentTextarea = document.getElementById('notice_cont');
const charCount = document.getElementById('charCount');

contentTextarea.addEventListener('input', function() {
    const length = this.value.length;
    charCount.textContent = length.toLocaleString() + '자';

    if (length > 5000) {
        charCount.classList.add('text-red-500', 'font-bold');
    } else {
        charCount.classList.remove('text-red-500', 'font-bold');
    }
});






// 파일 업로드 제한 및 미리보기
const fileInput = document.querySelector('input[name="attachments"]');
const fileMsg = document.getElementById('fileMsg');
const filePreview = document.getElementById('filePreview');
const fileList = document.getElementById('fileList');

fileInput.addEventListener('change', function() {
    const files = this.files;

    // 파일 개수 체크
    if (files.length > 5) {
        fileMsg.textContent = '최대 5개까지 업로드 가능합니다.';
        fileMsg.style.color = 'red';
        fileMsg.style.fontWeight = 'bold';
        this.value = '';
        filePreview.classList.add('hidden');
        return;
    }

    // 파일 크기 체크 (10MB)
    for (let i = 0; i < files.length; i++) {
        if (files[i].size > 10 * 1024 * 1024) {
            fileMsg.textContent = '파일당 최대 10MB까지 업로드 가능합니다.';
            fileMsg.style.color = 'red';
            fileMsg.style.fontWeight = 'bold';
            this.value = '';
            filePreview.classList.add('hidden');
            return;
        }
    }

    // 메시지 초기화
    fileMsg.textContent = 'PDF, 문서, 이미지, 압축파일 등을 첨부할 수 있습니다. (최대 5개, 파일당 10MB 이하)';
    fileMsg.style.color = '';
    fileMsg.style.fontWeight = '';

    // 파일 목록 표시
    if (files.length > 0) {
        fileList.innerHTML = '';
        for (let i = 0; i < files.length; i++) {
        // 파일 아이템 컨테이너
            const fileItem = document.createElement('div');
            fileItem.className = 'flex items-center gap-2 p-2 bg-white border border-gray-200 rounded text-sm';

            // SVG 아이콘
            const fileIcon = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
            fileIcon.setAttribute('width', '16');
            fileIcon.setAttribute('height', '16');
            fileIcon.setAttribute('viewBox', '0 0 24 24');
            fileIcon.setAttribute('fill', 'none');
            fileIcon.setAttribute('stroke', 'currentColor');
            fileIcon.setAttribute('stroke-width', '2');
            fileIcon.setAttribute('stroke-linecap', 'round');
            fileIcon.setAttribute('stroke-linejoin', 'round');
            fileIcon.className = 'text-primary-600';

            const path1 = document.createElementNS('http://www.w3.org/2000/svg', 'path');
            path1.setAttribute('d', 'M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z');

            const polyline = document.createElementNS('http://www.w3.org/2000/svg', 'polyline');
            polyline.setAttribute('points', '14 2 14 8 20 8');

            fileIcon.appendChild(path1);
            fileIcon.appendChild(polyline);

            // 파일명
            const fileName = document.createElement('span');
            fileName.className = 'flex-1 truncate';
            fileName.textContent = files[i].name;

            // 파일 크기
            const fileSize = document.createElement('span');
            fileSize.className = 'text-xs text-gray-500';
            fileSize.textContent = (files[i].size / 1024).toFixed(1) + 'KB';

            // 요소 조립
            fileItem.appendChild(fileIcon);
            fileItem.appendChild(fileName);
            fileItem.appendChild(fileSize);
            fileList.appendChild(fileItem);
        }

        filePreview.classList.remove('hidden');
    } else {
        filePreview.classList.add('hidden');
    }
});



// 임시저장 기능
function saveDraft() {

    alert('구현중.');
}



// 폼 제출시 임시저장 데이터 삭제
document.querySelector('form').addEventListener('submit', function(e) {
    e.preventDefault(); // 페이지 이동 방지

    // 필수 필드 검증
    const title = document.getElementById('notice_title').value.trim();
    const content = document.getElementById('notice_cont').value.trim();

    if (!title || !content) {
        e.preventDefault();
        alert('제목과 내용을 모두 입력해주세요.');
        return;
    }

    // 제출 전 확인
    if (!confirm('공지사항을 등록하시겠습니까?')) {
        e.preventDefault();
        return;
    }
    // FormData로 파일 포함해서 전송
    const formData = new FormData(this);

    fetch('/admin/notices', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('공지사항이 등록되었습니다.');


            // 목록 탭으로 돌아가기
            switchView('notice', null);

            // 목록 새로고침 (선택사항)
            searchNotices(1);
        } else {
            alert('등록 중 오류가 발생했습니다.: ' + data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('등록 중 오류가 발생했습니다.');
    });
});
</script>
