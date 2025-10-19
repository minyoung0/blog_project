<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.chatIcon{

}

.chatWindow {
  position: fixed;
  bottom: 20px;
  right: 20px;
  width: 350px;
  height: 500px;
  background-color: white;
  border: 1px solid #ccc;
  z-index: 1000;
  display: none; /* 처음엔 숨김 */
  flex-direction: column;
}

.hidden {
  display: none;
}

.chat-room-list {
  width: 100%;
}
.chat-room-item {
  display: flex;
  align-items: center;
  padding: 10px;
  border-bottom: 1px solid #eee;
  cursor: pointer;
  width: 100%;
  overflow: hidden;
}

.chatting-profile-img img {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
}

.chat-info {
  display: flex;
  flex-direction: column;
  flex: 1;
  margin-left: 10px;
  overflow: hidden;
}

.chat-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: bold;
  white-space: nowrap;
}

.chat-name {
  overflow: hidden;
  text-overflow: ellipsis;
}

.chat-time {
  font-size: 0.8em;
  color: #999;
  margin-left: 10px;
  flex-shrink: 0;
}

.chat-preview {
  font-size: 0.85em;
  color: #666;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

</style>
 <script src="https://code.jquery.com/jquery-3.6.1.min.js"></script>
 <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
	
</head>
<body>
<%
	String userId = (String) session.getAttribute("userId");
%>
<c:if test="${userId ne null }">
			<a id="chatToggleBtn" class="btn btn-primary rounded-circle shadow position-fixed chatIcon" style="	background-color:#5BA48E;border:none; bottom: 30px;	right: 30px; width: 60px; 
					height: 60px; display: flex; justify-content: center; align-items: center; z-index: 999; cursor:pointer;">
			    <i class="bi bi-bell fs-4"></i>
			</a>
</c:if>

<div id="chatPopup" class="chatWindow shadow rounded hidden"
     style="position: fixed; bottom: 20px; right: 20px; width: 350px; height: 500px; background-color: white; border: 1px solid #ccc; z-index: 9999; display: none;">
  
  <!-- 헤더 -->
  <div class="chatWindowHeader d-flex justify-content-between align-items-center p-2 border-bottom">
    <strong>채팅방</strong>
    <button type="button" class="btn-close btn-sm" id="chatCloseBtn"></button>
  </div>

  <!-- 바디: 메시지 + 입력창 포함 -->
  <div class="d-flex flex-column flex-grow-1">
    
    <!-- 채팅 내용 -->
    <div id="chatContainer" class="flex-grow-1 overflow-auto p-2" style="height:400px;">
      <p>채팅 내용을 불러오는 중...</p>
    </div>

    <!-- 입력창 -->
    <form id="chatForm" class="d-flex align-items-center p-2 border-top gap-2" style="height: 60px;">
	  <input type="text" id="chatInput" class="form-control flex-grow-1" placeholder="메시지를 입력하세요" style="height: 40px;" />
	  <button type="submit" class="btn btn-success flex-shrink-0 d-flex justify-content-center align-items-center"
	          style="height: 40px; width: 40px; background-color: #5BA48E; border: none;">
	    <i class="bi bi-send"></i>
	  </button>
	</form>


  </div>
</div>



<script>
document.addEventListener("DOMContentLoaded", function () {

});
$(document).ready(function(){
	$('#chatToggleBtn').click(function (e) {
		  e.preventDefault();
		  const popup = $('#chatPopup');

		  if (popup.css('display') === 'none') {
		    popup.css('display', 'flex');
		  } else {
		    popup.css('display', 'none');
		  }

		  const userId = `${userId}`;
		  $.ajax({
		    url: '/chat/getChatList.do',
		    type: 'get',
		    data: { userId: userId },
		    success: function (response) {
		      $('#chatContainer').html(response);
		    },
		    error: function () {
		      console.log("에러");
		    }
		  });
		});

		$('#chatCloseBtn').click(function () {
		  $('#chatPopup').css('display', 'none');
		});
		

		
		$(document).on('submit', '#chatForm', function (e) {
			  e.preventDefault();
			  console.log("currentRoomId: "+currentRoomId);
			  console.log("reseiverId: "+receiverId);
			  const senderId=`${userId}`;
			  const message = $('#chatInput').val().trim();
			  if (!message) return;

			  const chatData = {
			    roomId: currentRoomId,
			    receiverId: receiverId,
			    senderId:senderId,
			    message: message,
			    sendingTime: new Date().toLocaleTimeString(),
			    senderProfile:senderProfile
			  };

			  if (socket && socket.readyState === WebSocket.OPEN) {
			    socket.send(JSON.stringify(chatData));
			    $('#chatInput').val('');
			    appendMyMessage(chatData); // 내 채팅을 바로 표시
			  } else {
			    alert("웹소켓 연결 안 됨");
			  }
			});

	 	function appendMyMessage(chatData) {
	 		 const time = getFormattedDateTime(); // 시간 포맷 개선
	 		 const readStatus = chatData.readYn === 'Y' ? '' : '안읽음'
	 		  const messageHtml = `
	 			   <div class="message-row right">
	 		      <div class="message-content">
	 		        <div class="chat-bubble right">
	 		          `+escapeHtml(chatData.message)+`
	 		        </div>
	 		        <div class="chat-time text-end">
	 		          `+time+`
	 		          <span class="chat-read">`+readStatus+`</span>
	 		        </div>
	 		      </div>
	 		    </div>
	 		  `;
	 		  $('#chatContainer').append(messageHtml);
	 		  $('#chatContainer').scrollTop($('#chatContainer')[0].scrollHeight);
			}
		
		
		function escapeHtml(text) {
			  return text
			    .replace(/&/g, "&amp;")
			    .replace(/</g, "&lt;")
			    .replace(/>/g, "&gt;")
			    .replace(/"/g, "&quot;")
			    .replace(/'/g, "&#039;");
			} 
		function getFormattedDateTime() {
			  const now = new Date();
			  const year = now.getFullYear();
			  const month = String(now.getMonth() + 1).padStart(2, '0');
			  const day = String(now.getDate()).padStart(2, '0');
			  const hour = String(now.getHours()).padStart(2, '0');
			  const minute = String(now.getMinutes()).padStart(2, '0');
			  return year+`-`+month+`-`+day+`  `+hour+`:`+minute;
			}
		
		

})


</script>
</body>
</html>