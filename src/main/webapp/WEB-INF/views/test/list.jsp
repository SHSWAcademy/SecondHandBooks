<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>테스트 목록</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
            margin: 20px 0;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
        }
        h1 {
            color: #333;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>테스트 목록</h1>

        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>등록일</th>
                    <th>상세보기</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty list}">
                    <tr>
                        <td colspan="4" style="text-align: center;">
                            데이터가 없습니다.
                        </td>
                    </tr>
                </c:if>

                <c:forEach var="vo" items="${list}">
                    <tr>
                        <td>${vo.no}</td>
                        <td>${vo.title}</td>
                        <td>
                            <fmt:formatDate value="${vo.regdate}" pattern="yyyy-MM-dd HH:mm:ss" />
                        </td>
                        <td>
                            <a href="view?no=${vo.no}">보기</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <p>총 <strong>${list.size()}</strong>건</p>
    </div>
</body>
</html>