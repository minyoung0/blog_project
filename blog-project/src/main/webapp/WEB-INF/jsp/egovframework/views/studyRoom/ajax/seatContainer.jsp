<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.time.LocalDate"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
List<Integer> seatGrid = new ArrayList<>();
for (int i = 1; i <= 25; i++) {
	seatGrid.add(i);
}
pageContext.setAttribute("seatGrid", seatGrid);
%>
<div class="seat-container-element">
	<div class="seat-grid">
		<c:forEach var="index" items="${seatGrid}">
			<c:set var="seatFound" value="false" />
			<c:set var="seatStatus" value="available" />

			<c:forEach items="${seatInfo}" var="seat">
				<c:if test="${seat.seatLocation eq index}">
					<c:set var="seatFound" value="true" />

					<!-- 사용 불가한 좌석
		            	1.오늘 날짜가 사용불가 기간 내에 있는경우 
		            	2.선택한 날짜가 사용불가 기간 내에 있는 경우
		            	3.사용불가 이유가 있어야함
		            -->
					<c:if test="${seat.disabledReason ne null && (seat.startDate <= today && seat.endDate >= today) || ( seat.startDate <= selectDate && seat.endDate >= selectDate)}">
						<c:set var="seatStatus" value="disabled" />
					</c:if>

					<!--reservList에 있는 startTime endTime 사이에 지금시간-->
					<c:forEach items="${reservList}" var="reserv">
						<c:if test="${reserv.seatId eq seat.seatId && reserv.startTime <= today && reserv.endTime >= today}">
							<c:set var="seatStatus" value="reserved" />
						</c:if>
					</c:forEach>


					<c:choose>
						<c:when test="${seatStatus eq 'disabled'}">
							<button class="btn btn-danger seatBtn disabledSeat" value="${seat.seatId}" data-seat-id="${seat.seatId }" id="seatBtn"data-seat-index="${index }">
								<span>${index}번</span>
							</button>
						</c:when>
						<c:when test="${seatStatus eq 'reserved'}">
							<button class="btn btn-secondary seatBtn" value="${seat.seatId}" id="seatBtn" data-seat-index="${index }">
								<span>${index}번<br><span style="font-size:10px; color:white;">(사용중)</span></span>
								
							</button>
						</c:when>
						<c:otherwise>
							<button class="btn btn-outline-secondary seatBtn" value="${seat.seatId}" id="seatBtn" data-seat-index="${index }">
								<span>${index}번</span>
							</button>
						</c:otherwise>
					</c:choose>
				</c:if>
			</c:forEach>

			<!-- 좌석이 없는 경우 빈 칸 유지 -->
			<c:if test="${seatFound eq false}">
				<div class="seat-cell"></div>
			</c:if>
		</c:forEach>

	</div>

	<div class="reserv-container" >
		<input type="hidden" id="selectedSeatId" name="selectedSeatId" value="">
		<div style="display: flex; flex-direction: column; margin-top: 20px;" id="selectedSeat">
			<h6 style="color: #FF3D5C;">선택 날짜: ${selectedDay}</h6>
<!-- 			<h6>
				선택 좌석: <span id="selectSeat"></span>
			</h6> -->
		</div>
		<div class="reserv-container-table" id="reserv-container-table">
		
		</div>
	</div>
</div>
