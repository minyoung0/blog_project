<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>블로그 메인 페이지</title>

<!-- Bootstrap CSS -->
 <script src="https://code.jquery.com/jquery-3.6.1.min.js"></script>
 <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
	

<style>
.blog-logo {
	max-width: 200px; /* 로고 크기 조정 */
	display: block;
	margin: 10px auto; /* 가운데 정렬 */
}

.nav-container {
	width: 50%;
	margin: 0 auto; /* 네비게이션 바도 중앙 정렬 */
}

img {
	width: 100%;
}

.submit-reply-btn, .addReplyBtn{
	background-color:#5BA48E;
	border:none;
	min-width: 60px;              
	white-space: nowrap;
}

.addReplyBtn:hover{
	color:#5BA48E;
	border:none;
	background-color:white;
	border:1px solid #5BA48E;
}

.reply-form{
	display:flex;
	flex-direction:row;
	gap:8px;
	min-height:35px;
}


.edit-comment-btn{
	margin-right:8px;
	}


</style>
</head>
<body class="bg-light">
	<div class="container w-75 mx-auto mt-4 p-4 bg-white shadow rounded">
		<%
		String userId = (String) session.getAttribute("userId");
		%>
		<!-- 게시글 리스트 -->
		<div class="mt-3">
		    <c:forEach var="post" items="${post}">
		        <div class="card mb-3">
		            <div class="card-body d-flex">
		                <!-- 프로필 이미지 -->
		                <a href="/blog/myPage.do?blogUserId=${post.userId}">
		                    <img src="${post.profileImage}" alt="프로필"
		                         class="rounded-circle me-3" style="width: 50px; height: 50px; cursor: pointer;">
		                </a>
		
		                <!-- 게시글 내용 -->
		                <div class="flex-grow-1">
		                    <!-- ✅ 제목 (구독 버튼 제거) -->
		                    <h5 class="card-title mb-1 fw-bold">${post.title}</h5>
		
		                    <!-- ✅ 닉네임 + 날짜 + 구독 버튼을 한 줄로 배치 -->
		                    <div class="d-flex align-items-center">
		                        <p class="card-text text-muted fs-6 mb-0">${post.nickName} · ${post.createAt}</p>
		
		                        <c:if test="${userId ne post.userId && userId !=null && post.status ne 'active'}">
		                            <button class="btn btn-outline-success btn-sm ms-3 neighborBtn" data-user-id="${post.userId }">
		                                <i class="bi bi-person-circle"></i> 구독
		                            </button>
		                        </c:if>
		                    </div>
		
		                    <!-- ✅ 본문 -->
		                    <p class="card-text">${post.content}</p>
		
		                    <!-- 좋아요 & 댓글 버튼 -->
		                    <div>
		                        <button class="btn btn-outline-primary btn-sm me-2 likeBtn" id="likeBtn" data-post-id="${post.postId }">
		                            ❤️ 좋아요 <span class="badge bg-secondary"></span>
		                        </button>
		                        <button class="btn btn-outline-secondary btn-sm commentBtn" id="commentBtn" data-post-id="${post.postId }" >
		                            💬 댓글 <span class="badge bg-secondary"></span>
		                        </button>
		                    </div>
		                    <!-- 댓글 영역 (초기엔 숨김) -->
							<div class="comment-section mt-3" style="display: none;">
							    <!-- 댓글 목록 -->
							    <div class="comment-list mb-3">
							        <!-- 예시 댓글 -->
							        <div class="d-flex mb-2">
							          
							        </div>
							        <!-- 반복 출력 가능 -->
							    </div>
							
							    <!-- 댓글 작성 -->
							    <form class="comment-form d-flex">
							        <input type="text" class="form-control me-2" placeholder="댓글을 입력하세요">
							        <button type="button" class="btn btn-primary addReplyBtn" data-post-id="${post.postId}">등록</button>
							    </form>
							</div>
		                </div>
		            </div>
		        </div>
		    </c:forEach>
		</div>
		<jsp:include page="chattingLayout.jsp" />
		
	</div>
	
	<!-- Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script>
