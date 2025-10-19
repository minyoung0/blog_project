<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>채팅방</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .chat-bubble {
            max-width: 100%;
            padding: 10px;
            border-radius: 15px;
            margin-bottom: 10px;
            position: relative;
            font-size:13px;
        }

        .chat-bubble.left {
            background-color: #f1f0f0;
            align-self: flex-start;
        }

        .chat-bubble.right {
            background-color: #5BA48E;
            color: white;
            align-self: flex-end;
        }

        .chat-time {
            font-size: 0.75rem;
            color: gray;
            margin-top: 5px;
        }

        .chat-read {
            font-size: 0.7rem;
            color: lightgray;
            margin-left: 5px;
        }

        .chat-wrapper {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .profile-pic {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            margin-right: 8px;
        }

        .message-row {
            display: flex;
            align-items: flex-end;
        }

        .message-row.right {
            justify-content: flex-end;
        }

        .message-content {
            display: flex;
            flex-direction: column;
        }
    </style>
</head>

<body class="d-flex flex-column p-3" style="height: 100vh;">
		<!-- hidden input으로 정보 전달 -->
	<input type="hidden" id="roomId" value="${roomId}">
	<input type="hidden" id="receiverId" value="${partner.userId}">
		
    <!-- ✅ 1. 상대방 정보 영역 -->
    <div class="d-flex align-items-center border-bottom pb-2 mb-3">
        <img src="${partner.profileImage}" class="rounded-circle me-2" style="width: 40px; height: 40px;">
        <strong class="fs-5">${partner.nickName}</strong>
    </div>

    <!-- ✅ 2. 채팅 메시지 영역 -->
    <div class="chat-wrapper flex-grow-1 overflow-auto mb-3">
        <c:forEach var="msg" items="${message}">
            <c:choose>
                <c:when test="${msg.senderId eq sessionScope.userId}">
                    <div class="message-row right">
                        <div class="message-content">
                            <div class="chat-bubble right">
                                ${msg.message}
                            </div>
                            <div class="chat-time text-end">
                                ${msg.sendingTime}
                                <c:if test="${msg.readYn eq 'N'}">
                                    <span class="chat-read"> 안읽음</span>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="message-row">
                        <img src="${msg.senderProfile}" class="profile-pic" alt="상대 프로필">
                        <div class="message-content">
                            <div class="chat-bubble left">
                                ${msg.message}
                            </div>
                            <div class="chat-time">
                                ${msg.sendingTime}
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </div>

</body>
</html>
