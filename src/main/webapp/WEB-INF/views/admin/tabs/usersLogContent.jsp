<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
  <div class="p-6 border-b border-gray-100 bg-gray-50/50">
    <h3 class="font-bold text-lg text-gray-900">회원 접속 기록</h3>
    <p class="text-xs text-gray-500 mt-1">최근 로그인 기록 및 활동 내역</p>
  </div>
  <table class="w-full">
    <thead class="bg-gray-50 text-[11px] font-bold text-gray-400 uppercase tracking-widest border-b border-gray-100">
    <tr>
      <th class="px-6 py-4 text-left">회원</th>
      <th class="px-6 py-4 text-left">접속 IP</th>
      <th class="px-6 py-4 text-left">접속 시간</th>
      <th class="px-6 py-4 text-left">활동</th>
    </tr>
    </thead>
    <tbody class="divide-y divide-gray-50">
    <c:choose>
      <c:when test="${not empty userLogs}">
        <c:forEach var="log" items="${userLogs}">
          <tr class="hover:bg-gray-50/50 transition-colors">
            <td class="px-6 py-4">
              <p class="text-sm font-bold text-gray-900">${log.member_nicknm}</p>
            </td>
            <td class="px-6 py-4 text-xs text-gray-500 font-mono">${log.login_ip}</td>
            <td class="px-6 py-4 text-xs text-gray-500 font-mono">${log.login_dtm}</td>
            <td class="px-6 py-4 text-xs text-gray-500">${log.activity}</td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr>
          <td colspan="4" class="px-6 py-12 text-center text-sm text-gray-400">접속 기록이 없습니다</td>
        </tr>
      </c:otherwise>
    </c:choose>
    </tbody>
  </table>
</div>