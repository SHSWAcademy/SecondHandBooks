<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
  <div class="p-6 border-b border-gray-100 bg-gray-50/50"><h3 class="font-bold text-lg text-gray-900">모임 관리 (최근 생성순)</h3></div>
  <table class="w-full">
    <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
    <tr><th class="px-6 py-4 text-left">모임명</th><th class="px-6 py-4 text-left">지역</th><th class="px-6 py-4 text-left">정원</th><th class="px-6 py-4 text-left">일정</th><th class="px-6 py-4 text-left">생성일</th></tr>
    </thead>
    <tbody class="divide-y divide-gray-50">
    <c:forEach var="g" items="${clubs}">
      <tr class="hover:bg-gray-50/50 transition-colors">
        <td class="px-6 py-4"><p class="text-sm font-bold text-gray-900">${g.book_club_name}</p></td>
        <td class="px-6 py-4 text-xs text-gray-500"><div class="flex items-center gap-1"><i data-lucide="map-pin" class="w-3 h-3"></i> ${g.book_club_rg}</div></td>
        <td class="px-6 py-4 text-xs font-bold text-primary-600">${g.book_club_max_member}명</td>
        <td class="px-6 py-4 text-xs text-gray-500">${g.book_club_schedule}</td>
        <td class="px-6 py-4 text-xs text-gray-500 font-mono">${fn:substring(g.crt_dtm, 0, 10)}</td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>