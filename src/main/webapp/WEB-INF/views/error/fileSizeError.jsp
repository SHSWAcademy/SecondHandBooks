<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../common/header.jsp" />

<div class="bg-[#F8F9FA] min-h-[calc(100vh-200px)] flex items-center justify-center py-12 px-4 font-sans">
    <div class="bg-white p-10 rounded-[2.5rem] shadow-xl shadow-gray-200/50 border border-gray-100 max-w-md w-full text-center animate-fade-in-up">

        <div class="w-20 h-20 bg-blue-50 rounded-full flex items-center justify-center mx-auto mb-6 shadow-sm">
            <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/>
                <polyline points="14 2 14 8 20 8"/>
                <line x1="12" y1="18" x2="12" y2="12"/>
                <line x1="9" y1="15" x2="15" y2="15"/>
            </svg>
        </div>

        <h1 class="text-2xl font-black text-gray-900 mb-3 tracking-tight">
            ${errorMessage != null ? errorMessage : "파일 크기가 너무 큽니다"}
        </h1>

        <p class="text-gray-500 text-sm mb-8 leading-relaxed font-medium">
            업로드 가능한 최대 크기는 <strong>5MB</strong>입니다.<br>
            파일 용량을 확인 후 다시 시도해 주세요.
        </p>

        <a href="javascript:history.back()"
           class="inline-flex items-center gap-2 bg-blue-600 text-white px-8 py-3.5 rounded-full font-bold text-sm hover:bg-blue-700 transition-all shadow-lg shadow-blue-200 hover:shadow-xl hover:-translate-y-0.5">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
            다시 시도하기
        </a>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />