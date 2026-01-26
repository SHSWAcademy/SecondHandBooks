<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />

<script src="https://unpkg.com/lucide@latest"></script>

<div class="flex flex-col lg:flex-row gap-8 max-w-6xl mx-auto">

    <div class="lg:w-1/4">
        <div class="bg-white rounded-lg border border-gray-200 shadow-sm overflow-hidden sticky top-24">
            <div class="p-6 text-center border-b border-gray-100 bg-gray-50/50">
                <div class="w-20 h-20 bg-white border-2 border-primary-100 rounded-full flex items-center justify-center text-3xl font-bold text-primary-600 mx-auto mb-3 shadow-sm">
                    ${sessionScope.loginSess.member_nicknm.substring(0, 1)}
                </div>
                <h2 class="font-bold text-gray-900 text-lg">${sessionScope.loginSess.member_nicknm}님</h2>
                <p class="text-xs text-gray-500">${sessionScope.loginSess.member_email}</p>
            </div>

            <nav class="p-2 space-y-1">
                <a href="/mypage/profile" data-tab="profile"
                   class="nav-btn block w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all
                    <i data-lucide="user" class="w-4 h-4"></i> 내 프로필
                </a>

                <a href="/mypage/purchases" data-tab="purchases"
                   class="nav-btn block w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all
                    <i data-lucide="shopping-bag" class="w-4 h-4"></i> 구매 내역
                </a>

                <a href="/mypage/sales" data-tab="sales"
                   class="nav-btn block w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all
                    <i data-lucide="package" class="w-4 h-4"></i> 판매 내역
                </a>

                <a href="/mypage/wishlist" data-tab="wishlist"
                   class="nav-btn block w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all
                    <i data-lucide="heart" class="w-4 h-4"></i> 찜한 상품
                </a>

                <a href="/mypage/groups" data-tab="groups"
                   class="nav-btn block w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all
                    <i data-lucide="users" class="w-4 h-4"></i> 내 모임
                </a>

                <a href="/mypage/addresses" data-tab="addresses"
                   class="nav-btn block w-full text-left px-4 py-3 rounded-md text-sm font-bold flex items-center gap-3 transition-all
                    <i data-lucide="map-pin" class="w-4 h-4"></i> 배송지 관리
                </a>
            </nav>

            <div class="p-4 border-t border-gray-100">
                <button onclick="location.href='/logout'"
                        class="w-full flex items-center justify-center gap-2 text-xs font-bold text-gray-500 hover:text-red-600 py-2 transition">
                    <i data-lucide="log-out" class="w-3.5 h-3.5"></i> 로그아웃
                </button>
            </div>
        </div>
    </div>

    <div class="lg:flex-1 min-h-[500px]">
        <div id="tab-content">
            <jsp:include page="tabs/profile.jsp"/>
        </div>
    </div>

</div>

<script>
    window.loadTab = async function(tabName, params = {}) {
        try {
             // URL 파라미터 생성
             const queryString = new URLSearchParams(params).toString();
             const url = '/mypage/tab/' + tabName + (queryString ? '?' + queryString : '');

             // 로딩 표시
             document.getElementById('tab-content').innerHTML =
                '<div class="flex items-center justify-center py-20"><div class="text-gray-400">로딩 중..</div></div>';
             // Fetch 요청
             const response = await fetch(url);

             if (!response.ok) {
                throw new Error('Network response was not ok');
             }

             const html = await response.text();

             // 탭 내용 업데이트
             const tabContent = document.getElementById('tab-content');
             tabContent.innerHTML = html;

             const scripts = tabContent.querySelectorAll('script');
             scripts.forEach(script => {
                 const newScript = document.createElement('script');
                 if (script.src) {
                     newScript.src = script.src;
                 } else {
                     newScript.textContent = script.textContent;
                 }
                 document.body.appendChild(newScript);
                 document.body.removeChild(newScript);
              });

             // 스타일 업데이트
             updateActiveTab(tabName);

             // Lucide 아이콘 재랜더링
                lucide.createIcons();

             // URL 업데이트
             const displayUrl = '/mypage/' + tabName + (queryString ? '?' + queryString : '');
             history.pushState({tab: tabName, params: params}, '', displayUrl);

           } catch (error) {
                console.error('Tab loading error:', error);
                document.getElementById('tab-content').innerHTML =
                    '<div class="bg-red-50 border border-red-200 rounded-lg p-8 text-center">' +
                    '<p class="text-red-600 font-bold mb-2">탭을 불러오는데 실패했습니다</p>' +
                    '<p class="text-sm text-red-500">새로고침 후 다시 시도해주세요</p>' +
                    '</div>';
           }
        };

        // 활성 탭 스타일 업데이트
        function updateActiveTab(tabName) {
            document.querySelectorAll('[data-tab]').forEach(link => {
                    link.classList.remove('bg-primary-50', 'text-primary-600');
                    link.classList.add('text-gray-600');
            });

            const activeLink = document.querySelector('[data-tab="' + tabName + '"]');
            if (activeLink) {
                activeLink.classList.remove('text-gray-600');
                activeLink.classList.add('bg-primary-50', 'text-primary-600');
            }
        }



        document.addEventListener('DOMContentLoaded', () => {
              // 탭 링크 클릭 이벤트
              document.querySelectorAll('[data-tab]').forEach(link => {
                  link.addEventListener('click', (e) => {
                      e.preventDefault();
                      const tabName = link.dataset.tab;
                      loadTab(tabName);
                  });
              });

              // URL에서 현재 탭 확인
              const pathParts = window.location.pathname.split('/');
              const currentTab = pathParts[2] || 'profile';  // /mypage/purchases -> purchases

              // 해당 탭 로드
              loadTab(currentTab);
              lucide.createIcons();
          });

        // 브라우저 뒤로가기
        window.addEventListener('popstate', (event) => {
            if (event.state && event.state.tab) {
                loadTab(event.state.tab, event.state.params || {});
            }
        });

        function updateToSold(trade_seq) {
            if (!confirm('판매 완료 처리하면 다시 판매 중으로 되돌릴 수 없습니다.\n(판매글 수정 불가, 삭제 가능)')) {
                return;
            }

            fetch('/trade/sold/' + trade_seq, { method: 'POST' })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        alert('판매 완료 처리되었습니다.');
                        location.reload();
                    } else {
                        alert('처리에 실패했습니다.');
                    }
                });
        }

        function confirmPurchase(trade_seq) {
            if (!confirm('구매를 확정하시겠습니까?')) {
                return;
            }

            fetch('/trade/confirm/' + trade_seq, { method: 'POST' })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        alert('구매 확정되었습니다.');
                        location.reload();
                    } else {
                        alert('처리에 실패했습니다.');
                    }
                });
        }

</script>

<jsp:include page="../common/footer.jsp" />