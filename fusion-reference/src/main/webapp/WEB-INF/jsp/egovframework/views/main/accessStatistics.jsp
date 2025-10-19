<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Menu Access Statistics</title>
<style>
body {
	display: flex;
	flex-direction: column;
}

.firstLine {
	display: flex;
	flex-direction: row;
	gap: 80px;
}

.secondLine {
	display: flex;
	flex-dirction: row;
	gap: 80px;
}
</style>

</head>
<body>
	<div class="container mt-4">
		<h1 class="text-center mb-4">📊 통계 페이지</h1>

		<!-- 분류 선택 -->
		<div class="row mb-3">
			<div class="col-md-4">
				<label for="selectType" class="form-label fw-bold">📅 분류 선택</label>
				<select id="selectType" class="form-select">
					<option disabled selected>분류선택</option>
					<option value="year">년도별</option>
					<option value="month">월별</option>
					<option value="day">일별</option>
					<option value="time">시간별</option>
				</select>
			</div>

			<div class="col-md-4 d-none" id="checkDuplicate">
				<label class="form-label fw-bold">🛠 옵션</label>
				<div class="form-check">
					<input type="checkbox" class="form-check-input"
						id="removeDuplicate"> <label class="form-check-label"
						for="removeDuplicate">중복값 제거</label>
				</div>
			</div>
		</div>

		<!-- 날짜 선택 -->
		<div class="row mb-3">
			<div class="col-md-3 d-none" id="yearSelectWrapper">
				<label for="selectYear" class="form-label fw-bold">📅 연도 선택</label>
				<select id="selectYear" class="form-select">
					<option disabled selected>년도 선택</option>
					<option value="2023">2023</option>
					<option value="2024">2024</option>
					<option value="2025">2025</option>
				</select>
			</div>

			<div class="col-md-3 d-none" id="monthSelectWrapper">
				<label for="selectMonth" class="form-label fw-bold">📆 월 선택</label>
				<select id="selectMonth" class="form-select">
					<option disabled selected>월 선택</option>
					<%
					for (int i = 1; i <= 12; i++) {
					%>
					<option value="<%=i%>"><%=i%>월
					</option>
					<%
					}
					%>
				</select>
			</div>

			<div class="col-md-3 d-none" id="daySelectWrapper">
				<label for="selectDay" class="form-label fw-bold">📅 일 선택</label> <select
					id="selectDay" class="form-select">
					<option disabled selected>일 선택</option>
					<%
					for (int i = 1; i <= 31; i++) {
					%>
					<option value="<%=i%>"><%=i%>일
					</option>
					<%
					}
					%>
				</select>
			</div>
		</div>

		<!-- 버튼 -->
		<div class="row mb-3">
			<div class="col-md-6">
				<button id="getDataButton" class="btn btn-primary w-100 d-none">📊
					조회</button>
			</div>
			<div class="col-md-6">
				<button id="monthAccssButton" class="btn btn-secondary w-100 d-none">📅
					최근 3년 조회</button>
			</div>
		</div>

		<!-- 테이블 -->
		<div class="table-container">
			<table class="table table-bordered table-hover" id="monthTable">
				<thead class="table-dark" id="dataHead"></thead>
				<tbody id="dataBody"></tbody>
			</table>

			<table class="table table-bordered table-hover" id="dailyTable">
				<thead class="table-dark" id="dataHeadDaily"></thead>
				<tbody id="dataBodyDaily"></tbody>
			</table>

			<table class="table table-bordered table-hover" id="timeTable">
				<thead class="table-dark" id="dataHeadTime"></thead>
				<tbody id="dataBodyTime"></tbody>
			</table>

			<table class="table table-bordered table-hover" id="pivotTable">
				<thead class="table-dark" id="pivotDataHead"></thead>
				<tbody id="pivotDataBody"></tbody>
			</table>
		</div>
	</div>
	<button id="getDataButton" style="display: none">조회</button>
	<button id="monthAccssButton" style="display: none">최근 3년 조회</button>
	<script src="https://code.jquery.com/jquery-3.6.1.js"
		integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3"
		crossorigin="anonymous"></script>
	<link rel="stylesheet"
		href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
	<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>

	<script type="text/javascript">
	const selectType = document.getElementById("selectType");

	// 선택 옵션 요소들
	const yearSelectWrapper = document.getElementById("yearSelectWrapper");
	const monthSelectWrapper = document.getElementById("monthSelectWrapper");
	const daySelectWrapper = document.getElementById("daySelectWrapper");
	const checkDuplicate = document.getElementById("checkDuplicate");

	// 버튼 요소들
	const getDataButton = document.getElementById("getDataButton");
	const monthAccssButton = document.getElementById("monthAccssButton");

	// 테이블 요소들
	const monthTable = document.getElementById("monthTable");
	const dailyTable = document.getElementById("dailyTable");
	const timeTable = document.getElementById("timeTable");
	const pivotTable = document.getElementById("pivotTable");

	// 이벤트 리스너 추가
	selectType.addEventListener("change", function() {
	    // 모든 요소 초기 숨김 처리
	    yearSelectWrapper.classList.add("d-none");
	    monthSelectWrapper.classList.add("d-none");
	    daySelectWrapper.classList.add("d-none");
	    checkDuplicate.classList.add("d-none");
	    getDataButton.classList.add("d-none");
	    monthAccssButton.classList.add("d-none");
	    monthTable.classList.add("d-none");
	    dailyTable.classList.add("d-none");
	    timeTable.classList.add("d-none");
	    pivotTable.classList.add("d-none");

	    // 선택한 옵션에 따라 표시할 요소들 설정
	    if (this.value === "year") {
	        monthAccssButton.classList.remove("d-none"); // 최근 3년 조회 버튼 표시
	        pivotTable.classList.remove("d-none");

	    } else if (this.value === "month") {
	        yearSelectWrapper.classList.remove("d-none");
	        getDataButton.classList.remove("d-none"); // 조회 버튼 표시
	        monthTable.classList.remove("d-none");

	    } else if (this.value === "day") {
	        yearSelectWrapper.classList.remove("d-none");
	        monthSelectWrapper.classList.remove("d-none");
	        getDataButton.classList.remove("d-none");
	        dailyTable.classList.remove("d-none");

	    } else if (this.value === "time") {
	        yearSelectWrapper.classList.remove("d-none");
	        monthSelectWrapper.classList.remove("d-none");
	        daySelectWrapper.classList.remove("d-none");
	        checkDuplicate.classList.remove("d-none"); // 중복 제거 체크박스 표시
	        getDataButton.classList.remove("d-none");
	        timeTable.classList.remove("d-none");
	    }
	});


		$('#getDataButton').click(function() {
			const year = $("#selectYear option:selected").val();
			const month= $("#selectMonth option:selected").val();
			const day= $("#selectDay option:selected").val();
			const selectType=document.getElementById("selectType").value;
			
			console.log(selectType);
			console.log(month,year);
		if(selectType==="month"){
				$.ajax({
				url : '/main/monthlyYearData.do',
				method : 'GET',
				dataType:'json',
				data:{
					year:year
				},
				success : function(response) {
					console.log(response);
			
					if (response.success) {
					 const tbody = $('#dataBody');
					 const thead = $('#dataHead');
	                    tbody.empty(); // 기존 데이터 제거
	                    thead.empty();
	                    response.data.forEach(data => {
	                    	console.log(data);
	                        const row = `<tr>
	                        				<td>`+data.menuName+`</td>
	                                    	<td>`+data.January+`</td>
	                        				<td>`+data.February+`</td>
	                        				<td>`+data.March+`</td>
	                        				<td>`+data.April+`</td>
	                        				<td>`+data.May+`</td>
	                        				<td>`+data.June+`</td>
	                        				<td>`+data.July+`</td>
	                        				<td>`+data.August+`</td>
	                        				<td>`+data.September+`</td>
	                        				<td>`+data.October+`</td>
	                        				<td>`+data.November+`</td>
	                        				<td>`+data.December+`</td>
	                                     </tr>`;
	                        tbody.append(row);  
	                    });
	                    const menuName="메뉴명";
	                    	 const column=`<tr>
	                    	 <td>`+menuName+`</td>
                				<td>1월</td>
                				<td>2월</td>
                				<td>3월</td>
                				<td>4월</td>
                				<td>5월</td>
                				<td>6월</td>
                				<td>7월</td>
                				<td>8월</td>
                				<td>9월</td>
                				<td>10월</td>
                				<td>11월</td>
                				<td>12월</td>
                                </tr>`;
                            thead.append(column);
						alert("조회되었습니다");
					} else {
						alert("조회에 실패했습니다.");
					}
				},
				error : function(e) {
					alert("서버 오류가 발생했습니다.");
					console.log(e);
				}
			});
			
		}else if(selectType==="day"){
			$.ajax({
				url : '/main/DailyData.do',
				method : 'GET',
				dataType:'json',
				data:{
					year:year,
					month:month
				},
				success : function(response) {
					console.log(response);
			
					if (response.success) {
					 const tbody = $('#dataBodyDaily');
					 const thead = $('#dataHeadDaily');
	                    tbody.empty(); // 기존 데이터 제거
	                    thead.empty();
	                    response.data.forEach(data => {
	                    	console.log(data);
	           
	                       const row = `<tr>
	                        				<td>`+data.menuName+`</td>
	                        				<td>`+data.day1+`</td>
	                                    	<td>`+data.day2+`</td>
	                        				<td>`+data.day3+`</td>
	                        				<td>`+data.day4+`</td>
	                        				<td>`+data.day5+`</td>
	                        				<td>`+data.day6+`</td>
	                        				<td>`+data.day7+`</td>
	                        				<td>`+data.day8+`</td>
	                        				<td>`+data.day9+`</td>
	                        				<td>`+data.day10+`</td>
	                        				<td>`+data.day11+`</td>
	                        				<td>`+data.day12+`</td>
	                        				<td>`+data.day13+`</td>
	                        				<td>`+data.day14+`</td>
	                                    	<td>`+data.day15+`</td>
	                        				<td>`+data.day16+`</td>
	                        				<td>`+data.day17+`</td>
	                        				<td>`+data.day18+`</td>
	                        				<td>`+data.day19+`</td>
	                        				<td>`+data.day20+`</td>
	                        				<td>`+data.day21+`</td>
	                        				<td>`+data.day22+`</td>
	                        				<td>`+data.day23+`</td>
	                        				<td>`+data.day24+`</td>
	                        				<td>`+data.day25+`</td>
	                        				<td>`+data.day26+`</td>
	                        				<td>`+data.day27+`</td>
	                        				<td>`+data.day28+`</td>
	                        				<td>`+data.day29+`</td>
	                        				<td>`+data.day30+`</td>
	                        				<td>`+data.day31+`</td>
	                                     </tr>`;
	                        tbody.append(row);  
	                    });
	                    let column=`<tr><td>메뉴명</td>`;
	                    for(let i=1;i<=31;i++){
	                    	column+=`<td>`+i+`일</td>`;
	                    }
	                    column+=`</tr>`
	                    thead.append(column);
	       
						alert("조회되었습니다");
					} else {
						alert("조회에 실패했습니다.");
					}
				},
				error : function(e) {
					alert("서버 오류가 발생했습니다.");
					console.log(e);
				}
			});
		}else if(selectType==="time"){
			const removeDuplicate=document.getElementById("removeDuplicate").checked? 1:0;
			console.log("중복값제거여부"+removeDuplicate);
				$.ajax({
					url : '/main/TimeData.do',
					method : 'GET',
					dataType:'json',
					contentType:'application/json',
					data:{
						year:year,
						month:month,
						day:day,
						removeDuplicate:removeDuplicate
					},
					success : function(response) {
						console.log(response);
				
						if (response.success) {
						 const tbody = $('#dataBodyTime');
						 const thead = $('#dataHeadTime');
		                    tbody.empty(); // 기존 데이터 제거
		                    thead.empty();
		                    response.data.forEach(data => {
		                    	console.log(data);
		                    	  const row = `<tr>
                      				<td>`+data.menuName+`</td>
                      				<td>`+data.time0+`</td>
                      				<td>`+data.time1+`</td>
                                  	<td>`+data.time2+`</td>
                      				<td>`+data.time3+`</td>
                      				<td>`+data.time4+`</td>
                      				<td>`+data.time5+`</td>
                      				<td>`+data.time6+`</td>
                      				<td>`+data.time7+`</td>
                      				<td>`+data.time8+`</td>
                      				<td>`+data.time9+`</td>
                      				<td>`+data.time10+`</td>
                      				<td>`+data.time11+`</td>
                      				<td>`+data.time12+`</td>
                      				<td>`+data.time13+`</td>
                      				<td>`+data.time14+`</td>
                                  	<td>`+data.time15+`</td>
                      				<td>`+data.time16+`</td>
                      				<td>`+data.time17+`</td>
                      				<td>`+data.time18+`</td>
                      				<td>`+data.time19+`</td>
                      				<td>`+data.time20+`</td>
                      				<td>`+data.time21+`</td>
                      				<td>`+data.time22+`</td>
                      				<td>`+data.time23+`</td>
                                   </tr>`;
                      tbody.append(row);   
		                    });
		                    let column=`<tr><td>메뉴명</td>`;
		                    for(let i=0;i<=23;i++){
		                    	column+=`<td>`+i+`시</td>`;
		                    }
		                    column+=`</tr>`
		                    thead.append(column);
		               
							alert("조회되었습니다");
						} else {
							alert("조회에 실패했습니다.");
						}
					},
					error : function(e) {
						alert("서버 오류가 발생했습니다.");
						console.log(e);
					}
				});
		}
			
			
			console.log(year);

			
		})
		
 		$('#monthAccssButton').click(function(){
			$.ajax({
				url:'/main/recentThreeYear.do',
				method:'GET',
				dataType:'json',
				success : function(response) {
					console.log(response);
			
					if (response.success) {
					 const tbody = $('#pivotDataBody');
	                    tbody.empty(); // 기존 데이터 제거
	                    response.data.forEach(data => {
	                    	console.log(data);
	                        const row = `<tr>
	                        				<td>`+data.menuName+`</td>
	                        				<td>`+data.thisYear+`</td>
	                        				<td>`+data.thisYearMOne+`</td>
	                        				<td>`+data.thisYearMTwo+`</td>
	                                     </tr>`;
	                        tbody.append(row);  
	                    });
	                    
	                    const thead=$('#pivotDataHead');
	                    const currentDate=new Date();
	                    const thisYear=currentDate.getFullYear();
	                    const thisYearMOne=thisYear-1;
	                    const thisYearMTwo=thisYear-2;
	                    const menuName="메뉴명";
	         
	                    	 const column=`<tr>
	                    	 <td>`+menuName+`</td>
                				<td>`+thisYear+`</td>
                				<td>`+thisYearMOne+`</td>
                				<td>`+thisYearMTwo+`</td>
                                </tr>`;
                            thead.append(column);
	                
						alert("조회되었습니다");
					} else {
						alert("조회에 실패했습니다.");
					}
				},
				error : function() {
					alert("서버 오류가 발생했습니다.");
				}
			});
		})
	</script>
</body>
</html>
