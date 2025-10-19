<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.time.LocalDate"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<input type="hidden" id="totalList" value='${totalListJson}'>
<div id="roomInfo" style="display:flex; flex-direction:column">
	<div id="roomOff">
		<c:if test="${operInfo.updateReason ne null }">
			<div  style="border:1px solid red; display:flex; flex-direction:column; justify-content:center; align-items:center; margin-top:15px; margin-bottom:15px;'">
				<h6>${selectedDay}의 운영시간은</h6>
				<h6>${openTime}~${closeTime}입니다</h6>
				<strong style="color:red;">사유: ${operInfo.updateReason}</strong>
			</div>
		</c:if>	
	</div>
	<c:if test="${seatInfo ne null && (seatInfo.startDate<=today && seatInfo.endDate>=today) || (seatInfo.startDate<=selectDay && seatInfo.endDate>=selectDay)}">
		<div id="seatOff">
			<div style="border: 1px solid red; display: flex; flex-direction: column; justify-content: center; align-items: center; margin-top: 15px; margin-bottom: 15px; padding: 15px;'">
				<h6>해당 좌석은 ${seatInfo.startDate} 부터 ${seatInfo.endDate }까지 사용불가합니다.</h6>
				<strong style="color: red;">사유:${seatInfo.disabledReason}</strong>
			</div>
		</div>
	</c:if>

</div>
<!-- seatInfo != null    -> 해당좌석에 사용불가 정보가 있다   --> 
<c:if test="${seatInfo eq null || (seatInfo ne null &&(seatInfo.startDate>=today || seatInfo.endDate<=today) && (seatInfo.startDate>=selectDay || seatInfo.endDate<=selectDay))}">
	<div class="row" style="gap:0px;">

		<c:forEach items="${totalList }" var="index">
			<div class="col-md-6 mb-2 border" >
				<c:if test="${index.status eq '예약불가'}">
					<h6 style="text-decoration:line-through">${index.time }(${index.status }) </h6>
				</c:if>
				<c:if test="${index.status eq '예약가능'}">
					<h6 >${index.time } (${index.status }) </h6>
				</c:if>
			</div>
		</c:forEach>
	</div>
</c:if>

<c:if test="${seatInfo eq null || (seatInfo ne null &&(seatInfo.startDate>=today || seatInfo.endDate<=today) && (seatInfo.startDate>=selectDay || seatInfo.endDate<=selectDay))}">
	<div class="reserv-select" id="reserv-select" >
			<h4 style="margin-top:40px;border-top: 2px solid black; border-bottom: 2px solid black; height: 60px; display: flex; justify-content: center; align-items: center;">예약 목적 및 시간선택</h4>
			<div class="firstLine">
				<div class=""><h4>사용목적</h4></div>
				<div class="">
					<select class="form-select" aria-label="Default select example" id="selectReason">
						<option value="selectReason" selected>사용목적을 선택해주세요</option>
						<option value="study" >공부</option>
						<option value="study" >회의</option>
						<option value="study" >기타</option>
					</select>
				</div>
			</div>
			<div class="secondLine">
				<div class=""><h4>이용시간</h4></div>
				<div class="selectTime">
					<div>
						<select class="form-select selectStart" aria-label="Default select example" id="startTime">
							<option value="selectStart" selected>시작시간</option>
							
							<c:forEach items="${operStart}" var="time">
								<option value="${time}">${time}</option>
							</c:forEach>
						</select>
					</div>
						~
					<div id="form-select-selectEnd">
					<select class="form-select" aria-label="Default select example" id="endTime">
							<option value="selectEnd" selected>종료시간</option>
							
						</select> 
					</div>
				</div>
			
			</div>
			<button type="button"  class="btn btn-info reservApply" style="margin-top:40px;">신청하기</button>
	</div>
</c:if>