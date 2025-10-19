
<%
/*********************************************************
 * 업 무 명 : 게시판 컨트롤러
 * 설 명 : 게시판을 조회하는 화면에서 사용 
 * 작 성 자 : 김민규
 * 작 성 일 : 2022.10.06
 * 관련테이블 : 
 * Copyright ⓒ fusionsoft.co.kr
 *
 *********************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi"
	crossorigin="anonymous">
<title>퓨전 게시판(상세보기)</title>
<script type="text/javascript">
	// 수정 폼 토글 함수
	function toggleEditForm(commentId) {
		// 수정 폼의 ID를 찾아서 보이기/숨기기 토글
		var editForm = document.getElementById("editForm_" + commentId);
		if (editForm.style.display === "none" || editForm.style.display === "") {
			editForm.style.display = "block";
		} else {
			editForm.style.display = "none";
		}
	}

	function toggleReplyForm(commentId) {
		var replyForm = document.getElementById("replyForm_" + commentId);
		if (replyForm.style.display === "none"
				|| replyForm.style.display === "") {
			replyForm.style.display = "block";
		} else {
			replyForm.style.display = "none";
		}
	}
	function openReplyPopup(boardId, parentBoardId) {

		if (!boardId || boardId === "null" || boardId === "") {
			alert("게시글 정보가 올바르지 않습니다.");
			return;
		}
		if (!parentBoardId || parentBoardId === "null") {
			parentBoardId = boardId; // parentBoardId가 없으면 자기 자신을 부모로 설정
		}
		const url = `/board/boardReplyForm.do?parentBoardId=${parentBoardId}`;
		window.open(url, 'ReplyPopup', 'width=800,height=600,scrollbars=yes');
	}
	window.onload = function() {
	    document.querySelectorAll('.delete-button').forEach(function(button) {
	        button.addEventListener('click', function(event) {
	            event.preventDefault(); // 기본 동작 방지

	            const boardId = this.dataset.boardId; // 삭제할 게시글 ID 가져오기
	            if (!boardId) {
	                alert('게시글 정보가 올바르지 않습니다.');
	                return;
	            }

	            // 삭제 확인
	            if (!confirm('정말로 게시글을 삭제하시겠습니까?')) {
	                return;
	            }

	            // AJAX 요청으로 삭제 처리
	            $.ajax({
	                type: 'POST',
	                url: '/board/delBoardPost.do',
	                data: { boardId: boardId },
	                success: function(response) {
	                    alert('게시글이 삭제되었습니다.');
	                    // 부모 창 새로고침
	                    if (window.opener) {
	                        window.opener.location.reload();
	                    }
	                    // 현재 팝업 창 닫기
	                    if (window.opener) {
	                        window.close();
	                    } else {
	                        alert('팝업 창이 아니어서 닫을 수 없습니다. 새 탭에서는 수동으로 창을 닫아주세요.');
	                    }
	                },
	                error: function() {
	                    alert('게시글 삭제 중 오류가 발생했습니다.');
	                }
	            });
	        });
	    });
	};
</script>
</head>
<body>
	<main class="mt-5 pt-5">
		<div class="container-fluid px-4">
			<h1 class="mt-4">게시글 조회</h1>
			<div class="card mb-4">
				<div class="card-body">
					<div class="mb-3">
						<label for="title" class="form-label">제목</label> <input type="text" class="form-control" id="title" name="title" value="${boardPost.boardTitle}" readOnly>
					</div>
					<div class="mb-3">
						<label for="content" class="form-label">내용</label>
						<textarea class="form-control" id="content" name="content" readOnly>${boardPost.boardContent}</textarea>
					</div>
					<div class="mb-3">
						<label for="writer" class="form-label">작성자</label> <input type="text" class="form-control" id="writer" name="writer" value="${boardPost.userName}" disabled>
					</div>
					<a href="/board/boardList.do" class="btn btn-outline-secondary">목록</a>
					<c:if test="${boardPost.userId == loggedInUserId}">
						<a href="/board/boardPostModify.do?boardId=${boardPost.boardId}&menuId=${menuId}" class="btn btn-outline-primary">수정하기</a>
						<button class="btn btn-outline-danger" onclick="location.href='/board/delBoardPost.do?boardId=${boardPost.boardId}'">삭제하기</button>
					</c:if>
					<c:if test="${not empty boardPost.boardId}">
						<button type="button" class="btn btn-outline-primary" onclick="window.open('/board/boardReplyForm.do?parentBoardId=${boardPost.boardId}&menuId=${menuId}', 
                                  '_blank', 
                                  'width=600,height=500');">답글 작성</button>
					</c:if>


				</div>
			</div>
			<div>
			<div class="mb-4">
				<label for="comment" class="form-label">댓글 작성</label>

				<%-- 로그인 상태일 때만 댓글 작성 폼 보이기 --%>
				<c:if test="${not empty loggedInUserId}">
					<form id="commentForm" action="/board/addComment.do?menuId=${menuId }" method="post">
						<input type="hidden" name="boardId" value="${boardPost.boardId}" />
						<textarea class="form-control" id="comment" name="commentContent" placeholder="댓글을 입력하세요." required></textarea>
						<button type="submit" class="btn btn-primary mt-2">댓글 작성</button>
					</form>
				</c:if>

				<%-- 로그아웃 상태 안내 메시지 --%>
				<c:if test="${empty loggedInUserId}">
					<div class="border border-success p-2 mb-2">로그인 후 댓글을 작성 할 수 있습니다</div>
				</c:if>
			</div>
        <c:forEach var="comment" items="${comments}">
            <div class="card mb-3" style="margin-left:${comment.commentLevel * 20}px;">
                <div class="card-body">
                    <c:choose>
                        <c:when test="${comment.deleteYn == 1}">
                            <p class="text-muted fst-italic">삭제된 댓글입니다.</p>
                        </c:when>
                        <c:otherwise>
                            <p class="mb-1">
                                <strong>${comment.userId}</strong> | 
                                <span class="text-muted">${comment.commentRegistDatetime}</span>
                            </p>
                            <p class="mb-2">${comment.commentContent}</p>

                            <!-- 수정 및 삭제 버튼 -->
                            <c:if test="${loggedInUserId == comment.userId}">
                                <button type="button" class="btn btn-sm btn-outline-primary" onclick="toggleEditForm('${comment.commentId}')">수정</button>
                                <form action="/board/deleteComment.do?menuId=${menuId }" method="post" style="display: inline;">
                                    <input type="hidden" name="commentId" value="${comment.commentId}" />
                                    <input type="hidden" name="boardId" value="${boardPost.boardId}" />
                                    <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</button>
                                </form>
                            </c:if>

                            <!-- 댓글 수정 폼 (숨김 상태) -->
                            <div id="editForm_${comment.commentId}" style="display: none;">
                                <form action="/board/editComment.do?menuId=${menuId }" method="post">
                                    <input type="hidden" name="commentId" value="${comment.commentId}" />
                                    <input type="hidden" name="boardId" value="${boardPost.boardId}" />
                                    <textarea name="commentContent" class="form-control mb-2" rows="3" required>${comment.commentContent}</textarea>
                                    <button type="submit" class="btn btn-sm btn-success">수정 완료</button>
                                    <button type="button" class="btn btn-sm btn-secondary" onclick="toggleEditForm('${comment.commentId}')">취소</button>
                                </form>
                            </div>

                            <!-- 대댓글 작성 -->
                            <c:if test="${not empty loggedInUserId}">
                                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="toggleReplyForm('${comment.commentId}')">대댓글 작성</button>
                                <div id="replyForm_${comment.commentId}" style="display: none;" class="mt-2">
                                    <form action="/board/addReply.do?menuId=${menuId }" method="post">
                                        <input type="hidden" name="boardId" value="${boardPost.boardId}" />
                                        <input type="hidden" name="parentCommentId" value="${comment.commentId}" />
                                        <textarea name="commentContent" class="form-control mb-2" rows="3" placeholder="대댓글을 입력하세요." required></textarea>
                                        <button type="submit" class="btn btn-sm btn-primary">대댓글 작성</button>
                                        <button type="button" class="btn btn-sm btn-secondary" onclick="toggleReplyForm('${comment.commentId}')">취소</button>
                                    </form>
                                </div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:forEach>
    </div>
	</main>
</body>
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<script type="text/javascript">
	$(document).ready(function() {

	});
</script>
</html>