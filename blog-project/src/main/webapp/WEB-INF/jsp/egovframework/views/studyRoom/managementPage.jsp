<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="egovframework.fusion.user.vo.UserVO"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<script
	src="https://cdn.ckeditor.com/ckeditor5/29.1.0/classic/ckeditor.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css"
	rel="stylesheet" crossorigin="anonymous">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3"
	crossorigin="anonymous"></script>
<link rel="stylesheet"
	href="https://cdn.ckeditor.com/ckeditor5/44.1.0/ckeditor5.css" />
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
<link rel="stylesheet"
	href="https://cdn.ckeditor.com/ckeditor5-premium-features/44.2.0/ckeditor5-premium-features.css" />
<style>
.wrapper {
	width: 70%;
	height: 100vh;
	margin: 20px auto;
}

.tiles-header {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	align-items: center;
}

.main-header {
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	margin-top: 70px;
	margin-right: 120px;
	gap: 50px;
}

.header-nav {
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.chkDate {
	/* 	display:flex;
	flex-direction:row; */
	
}

.chkRoom {
	height: 40px;
	display: flex;
	flex-direction: row;
	gap: 8px;
}

.seatBtn {
	width: 80px;
	height: 80px;
	margin: 10px;
	position: relative;
	/* 	display: flex;
	align-items: center;
	justify-content: center; */ user-drag; auto;
	cursor: move;
}

/* #seatGrid {
	width: 530px;
	margin-top:20px;
	margin:20px auto;
	border:1px solid black;
	border-radius:5px;
}*/

.seat-grid {
	display: grid;
	grid-template-columns: repeat(5, 1fr);
	gap: 10px;
	width: 300px;
	margin: auto;
}

.roomName {
	margin: 20px auto;
	width: 530px;
	text-align: center;
}

.seat-grid {
	margin: 20px auto;
	display: grid;
	grid-template-columns: repeat(5, 80px);
	grid-template-rows: repeat(5, 80px);
	gap: 20px;
}

.seat-cell {
	width: 25%;
	height: 80px;
	display: flex;
	align-items: center;
	justify-content: center;
}

.seat-container {
	width: 100%;
	margin-top: 40px;
}

.seat-container-element {
	display: flex;
	flex-direction: column;
	margin-bottom: 100px;
	background-color: white;
}

.row {
	margin: 0px !important;
}

.reserv-container {
	width: 50%;
}

.mb-2 {
	margin: 0px !important;
}

.border {
	height: 100%;
	display: flex;
	justify-content: center;
	align-items: center;
	display: flex;
}

.seatBtn:focus-visible, .seatBtn:focus, .seatBtn:active {
	box-shadow: 0 0 0 4px rgba(220, 53, 69, 0.5);
	z-index: 1;
}

.draggable.dragging {
	opacity: 0.5;
}

.seatTwoBtn {
	display: flex;
	flex-direction: row;
	justify-content: center;
	gap: 8px;
}

#addSeatInfo {
	display: flex;
	flex-direction: column;
}
</style>

<script>
	let key = "${param.key}";
	console.log(key);
	if (key === "seatinfo") {

		$("#studyRoomInfo-tab").removeClass("active");
		$("#roomInfo-tab").removeClass("active");
		$("#seatinfo-tab").addClass("active");

		$("#studyRoomInfo").removeClass("show active");
		$("#roomInfo").removeClass("show active");
		$("#seatinfo").addClass("show active");

	} else if (key === "studyRoomInfo") {

		$("#roomInfo-tab").removeClass("active");
		$("#seatinfo-tab").removeClass("active");
		$("#studyRoomInfo-tab").addClass("active");

		$("#seatinfo").removeClass("show active");
		$("#roomInfo").removeClass("show active");
		$("#studyRoomInfo").addClass("show active");

	} else if (key === "roomInfo") {

		$("#seatinfo-tab").removeClass("active");
		$("#studyRoomInfo-tab").removeClass("active");
		$("#roomInfo-tab").addClass("active");

		$("#studyRoomInfo").removeClass("show active");
		$("#seatinfo").removeClass("show active");
		$("#roomInfo").addClass("show active");

	}
