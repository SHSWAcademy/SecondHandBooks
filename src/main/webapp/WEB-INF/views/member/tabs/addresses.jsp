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

<div id="addr-modal" class="hidden fixed inset-0 bg-black/50 backdrop-blur-sm items-center justify-center z-50 p-4 flex">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-md p-6 relative">
        <div class="flex justify-between items-center mb-6">
            <h3 class="text-lg font-bold" id="modal-title">새 배송지 추가</h3>
            <button onclick="closeAddrModal()"><i data-lucide="x" class="w-5 h-5 text-gray-400"></i></button>
        </div>

        <form id="form-addr" onsubmit="return submitAddress(event)">
            <input type="hidden" name="addr_seq" id="addr_seq" value="0">

            <div class="space-y-4">
                <div>
                    <label class="block text-xs font-bold text-gray-600 mb-1">배송지명</label>
                    <input type="text" name="addr_nm" id="addr_nm" placeholder="예: 우리집, 회사" class="w-full border border-gray-300 rounded p-2.5 text-sm outline-none focus:border-primary-500" required />
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-600 mb-1">주소</label>
                    <div class="flex gap-2 mb-2">
                        <input type="text" name="post_no" id="post_no" placeholder="우편번호" readonly class="w-24 border border-gray-300 rounded p-2.5 text-sm bg-gray-50" required />
                        <button type="button" onclick="execDaumPostcode()" class="bg-gray-800 text-white text-xs px-3 rounded font-bold whitespace-nowrap hover:bg-gray-900">검색</button>
                    </div>
                    <input type="text" name="addr_h" id="addr_h" placeholder="기본 주소" readonly class="w-full border border-gray-300 rounded p-2.5 text-sm bg-gray-50 mb-2" required />
                    <input type="text" name="addr_d" id="addr_d" placeholder="상세 주소 입력" class="w-full border border-gray-300 rounded p-2.5 text-sm outline-none focus:border-primary-500" required />
                </div>
                <div class="flex items-center gap-2">
                    <input type="checkbox" name="default_yn" id="chk-default" value="1" class="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500">
                    <label for="chk-default" class="text-sm text-gray-700 select-none cursor-pointer">기본 배송지로 설정</label>
                </div>

                <button type="submit" class="w-full bg-primary-600 text-white py-3 rounded font-bold text-sm hover:bg-primary-700 mt-4 shadow-sm">저장하기</button>
            </div>
        </form>
    </div>
</div>

<script>
    loadAddressList();

    function loadAddressList() {
        $.ajax({
            url: '/profile/address/list',
            method: 'GET',
            dataType: 'json',
            success: function(data) {
                let html = '';
                if(!data || data.length === 0) {
                    html = '<div class="text-center py-12 bg-white border border-gray-200 border-dashed rounded-lg text-gray-500 text-sm">' +
                        '<div class="mb-2"><i data-lucide="map-pin-off" class="w-8 h-8 mx-auto text-gray-300"></i></div>' +
                        '등록된 배송지가 없습니다.' +
                        '</div>';
                } else {
                    data.forEach(item => {
                        // 1. 변수 미리 선언 (JSP 에디터 혼란 방지)
                        let isDefault = (item.default_yn === 1);
                        let boxClass = isDefault ? 'border-primary-500 bg-white' : 'border-gray-200 bg-white';
                        let defaultBadge = isDefault ? '<span class="text-[10px] bg-primary-100 text-primary-600 px-1.5 py-0.5 rounded font-bold">기본</span>' : '';

                        // 2. 수정 버튼 데이터 처리
                        let editData = JSON.stringify(item).replace(/"/g, '&quot;');

                        // 3. 버튼 HTML 분리
                        let btnHtml = '';
                        if (!isDefault) {
                            btnHtml = '<button onclick="setDefault(' + item.addr_seq + ')" class="text-xs border border-gray-300 px-2 py-1 rounded hover:bg-gray-50 transition">기본 배송지로 설정</button>';
                        }

                        // 4. HTML 조립 (백틱 중첩 제거)
                        html += '<div class="p-5 rounded-lg border ' + boxClass + '">' +
                            '  <div class="flex justify-between items-start mb-2">' +
                            '    <div class="flex items-center gap-2">' +
                            '      <span class="font-bold text-gray-900">' + item.addr_nm + '</span>' +
                            defaultBadge +
                            '    </div>' +
                            '    <div class="flex items-center gap-2 text-xs text-gray-500">' +
                            '      <button onclick="openEditModal(' + editData.replace(/"/g, "'") + ')" class="hover:text-gray-900 hover:underline">수정</button>' +
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
                $('#addr-list-container').html(html);
                lucide.createIcons();
            },
            error: function(err) {
                console.error(err);
                $('#addr-list-container').html('<div class="text-center text-red-500 py-4">목록을 불러오는데 실패했습니다.</div>');
            }
        });
    }

    function openAddrModal() {
        $('#form-addr')[0].reset();
        $('#addr_seq').val(0);
        $('#modal-title').text('새 배송지 추가');
        $('#addr-modal').removeClass('hidden').addClass('flex');
    }

    function openEditModal(item) {
        // item이 객체가 아니라 문자열로 넘어왔을 경우 파싱
        if (typeof item === 'string') {
            item = JSON.parse(item);
        }

        $('#form-addr')[0].reset();

        $('#addr_seq').val(item.addr_seq);
        $('#addr_nm').val(item.addr_nm);
        $('#post_no').val(item.post_no);
        $('#addr_h').val(item.addr_h);
        $('#addr_d').val(item.addr_d);

        $('#chk-default').prop('checked', item.default_yn === 1);

        $('#modal-title').text('배송지 수정');
        $('#addr-modal').removeClass('hidden').addClass('flex');
    }

    function submitAddress(e) {
        e.preventDefault();

        const formData = $('#form-addr').serialize();
        const seq = $('#addr_seq').val();

        const url = (seq == 0 || seq == '0') ? '/profile/address/add' : '/profile/address/update';

        $.ajax({
            url: url,
            method: 'POST',
            data: formData,
            success: function(res) {
                if(res === 'success') {
                    closeAddrModal();
                    loadAddressList();
                } else {
                    alert('저장에 실패했습니다.');
                }
            },
            error: function() {
                alert('서버 오류가 발생했습니다.');
            }
        });
    }

    function closeAddrModal() {
        $('#addr-modal').addClass('hidden').removeClass('flex');
    }

    function deleteAddr(seq) {
        if(!confirm('정말 삭제하시겠습니까?')) return;
        $.post('/profile/address/delete', {addr_seq: seq}, function(res) {
            if(res === 'success') loadAddressList();
            else alert('삭제 실패');
        });
    }

    function setDefault(seq) {
        if(!confirm('기본 배송지로 설정하시겠습니까?')) return;
        $.post('/profile/address/setDefault', {addr_seq: seq}, function(res) {
            if(res === 'success') loadAddressList();
            else alert('설정 실패');
        });
    }

    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = data.roadAddress;
                var extraAddr = '';

                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                if(extraAddr !== ''){
                    addr += ' (' + extraAddr + ')';
                }

                $('#post_no').val(data.zonecode);
                $('#addr_h').val(addr);
                $('#addr_d').focus();
            }
        }).open();
    }
</script>