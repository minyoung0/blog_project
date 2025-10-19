<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="../../../../../../js/chat-common.js"></script>
<% String userId= (String) session.getAttribute("userId"); %>
<div class="chat-room-list">
	<c:forEach items="${chattingList}" var="room">
		<div class="chat-room-item" onclick="openChatRoom(${room.roomId},'${room.otherUserId}','${userId }')">
			<div class="chatting-profile-img">
				<img src="${room.otherUserProfile}" alt="profile" />
			</div>
			<div class="chat-info">
				<div class="chat-header">
					<span class="chat-name">${room.otherUserNickName}</span>
					<span class="chat-time">${room.recentlyTime}</span>
				</div>
				<div class="chat-preview">
					<c:choose>
						<c:when test="${not empty room.message}">
							${room.message}
						</c:when>
						<c:otherwise>
							대화 내용이 없습니다.
						</c:otherwise>
					</c:choose>
				</div>
			</div>
			<c:if test="${room.readYn eq 'N' && room.senderId ne userId}">
				<div class="unread-badge">●</div>
			</c:if>
		</div>
	</c:forEach>
</div>
<script>
function openChatRoom(roomId,user1Id,user2Id){
	console.log("user1Id:"+user1Id);
	console.log("user2Id:"+user2Id);
	loadChatMessage(roomId,user1Id,user2Id);
}
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
</script>
