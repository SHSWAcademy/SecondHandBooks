<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div>
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-bold text-gray-900">배송지 관리</h2>
        <button onclick="openAddrModal()" class="text-xs bg-gray-900 text-white px-3 py-2 rounded font-bold hover:bg-gray-800 flex items-center gap-1">
            <i data-lucide="plus" class="w-3.5 h-3.5"></i> 새 배송지 추가
        </button>
    </div>

    <div id="addr-list-container" class="space-y-4">
        <div class="text-center py-10 text-gray-400 text-sm">목록을 불러오는 중...</div>
    </div>
</div>

<!-- 모달 -->
<div id="addr-modal" class="hidden fixed inset-0 bg-black/50 backdrop-blur-sm items-center justify-center z-50 p-4 flex">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-md p-6 relative">
        <div class="flex justify-between items-center mb-6">
            <h3 class="text-lg font-bold" id="modal-title">새 배송지 추가</h3>
            <button onclick="closeAddrModal()">
                <i data-lucide="x" class="w-5 h-5 text-gray-400"></i>
            </button>
        </div>

        <form id="form-addr" onsubmit="submitAddress(event)">
            <input type="hidden" name="addr_seq" id="addr_seq" value="0">

            <div class="space-y-4">
                <div>
                    <label class="block text-xs font-bold text-gray-600 mb-1">배송지명</label>
                    <input type="text" name="addr_nm" id="addr_nm" placeholder="예: 우리집, 회사"
                           class="w-full border border-gray-300 rounded p-2.5 text-sm outline-none focus:border-primary-500" required />
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-600 mb-1">주소</label>
                    <div class="flex gap-2 mb-2">
                        <input type="text" name="post_no" id="post_no" placeholder="우편번호" readonly
                               class="w-24 border border-gray-300 rounded p-2.5 text-sm bg-gray-50" required />
                        <button type="button" onclick="execDaumPostcode()"
                                class="bg-gray-800 text-white text-xs px-3 rounded font-bold whitespace-nowrap hover:bg-gray-900">
                            검색
                        </button>
                    </div>
                    <input type="text" name="addr_h" id="addr_h" placeholder="기본 주소" readonly
                           class="w-full border border-gray-300 rounded p-2.5 text-sm bg-gray-50 mb-2" required />
                    <input type="text" name="addr_d" id="addr_d" placeholder="상세 주소 입력"
                           class="w-full border border-gray-300 rounded p-2.5 text-sm outline-none focus:border-primary-500" required />
                </div>
                <div class="flex items-center gap-2">
                    <input type="checkbox" name="default_yn" id="chk-default" value="1"
                           class="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500">
                    <label for="chk-default" class="text-sm text-gray-700 select-none cursor-pointer">
                        기본 배송지로 설정
                    </label>
                </div>

                <button type="submit"
                        class="w-full bg-primary-600 text-white py-3 rounded font-bold text-sm hover:bg-primary-700 mt-4 shadow-sm">
                    저장하기
                </button>
            </div>
        </form>
    </div>
</div>

