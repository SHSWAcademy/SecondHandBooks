<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
  <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
    <h3 class="font-bold text-lg text-gray-900">회원 관리 (최근 가입순)</h3>
  </div>

     <!-- 검색 영역 -->
      <div class="px-6 py-5 bg-gray-50/50 border-b border-gray-100">
        <div class="flex items-center gap-3">
          <!-- 검색 타입 -->
          <select
            id="searchType"
            class="px-4 py-2.5 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent transition">
            <option value="all">전체</option>
            <option value="nickname">닉네임</option>
            <option value="email">이메일</option>
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
    <tr><th class="px-6 py-4 text-left">회원 정보</th><th class="px-6 py-4 text-left">상태</th><th class="px-6 py-4 text-left">가입일</th><th class="px-6 py-4 text-right">관리</th></tr>
    </thead>
    <tbody class="divide-y divide-gray-50">
    <c:forEach var="m" items="${members}">
      <tr class="hover:bg-gray-50/50 transition-colors">
        <td class="px-6 py-4">
          <div class="flex items-center gap-3">
            <div class="w-9 h-9 rounded-full bg-blue-50 flex items-center justify-center font-bold text-primary-600 border border-blue-100">${fn:substring(m.member_nicknm, 0, 1)}</div>
            <div><p class="text-sm font-bold text-gray-900">${m.member_nicknm}</p><p class="text-[11px] text-gray-400">${m.member_email}</p></div>
          </div>
        </td>
        <td class="px-6 py-4">
          <c:choose>
            <c:when test="${m.member_st == 'JOIN'}"><span class="inline-flex items-center px-2.5 py-1 rounded-md text-[10px] font-bold bg-emerald-50 text-emerald-600 border border-emerald-100">Active</span></c:when>
            <c:otherwise><span class="inline-flex items-center px-2.5 py-1 rounded-md text-[10px] font-bold bg-gray-50 text-gray-600 border border-gray-100">Inactive</span></c:otherwise>
          </c:choose>
        </td>
        <td class="px-6 py-4 text-xs text-gray-500 font-mono">${fn:substring(m.crt_dtm, 0, 10)}</td>
        <td class="px-6 py-4 text-right"><button class="text-gray-400 hover:text-gray-600"><i data-lucide="more-horizontal" class="w-4 h-4"></i></button></td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>