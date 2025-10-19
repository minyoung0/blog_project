
		function connectWebSocket(roomId,receiverId, userId) {
			  console.log("웹소켓 ");
			  socket = new WebSocket("ws://localhost:8080/chatting.do?roomId=" + roomId + "&userId=" + userId);

			  socket.onopen = () => console.log("🔌 [myPageSide] 웹소켓 연결됨");
	
			  socket.onmessage = function (event) {
			    const msg = JSON.parse(event.data);
			    console.log(msg);
			    if(msg.senderId === userId) return;
			    
			    if (roomId !== msg.roomId) {
			    	console.log("roomId: "+roomId);
			    	console.log("msg.roomId:"+msg.roomId);
			        showChatNotification(msg);
			      } else {
			    	console.log("dddd");
			        displayIncomingMessage(msg); // 기존 append 처리
					
			        socket.send(JSON.stringify({
			        	type:"readNotify",
			        	roomId:msg.roomId,
			        	senderId:userId,
			        	receiverId:receiverId
			        }));
			      }
			  };

			  socket.onerror = function (error) {
			    console.error("❌ 웹소켓 에러", error);
			  };

			  socket.onclose = function () {
			    console.log("🔒 웹소켓 연결 종료");
			  };
			}
		
		function displayIncomingMessage(chatData) {
			console.log(chatData)
			  const time = getFormattedDateTime();
			  const messageHtml = `
			    <div class="message-row">
			      <img src="`+chatData.senderProfile+ `" class="profile-pic" alt="상대 프로필">
			      <div class="message-content">
			        <div class="chat-bubble left">
			          `+escapeHtml(chatData.message)+`
			        </div>
			        <div class="chat-time">`+time+`</div>
			      </div>
			    </div>
			  `;
			  $('#chatContainer').append(messageHtml);
			  $('#chatContainer').scrollTop($('#chatContainer')[0].scrollHeight);
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



		function escapeHtml(text) {
			  return text
			    .replace(/&/g, "&amp;")
			    .replace(/</g, "&lt;")
			    .replace(/>/g, "&gt;")
			    .replace(/"/g, "&quot;")
			    .replace(/'/g, "&#039;");
			} 
	
		function scrollToBottom(){
			  const chatContainer = $('#chatContainer');
			  chatContainer.scrollTop(chatContainer[0].scrollHeight);
		}
		