</script>
</head>
<body>
	<%
	String today = LocalDate.now().toString();
	String month = LocalDate.now().plusMonths(1).toString();
	%>
	<!-- 탭 메뉴 -->
	<ul class="nav nav-tabs" id="myTab" role="tablist">
		<li class="nav-item" role="presentation">
			<button class="nav-link active" id="seatinfo-tab"
				data-bs-toggle="tab" data-bs-target="#seatinfo" type="button"
				role="tab" aria-controls="seatinfo" aria-selected="true">좌석관리</button>
		</li>
		<li class="nav-item" role="presentation">
			<button class="nav-link" id="studyRoomInfo-tab" data-bs-toggle="tab"
				data-bs-target="#studyRoomInfo" type="button" role="tab"
				aria-controls="studyRoomInfo" aria-selected="false">독서실
				운영관리</button>
		</li>
		<li class="nav-item" role="presentation">
			<button class="nav-link" id="roomInfo-tab" data-bs-toggle="tab"
				data-bs-target="#roomInfo" type="button" role="tab"
				aria-controls="roomInfo" aria-selected="false">열람실 운영관리</button>
		</li>
	</ul>

	<!-- 내용 -->
	<div class="tab-content" id="myTabContent">

		<!-- 좌석 정보 -->
		<div class="tab-pane fade show active p-3" id="seatinfo"
			role="tabpanel" aria-labelledby="seatinfo">
			<div class="card shadow p-4">
				<h5 class="fw-bold mb-3">좌석 정보</h5>

				<!-- 열람실 선택 -->
				<div class="mb-3">
					<label for="selectRoom" class="form-label fw-bold">열람실 선택</label> <select
						class="form-select" id="selectRoom" name="selectRoom">
						<option value="select" selected>열람실을 선택해주세요</option>
						<c:forEach items="${roomList}" var="room">
							<option value="${room.roomId}">${room.roomName}</option>
						</c:forEach>
					</select>
				</div>

				<!-- 좌석 컨테이너 -->
				<div class="seat-container-element border rounded p-3">
					<div class="seat-grid" id="seatContainer"></div>
					<div class="seatTwoBtn d-flex gap-2 mt-3" id="seatTwoBtn"
						style="display: none;">
						<button id="saveSeats" class="btn btn-primary">위치 저장</button>
						<button id="addSeat" class="btn btn-outline-primary addSeat">좌석
							추가</button>
					</div>

					<!-- 좌석 추가 입력 -->
					<div id="addSeatInfo" class="mt-3 p-3 bg-light rounded"
						style="display: none;">
						<p class="fw-bold">
							추가할 열람실: <span id="addRoomName" class="text-primary"></span>
						</p>
						<label for="seatLocation" class="form-label">위치 입력</label> <input
							type="text" id="seatLocation" class="form-control mb-2" />
						<button type="button" class="btn btn-outline-info insApply">등록하기</button>
					</div>
				</div>
			</div>
		</div>

		<!-- 스터디룸 예약 -->
		<div class="tab-pane fade p-3" id="studyRoomInfo" role="tabpanel"
			aria-labelledby="studyRoomInfo-tab">
			<div class="card shadow p-4">
				<h5 class="fw-bold mb-3">독서실 운영 관리</h5>

				<div class="mb-3">
					<label for="datePicker" class="form-label fw-bold">변경 날짜</label> <input
						type="date" id="datePicker1" class="form-control" min="<%=today%>"
						max="<%=month%>"> <input type="hidden" value="${userId}"
						id="userId">
				</div>

				<div class="form-check mb-3">
					<input class="form-check-input" type="checkbox" id="allDayCheck"
						value="1"> <label class="form-check-label"
						for="allDayCheck">하루 종일</label>
				</div>

				<div class="mb-3">
					<label class="form-label fw-bold">이용 시간</label>
					<div class="d-flex align-items-center">
						<select class="form-select me-2" id="openTime">
							<option selected>오픈시간</option>
							<option>08:00</option>
							<option>09:00</option>
							<option>10:00</option>
							<option>11:00</option>
							<option>12:00</option>
							<option>13:00</option>
							<option>14:00</option>
							<option>15:00</option>
						</select> <span class="fw-bold"> ~ </span> <select class="form-select ms-2"
							id="closeTime">
							<option selected>마감시간</option>
							<option>12:00</option>
							<option>13:00</option>
							<option>14:00</option>
							<option>15:00</option>
							<option>18:00</option>
							<option>19:00</option>
							<option>20:00</option>
							<option>21:00</option>
							<option>22:00</option>
							<option>23:00</option>
						</select>
					</div>
				</div>

				<div class="mb-3">
					<label for="updateReason" class="form-label fw-bold">사유</label> <input
						type="text" class="form-control" id="updateReason"
						placeholder="사유를 입력하세요">
				</div>

				<div class="text-end">
					<button class="btn btn-primary updStudyRoom">등록하기</button>
				</div>
			</div>
		</div>

		<!-- 열람실 정보 -->
		<div class="tab-pane fade p-3" id="roomInfo" role="tabpanel"
			aria-labelledby="roomInfo-tab">
			<div class="card shadow p-4">
				<h5 class="fw-bold mb-3">열람실 운영관리</h5>

				<div class="mb-3">
					<label for="datePicker" class="form-label fw-bold">변경 날짜</label> <input
						type="date" id="datePicker2" class="form-control" min="<%=today%>"
						max="<%=month%>"> <input type="hidden" value="${userId}"
						id="userId">
				</div>

				<div class="form-check mb-3">
					<input class="form-check-input" type="checkbox"
						id="allDayCheckRoom"> <label class="form-check-label"
						for="allDayCheck">하루 종일</label>
				</div>

				<div class="mb-3">
					<label for="selectRoom" class="form-label fw-bold">열람실 선택</label> <select
						class="form-select" id="selectRoom">
						<option value="select" selected>열람실을 선택해주세요</option>
						<c:forEach items="${roomList}" var="room">
							<option value="${room.roomId}">${room.roomName}</option>
						</c:forEach>
					</select>
				</div>

				<div class="mb-3">
					<label class="form-label fw-bold">이용 시간</label>
					<div class="d-flex align-items-center">
						<select class="form-select me-2" id="openTimeRoom">
							<option selected>오픈시간</option>
							<option>08:00</option>
							<option>09:00</option>
							<option>10:00</option>
							<option>11:00</option>
							<option>12:00</option>
							<option>13:00</option>
							<option>14:00</option>
							<option>15:00</option>
						</select> <span class="fw-bold">~</span> <select class="form-select ms-2"
							id="closeTimeRoom">
							<option selected>마감시간</option>
							<option>18:00</option>
							<option>19:00</option>
							<option>20:00</option>
							<option>21:00</option>
							<option>22:00</option>
							<option>23:00</option>
						</select>
					</div>
				</div>
			</div>
		</div>

	</div>

