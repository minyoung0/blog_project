<%@page import="egovframework.fusion.blog.user.vo.BlogUserVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>검색 및 인증</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css"
	rel="stylesheet" crossorigin="anonymous">
<style>
.blog-logo {
	max-width: 200px; /* 로고 크기 조정 */
	display: block;
	margin: 10px auto; /* 가운데 정렬 */
}


.navbar-nav {
    display: flex;
    align-items: center; /* 모든 요소를 세로 중앙 정렬 */
}
.navbar-dark {
	height: 70px;
}

.logout {
	color: white;
	text-decoration: none;
	margin-left: 10px;
	font-size:14px;
}

.logout:hover {
	color: white;
	text-decoration: underline;
}

.myBlog{
	padding:5px 15px !important;
	font-size:14px !important;
}
</style>
</head>
<!-- 수습 -->

<!-- 블로그 -->
<%
BlogUserVO loggedInUser = (BlogUserVO) session.getAttribute("loggedInUser");
String userId = (String) session.getAttribute("userId");
%>
<!-- 네비게이션 바 -->

<nav class="navbar navbar-expand-lg navbar-dark"
	style="background-color: #5BA48E;">
	<div class="container-fluid d-flex justify-content-between">
		<!-- 블로그 로고 -->
		<a class="navbar-brand" href="/blog/mainPage.do?menuId=13"><strong>BLOG</strong></a>

		<!-- 네비게이션 메뉴 -->
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse"
			data-bs-target="#navbarNav">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse justify-content-end"
			id="navbarNav">
			<ul class="navbar-nav">
				<%
				if (loggedInUser == null) {
				%>
				<li class="nav-item"><a href="/blog/loginPage.do"
					class="btn btn-outline-light">로그인</a></li>
				<%
				} else {
				%>
				<li class="nav-item"><a href="/blog/myPage.do?blogUserId=${userId }"
					class="btn btn-outline-light myBlog">내 블로그</a></li>
				<li class="nav-item"><a href="/blog/logout.do" class="logout">로그아웃</a>
				</li>
				
				<%
				}
				%>
			</ul>
		</div>
	</div>
</nav>

</html>
