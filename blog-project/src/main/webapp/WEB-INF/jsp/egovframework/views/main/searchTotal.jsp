<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
/* 전체 레이아웃 */
body {
	font-family: 'Arial', sans-serif;
	background-color: #f8f9fa;
	margin: 0;
	padding: 0;
}

main {
	padding: 20px;
}

/* 갤러리 그리드 */
.gallery-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
	gap: 20px;
	margin-top: 20px;
}

/* 카드 스타일 */
.gallery-card {
	border: 1px solid #ddd;
	border-radius: 10px;
	overflow: hidden;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	transition: transform 0.2s, box-shadow 0.2s;
	background-color: #fff;
	text-decoration: none;
	color: inherit;
}

.gallery-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

/* 썸네일 스타일 */
.gallery-thumbnail {
	width: 100%;
	height: 200px;
	object-fit: cover;
}

/* 카드 정보 */
.gallery-info {
	padding: 15px;
	text-align: center;
}

.gallery-info h5 {
	font-size: 1.2em;
	font-weight: bold;
	color: #333;
	margin-bottom: 10px;
	display: -webkit-box;
	-webkit-box-orient: vertical;
	overflow: hidden;
	text-overflow: ellipsis;
	line-clamp: 2;
	-webkit-line-clamp: 2;
}

.gallery-info p {
	font-size: 0.95em;
	color: #666;
	margin-bottom: 10px;
	display: -webkit-box;
	-webkit-box-orient: vertical;
	overflow: hidden;
	text-overflow: ellipsis;
	line-clamp: 2;
	-webkit-line-clamp: 2;
	max-height: 3em;
}

.gallery-info .meta {
	font-size: 0.9em;
	color: #888;
}

/* 검색 폼 및 필터 */
form {
	display: flex;
	flex-wrap: wrap;
	gap: 10px;
	margin-bottom: 20px;
}

form .form-select, form .form-control {
	width: auto;
	flex: 1;
}

form .btn-primary {
	height: 38px;
	font-size: 0.95em;
}

/* 페이징 */
.pagination {
	margin-top: 30px;
	justify-content: center;
}

.pagination .page-item.active .page-link {
	background-color: #007bff;
	color: #fff;
	border-color: #007bff;
	font-weight: bold;
}

.pagination .page-link {
	color: #007bff;
	border: 1px solid #ddd;
}

.pagination .page-link:hover {
	background-color: #e9ecef;
	color: #0056b3;
}

/* 로그인/로그아웃 */
.auth-section {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	margin-bottom: 20px;
}

.auth-section span {
	font-size: 16px;
	color: #555;
}
</style>
</head>
<body>
	<div class="boardType">
		<h1>글게시판 검색 결과 메뉴아이디:${menuId }</h1><br>
		<div class="card-body">

			<table class="table table-hover table-striped">
				<thead>
					<tr>
						<th>글 번호</th>
						<th>메뉴명</th>
						<th>제목</th>
						<th>작성자</th>
						<th>조회수</th>
						<th>작성일</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty boardList}">
							<c:forEach items="${boardList}" var="board" varStatus="status">
								<tr>
									<td>${board.boardId}</td>
									<td>${board.menuName}</td>
									<td style="padding-left: ${board.boardLevel * 20}px;"><c:choose>
											<c:when test="${board.boardLevel > 1}">
												<span style="color: gray;">[답글] </span>
											</c:when>
										</c:choose> <a href="#" onclick="openPopup('/board/boardPost.do?boardId=${board.boardId}&menuId=${board.menuId}')"> ${board.boardTitle} </a></td>
									<td>${board.userName}</td>
									<td>${board.viewcount}</td>
									<td>${board.boardRegistDatetime}</td>
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

	<div class="gallery-grid">
		<h1>갤러리게시판 검색 결과</h1><Br>
		<c:choose>
			<c:when test="${not empty galleryList}">
				<c:forEach var="gallery" items="${galleryList}">
					<%-- <a href="/gallery/galleryDetail.do?boardId=${gallery.boardId}" class="gallery-card"> --%>
					<a href="javascript:void(0);" class="gallery-card" onclick="openPopup('/gallery/galleryDetail.do?boardId=${gallery.boardId}&menuId=${gallery.menuId}')"> <img src="${gallery.thumbnailPath}" alt="${gallery.boardTitle}"
						class="gallery-thumbnail">
						<div class="gallery-info">
							<h5>${gallery.boardTitle}_${gallery.menuId}</h5>
							<p>${gallery.boardContent}</p>
							<p>메뉴 이름: ${gallery.menuName}</p>
							<div class="meta">
								작성일: ${gallery.boardRegistDatetime} | 작성자: ${gallery.userName} <br> 조회수: ${gallery.viewCount} | 좋아요: ${gallery.likeCount}
							</div>
						</div>
					</a>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<div class="no-results">
					<p>일치하는 항목이 없습니다.</p>
				</div>
			</c:otherwise>
		</c:choose>
	</div>

	<div class="surveyType">
		<h1>설문 검색 결과</h1><br>
		<table class="table table-hover table-striped">
			<thead>
				<tr>
					<th>제목</th>
					<th>참여기간</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${not empty surveyList}">
						<c:forEach items="${surveyList}" var="survey" varStatus="status">
							<tr>
								<td><a href="#" onclick="openPopup('/survey/main.do?menuId=3')"> ${survey.surveyName}</a></td>
								<td>${survey.startDate}~${survey.endDate}</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="5" class="text-center">일치하는 항목이 없습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>
	<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
	<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
	<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
	<script type="text/javascript">


		function openPopup(url) {
			window.open(url, 'popup', 'width=800,height=600,scrollbars=yes');
		}
	</script>
</body>
</html>