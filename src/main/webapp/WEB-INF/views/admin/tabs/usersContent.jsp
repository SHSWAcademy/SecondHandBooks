<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
  <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
    <h3 class="font-bold text-lg text-gray-900">회원 관리 (최근 가입순)</h3>
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