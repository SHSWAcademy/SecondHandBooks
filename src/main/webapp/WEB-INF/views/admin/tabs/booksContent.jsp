<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
  <div class="p-6 border-b border-gray-100 bg-gray-50/50"><h3 class="font-bold text-lg text-gray-900">상품 관리 (최근 등록순)</h3></div>
   <!-- 검색 영역 -->
    <div class="px-6 py-5 bg-gray-50/50 border-b border-gray-100">
      <div class="flex items-center gap-3">
        <!-- 검색 타입 -->
        <select
          id="searchType"
          class="px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition">
          <option value="all">전체</option>
          <option value="nickname">상품명</option>
          <option value="email">지역</option>
        </select>

        <!-- 검색 입력창 -->
        <div class="flex-1 relative">
          <input
            type="text"
            id="searchKeyword"
            placeholder="검색어를 입력하세요..."
            class="w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition pl-10"
            onkeypress="if(event.keyCode === 13) searchMembers()">
          <i data-lucide="search" class="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
        </div>

        <!-- 버튼 그룹 -->
        <div class="flex gap-2">
          <button
            onclick="searchMembers()"
            class="px-5 py-2.5 bg-primary-600 text-white text-sm font-medium rounded-lg hover:bg-primary-700 transition-all flex items-center gap-2 shadow-sm hover:shadow">
            <i data-lucide="search" class="w-4 h-4"></i>
            검색
          </button>
          <button
            onclick="resetSearch()"
            class="px-5 py-2.5 bg-white border border-gray-300 text-gray-700 text-sm font-medium rounded-lg hover:bg-gray-50 transition-all flex items-center gap-2">
            <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
            초기화
          </button>
        </div>
      </div>
    </div>
  <table class="w-full">
    <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
    <tr><th class="px-6 py-4 text-left">상품명</th><th class="px-6 py-4 text-left">가격</th><th class="px-6 py-4 text-left">지역</th><th class="px-6 py-4 text-left">상태</th><th class="px-6 py-4 text-left">등록일</th></tr>
    </thead>
    <tbody class="divide-y divide-gray-50">
    <c:forEach var="t" items="${trades}">
      <tr class="hover:bg-gray-50/50 transition-colors">
        <td class="px-6 py-4"><p class="text-sm font-bold text-gray-900 w-64 truncate">${t.sale_title}</p><p class="text-[10px] text-gray-400">${t.book_title}</p></td>
        <td class="px-6 py-4 text-sm font-black text-primary-600"><fmt:formatNumber value="${t.sale_price}" pattern="#,###" />원</td>
        <td class="px-6 py-4 text-xs text-gray-500">${t.sale_rg}</td>
        <td class="px-6 py-4"><span class="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold ${t.sale_st == 'SALE' ? 'bg-green-50 text-green-600' : 'bg-gray-100 text-gray-500'}">${t.sale_st}</span></td>
        <td class="px-6 py-4 text-xs text-gray-500 font-mono">${fn:substring(t.crt_dtm, 0, 10)}</td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>