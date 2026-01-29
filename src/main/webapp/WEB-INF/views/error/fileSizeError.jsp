<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../common/header.jsp" />

<div class="max-w-6xl mx-auto py-20 flex flex-col items-center justify-center min-h-[60vh]">

    <!-- 에러 아이콘 -->
    <div class="w-20 h-20 mb-6 flex items-center justify-center rounded-full bg-red-100 text-red-600">
        <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01M21 12c0 4.97-4.03 9-9 9s-9-4.03-9-9 4.03-9 9-9 9 4.03 9 9z"/>
        </svg>
    </div>

    <!-- 메시지 -->
    <h1 class="text-2xl font-bold text-gray-900 mb-4 text-center">
        ${errorMessage != null ? errorMessage : "업로드 가능한 파일 크기를 초과했습니다."}
    </h1>

    <p class="text-gray-600 text-center mb-6">
        최대 5MB 이하의 파일만 업로드 가능합니다.
    </p>

    <!-- 이전 페이지 버튼 -->
    <a href="javascript:history.back()"
       class="px-6 py-3 bg-primary-500 text-white rounded-xl hover:bg-primary-600 transition font-bold shadow-sm">
        이전 페이지로 돌아가기
    </a>
</div>

<jsp:include page="../common/footer.jsp" />
