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
	<c:forEach var="index" items="${seatGrid}">
		<c:set var="seatFound" value="false" />

		<c:forEach items="${seatList}" var="seat">
			<c:if test="${seat.seatLocation eq index}">
				<c:set var="seatFound" value="true" />
				<button class="btn btn-outline-secondary seatBtn" value="${seat.seatId}" id="seatBtn" draggable="true" data-seat-id="${seat.seatId}"
                        data-seat-location="${index}">
						<span>${index}번</span>
				</button>

			</c:if>
		</c:forEach>

		<!-- 좌석이 없는 경우 빈 칸 유지 -->
		<c:if test="${seatFound eq false}">
			<div class="seat-cell" data-seat-location="${index}"></div>
		</c:if>
	</c:forEach>
				
				