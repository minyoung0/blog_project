
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi"
	crossorigin="anonymous">
<title>퓨전 게시판(작성)</title>
<script>
	window.onload = function() {
		document
				.querySelector('form')
				.addEventListener(
						'submit',
						function(event) {
							event.preventDefault(); // 기본 폼 제출 방지
							if(confirm('글을 작성하시겠습니까?')){
								// AJAX 요청으로 데이터 전송
							$.ajax({
								type : 'POST',
								url : '/board/insBoardPost.do',
								data : $(this).serialize(),
								success : function(response) {
									// 데이터 등록 성공 시 부모 창 새로고침
									if (window.opener) {
										window.opener.location.reload(); // 부모 창 새로고침
									}
									// 팝업 창 닫기 시도
									if (window.opener) {
										window.close();
									} else {
										alert('팝업 창이 아니어서 닫을 수 없습니다. 새 탭에서는 수동으로 창을 닫아주세요.');
									}
								},
								error : function() {
									alert('게시글 등록 중 오류가 발생했습니다.');
									}
								});
							}else{
								return false;
							}
							
						});
	}
</script>
</head>
<body>

	<main class="mt-5 pt-5">
		<div class="container-fluid px-4">
			<h1 class="mt-4">게시글 작성</h1>
			<div class="card mb-4">
				<div class="card-body">
					<form method="post" id="boardForm">
						<div class="mb-3">

							<label for="board_type" class="form-label">게시글 유형

								<div id="popup_yn_div" style="display: none;">
									<input type="hidden" name="menuId" value="${menuId}">  <label for="popup_yn">팝업 여부:</label><input type="checkbox" id="popup_yn" value="1" name="popupYn"> 팝업으로 띄우기
								</div>
							</label> <select name="boardType" id="board_type" onchange="togglePopupYn()" class="form-select">
								<option value="normal">일반</option>
								<option value="notice">공지사항</option>
							</select>
						</div>
						<div class="mb-3">
							<label for="title" class="form-label">제목</label> <input type="text" class="form-control" id="boardTitle" name="boardTitle" value="">
						</div>
						<div class="mb-3">
							<label for="content" class="form-label">내용</label>
							<textarea class="form-control" id="boardContent" name="boardContent" value=""></textarea>
						</div>
						<a href="/board/boardList.do" class="btn btn-outline-secondary">목록</a>
						<button class="btn btn-outline-warning">등록하기</button>
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
	function togglePopupYn() {
		const boardType = document.getElementById("board_type").value;
		const popupYnDiv = document.getElementById("popup_yn_div");
		if (boardType === "notice") {
			popupYnDiv.style.display = "block";
		} else {
			popupYnDiv.style.display = "none";
			document.getElementById("popup_yn").checked = false;
		}
	}
</script>
</html>