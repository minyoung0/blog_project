<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:choose>
	<c:when test="${not empty commentList}">
		<c:forEach items="${commentList}" var="comment">
			<div class="mb-2" id="comment-${comment.commentId}">
				<strong>${comment.userId}</strong>:<span>${comment.commentContent}</span>
				<button class="btn btn-primary comment-edit-button">수정하기</button>
				<button class="btn btn-danger comment-delete-button" data-post-id="${comment.commentId}">삭제하기</button>
			</div>
		</c:forEach>
	</c:when>
	<c:otherwise>
		
			<strong>댓글이 없습니다.</strong>

	</c:otherwise>
</c:choose>


