<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="egovframework.fusion.user.vo.UserVO" %>
<!DOCTYPE html>
<html>
<head>
    <title>회원가입 완료</title>
    <script>
        window.onload = function() {
            alert('${successMessage}'); // 회원가입 완료 메시지 띄우기
            //window.location.href = '/board/boardList.do'; // boardList 페이지로 이동
       		/* window.location.href='/gallery/galleryList.do';  galleryList*/
       		window.location.href='/survey/main.do';
        };
    </script>
</head>
<body>
</body>
</html>