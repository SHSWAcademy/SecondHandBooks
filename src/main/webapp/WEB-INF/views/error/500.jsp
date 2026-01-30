<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../common/header.jsp" />

<div class="bg-[#F8F9FA] min-h-[calc(100vh-200px)] flex items-center justify-center py-12 px-4 font-sans">
    <div class="bg-white p-10 rounded-[2.5rem] shadow-xl shadow-gray-200/50 border border-gray-100 max-w-2xl w-full text-center animate-fade-in-up">

        <div class="w-20 h-20 bg-red-50 rounded-full flex items-center justify-center mx-auto mb-6 shadow-sm">
            <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#EF4444" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                <line x1="12" y1="9" x2="12" y2="13"/>
                <line x1="12" y1="17" x2="12.01" y2="17"/>
            </svg>
        </div>

        <h1 class="text-3xl font-black text-gray-900 mb-3 tracking-tight">서비스 이용에 불편을 드려 죄송합니다</h1>
        <p class="text-gray-500 text-sm mb-8 leading-relaxed font-medium">
            일시적인 시스템 오류가 발생했습니다.<br>
            잠시 후 다시 시도해 주세요.
        </p>

        <div class="flex justify-center gap-3 mb-8">
            <a href="javascript:history.back()" class="px-6 py-3 bg-gray-100 text-gray-600 rounded-full font-bold text-sm hover:bg-gray-200 transition-all">
                이전 페이지
            </a>
            <a href="/" class="px-6 py-3 bg-gray-900 text-white rounded-full font-bold text-sm hover:bg-black transition-all shadow-lg hover:shadow-xl hover:-translate-y-0.5">
                홈으로 가기
            </a>
        </div>

        <% if (exception != null) { %>
        <div class="text-left border-t border-gray-100 pt-6">
            <details class="group">
                <summary class="flex items-center gap-2 text-xs font-bold text-gray-400 cursor-pointer hover:text-red-500 transition-colors list-none select-none">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="transition-transform group-open:rotate-90"><path d="m9 18 6-6-6-6"/></svg>
                    에러 상세 내용 보기 (Developer Only)
                </summary>
                <div class="mt-4 p-4 bg-gray-900 rounded-2xl overflow-x-auto shadow-inner">
                    <p class="text-red-400 text-xs font-mono mb-2 font-bold">
                        <%= exception.getClass().getName() %>: <%= exception.getMessage() %>
                    </p>
                    <pre class="text-[10px] text-gray-300 font-mono leading-relaxed whitespace-pre-wrap"><%
                        java.io.StringWriter sw = new java.io.StringWriter();
                        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
                        exception.printStackTrace(pw);
                        out.println(sw.toString());
                    %></pre>
                </div>
            </details>
        </div>
        <% } %>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />