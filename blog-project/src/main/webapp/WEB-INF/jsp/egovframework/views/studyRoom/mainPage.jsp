<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="egovframework.fusion.user.vo.UserVO"%>
<%@page import="java.time.LocalDate"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>퓨전독서실</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
</head>

<style>
.wrapper {
	width: 90%;
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

input[type="date"] {
	width: 150px;
	height: 40px;
	border-radius: 5px;
	border: 1px solid black;
	text-align: center;
	padding: 6px;
}

.seatBtn {
	width: 80px;
	height: 80px;
	margin: 10px;
	position: relative;
	display: flex;
	align-items: center;
	justify-content: center;
}

.disabledSeat::before, .disabledSeat::after {
	content: "";
	position: absolute;
	width: 100%;
	height: 1px;
	transform-origin: center;
	background-color: black;
}

.disabledSeat::before {
	transform: rotate(45deg);
}

.disabledSeat::after {
	transform: rotate(-45deg);
}

#seatGrid {
	width: 530px;
	/* margin-top:20px; */
	margin: 20px auto;
	border: 1px solid black;
	border-radius: 5px;
}

.roomName {
	margin: 20px auto;
	width: 530px;
	text-align: center;
}

.seat-grid {
	width: 50%;
	margin: 20px auto;
	display: grid;
	grid-template-columns: repeat(5, 50px); /* 5열, 각 칸 50px */
	grid-template-rows: repeat(5, 50px); /* 5행, 각 칸 50px */
	gap: 55px;
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
	flex-direction: row;
	margin-bottom: 100px;
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
	height: 50px;
	display: flex;
	justify-content: center;
	align-items: center;
}

.active {
	background-color: #FFC107;
}

.seatBtn:focus-visible, .seatBtn:focus, .seatBtn:active {
	box-shadow: 0 0 0 4px rgba(220, 53, 69, 0.5);
	z-index: 1;
}

.reserv-select {
	display: flex;
	flex-direction: column;
}

.firstLine, .secondLine {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	align-items: center;
	height: 80px;
	border-bottom: 2px solid black;
}

.firstLine {
	border-bottom: 1px solid gray;
}

.selectTime {
	display: flex;
	flex-direction: row;
}

.li-element {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	margin-bottom: 10px;
	line-height: 40px;
}
.carousel-control-prev-icon{
	background-image:url("data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='darkgray'><path d='M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z'/></svg>");
	
}

.carousel-control-next-icon{
	background-image:url("data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='darkgray'><path d='M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708z'/></svg>");
}

.carousel-item{
background-color:white;
padding:30px;
border-radius:10px;

}

.text-center{
	width:80%;
	margin-left:110px;
}


