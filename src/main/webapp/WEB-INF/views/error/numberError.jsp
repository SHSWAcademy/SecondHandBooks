<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../common/header.jsp" />

<div class="bg-[#F8F9FA] min-h-[calc(100vh-200px)] flex items-center justify-center py-12 px-4 font-sans">
    <div class="bg-white p-10 rounded-[2.5rem] shadow-xl shadow-gray-200/50 border border-gray-100 max-w-md w-full text-center animate-fade-in-up">

        <div class="w-20 h-20 bg-yellow-50 rounded-full flex items-center justify-center mx-auto mb-6 shadow-sm">
            <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#EAB308" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M7.5 4h9l2.25 4.5h-13.5L7.5 4z"/>
                <path d="M5.25 8.5v12.75a2.25 2.25 0 0 0 2.25 2.25h9a2.25 2.25 0 0 0 2.25-2.25V8.5"/>
                <path d="M12 12v6"/>
                <path d="M12 12l3 3"/>
                <path d="M12 12l-3 3"/>
            </svg>
        </div>

        <h1 class="text-2xl font-black text-gray-900 mb-3 tracking-tight">
            입력 값이 올바르지 않습니다
        </h1>

        <p class="text-gray-500 text-sm mb-8 leading-relaxed font-medium">
            입력하신 숫자가 허용 범위를 벗어났습니다.<br>
            확인 후 다시 입력해 주세요.
        </p>

        <a href="javascript:history.back()"
           class="inline-flex items-center gap-2 bg-gray-900 text-white px-8 py-3.5 rounded-full font-bold text-sm hover:bg-black transition-all shadow-lg hover:shadow-xl hover:-translate-y-0.5">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
            이전으로 돌아가기
        </a>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />