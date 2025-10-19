<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.fusion.user.vo.UserVO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<style>
.container {
	display: flex;
	flex-direction: column;
}

.card-hearder{
	display:flex;
	flex-direction:row;
	justify-content:space-between
}
</style>
<body>

	<%
	UserVO loggedInUser = (UserVO) session.getAttribute("loggedInUser");
	%>
	<!-- 	<h1>게시판</h1> -->

	<main class="mt-5 pt-5">
		<div class="container-fluid px-4">


			<%
			if (loggedInUser != null) {
			%>
			<div class="card-header">
				<div class="card mb-4" style="width: 30%;">
				메뉴아이디:${menuId }
					<!-- 게시글 수 선택 -->
					<form action="/progress/progressMain.do" method="get" style="display: flex; gap: 10px; align-items: center;">
						<input type="hidden" value="${menuId}" id="menuId" name="menuId">
						<select name="limit" class="form-select" >
							<option>선택</option>
							<option value="5" ${selectedlimit==10 ? 'selected':''}>5개</option>
							<option value="10" ${selectedlimit==20 ? 'selected':''}>10개</option>
							<option value="20" ${selectedlimit==30 ? 'selected':''}>20개</option>
						</select> <input type="hidden" name="page" value="1">
						<button class="btn btn-primary" style="width:100px;">조회</button>
					</form>
				</div>
				<div class="write-btn">
					<a class="btn btn-primary float-end" onclick="openPopup('/progress/progressRegister.do?menuId=${menuId}')"> <i class="fas fa-edit"></i> 글 작성
					</a>
				</div>
			</div>
			<%
			}
			%>
			<div class="card-body">
				<c:set var="startNumber" value="${count - (currentPage - 1) * selectedLimit}" />
				<table class="table table-hover table-striped">
					<thead>
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>작성자</th>
							<th>담당 관리자</th>
							<th>요청 상태</th>
							<th>작성날짜</th>
						</tr>
					</thead>
					<tbody>
				
						<c:choose>
							<%-- <c:when test="${loggedInUser.userId == board.userId }"> --%>
							<c:when test="${ not empty boardList}">
								<c:forEach items="${boardList}" var="board" varStatus="status">
									<tr>
										<td>${startNumber - (status.count - 1) }</td> 
									<%-- 	<td>${status.count}</td> --%>
							<%-- 			<td>${count}</td> --%>
										<!-- <td>번호</td> -->
										<td><a href="#" onclick="openPopup('/progress/progredssBoardDetail.do?boardId=${board.boardId}&menuId=${menuId }')">
										 	<c:if test="${board.maxRef>0}">[${board.maxRef}차 이의제기]</c:if> ${board.boardTitle} </a></td>
										<td>${board.userId}</td>
										<td>${board.adminId}</td>
										<td>${board.subCodeName}</td>
										<td>${board.boardCreateAt }</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="6" class="text-center">게시글이 없습니다.</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
		</div>
		<div class="container" style="display: flex; justify-content: flex-end;">

			<div>
				<nav aria-label="Page navigation">
					<ul class="pagination justify-content-center">
						<c:if test="${totalPage > 0}">
							<c:forEach var="i" begin="1" end="${totalPage}">
								<li class="page-item ${currentPage == i ? 'active' : ''}"><a class="page-link" href="/progress/progressMain.do?menuId=${menuId }&page=${i}&limit=${selectedLimit}"> ${i} </a></li>
							</c:forEach>
						</c:if>
					</ul>
				</nav>

			</div>
			<!-- 페이징  -->
		</div>



	</main>
</body>
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>

<script>
	function openPopup(url) {
		window.open(url, 'popup', 'width=800,height=900,scrollbars=yes');
	}
</script>
</html>