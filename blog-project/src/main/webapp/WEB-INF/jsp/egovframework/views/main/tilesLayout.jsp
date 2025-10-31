<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인화면</title>
<style>
 body{
  width:100%;
  height:100vh;
  display:flex;
  flex-direction:column;
 }
 .header{

 }
 .main{
 display:flex;
 flex-direction:column;
 }
 .menu{
 height:40px;
 }
 .body{
 width:70%;
 margin:0 auto;
 }
</style>
</head>
<body>

	<div id="header" class="header">
		<tiles:insertAttribute name="header" />
	</div>
	<div id="main" class="main">
<%-- 		<div class="menu">
			<tiles:insertAttribute name="menu" />
		</div> --%>
		<div class="body">
			<tiles:insertAttribute name="body" />
		</div>

	</div>
	<script>
  const userId = '<%= session.getAttribute("userId") %>';
  let globalSocket;

  if (userId) {
    globalSocket = new WebSocket("ws://localhost:8080/chatting.do?userId=" + userId);

    globalSocket.onopen = () => {
      console.log("✅ 로그인 후 WebSocket 연결됨");
    };

    globalSocket.onmessage = function (event) {
      const msg = JSON.parse(event.data);

      // 예: 내가 현재 채팅창 안에 없을 때만 알림
      if (msg.roomId !== window.currentRoomId) {
        showChatNotification(msg);
      }
    };

    globalSocket.onclose = () => console.log("🔌 WebSocket 연결 종료");
    globalSocket.onerror = err => console.error("❌ WebSocket 오류", err);
  }
  
  function showChatNotification(msg) {
	  const toastHtml = `
	    <div class="toast align-items-center text-white  border-0 show" role="alert" style="width:200px; position: fixed; bottom: 100px; right: 30px; z-index: 9999; background-color:#5BA48E">
	      <div class="d-flex">
	        <div class="toast-body">
	          💬 `+msg.senderId+` : `+escapeHtml(msg.message)+`
	        </div>
	        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
	      </div>
	    </div>
	  `;
	  $('body').append(toastHtml);

	  // 자동 제거
	  setTimeout(() => {
	    $('.toast').remove();
	  }, 4000);
	}
	function escapeHtml(text) {
		  return text
		    .replace(/&/g, "&amp;")
		    .replace(/</g, "&lt;")
		    .replace(/>/g, "&gt;")
		    .replace(/"/g, "&quot;")
		    .replace(/'/g, "&#039;");
		} 


</script>
</body>
</html>