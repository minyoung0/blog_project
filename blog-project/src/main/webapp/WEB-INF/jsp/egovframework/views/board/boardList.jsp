
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
<%@ page import="egovframework.fusion.user.vo.UserVO"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi"
	crossorigin="anonymous">


<title>퓨전 게시판(목록)</title>
</head>
<body>
	<%
	UserVO loggedInUser = (UserVO) session.getAttribute("loggedInUser");
	%>
	<!-- 	<h1>게시판</h1> -->

	<main class="mt-5 pt-5">
		<div class="container-fluid px-4">

			<%-- 			<div class="d-flex justify-content-end mb-3">
				<c:choose>
					<c:when test="${loggedInUser == null}">
						<button type="button" class="btn btn-outline-primary" onclick="location.href='/user/loginPage.do'">로그인</button>
					</c:when>
					<c:otherwise>
						<button type="button" class="btn btn-outline-primary" onclick="location.href='/user/logout.do'">로그아웃</button>
					</c:otherwise>
				</c:choose>
			</div>

			<div class="container" style="display: flex; justify-content: flex-end;">
				<div class="card mb-4" style="width: 100%;">

					<!-- 게시글 수 선택 -->
					<form action="/board/boardList.do" method="get" style="display: flex; gap: 10px; align-items: center;">
						<select name="limit" class="form-select" onchange="this.form.submit()">
							<option>선택</option>
							<option value="10" ${selectedlimit==10 ? 'selected':''}>10개</option>
							<option value="20" ${selectedlimit==20 ? 'selected':''}>20개</option>
							<option value="30" ${selectedlimit==30 ? 'selected':''}>30개</option>
						</select> <input type="hidden" name="page" value="1">
					</form>

					<form action="/board/searchBoard.do" method="get" style="display: flex; gap: 10px; align-items: center;">
						<select name="searchType" class="form-select" style="flex: 0 0 120px;">
							<option value="title" ${param.searchType == 'title' ? 'selected' : ''}>제목</option>
							<option value="content" ${param.searchType == 'content' ? 'selected' : ''}>내용</option>
							<option value="writer" ${param.searchType == 'writer' ? 'selected' : ''}>작성자</option>
							<option value="all" ${param.searchType == 'all' ? 'selected' : ''}>전체</option>
						</select> <input type="text" name="keyword" placeholder="검색어를 입력하세요" value="${param.keyword}" class="form-control" style="flex: 1; max-width: 400px;" required />
						<button type="submit" class="btn btn-primary" style="flex: 0 0 100px;">검색</button>
					</form>

				</div>
			</div>
 --%>
			<%
			if (loggedInUser != null) {
			%>
			<div class="card-header">
				<a class="btn btn-primary float-end" onclick="openPopup('/board/boardRegister.do?menuId=${menuId}')"> <i class="fas fa-edit"></i> 글 작성
				</a>
			</div>
			<%
			}
			%>
			<div class="card-body">
				<form id="deleteForm" action="/board/checkDelBoard.do?menuId=${menuId}" method="post">

					<c:set var="startNumber" value="${totalCount - (currentPage - 1) * selectedLimit}" />

					<table class="table table-hover table-striped">
						<thead>
							<tr>
								<c:choose>
									<c:when test="${userAccess eq 'superAdmin'}">
										<th>선택</th>
									</c:when>
								</c:choose>

								<th>글 번호</th>
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
											<c:choose>
												<c:when test="${userAccess eq 'superAdmin'}">
													<td><input type="checkbox" name="boardIds" value="${board.boardId }"></td>
												</c:when>
											</c:choose>

											<td>${startNumber - (status.count - 1)}</td>
											<td style="padding-left: ${board.boardLevel * 20}px;"><c:choose>
													<c:when test="${board.boardLevel >= 1}">
														<span style="color: gray;">[답글] </span>
													</c:when>
												</c:choose> <a href="#" onclick="openPopup('/board/boardPost.do?boardId=${board.boardId}&menuId=${menuId }')"> ${board.boardTitle} </a></td>
											<td>${board.userName}</td>
											<td>1</td>
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
					<c:choose>
						<c:when test="${userAccess eq 'superAdmin'}">
							<button type="button" id="deleteButton" class="btn btn-danger">선택항목 삭제</button>

						</c:when>
					</c:choose>
				</form>

			</div>
		</div>
		<!-- 페이징  -->
		<nav aria-label="Page navigation">
			<ul class="pagination justify-content-center">
				<c:if test="${totalPage > 0}">
					<c:forEach var="i" begin="1" end="${totalPage}">
						<li class="page-item ${currentPage == i ? 'active' : ''}"><a class="page-link" href="/board/boardList.do?menuId=${menuId}&page=${i}&limit=${selectedLimit}"> ${i} </a></li>
					</c:forEach>
				</c:if>
			</ul>
		</nav>


	</main>
	<c:forEach items="${popupBoards}" var="popup">
		<div class="modal" tabindex="-1" role="dialog" id="popup_modal">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">

					<div class="popup" data-board-id="${popup.boardId}">
						<div class="modal-header">
							<h1>${popup.boardTitle}</h1>
						</div>
						<div class="modal-body">${popup.boardContent}</div>
						<p></p>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary week_close_btn">일주일 간 보지않기</button>
							<button type="button" class="btn btn-primary" data-dismiss="modal">닫기</button>
						</div>
					</div>

				</div>
			</div>
		</div>
	</c:forEach>

