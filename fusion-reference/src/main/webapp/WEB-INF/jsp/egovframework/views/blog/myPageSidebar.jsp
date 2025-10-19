<%@page import="egovframework.fusion.blog.user.vo.BlogUserVO"%>
<%@page import="egovframework.fusion.user.vo.UserVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 사이드바</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free/js/all.min.js"></script>
<script>
	const loggedInUserProfile=`${pageContext.request.contextPath}`;
	console.log("loggedInUserProfile: "+loggedInUserProfile);
</script><script src="../../../../../js/chat-common.js"></script>
<style>

.profile-card {
	text-align: center;
	background: #f8f9fa;
	padding: 15px;
	border-radius: 10px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.profile-img {
	width: 100%;
	height: 100%; /* 3:4 비율 */
	object-fit: cover;
	border-radius: 8px;
	border: 2px solid #ddd;
}

.profile-name {
	font-size: 1.2rem;
	font-weight: bold;
	margin-top: 10px;
}

.profile-email {
	font-size: 0.9rem;
	color: #777;
}

.profile-actions {
	margin-top: 10px;
}

.settings-btn {
	float: right;
	font-size: 1.2rem;
	color: #777;
	cursor: pointer;
}

.settings-btn:hover {
	color: #333;
}

.category-item {
	padding: 12px 15px;
	background: #fff;
	border-bottom: 1px solid #ddd;
	transition: background 0.3s ease;
}

.category-item:hover {
	background: #f5f5f5; /* 마우스 올렸을 때 색상 변경 */
}

.settings-btn{
	width:10%;
	height:10%;
	margin-bottom:10px;
}

.visitor-count{
	font-size:13px;
}
</style>
</head>
<body>
	<%
		BlogUserVO loggedInUser= (BlogUserVO)session.getAttribute("loggedInUser");
	%>
	<div class="profile-card">
		<!-- 설정 버튼 -->
	<c:if test="${not empty loggedInUser and loggedInUser.userId==userInfo.userId }">	
		<i class="fas fa-cog settings-btn" style=""
			onclick="location.href='/blog/settings.do'"></i>
	</c:if>

		<!-- 프로필 이미v c지 -->
		<img src="${userInfo.profileImage}" alt="Profile Image"
			class="profile-img">

		<!-- 닉네임 & 이메일 -->
		<div class="profile-name">${userInfo.nickName}</div>
		<div class="profile-email">${userInfo.bio}</div>

		<!-- 버튼 영역 -->
		<c:if test="${not empty loggedInUser and loggedInUser.userId==userInfo.userId }">	
		<!-- 	<div class="profile-actions">
				<button class="btn btn-sm chatList"
					style="background-color: #5BA48E; color: white;">
					<i class="fas fa-envelope"></i> 채팅목록
				</button>
			</div> -->
		</c:if>
		<c:if test="${loggedInUser.userId != userInfo.userId }">	
			<div class="profile-actions">
				<button class="btn btn-sm startChatBtn" data-receiver-id="${userInfo.userId }"
					style="background-color: #5BA48E; color: white;">
					<i class="fas fa-envelope"></i> 채팅보내기
				</button>
			</div>
		</c:if>
		
	</div>

	<!-- 마이페이지 메뉴 -->
	<div class="list-group mt-3">
	    <div class="my-categories mt-3">
	        <h5>카테고리</h5>
	        <div class="category-list">
	            <ul class="list-group">
	                <c:forEach items="${category}" var="category">
	                    <li class="list-group-item category-item" style="cursor: pointer;"
	                        onclick="document.getElementById('categoryForm${category.categoryId}').submit();">
	                        <form id="categoryForm${category.categoryId}" method="GET" action="/blog/myPage.do">
	                            <input type="hidden" name="categoryId" value="${category.categoryId}">
	                            <input type="hidden" name="blogUserId" value="${userInfo.userId}">
	                        </form>
	                        <span style="text-decoration:none; color:black;">
	                            ${category.categoryName} 
	                        </span>
	                    </li>
	                </c:forEach>
	            </ul>
	        </div>
	    </div>
	</div>


	<div class="visitor-count mt-3 text-center">
		<p>
			<strong>오늘 방문: </strong><span id="todayVisits"></span> | <strong>총 방문: </strong>
			<span id="totalVisits"></span>
		</p>
	</div>
<script>
	$(document).ready(function(){
		$.ajax({
			url:'/blog/getVisit.do',
			type:'get',
			success:function(response){
				console.log(response.todayVisits);
				console.log(response.totalVisits);
				
			    $("#todayVisits").text(response.todayVisits);
	            $("#totalVisits").text(response.totalVisits);
			}
		})
		
	
		$(document).on('click','.startChatBtn',function(e){
			e.preventDefault();
			
			const receiverId=$(this).data('receiver-id');
			const chatPopup=$('#chatPopup');
			const chatContainer=$('#chatContainer');
			
			chatPopup.show();
			
			$.ajax({
				url:'/chat/getChatRoom.do',
				type:'post',
				data:{
					receiverId:receiverId
				},
				success:function(response){
					const roomId=response.roomId;
					loadChatMessage(roomId,receiverId,response.userId);
				},error:function(){
					console.log("에러발생");
				}
			})
		})
		
		function loadChatMessage(roomId,receiverId,userId){
			window.currentRoomId=roomId;
			window.receiverId=receiverId;
			window.senderProfile=`${loggedInUser.profileImage}`;
			$.ajax({
				url:'/chat/getMessage.do',
				type:'get',
				data:{roomId:roomId,receiverId:receiverId},
				success:function(response){
					const chatContainer=$('#chatContainer');
					chatContainer.html(response);
					console.log("roomId: "+roomId+", receiverId: "+receiverId+", userId:"+userId);
					  // 웹소켓 연결도 여기서 시작해야 돼
					  connectWebSocket(roomId,receiverId,userId); // 함수 정의 참고
					  scrollToBottom();
				},error:function(){
					console.log("error");
				}
			})

		}
		

	})

</script>
</body>
</html>
