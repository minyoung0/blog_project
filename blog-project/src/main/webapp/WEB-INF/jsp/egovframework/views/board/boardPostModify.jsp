<%
/*********************************************************
 * 업 무 명 : 게시판 컨트롤러
 * 설 명 : 게시판을 조회하는 화면에서 사용 
 * 작 성 자 : 김민규
 * 작 성 일 : 2022.10.06
 * 관련테이블 : 
 * Copyright ⓒ fusionsoft.co.kr
 *
 *********************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi"
	crossorigin="anonymous">
<title>퓨전 게시판(수정)</title>
</head>
<body>
	<main class="mt-5 pt-5">
	<div class="container-fluid px-4">
		<h1 class="mt-4">게시글 수정</h1>
		menu Id=${menuId }
		boardId=${boardPost.boardId }
		<div class="card mb-4">
			<div class="card-body">
				<form method="post" action="/board/updBoardPost.do?boardId=${boardPost.boardId}&menuId=${menuId}">
					<input type="hidden" name="menuId" value=${menuId }/>
					<input type="hidden" name="boardId" value="${boardPost.boardId}" />
					<div class="mb-3">
						<label for="title" class="form-label">제목</label>
						<input type="text" class="form-control" id="title" name="boardTitle" value="${boardPost.boardTitle}">
					</div>
					<div class="mb-3">
						<label for="content" class="form-label">내용</label>
						<textarea class="form-control" id="content" name="boardContent">${boardPost.boardContent}</textarea>
					</div>
					<div class="mb-3">
						<label for="writer" class="form-label">작성자</label>
						<input type="text" class="form-control" id="writer" name="writer" value="${boardPost.userName}" disabled>
					</div>
					<a href="/board/boardList.do" class="btn btn-outline-secondary">목록</a>
					<button class="btn btn-outline-warning">수정하기</button>
				</form>
			</div>
		</div>
	</div>
	</main>
</body>
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<script type="text/javascript">
	$(document).ready(function() {
		
	});
</script>
</html>