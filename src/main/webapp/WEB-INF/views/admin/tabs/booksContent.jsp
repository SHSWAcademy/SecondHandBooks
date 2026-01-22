<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
  <div class="p-6 border-b border-gray-100 bg-gray-50/50"><h3 class="font-bold text-lg text-gray-900">상품 관리 (최근 등록순)</h3></div>
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