</style>
<script>
	$(document).ready(
			function() {

				document.getElementById("datePicker").addEventListener(
						"change", function() {
							var selectedDate = this.value;
							console.log("선택한 날짜:" + selectedDate);
							$('#showChkDate').text(selectedDate);
						})
			
				$(document).on('click','.cancelReserv',function(e){
					e.preventDefault();
					console.log("클릭클릭");
					const reservId=$(this).val();
					console.log("아이디"+reservId);
					if(confirm("해당예약을 취소하시겠습니까? 취소하신 예약은 복구할 수 없습니다")){
						$.ajax({
							url:'/studyRoom/cancelReserv.do',
							type:'POST',
							data:{reservId:reservId},
							success:function(){
								alert("예약이 취소되었습니다");
								myReserv();
							},error:function(err){
								alert("오류발생"+err);
							}
						})
					}else{
						return false;
					}
				})

				
				$(document).on('click','.chkSeat',function(e){
					e.preventDefault();
					const roomId=document.getElementById('selectRoom').value;
					const roomName= $('#selectRoom option:checked').text();
					const seatSection=$('#seat-container');
					const selectDay=document.getElementById('datePicker').value;
					console.log("ddddddddd"+selectDay);
					if(selectDay===""){
						alert("날짜를 선택해주세요");
						return;
					}
					if(roomId==="select"){
						alert("열람실을 선택해주세요");
						return;
					}
					
			 		$.ajax({
						url:'/studyRoom/chkSeat.do',
						type:'POST',
						data:{roomId:roomId,selectDate:selectDay},
						success: function (response) {
	        	            const seatContainer=$('#seat-container');
	        	            seatContainer.html(response);
	        	            const roomHtml=`<h4 class="roomName"><`+roomName+`></h4>`;
	        	            seatSection.prepend(roomHtml);
	        	            console.log("가져오기 성공");
	        	        },
	        	        error: function (err) {
	        	            alert ('오류 발생:', err);
	        	        }
						
					})
				})
				
 				$(document).on('click','.seatBtn',function(){
					const seatId=this.value;
					const seatIndex=$(this).data("seat-id");
					$('#selectSeat').text(seatIndex+"번");
					$('#selectedSeatId').val(seatId);
					const reservTableContainer=$('#reserv-container-table')
					const selectDay=document.getElementById('datePicker').value;
					console.log("선택한 좌석:"+seatId+", 선택한 날짜:"+selectDay);
					$('#selectedSeat').show();
					$('#roomInfo').show();
					$('#reserv-select').show();
					clickSeat(seatId,selectDay);
				})
				 
				$(document).on('click','.reservApply',function(e){
					 e.preventDefault();
			    	  e.stopPropagation();
					const seatId=$('#selectedSeatId').val();
					const selectReason=document.getElementById('selectReason').value;
					const startTime=document.getElementById('startTime').value;
					const endTime=document.getElementById('endTime').value;
					const selectDay=document.getElementById('datePicker').value;
					const message=seatId+`번 좌석을 `+selectDay+` `+startTime+`~`+endTime+`으로 예약하시겠습니까?`;
					const userId=document.getElementById('userId').value;
					console.log("선택한 좌석:"+seatId+", 시작시간:"+startTime+", 종료시간:"+endTime+",선택한 날짜:"+selectDay);
					if(userId===""){
						alert("로그인 후 이용해주세요");
						return;
					}
					if(selectReason==="selectReason"){
						alert("사용목적을 선택해주세요");
						return;
					}
					if(startTime==="selectStart"){
						alert("시작시각을 선택해주세요");
						return;
					}
					if(startTime==="selectEnd"){
						alert("종료시각을 선택해주세요");
						return;
					}
					if(confirm(message)){
	  					$.ajax({
							url:'/studyRoom/insApply.do',
							type:'POST',
							data:{selectReason:selectReason,startTime:startTime,endTime:endTime,seatId:seatId,selectDay:selectDay},
							success: function (response) { 	        	           
		        	            console.log("가져오기 성공");
								alert(response.message);
								/* window.location.reload(); */
								clickSeat(seatId,selectDay);
		        	        },
		        	        error: function (response) {
		        	            alert (response.message);
		        	        }
						})  
						
					}else{
						return false;
					}
				})
				
				
				$(document).on('change','.selectStart',function(e){
					e.preventDefault();
					console.log("클릭");
					console.log($(this).val());
					getEnd($(this).val());
				})
				
				
		 		$(document).on('change','#datePicker',function(){
					const selectDay=document.getElementById('datePicker').value;
					const selectContainer=$('#selectRoom');
				    let isDisabledDay = false;
					selectContainer.html("");
					var html="";
			        let disabledDates = [];

			        <c:forEach items="${studyRoomInfo}" var="info">
			            disabledDates.push("${info.updateInfo}");
			        </c:forEach>

			        console.log("선택한 날짜:", selectDay);
			        console.log("휴무일 리스트:", disabledDates);

			        if (disabledDates.includes(selectDay)) {
			            alert("이용 불가능한 날입니다.");
			            $('#chkRoom').hide();
			        } else {
			            $('#chkRoom').show(); 
			        }
			        
			        
			        $.ajax({
			        	url:'/studyRoom/offRoom.do',
			        	type:'POST',
			        	data:{selectDay:selectDay},
			        	success:function(response){
			        		response.offRoomList.forEach(index=>{
			        			html+=`<option value="`+index.roomId+`">`+index.roomName+`</option>`;
			        		})
			        		selectContainer.append(html);
			        	},
			        	error:function(err){
			        		console.log(err);
			        	}
			        })
			        
			        
			    });

				
			})
			
		
			
		function getEnd(selectStart){
			console.log("getEnd"+selectStart);
			const totalList=document.getElementById('totalList').value;
			var total=JSON.parse(totalList);
			var availableTimes=[];
			var collecting=false;

			for (let index of total){
				var time=index.time.split(" ");
				var plusTime=index.time.split("~");
				var startTime=time[0];
		
				if(collecting){
					console.log("상태:"+index.status);
					if(index.status==="예약불가"){
						break;
					}
					var split=index.time.split("~");
						availableTimes.push(split[1]);
						console.log("~다음:"+split[1]);
					}
				
			    if (startTime === selectStart) {
			    	console.log("true");
			    	availableTimes.push(plusTime[1]);
			    	collecting = true;
		        	}
			    
			}
			    console.log("선택가능한 "+availableTimes);

			    
			    var selectEndSection=$('#endTime');
			    selectEndSection.html("");
			    var html=`<option value="selectStart" selected>시작시간</option>`;
			    
			    availableTimes.forEach(index=>{
			    	
			    	html+=`<option value="`+index+`">`+index+`</option>`;
			    	
			    })
			    
			    selectEndSection.append(html);
		}

		function myReserv() {
		    console.log("모달 온~");

		    const userId = document.getElementById('userId').value;
		    console.log(userId);
		    if (userId == "") {
		        alert("로그인이 필요합니다");
		        window.location.replace('/user/loginPage.do');
		    }

		    $.ajax({
		        url: '/studyRoom/getReservList.do',
		        type: 'POST',
		        success: function (response) {
		            const reservList = response.list;
		            const modalBody = $('#myReservTableBody');
		            modalBody.empty();

		            reservList.forEach(index => {
		                console.log("111" + index);
		                modalBody.append(`
		                    <tr>
		                        <td>`+index.reservDate+`</td>
		                        <td>`+index.roomName+`</td>
		                        <td>`+index.seatLocation+`번</td>
		                        <td>`+index.startTime+` ~ `+index.endTime+`</td>
		                        <td>
		                            <button type="button" class="btn btn-outline-danger cancelReserv" value="`+index.reservId+`">
		                                예약취소
		                            </button>
		                        </td>
		                    </tr>
		                `);
		            });
		        },
		        error: function (err) {
		            console.log(err);
		        }
		    });

		    $('#reservModal').modal("show");
		}
		
		function clickSeat(seatId,selectedDay){
				console.log(seatId);
				console.log(selectedDay)
				/* const seatId=this.value; */
				$('#selectSeat').text(seatId+"번");
				$('#selectedSeatId').val(seatId);
				const reservTableContainer=$('#reserv-container-table')
				const selectDay=document.getElementById('datePicker').value;
				console.log("선택한 좌석:"+seatId+", 선택한 날짜:"+selectDay);
				$('#selectedSeat').show();
				$('#roomInfo').show();
				$('#reserv-select').show();
					$.ajax({
					url:'/studyRoom/getSeatInfo.do',
					type:'POST',
					data:{seatId:seatId,selectDay:selectDay},
					success: function (response) { 	        	           
        	            console.log("가져오기 성공");
        	            reservTableContainer.html(response);
        	        },
        	        error: function (err) {
        	            alert ('오류 발생:', err);
        	        }
				}) 

		}
        $(document).ready(function () {
      	  $(".modal-dialog").draggable({
      	    handle: ".modal-header"
      	  });
      	});
        function openPopup(url) {
    		window.open(url, 'popup', 'width=1000,height=1000,scrollbars=yes');
    	}
