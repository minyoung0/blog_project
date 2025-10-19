<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 상세보기</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.1.js"></script>

<style>
.body {
    margin: auto;
    margin-top: 40px;
    padding: 20px;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
} 

.post-title {
    font-size: 1.8rem;
    font-weight: bold;
    margin-bottom: 10px;
}

.post-meta {
    font-size: 0.9rem;
    color: #777;
    margin-bottom: 20px;
}

.post-content {
    font-size: 1rem;
    color: #333;
    line-height: 1.6;
    margin-bottom: 20px;
}

img{
	width:100%;
}

.like-button {
    display: flex;
    justify-content: center;
    margin-top: 20px;
}

.comment-section {
    margin-top: 30px;
}


.comment-box {
    width: 100%;
    resize: none;
}

.comment {
    padding: 10px;
    border-bottom: 1px solid #ddd;
    margin-bottom: 5px;
}
</style>
</head>
<body>

<div class="body">
    <!-- 제목 -->
    <h2 class="post-title">${post.title}</h2>

    <!-- 작성자, 작성일, 조회수, 좋아요 개수 -->
    <div class="post-meta">
        작성자: ${post.nickName} | 작성일: ${post.createAt} | 조회수:${post.viewCount }  | ❤️ 
    </div>

    <!-- 본문 내용 -->
    <div class="post-content">
        ${post.content}
    </div>

    <!-- 좋아요 버튼 -->
    <div class="like-button">
        <button class="btn btn-danger" onclick="likePost(${post.postId})">
            ❤️ 좋아요
        </button>
    </div>

    <!-- 댓글 영역 -->
    <div class="comment-section">
        <h4>댓글</h4>

        <!-- 댓글 입력 -->
        <textarea id="comment-input" class="form-control comment-box" rows="3" placeholder="댓글을 입력하세요..."></textarea>
        <button class="btn btn-primary mt-2" onclick="addComment(${post.postId})" style="background-color:#5BA48E; border:none;">댓글 등록</button>

        <!-- 댓글 목록 -->
<%--         <div id="comment-list">
            <c:forEach var="comment" items="${comments}">
                <div class="comment">
                    <strong>${comment.writer}</strong> - ${comment.createAt}  
                    <p>${comment.content}</p>
                </div>
            </c:forEach>
        </div> --%>
    </div>
</div>
<jsp:include page="../chattingLayout.jsp" />
<script>
function likePost(postId) {
    $.ajax({
        type: "POST",
        url: "/blog/likePost",
        data: { postId: postId },
        success: function(response) {
            alert("좋아요가 반영되었습니다!");
            location.reload();
        }
    });
}

function addComment(postId) {
    var commentContent = $("#comment-input").val();
    if (commentContent.trim() === "") {
        alert("댓글을 입력해주세요.");
        return;
    }

    $.ajax({
        type: "POST",
        url: "/blog/addComment",
        data: { postId: postId, content: commentContent },
        success: function(response) {
            alert("댓글이 등록되었습니다!");
            location.reload();
        }
    });
}
</script>

</body>
</html>
