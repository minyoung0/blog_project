<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:choose>
	<c:when test="${not empty boardList}">
		<c:forEach items="${boardList}" var="board">
			<div class="card-header post">
				<div class="button-section boardButton" style="margin-bottom: 8px;">
					<button class="btn btn-primary edit-button">수정하기</button>
					<button class="btn btn-danger delete-button" style="margin-left: 8px;">삭제하기</button>
				</div>
				<h3>
					<span class="post-title"></span>
				</h3>
				<div class="userAndFollow">
					<h5>
						작성자:${board.userId}
					</h5>
					<button type="button" class="btn btn-outline-secondary follow" style="margin-left: 8px; display: none;">팔로우</button>
					<button type="button" class="btn btn-secondary followed" style="margin-left: 8px; display: none;">팔로잉</button>
					<button type="button" class="btn btn-secondary follow-ing" style="margin-left: 8px; display: none;">요청중</button>
				</div>
				<h6>
					작성날짜:${board.boardRegistDatetime}
				</h6>
				<br>
				<h6 style="color: red;">
					<span class="post-scrapOriginalUser"></span>
				</h6>
			</div>
			<div class="card-body">
				<h4>
					<span id="content">${content}</span>
				</h4>
				<div class="post-files-container">
					<h5>첨부파일</h5>
					<ul class="post-files"></ul>
				</div>
				<!-- <p>`+fileHtml+`</p> -->
				<button class="btn btn-primary comment-button" data-user-access="${post.accessRight}">댓글</button>
				<button class="btn btn-success scrap-button">스크랩하기</button>
				<div class="comment-container"></div>
			</div>
		</c:forEach>
	</c:when>
	<c:otherwise>

		<strong>댓글이 없습니다.</strong>

	</c:otherwise>
</c:choose>