</body>
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<script type="text/javascript">
$(document).ready(function () {
    // jQuery 및 Bootstrap JS 로딩 확인
    if (typeof jQuery === 'undefined') {
        console.error("jQuery가 로드되지 않았습니다.");
    }
    if (typeof bootstrap === 'undefined') {
        console.error("Bootstrap JS가 로드되지 않았습니다.");
    }

    // 모달 자동 실행 (쿠키 체크 포함)
    if ($.cookie('popup_hidden') === undefined) {
        let popupModal = new bootstrap.Modal(document.getElementById('popup_modal'), {
            keyboard: false,
            backdrop: 'static'
        });
        popupModal.show();
    } else {
        console.log("모달이 쿠키 설정으로 인해 표시되지 않음.");
    }

    // "일주일 간 보지 않기" 버튼 클릭 시
    $('.week_close_btn').click(function () {
        $('#popup_modal').modal('hide');
        $.cookie('popup_hidden', 'true', { expires: 7, path: '/' });
    });

    // "닫기" 버튼 클릭 시
    $('.btn-primary').click(function () {
        $('#popup_modal').modal('hide');
    });
});

	function setCookie(name, value, days) {
		const date = new Date();
		date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
		document.cookie = `${name}=${value}; path=/; expires=${date.toUTCString()}`;
	}
	let popupOffseTop = 50; // 초기 Y축 위치
	let popupOffsetLeft = 50; // 초기 X축 위치
	const popupOffsetStepTop = 80; // 각 팝업의 세로 간격
	const popupOffsetStepLeft = 80; // 각 팝업의 가로 간격
	$(".popup").each(function(index, element) {

		const popup = $(this);
		const boardId = popup.data("board-id");
		console.log("Debug - Popup Element:", popup);
		console.log("Debug - Board ID:", boardId); // boardId 값 확인

		console.log("Checking Cookie for:", `popup_${boardId}`);
		/* 				if (getCookie(`popup_${boardId}`) === "hidden") {
		 console
		 .log(`Popup ${boardId} is hidden due to cookie.`);
		 return; // 쿠키가 설정된 팝업은 표시하지 않음
		 }
		 */
		popup.show();

		// CSS 위치 설정 (퍼센트 단위)
		const offsetTop = 20 + (index * popupOffsetStepTop); // Y축 위치
		const offsetLeft = 20 + (index * popupOffsetStepLeft); // X축 위치
		console.log(`Top: ${topPosition}px, Left: ${leftPosition}px`);
		popup.css({
			display : "block",
			position : "absolute",
			top : `${popupOffsetTop + (index * popupOffsetStepTop)}px`,
			left : `${popupOffsetLeft + (index * popupOffsetStepLeft)}px`,
			background : "#fff",
			padding : "20px",
			border : "1px solid #000",
			"z-index" : 9999,
			"box-shadow" : "0px 4px 10px rgba(0, 0, 0, 0.3)"
		});

		// 드래그 가능하게 설정
		popup.draggable({
			containment : "window" // 화면 안에서만 드래그 가능
		});

		// 닫기 버튼 이벤트
		popup.find(".close-popup").on("click", function() {
			const dontShow = popup.find(".dont-show").is(":checked");
			if (dontShow) {
				setCookie(`popup_${boardId}`, "hidden", 1); // 7일 유지
				console.log(`Set Cookie for popup_${boardId}`);
			}
			popup.hide();
		});
	});

	function openPopup(url) {
		window.open(url, 'popup', 'width=800,height=600,scrollbars=yes');
	}
</script>
</html>