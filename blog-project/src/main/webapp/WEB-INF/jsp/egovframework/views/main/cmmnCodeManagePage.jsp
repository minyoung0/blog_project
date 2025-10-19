<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>공통 코드 관리</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css"
	rel="stylesheet" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.6.4.min.js"
	crossorigin="anonymous"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
	crossorigin="anonymous"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">

<style>
body {
	background-color: #f8f9fa;
}

.container {
	max-width: 1400px;
	margin: auto;
	padding-top: 20px;
}

.table-container {
	background: white;
	padding: 20px;
	border-radius: 10px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	margin-bottom: 20px;
}

.table th {
	background-color: #6799F0;
	color: white;
	text-align: center;
}

.table tbody tr:hover {
	background-color: #f1f1f1;
}

.btn i {
	margin-right: 5px;
}

.tab-content {
	margin-top: 20px;
}

.table-title {
	text-align: center;
	font-size: 20px;
	font-weight: bold;
	margin-bottom: 15px;
	color: #007bff;
}

.btn-group {
	display: flex;
	justify-content: space-between;
	width:45%;
}

.table-wrapper {
	display: flex;
	justify-content: space-between;
	gap: 20px;
}

.table-box {
	flex: 1;
}
</style>
<script>
	let key = "${param.key}";
	console.log(key);
	if (key === "cmmnList") {

		$("#cmmnList-tab").removeClass("active");
		$("#mmnManage-tab").removeClass("active");

		$("#cmmnList").removeClass("show active");
		$("#cmmnManage").removeClass("show active");

	} else if (key === "mmnManage") {
		$("#cmmnList-tab").removeClass("active");
		$("#mmnManage-tab").removeClass("active");

		$("#cmmnList").removeClass("show active");
		$("#cmmnManage").removeClass("show active");
	}

	$(document)
			.ready(
					function() {
						$('a')
								.each(
										function() {
											const id = this.id;
											console.log(id);
											if (id.startsWith("mainCodeName-")) {
												document.getElementById(id).onclick = function() {
													console.log("클릭");
													const mainCodeId = id
															.split('-')[1];
													console.log(mainCodeId);
													const subCodeSection = document
															.getElementById("subCodeSection-"
																	+ mainCodeId);

													if (subCodeSection.style.display === "none"
															|| subCodeSection.style.display === "") {
														subCodeSection.style.display = "inline";
													} else {
														subCodeSection.style.display = "none";
													}
												}
											}
										})

						$("#deleteButton")
								.click(
										function() {
											// 체크된 항목이 있는지 확인
											const checkedItems = $("input[name='mainCodeIds']:checked");
											console.log("타입"
													+ typeof checkedItems)
											if (checkedItems.length === 0) {
												alert("삭제할 대문항을 선택하세요.");
												return;
											}

											// 확인 메시지 출력
											if (confirm("선택한 대문항을 삭제하시겠습니까?")) {

												const mainCodeIds = [];
												checkedItems.each(function() {
													mainCodeIds.push($(this)
															.val());
												});
												console.log("코드배열:"
														+ mainCodeIds);
												$
														.ajax({
															url : '/main/checkDelMainCode.do',
															type : 'POST',
															contentType : 'application/json',
															data : JSON
																	.stringify({
																		mainCodeIds : mainCodeIds
																	}),
															success : function(
																	response) {
																if (response.success) {
																	console
																			.log("삭제되었습니다");
																	location
																			.reload();
																} else {
																	alert(response.message);
																}
															},
															error : function(
																	xhr,
																	status,
																	error) {
																console
																		.error(
																				"AJAX 요청 실패",
																				status,
																				error);
																console
																		.error(
																				"서버응답: ",
																				xhr.responseText);
																console
																		.log("서버와의 통신에 오류가 발생했습니다");
															}

														})
												// 폼 제출
												/* 		 	$("#deleteForm").submit();  */
												console.log("삭제");
											}

										});

						$("#subDeleteButton")
								.click(
										function() {
											// 체크된 항목이 있는지 확인
											const checkedItems = $("input[name='subCodeIds']:checked");
											console.log("소문항 삭제");
											if (checkedItems.length === 0) {
												alert("삭제할 게시글을 선택하세요.");
												return;
											}

											// 확인 메시지 출력
											if (confirm("선택한 게시글을 삭제하시겠습니까?")) {
												// 폼 제출
												$("#deleteSubForm").submit();
											}

										});

						// 대문항 코드 클릭 이벤트
						$(document)
								.on(
										'click',
										'a[id^="mainCodeName-"]',
										function(e) {
											console.log("test");
											e.preventDefault(); // 기본 동작 방지

											const mainCodeId = $(this).attr(
													'id').split('-')[1];
											console.log(mainCodeId);

											$('.subCodeRow').hide();

											$(
													`.subCodeRow[data-main-code-id="`
															+ mainCodeId + `"]`)
													.show();
										});

					})
	function openPopup(url) {
		window.open(url, 'popup', 'width=800,height=600,scrollbars=yes');
	}