</script>
<body>
	<%
	String today = LocalDate.now().toString();
	String month = LocalDate.now().plusMonths(1).toString();
	UserVO userId = (UserVO) session.getAttribute("loggedInUser");
	String accessRight = (String) session.getAttribute("accessRight");
	%>


	<div class="wrapper">
		<div class="tiles-header">
			<div class="header-logo">
				<h1>${siteName.studyRoomName}</h1>
			</div>
			<div class="header-nav">
				<button type="button" class="btn btn-outline-primary myReserv" onclick="myReserv()">나의예약현황</button>
				<c:if test="${accessRight eq 'superAdmin' }">
					<button type="button" class="btn btn btn-outline-dark" onclick="openPopup('/studyRoom/managementPage.do')">관리자 페이지</button>
				</c:if>
			</div>
		</div>
		<div id="announcement" style="border: 4px solid #F2CE29; margin-top: 30px; padding-top: 30px; padding-bottom:20px;  text-align: center;">
			<h2>
				<strong>공지사항</strong>
			</h2>
			<div id="carouselExampleControls" class="carousel slide" data-bs-ride="carousel" data-bs-interval="7000">
				<div class="carousel-inner">
					<div class="carousel-item active">
						<h4>저희 ${siteName.studyRoomName}의 운영에 변경이 있습니다.이용에 불편을 드려 죄송합니다</h4>
						<table class="table table-bordered text-center">
							<thead class="table-primary">
								<tr>
									<th>휴무일</th>
									<th>사유</th>
								</tr>
							</thead>
							<c:forEach items="${studyRoomInfo }" var="info">
								<tbody>
									<td>${info.updateInfo }</td>
									<td>${info.updateReason }</td>
								</tbody>
							</c:forEach>
						</table>

					</div>
					<div class="carousel-item">
						<h4>열람실 운영에 변경이 있습니다.이용에 불편을 드려 죄송합니다</h4>
						<table class="table table-bordered text-center">
							<thead class="table-primary">
								<tr>
									<th>사용불가기간</th>
									<th>열람실명</th>
									<th>사유</th>
								</tr>
							</thead>
							<c:forEach items="${roomInfo }" var="info">
								<tbody>
									<td>${info.updateInfo}</td>
									<td>${info.roomName }</td>
									<td>${info.disabledReason }</td>
								</tbody>
							</c:forEach>
						</table>
					</div>
				</div>
				<button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="prev">
					<span class="carousel-control-prev-icon" aria-hidden="true"></span> 
					<span class="visually-hidden">Previous</span>
				</button>
				<button class="carousel-control-next" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="next">
					<span class="carousel-control-next-icon" aria-hidden="true"></span> 
					<span class="visually-hidden">Next</span>
				</button>
			</div>
			<br>
		</div>
		<div class="main">
			<div class="main-header">
				<div class="chkDate">
					<input type="date" id="datePicker" min="<%=today%>" max="<%=month%>"> <input type="hidden" value="${userId}" id="userId">
				</div>
				<div class="chkRoom" style="display: none;" id="chkRoom">
					<select class="form-select" aria-label="Default select example" id="selectRoom">
						<option value="select" selected>열람실을 선택해주세요</option>

					</select>
					<button class="btn btn-outline-primary chkSeat" style="width: 250px;">좌석 조회</button>
				</div>
			</div>

			<div id="seat-container"></div>

		</div>



	</div>

	<!-- 예약 내역 모달 -->
	<div class="modal fade" id="reservModal" tabindex="-1" aria-labelledby="reservModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="reservModalLabel">내 예약 내역</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div class="table-responsive">
						<table class="table table-bordered text-center">
							<thead class="table-primary">
								<tr>
									<th>예약일</th>
									<th>열람실 번호</th>
									<th>좌석 번호</th>
									<th>예약 시간</th>
									<th>취소</th>
								</tr>
							</thead>
							<tbody id="myReservTableBody">
								<!-- 예약 내역이 동적으로 추가됨 -->
							</tbody>
						</table>
					</div>
				</div>

			</div>
		</div>
	</div>


</body>
</html>