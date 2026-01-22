<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
  <div class="p-6 border-b border-gray-100 bg-gray-50/50">
    <h3 class="font-bold text-lg text-gray-900">관리자 활동 로그</h3>
    <p class="text-xs text-gray-500 mt-1">관리자 로그인 및 주요 활동 기록</p>
  </div>
  <table class="w-full">
    <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
    <tr>
      <th class="px-6 py-4 text-left">관리자</th>
      <th class="px-6 py-4 text-left">활동</th>
      <th class="px-6 py-4 text-left">접속 IP</th>
      <th class="px-6 py-4 text-left">일시</th>
    </tr>
    </thead>
    <tbody class="divide-y divide-gray-50">
    <c:choose>
      <c:when test="${not empty adminLogs}">
        <c:forEach var="log" items="${adminLogs}">
          <tr class="hover:bg-gray-50/50 transition-colors">
            <td class="px-6 py-4">
              <p class="text-sm font-bold text-gray-900">${log.admin_login_id}</p>
            </td>
            <td class="px-6 py-4 text-xs text-gray-600">${log.activity}</td>
            <td class="px-6 py-4 text-xs text-gray-500 font-mono">${log.login_ip}</td>
            <td class="px-6 py-4 text-xs text-gray-500 font-mono">${log.activity_dtm}</td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr>
          <td colspan="4" class="px-6 py-12 text-center text-sm text-gray-400">활동 기록이 없습니다</td>
        </tr>
      </c:otherwise>
    </c:choose>
    </tbody>
  </table>
</div>