</script>
</head>
<body>

	<div class="container">
		<!-- 탭 메뉴 -->
		<ul class="nav nav-tabs" id="myTab" role="tablist">
			<li class="nav-item">
				<button class="nav-link active" id="cmmnList-tab"
					data-bs-toggle="tab" data-bs-target="#cmmnList" type="button">
					<i class="bi bi-list-ul"></i> 공통코드 목록
				</button>
			</li>
			<li class="nav-item">
				<button class="nav-link" id="cmmnManage-tab" data-bs-toggle="tab"
					data-bs-target="#cmmnManage" type="button">
					<i class="bi bi-tools"></i> 공통코드 관리
				</button>
			</li>
		</ul>

		<div class="tab-content">
			<!-- 공통코드목록 -->
			<!-- 공통코드목록 -->
			<div class="tab-pane fade show active" id="cmmnList" role="tabpanel"
				aria-labelledby="cmmnList-tab">
				<div class="table-container">
					<h3 class="text-center text-primary">공통코드 목록</h3>

					<!-- 코드검색 -->
					<form action="/sns/MainCodesearch.do" method="get"
						class="d-flex align-items-center mb-3">
						<select name="searchType" class="form-select me-2"
							style="width: 150px;">
							<option value="codeId"
								${param.searchType == 'codeId' ? 'selected' : ''}>코드ID</option>
							<option value="codeName"
								${param.searchType == 'codeName' ? 'selected' : ''}>코드명</option>
						</select> <input type="text" name="keyword" class="form-control me-2"
							placeholder="검색어 입력" value="${param.keyword}"
							style="max-width: 300px;">
						<button type="submit" class="btn btn-primary">
							<i class="bi bi-search"></i> 검색
						</button>
					</form>

					<!-- 코드 목록 -->
					<c:choose>
						<c:when test="${not empty mainCodeList}">
							<ul class="list-group mb-3">
								<li class="list-group-item active">코드ID - 코드명</li>
								<c:forEach var="mainCode" items="${mainCodeList}">
									<li class="list-group-item"><a href="#"
										id="mainCodeName-${mainCode.mainCodeId}"
										class="text-decoration-none text-dark"> <span
											class="badge bg-secondary me-2">${mainCode.mainCodeId}</span>
											${mainCode.mainCodeName}
									</a>
										<div class="subCodeSection mt-2"
											id="subCodeSection-${mainCode.mainCodeId}"
											style="display: none;">
											<ul class="list-group">
												<c:forEach var="subCode" items="${subCodeList}">
													<c:if test="${mainCode.mainCodeId eq subCode.mainCodeId}">
														<li class="list-group-item"><span
															class="badge bg-info">${subCode.mainCodeId}-${subCode.subCodeId}</span>
															${subCode.subCodeName}</li>
													</c:if>
												</c:forEach>
											</ul>
										</div></li>
								</c:forEach>
							</ul>
						</c:when>
					</c:choose>

					<!-- 코드 검색결과 -->
					<div id="searchResult">
						<table class="table table-bordered table-striped table-hover">
							<thead class="bg-primary text-white">
								<tr class="text-center">
									<th>코드ID</th>
									<th>코드명</th>
									<th>코드 부가설명</th>
									<th>코드 생성날짜</th>
									<th>코드 생성자</th>
									<th>코드 활성화 여부</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
									<c:when test="${not empty codeDetail}">
										<c:forEach items="${codeDetail}" var="codeDetail">
											<tr class="text-center">
												<td>${codeDetail.mainCodeId}</td>
												<td>${codeDetail.mainCodeName}</td>
												<td>${codeDetail.mainCodeDescription}</td>
												<td>${codeDetail.createAt}</td>
												<td>${codeDetail.createdBy}</td>
												<td><span
													class="badge ${codeDetail.deleteYn == 0 ? 'bg-success' : 'bg-danger'}">
														${codeDetail.deleteYn == 0 ? 'O' : 'X'} </span></td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td colspan="6" class="text-center">검색결과가 없습니다</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
					</div>
				</div>
			</div>



			<!-- 공통코드 관리 -->
			<div class="tab-pane fade show" id="cmmnManage">
				<div class="table-container">
					<h3 class="text-center text-primary">공통코드 관리</h3>

					<div class="table-wrapper">
						<!-- 대분류 코드 테이블 -->
						<div class="table-box">
							<h5 class="table-title">대문항 공통코드</h5>
							<table class="table table-primary table-bordered table-striped">
								<thead>
									<tr>
										<th>선택</th>
										<th>코드ID</th>
										<th>코드명</th>
										<th>부가설명</th>
										<th>생성날짜</th>
										<th>생성자</th>
										<th>활성화</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${mainCodeList}" var="mainCode">
										<tr>
											<td><input type="checkbox" name="mainCodeIds"
												value="${mainCode.mainCodeId}"></td>
											<td>${mainCode.mainCodeId}</td>
											<td>${mainCode.mainCodeName}</td>
											<td>${mainCode.mainCodeDescription}</td>
											<td>${mainCode.createAt}</td>
											<td>${mainCode.createdBy}</td>
											<td>${mainCode.deleteYn == 0 ? 'O' : 'X'}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							<div class="btn-group mb-3">
								<button type="button" class="btn btn-success"
									onclick="openPopup('/main/mainCodeAddPage.do')">
									<i class="bi bi-plus-circle"></i> 추가하기
								</button>
								<button type="button" class="btn btn-danger" id="deleteButton">
									<i class="bi bi-trash"></i> 삭제하기
								</button>
							</div>
						</div>

						<!-- 소분류 코드 테이블 -->
						<div class="table-box">
							<h5 class="table-title">소문항 공통코드</h5>
							<table class="table table-bordered table-striped">
								<thead>
									<tr>
										<th>선택</th>
										<th>코드ID</th>
										<th>코드명</th>
										<th>부가설명</th>
										<th>생성날짜</th>
										<th>생성자</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${subCodeList}" var="subCode">
										<tr>
											<td><input type="checkbox" name="subCodeIds"
												value="${subCode.seqSubCodeId}"></td>
											<td>${subCode.mainCodeId}-${subCode.subCodeId}</td>
											<td>${subCode.subCodeName}</td>
											<td>${subCode.subCodeDescription}</td>
											<td>${subCode.createAt}</td>
											<td>${subCode.createdBy}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							<div class="btn-group mb-3">
								<button type="button" class="btn btn-success"
									onclick="openPopup('/main/subCodeAddPage.do')">
									<i class="bi bi-plus-circle"></i> 추가하기
								</button>
								<button type="button" class="btn btn-danger"
									id="subDeleteButton">
									<i class="bi bi-trash"></i> 삭제하기
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
		function openPopup(url) {
			window.open(url, 'popup', 'width=800,height=600,scrollbars=yes');
		}
	</script>

</body>
</html>
