<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>테스트 상세</title>
    <style>
        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
        }
        .field {
            margin: 15px 0;
            padding: 10px;
            background-color: #f9f9f9;
            border-left: 4px solid #4CAF50;
        }
        .label {
            font-weight: bold;
            color: #555;
            display: inline-block;
            width: 100px;
        }
        .value {
            color: #333;
        }
        .btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        .btn:hover {
            background-color: #45a049;
        }
        h1 {
            color: #333;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>테스트 상세보기</h1>

        <div class="field">
            <span class="label">번호:</span>
            <span class="value">${vo.no}</span>
        </div>

        <div class="field">
            <span class="label">제목:</span>
            <span class="value">${vo.title}</span>
        </div>

        <div class="field">
            <span class="label">등록일:</span>
            <span class="value">
                <fmt:formatDate value="${vo.regdate}" pattern="yyyy년 MM월 dd일 HH:mm:ss" />
            </span>
        </div>

        <a href="list" class="btn">목록으로</a>
    </div>
</body>
</html>