<!-- ⭐ Daum 우편번호 API 추가 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
    // ===== 페이지 로드 시 목록 조회 =====
    loadAddressList();

    // ===== 1. 배송지 목록 조회 (Fetch) =====
    async function loadAddressList() {
        try {
            const response = await fetch('/profile/address/list');

            if (!response.ok) {
                throw new Error('Network error');
            }

            const data = await response.json();

            let html = '';
            if (!data || data.length === 0) {
                html = '<div class="text-center py-12 bg-white border border-gray-200 border-dashed rounded-lg">' +
                       '<div class="mb-2"><i data-lucide="map-pin-off" class="w-8 h-8 mx-auto text-gray-300"></i></div>' +
                       '<p class="text-gray-500 text-sm">등록된 배송지가 없습니다.</p>' +
                       '</div>';
            } else {
                data.forEach(item => {
                    const isDefault = (item.default_yn === 1);
                    const boxClass = isDefault ? 'border-primary-500 bg-white' : 'border-gray-200 bg-white';
                    const defaultBadge = isDefault
                        ? '<span class="text-[10px] bg-primary-100 text-primary-600 px-1.5 py-0.5 rounded font-bold">기본</span>'
                        : '';

                    // JSON을 문자열로 변환 (HTML에 삽입용)
                    const itemJson = JSON.stringify(item).replace(/"/g, "'");

                    let btnHtml = '';
                    if (!isDefault) {
                        btnHtml = '<button onclick="setDefault(' + item.addr_seq + ')" ' +
                                 'class="text-xs border border-gray-300 px-2 py-1 rounded hover:bg-gray-50 transition">' +
                                 '기본 배송지로 설정</button>';
                    }

                    html += '<div class="p-5 rounded-lg border ' + boxClass + '">' +
                           '  <div class="flex justify-between items-start mb-2">' +
                           '    <div class="flex items-center gap-2">' +
                           '      <span class="font-bold text-gray-900">' + item.addr_nm + '</span>' +
                           defaultBadge +
                           '    </div>' +
                           '    <div class="flex items-center gap-2 text-xs text-gray-500">' +
                           '      <button onclick=\'openEditModal(' + itemJson + ')\' class="hover:text-gray-900 hover:underline">수정</button>' +
                           '      <span class="text-gray-300">|</span>' +
                           '      <button onclick="deleteAddr(' + item.addr_seq + ')" class="hover:text-red-600 hover:underline">삭제</button>' +
                           '    </div>' +
                           '  </div>' +
                           '  <p class="text-sm text-gray-800 mb-3">' +
                           '    <span class="text-gray-500 mr-1">[' + item.post_no + ']</span>' +
                           item.addr_h + ' ' + item.addr_d +
                           '  </p>' +
                           btnHtml +
                           '</div>';
                });
            }

            document.getElementById('addr-list-container').innerHTML = html;
            lucide.createIcons();

        } catch (error) {
            console.error('목록 조회 실패:', error);
            document.getElementById('addr-list-container').innerHTML =
                '<div class="text-center text-red-500 py-4">목록을 불러오는데 실패했습니다.</div>';
        }
    }

    // ===== 2. 배송지 추가/수정 (Fetch) =====
    async function submitAddress(e) {
        e.preventDefault();

        const form = document.getElementById('form-addr');
        const formData = new FormData(form);
        const seq = document.getElementById('addr_seq').value;

        // FormData를 URLSearchParams로 변환
        const params = new URLSearchParams();
        for (const [key, value] of formData.entries()) {
            params.append(key, value);
        }

        const url = (seq == 0 || seq == '0') ? '/profile/address/add' : '/profile/address/update';

        try {
            const response = await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            });

            const result = await response.text();

            if (result === 'success') {
                closeAddrModal();
                loadAddressList();
            } else {
                alert('저장에 실패했습니다.');
            }
        } catch (error) {
            console.error('저장 실패:', error);
            alert('서버 오류가 발생했습니다.');
        }
    }

    // ===== 3. 배송지 삭제 (Fetch) =====
    async function deleteAddr(seq) {
        if (!confirm('정말 삭제하시겠습니까?')) return;

        try {
            const response = await fetch('/profile/address/delete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'addr_seq=' + seq
            });

            const result = await response.text();

            if (result === 'success') {
                loadAddressList();
            } else {
                alert('삭제 실패');
            }
        } catch (error) {
            console.error('삭제 실패:', error);
            alert('서버 오류가 발생했습니다.');
        }
    }

    // ===== 4. 기본 배송지 설정 (Fetch) =====
    async function setDefault(seq) {
        if (!confirm('기본 배송지로 설정하시겠습니까?')) return;

        try {
            const response = await fetch('/profile/address/setDefault', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'addr_seq=' + seq
            });

            const result = await response.text();

            if (result === 'success') {
                loadAddressList();
            } else {
                alert('설정 실패');
            }
        } catch (error) {
            console.error('설정 실패:', error);
            alert('서버 오류가 발생했습니다.');
        }
    }

    // ===== 모달 열기/닫기 (순수 JavaScript) =====
    function openAddrModal() {
        document.getElementById('form-addr').reset();
        document.getElementById('addr_seq').value = 0;
        document.getElementById('modal-title').textContent = '새 배송지 추가';
        document.getElementById('addr-modal').classList.remove('hidden');
        document.getElementById('addr-modal').classList.add('flex');
    }

    function openEditModal(item) {
        // 문자열로 넘어온 경우 파싱
        if (typeof item === 'string') {
            item = JSON.parse(item);
        }

        document.getElementById('form-addr').reset();
        document.getElementById('addr_seq').value = item.addr_seq;
        document.getElementById('addr_nm').value = item.addr_nm;
        document.getElementById('post_no').value = item.post_no;
        document.getElementById('addr_h').value = item.addr_h;
        document.getElementById('addr_d').value = item.addr_d;
        document.getElementById('chk-default').checked = (item.default_yn === 1);

        document.getElementById('modal-title').textContent = '배송지 수정';
        document.getElementById('addr-modal').classList.remove('hidden');
        document.getElementById('addr-modal').classList.add('flex');
    }

    function closeAddrModal() {
        document.getElementById('addr-modal').classList.add('hidden');
        document.getElementById('addr-modal').classList.remove('flex');
    }

    // ===== Daum 우편번호 검색 =====
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = data.roadAddress;
                var extraAddr = '';

                if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                    extraAddr += data.bname;
                }
                if (data.buildingName !== '' && data.apartment === 'Y') {
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                if (extraAddr !== '') {
                    addr += ' (' + extraAddr + ')';
                }

                document.getElementById('post_no').value = data.zonecode;
                document.getElementById('addr_h').value = addr;
                document.getElementById('addr_d').focus();
            }
        }).open();
    }

    // ===== Lucide 아이콘 초기화 =====
    lucide.createIcons();
</script>