</body>
<script>
	$(document).ready(
			function() {
				$(document).on('change', '#selectRoom', function() {
					const roomId = $(this).val();
					const seatContainer = $('#seatContainer');
					$('#seatTwoBtn').show();
					resetSeat(roomId);
				})

				$(document).on('click', '.addSeat', function() {
					const roomId = $('#selectRoom option:selected').val();
					const roomName = $('#selectRoom option:selected').text();
					console.log("ssssss" + roomId);
					console.log("name" + roomName);
					console.log("Sdfsfs");
					$('#addRoomName').text(roomName);
					$('#addSeatInfo').show();
				})

				$(document).on('click', '.insApply', function(e) {

					e.preventDefault();
					const roomId = $('#selectRoom option:selected').val();
					const roomLocation = $('#seatLocation').val();
					if (confirm("좌석을 등록하시겠습니까?")) {
						$.ajax({
							url : '/studyRoom/addSeat.do',
							type : 'POST',
							data : {
								roomId : roomId,
								roomLocation : roomLocation
							},
							success : function() {
								console.log("등록완료");
								alert("등록되었습니다");
								resetSeat(roomId);
							},
							error : function() {
								console.log("오류발생")
							}
						})
					}
				})

				function resetSeat(roomId) {
					const seatContainer = $('#seatContainer');
					$.ajax({
						url : '/studyRoom/getSeat.do',
						type : 'POST',
						data : {
							roomId : roomId
						},
						success : function(response) {
							seatContainer.html(response);
							$('#addRoomName').text("");
						},
						error : function(err) {
							console.log(err);
						}
					})
				}

				var draggedSeat = null;
				var drggedSeatId = null;
				var draggedFromLocation = null;

				document.addEventListener("dragstart", function(e) {
					if (e.target.classList.contains("seatBtn")) {
						draggedSeat = e.target;
						draggedSeatId = e.target.getAttribute("data-seat-id");
						draggedFromLocation = e.target
								.getAttribute("data-seat-location");

						console.log("드래그 시작: 좌석아이디:" + draggedSeatId
								+ ",좌석 위치:" + draggedFromLocation);
						e.dataTransfer.setData("text/plain", draggedSeatId);
					}
				});
				document.addEventListener("dragover", function(e) {
					e.preventDefault();

					if (e.target.classList.contains("seat-cell")) {
						const newLocation = e.target
								.getAttribute("data-seat-location");

						console.log("드롭!!!!!! 좌석아이디:" + draggedSeatId + "기존위치"
								+ draggedFromLocation + ", 새로운 위치:"
								+ newLocation);

						e.target.appendChild(draggedSeat);

					}
				});

				function toggleTimeSelect(allDayCheckbox, openTimeSelect,
						closeTimeSelect) {
					$(allDayCheckbox).on("change", function() {
						const isChecked = $(this).is(":checked");
						$(openTimeSelect).prop('disabled', isChecked);
						$(closeTimeSelect).prop('disabled', isChecked);
					});
				}

				toggleTimeSelect('#allDayCheck', '#openTime', '#closeTime');

				toggleTimeSelect('#allDayCheckRoom', '#openTimeRoom',
						'#closeTimeRoom');

				$(document).on(
						'click',
						'.updStudyRoom',
						function(e) {
							e.preventDefault();
							console.log("독서실 운영");
							var selectDay = $('#datePicker1').val();
							var selectStart = $('#openTime').val();
							var selectEnd = $('#closeTime').val();
							var all = $('#allDayCheck').val();
							const reason = $('#updateReason').val();
							console.log(selectDay);
							console.log(selectStart);
							console.log(selectEnd);
							console.log(all);
							console.log(reason);

							//유효성체크
							if (selectDay === "") {
								alert("변경하실 날짜를 선택해주십시오");
							}

							if (!$('#allDayCheck').is(':checked')) {
								if (selectStart === "오픈시간") {
									alert("오픈시간을 선택해주세요");
								}
								if (selectEnd === "마감시간") {
									alert("마감시간을 선택해주세요");
								}
							}

							//하루종일일때와 범위정할때
							if ($('#allDayCheck').is(':checked')) {
								selectStart = selectDay + ' 00:00:00';
								selectEnd = selectDay + ' 00:00:00';
								console.log("start:" + selectStart + "   end:"
										+ selectEnd);
							} else {
								selectStart = selectDay + " " + selectStart;
								selectEnd = selectDay + " " + selectEnd;

							}

							if (confirm(selectStart + " ~ " + selectEnd
									+ " 해당 날짜의 운영시간을 변경하시겠습니까?")) {
								$.ajax({
									url : '/studyRoom/updStudyRoom.do',
									type : 'POST',
									data : {
										selectStart : selectStart,
										selectEnd : selectEnd,
										selectDay : selectDay,
										reason : reason
									},
									success : function(response) {
										alert(response.message);
									},
									error : function(response) {
										alert(response.message);
									}
								})
							} else {
								return false;
							}

						})

			})
</script>
</html>