/* 		document.addEventListener("DOMContentLoaded", function () {
		    const chatBtn = document.getElementById("chatToggleBtn");
		    const chatPopup = document.getElementById("chatPopup");
		    const closeBtn = document.getElementById("chatCloseBtn");
	
		    chatBtn.addEventListener("click", function () {
		        chatPopup.style.display = (chatPopup.style.display === "none" || chatPopup.style.display === "") ? "block" : "none";
		    });
	
		    closeBtn.addEventListener("click", function () {
		        chatPopup.style.display = "none";
		    });
		}); */
		$(document).ready(function(){
			/* $('#chatToggleBtn').click(function(e){
				console.log("클릭ㄱ긱");
				const userId=`${userId}`;
				const chatContainer=$('#chatContainer');				
				
				e.preventDefault();
				$.ajax({
					url:'/chat/getChatList.do',
					type:'get',
					data:{userId:userId},
					success:function(response){
						chatContainer.html(response);
					},error:function(){
						console.log("에러");
					}
				})
			}) */
			
			$(document).on('click', '.neighborBtn', function(e) {
				e.preventDefault();
				const userId = $(this).data('user-id');
				console.log("구독 대상:", userId);

				if (confirm("구독하시겠습니까?")) {
					$.ajax({
						url: '/blog/subscribe.do',
						type: 'post',
						data: { ownerId: userId },
						success: function () {
							alert("구독 완료 되었습니다");
							window.location.reload();
						},
						error: function (xhr, status, error) {
							console.error(error);
						}
					});
				} else {
					return false;
				}
			});

			
			$('.commentBtn').click(function(e){
				e.preventDefault();
				 const postId = $(this).data('post-id');
			    const $commentSection = $(this).closest('.card-body').find('.comment-section');
			    const userId = `${userId}`;
			    $commentSection.slideToggle();
			    reloadComments(postId, $commentSection, userId);
			})
			
			$(document).on('click', '#likeBtn', function(e){
				e.preventDefault();
				const postId = $(this).data('post-id');
				console.log("게시글 번호:"+postId);
				const userId=`${userId}`;
				console.log("userId: "+userId);
				if(userId===''){
					alert("로그인 이후 사용가능한 기능입니다");
					return false;
				}
				$.ajax({
					url:'/blog/addLike.do',
					type:'get',
					data:{postId:postId},
					success:function(e){
						console.log("좋아요");
					},error:function(err){
						console.log("에러발생");
					}
				})
			})
			
			// 여러 댓글 버튼과 영역을 구분해서 작동하게 만들기
			
			function reloadComments(postId, $commentSection, userId) {
				    const commentList = $commentSection.find('.comment-list');
				    commentList.empty().append('<div class="text-muted">불러오는 중...</div>');
				
				    $.ajax({
				        url: '/blog/getComment.do',
				        type: 'post',
				        data: { postId: postId },
				        success: function(response) {
				            const list = response.commentList;
				            commentList.empty();
				
				            if (!list || list.length === 0) {
				                commentList.append('<div class="text-muted">댓글이 없습니다.</div>');
				            } else {
				            	renderCommentsRecursive(list, commentList, 0,userId);
				            }
				        },
				        error: function() {
				            commentList.html('<div class="text-danger">댓글 로딩 실패</div>');
				        }
				    });
				}
			
				function renderCommentsRecursive(comments, $container, depth,userId) {
				    comments.forEach(c => {
				        const isMine = c.userId === userId;
				        const indentClass = 'ms-' + (depth * 4); // Bootstrap 들여쓰기 클래스
				        const isReply = depth > 0;
				        const replyIcon = isReply ? `<i class="bi bi-arrow-return-right me-1 text-secondary"></i>` : '';
						const isUpdate= c.updateAt? c.updateAt+` (수정됨)` : c.createAt;

				        console.log("depth: "+indentClass);
				        console.log("children: "+c.children);
	
				        if (c.deleteYn === 'Y') {
				        	 $comment = $(`
				                     <div class="d-flex mb-3 `+indentClass+`">
				                         <div class="bg-light text-muted fst-italic p-2 rounded w-100" style="border-left: 3px solid #ccc;">삭제된 댓글입니다.</div>
				                     </div>
				                 `);
				        }else{
				        	$comment = $(`
						            <div class="d-flex mb-3 `+indentClass+`">
						                <img src="`+c.profileImage+`" alt="프로필"
						                    class="rounded-circle me-2" style="width: 40px; height: 40px;">
						                <div class="flex-grow-1">
						                    <div class="d-flex align-items-center mb-1 justify-content-between">
						                        <div>
						                            <strong class="me-2">`+replyIcon+c.nickName+`</strong>
						                            <small class="text-muted">`+isUpdate+`</small>
						                            </div>
			                                        ` + (isMine ?
			                                            '<div>' +
			                                                '<button class="btn btn-sm btn-outline-secondary edit-comment-btn" data-comment-id="' + c.commentId + '">수정</button>' +
			                                                '<button class="btn btn-sm btn-outline-danger delete-comment-btn" data-comment-id="' + c.commentId + '">삭제</button>' +
			                                            '</div>' : '') + `
			                                    </div>
						                    <p class="mb-1 comment-content">`+c.content+`</p>
						                    <button class="btn btn-sm btn-link reply-comment-btn text-decoration-none" data-parent-id="`+c.commentId+`">↪ 대댓글 달기</button>
						                    <div class="reply-form mt-2" style="display: none;">
						                        <input type="text" class="form-control form-control-sm mb-1" placeholder="대댓글을 입력하세요">
						                        <button class="btn btn-sm btn-primary submit-reply-btn addReplyBtn"
						                            data-parent-id="`+c.commentId+`" data-post-id="`+c.postId+`">등록</button>
						                    </div>
						                </div>
						            </div>
						        `);
				        	}
				    
				        $container.append($comment);
	
				        // ✅ 자식이 있으면 재귀 호출
				        if (c.children && c.children.length > 0) {
				            renderCommentsRecursive(c.children, $container, depth + 1,userId);
				            console.log("자식있음");
				        }
				    });
				}
				
			
				$(document).on('click','.edit-comment-btn',function(e){
					e.preventDefault();
					console.log("클릭");
					const $btn=$(this);
					const $commentBlock=$btn.closest('.d-flex.mb-3');
					const $contentP=$commentBlock.find('.comment-content');
					const originalContent=$contentP.text().trim();
					const userId = `${userId}`;
					 // 수정 중이 아니면 → 수정 모드로 전환
				    if (!$btn.hasClass('editing')) {
				        const inputHtml = `<input type="text" class="form-control form-control-sm edit-input mb-1" value="`+originalContent+`">`;
				        $contentP.replaceWith(inputHtml);

				        $btn.text('수정 완료').addClass('editing');
				    } else {
				        // 수정 완료 눌렀을 때
				        const newContent = $commentBlock.find('.edit-input').val().trim();
				        const commentId = $btn.data('comment-id');
				        const postId = $btn.closest('.card-body').find('.commentBtn').data('post-id');
				        const $commentSection = $btn.closest('.card-body').find('.comment-section');

				        if (!newContent) {
				            alert('수정할 내용을 입력하세요.');
				            return;
				        }

				         $.ajax({
				            url: '/blog/updateComment.do',
				            type: 'post',
				            data: {
				                commentId: commentId,
				                content: newContent
				            },
				            success: function() {
				                alert('댓글이 수정되었습니다.');
				                reloadComments(postId, $commentSection, userId);
				            },
				            error: function() {
				                alert('수정 중 오류 발생');
				            }
				        }); 
				    }
				})
				
				$(document).on('click','.delete-comment-btn',function(e){
					e.preventDefault();
					const commentId=$(this).data('comment-id');
					const $btn=$(this);
					const postId = $btn.closest('.card-body').find('.commentBtn').data('post-id');
			        const $commentSection = $btn.closest('.card-body').find('.comment-section');
			        const userId = `${userId}`;
					console.log("commentId: "+commentId);
					if(confirm("삭제하시겠습니까?")){
						$.ajax({
							url:'/blog/deleteComment.do',
							type:'get',
							data:{commentId:commentId},
							success:function(){
								alert('삭제되었습니다');
								reloadComments(postId,$commentSection,userId);
							},error:function(){
								console.log("에러발생");
							}
						})
					}else{
						return false;
					}
				})


			// 댓글 목록 전체에 이벤트 위임
			    $(document).on('click', '.reply-comment-btn', function(e) {
			        e.preventDefault();

			        // 현재 버튼 기준으로 같은 댓글 내에 있는 reply-form 찾아서 토글
			        $(this).siblings('.reply-form').slideToggle();
			    });
			
			
			$(document).on('click','.addReplyBtn',function(e){
				e.preventDefault();
				const $btn = $(this); // 클릭된 버튼
			    const content = $btn.siblings('input').val(); // 같은 줄에 있는 input
			    const $commentSection = $(this).closest('.card-body').find('.comment-section');
			    const postId = $btn.data('post-id');
			    const parentId = $btn.data('parent-id'); // 댓글이면 없음, 대댓글이면 있음
			    const userId = `${userId}`;
			    console.log("postId: "+postId);
			    console.log("commentId: "+parentId);
			    console.log("content: "+content);
			    
			    if(!userId){
			    	alert('로그인이 필요합니다');
			    	window.location.href='/blog/loginPage.do';
			    	return;
			    }
			    if (!content.trim()) {
			        alert('내용을 입력하세요');
			        return;
			    }
			    
				if(confirm("댓글 등록하시겠습니까?")){
					$.ajax({
						url:'/blog/addComment.do',
						type:'post',
						data:{
							postId:postId,
							parentId:parentId,
							content:content,
							userId:userId
						},success:function(){
							reloadComments(postId,$commentSection,userId);
						},error:function(){
							console.log("에러발생");
						}
					})
				}else{
					return false;
				}
			})

		})
	</script>
</body>
</html>
