<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SNS 메인화면</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript">

	 $(document).ready(function () {
         const fileInput = $('#fileUpload');
         const fileNamesList = $('#fileNamesList');
         const postList = $('#postList');
         // 파일 선택 이벤트
         fileInput.on('change', function () {
             const files = Array.from(fileInput[0].files);

             // 기존 파일 목록 초기화
             fileNamesList.empty();

         });
         
         //스크롤
         $(window).scroll(function() {
		  // 스크롤 이동 시 실행되는 코드
		  $(window).scrollTop();
		  console.log("스크롤중");
		})

         // 게시글 작성
         $('#submitButton').click(function () {
             const title = $('#boardTitle').val();
             const content = $('#boardContent').val();
             const files = fileInput[0].files;
             const menuId=$('#menuId').val();

             console.log(title);
             console.log(content);
             console.log(files);
             console.log("메뉴아이디:"+menuId);
             
             // 유효성 검사
             if (!title.trim() || !content.trim()) {
                 alert('제목과 내용을 입력해주세요.');
                 return;
             }

             // FormData 생성
             const formData = new FormData();
             formData.append('title', title);
             formData.append('content', content);
             formData.append('menuId',menuId);
             if(files.length>0){
            	 Array.from(files).forEach(file => {
                 formData.append('files', file);
             	});
             }
             
             console.log(formData);
				if(confirm("등록하시겠습니까?")){
	             // 게시글 등록
	             $.ajax({
	                 url: '/sns/insBoardPost.do',
	                 type: 'POST',
	                 data: formData,
	                 contentType: false,
	                 processData: false,
	                 success: function (response) {
	                     if (response.success) {
	                         alert('게시글 작성이 완료되었습니다!');
	                        /*  $('#surveyForm')[0].reset(); */
	                         loadPosts(); // 게시글 목록 새로고침
	                        parent.document.location.reload();
	                     } else {
	                         //파일 오류 메시지가 있을 경우
	                       alert(response.message);
	                     }
	                 },
	                 error: function (err) {
	                     // 서버 오류 발생 시
	                     console.error(err);
	                 }
	             });
				}else{return false;}

         });
         
         
         // 게시글 목록 추가
    	
         
         //스크랩하기
         $(document).on('click','.scrap-button',function(){
        	 console.log("스크랩하기");
        	 const boardId=$(this).data('post-id');
        	 const originalBoard=$(`#post-`+boardId);
        	 let fileList=[];
        	 console.log(typeof boardId);
        	 console.log("게시글 아이디"+boardId);
        	 
        	 if(confirm("해당 게시글을 스크랩하시겠습니까?")){
	        		 $.ajax({
	        			 url:'/sns/scrapBoard.do',
	        			 type:'POST',
	        			 data:{boardId:boardId},
	        			 success:function(response){
	        				 alert('스크랩되었습니다');
	        				 loadPosts();
	        				 document.location.reload();
	        			 },
	        			 error:function(err){
	        				 console.error('스크랩 중 오류 발생',err);
	        			 }
	        		 })
        	 }else{
        		 return false;
        	 }
         })
         
         //게시글 삭제
        $(document).on('click','.delete-button',function(){
       	 const postCard=$('#post-${post.boardId}');
       	 const boardId=$(this).data('post-id');
       	 console.log(postCard);
   
       	 console.log("게시글번호:"+boardId);
       	 
       	 if(confirm("해당 게시글을 삭제하시겠습니까?")){
			$.ajax({
				url:'/sns/deleteBoard.do',
				type:'POST',
				data:{boardId:boardId},
				success:function(response){
					alert('삭제되었습니다!');
					console.log(response);
					/* postCard.remove(); */
				     loadPosts();
				     document.location.reload();
				},
				error:function(err){
					console.error('삭제 중 오류 발생',err);
				}
			});       		 
       	 }else{
       		 return false;
       	 }
          })
         
         //스크롤에 필요한 페이지 정보
         let currentPage=1;
         const maxBoard=5;
         let loading=false;
    	//게시글 불러오기
         function loadPosts() {
    		if(loading){
    			return;
    		}
    		loading=true;
        	 
             $.ajax({
                 url: '/sns/getBoardList.do',
                 type: 'GET',
                 dataType:'json',
                 data:{page:currentPage, size:maxBoard},
                 success: function (response) {
                     response.forEach(post => addPostToList(post)); 
                	 console.log(response);
                	 console.log("loadPost page:"+currentPage);
                	 if(response.length>0){             		 
                		 currentPage++;	
                		 console.log("현재페이지:"+currentPage);
                	 }else{
                		 console.log("더이상 게시글없음");
                		 $(window).off('scroll');
                	 }
                	 loading=false;
                 },
                 error: function (err) {
                     console.error('게시글 목록 로드 중 오류 발생:', err);
                     loading=false;
                 }
             });
         }
         // 스크롤
         $(window).on('scroll', function () {
     		console.log($(window).scrollTop()); //스크롤 위치 (수직값)
    		console.log($(window).height());//창의 세로 길이
    		console.log($(document).height());//보여지는 게시글 세로길이
        	if ($(window).scrollTop() + $(window).height() >= $(document).height()-5) {
        		console.log($(window).scrollTop());
        		console.log($(window).height());
        		console.log($(document).height());
                 loadPosts();
        	}
            
         });

         // 페이지 로드 시 기존 게시글 목록 가져오기
         loadPosts(currentPage);
         
         function addPostToList(post) {
        	 var revFiles=post.files;
        	 var revTitles=post.title;
        	 var revContent=post.content;
        	 console.log("파일:"+revFiles+"제목:"+revTitles+"내용:"+revContent);
        	 revFiles.forEach(function(file,index){
        		 console.log("파일:"+(index+1));
        		 console.log("파일명:"+file.originalName);
        		 console.log("파일경로:"+file.filePath);
        	 });
        	 
        	 if(revFiles.length>0){
        		 var fileHtml=`<div><strong>첨부파일:</strong><ul>`;
        		 
        		 revFiles.forEach(function(file){
        			 fileHtml+=`<li><a href="`+file.filePath+`" style="text-decoration:none; color:black;" download="`+file.originalName+`"> `+file.originalName+`</a></li>`;
        			 
        		 })
        		 fileHtml+=`</ul></div>`;
        	 }else{
        		 fileHtml=`<p>첨부파일없음</p>`;
        	 }
        	 
            const postItem = `
                <div class="card mb-3" id='post-`+post.boardId+`'>
                    <div class="card-header">
                    	<div class="button-section">
                   			 	<button class="btn btn-primary edit-button" data-post-id="`+post.boardId+`">수정하기&boardId: `+post.boardId+`</button>
                   				<button class="btn btn-danger delete-button" data-post-id="`+post.boardId+`">삭제하기&boardId:`+post.boardId+`</button>
                   		</div>
                       	<h3>`+post.title+`</h3><h5>작성자:`+post.user+`</h5>
                    </div>
                    <div class="card-body">
                        <h4>`+post.content+`</h4>
                        <p>`+fileHtml+`</p>
                    	<button class="btn btn-primary comment-button" data-post-id="`+post.boardId+`">댓글</button>
                    	<button class="btn btn-success scrap-button" data-post-id="`+post.boardId+`">스크랩하기&boardId:`+post.boardId+`</button>
                    </div>  
                </div>
            `;
             postList.append(postItem);
             

             
         } 
         
         
         function downloadFile(){
        	 if(confirm("다운로드 받으시겠습니까?")){
        		 
        	 }else{
        		 return false;
        	 }
         }
        
		//댓글 버튼
         $(document).on('click','.comment-button',function(){
        	 const postCard=$(this).closest('.card');
        	 const boardId=$(this).data('post-id');
           		const commentArea=document.getElementById('comment-section')
        	 
              // 댓글 입력 및 리스트 영역 추가
              if (postCard.find('.comment-section').length === 0) {
                  const commentSection = `
                      <div class="comment-section mt-3" id="comment-section">
                          <div id="commentList-${boardId}" class="mb-3">
                              <!-- 댓글 리스트-->
                          </div>
                          <div class="input-group">
                          <p>id:`+boardId+`
                              <input type="text" class="form-control" placeholder="댓글을 입력해주세요" id="commentInput-`+boardId+`">
                              <button class="btn btn-primary addCommentButton" data-post-id="`+boardId+`" id="addCommentButton">댓글 달기</button>
                          </div>
                      </div>`;
                  postCard.append(commentSection);

                  // 댓글 리스트 불러오기
                  loadComments(boardId);
              }
           })
           
           //댓글 추가
           $(document).on('click','.addCommentButton',function(){
        	   const boardId = $(this).data('post-id');
        	    console.log("게시글아이디"+boardId);
        	    const commentInput = $(`#commentInput-`+boardId);
        	    const commentText = commentInput.val().trim();
        	    const userId="${userId}";
        	    console.log(userId);
        	    console.log(typeof boardId);
        	    console.log(commentText);
        	    
        	    if (!commentText) {
        	        alert('댓글을 입력해주세요.');
        	        return;
        	    }
        	    
        	    $.ajax({
        	        url: '/sns/addComment.do',
        	        type: 'POST',
        	        data: JSON.stringify({ boardId: boardId, text: commentText, userId:userId  }),
        	        contentType: 'application/json',
        	        success: function (response) {
        	            if (response.success) {
        	            	alert('댓글작성이 되었습니다!');
        	                commentInput.val(''); // 댓글 입력창 초기화
       	                	loadComments(boardId); // 댓글 리스트 새로고침 
        	            } else {
        	                alert('댓글 작성 중 오류가 발생했습니다: ' + response.message);
        	            }
        	        },
        	        error: function (err) {
        	            console.error('댓글 작성 중 오류 발생:', err);
        	        }
        	    });
        	    console.log("댓글 "+commentText);
        	   
           })
           
           //댓글 리스트 불러오기
           function loadComments(boardId) {

        	 console.log("무슨 보드아이디여:"+boardId);
        	    $.ajax({
        	        url: '/sns/getComments.do', // 댓글 리스트 API 엔드포인트
        	        type: 'GET',
        	        data: { boardId: boardId },
        	        success: function (response) {
        	            const commentList = $(`#commentList-${boardId}`);
        	            commentList.empty(); // 기존 댓글 목록 초기화

        	            response.forEach(comment => {
        	                const commentItem = `
        	                    <div class="mb-2" id='comment-`+comment.commentId+`'>
        	                        <strong>`+comment.user+`</strong>:<span> `+comment.content+`</span>
        	                        <button class="btn btn-primary comment-edit-button">수정하기</button>
        	                        <button class="btn btn-danger comment-delete-button" data-post-id="`+comment.commentId+`">삭제하기&`+comment.commentId+`</button>
        	                    </div>`;
        	                commentList.append(commentItem);
        	            });
        	        },
        	        error: function (err) {
        	            console.error('댓글 목록 로드 중 오류 발생:', err);
        	        }
        	    });
        	}
		
		//댓글 수정 버튼
         $(document).on('click','.comment-edit-button',function(){
        	 const commentId=$(this).closest('div').attr('id').split('-')[1];
        	 console.log(commentId);
        	 const commentItem=$(this).closest('div');
        	 console.log(commentItem);
        	 const commentArea=$(this).closest('.mb-2');
        	 console.log(commentArea);
        	 const originalComment=$(this).siblings('strong').next().text().trim();
        	 console.log("text:"+originalComment);
        	 const originalUser=$(this).siblings('strong').text().trim();
        	 

        	 
        	 const commentUpdItem=`<div class="inputComment">
        	 	<strong>`+originalUser+`:</strong>
        	 	<input type="text" value="`+originalComment+`" id="edtInputText">
        	 	 <button class="btn btn-primary save-comment-edit-button" data-post-id="`+commentId+`">수정하기</button>
        	 	 <button class="btn btn-danger cancel-comment-edit-button">취소하기</button>
        	 </div>`;
        	 
        	 commentArea.replaceWith(commentUpdItem);
        	 
        	 
         })
         
         $(document).on('click','.save-comment-edit-button',function(){
        	 const commentId=$(this).data('post-id');
        	 console.log("수정하려는 댓글 아이디:"+commentId);
        	 console.log(typeof commentId);
        	 const edtText=$(this).siblings('#edtInputText').val();
        	 console.log("수정하려는 댓글 내용:"+edtText);
        	 
        	 const boardId=$(this).closest('.card').attr('id').split('-')[1];
        	 console.log("수정하려는 댓글의 부모 게시글 아이디:"+boardId);
        	 
        	 if(confirm("댓글을 수정하시겠습니까?")){
	        	 $.ajax({
	        		 url:'/sns/editComment.do',
	        		 type:'POST',
	        		 data:JSON.stringify({commentId: commentId,
	        			 commentText : edtText,
	        			 boardId:boardId}),
	        		dataType:'json',
	        		contentType:'application/json',
	        		success:function(){
	        			alert('댓글 수정이 완료되었습니다');
	        			loadComments(boardId);
	        		},
	        		error:function(){
	        			alert('댓글 수정 중 오류가 발생하였습니다');
	        		}
	        	 })
        	 }
        	 
         })
         
         
         
         //댓글삭제
         $(document).on('click','.comment-delete-button',function(){
           	 const commentCard=$('#comment-${comment.commentId}');
           	 const commentId=$(this).data('post-id');
           	 
        	 const boardId2=$('.comment-button').data('post-id');
        	 console.log("삭제 버튼 눌렀을때 부모 게시글 아이디:"+boardId2);
           	 console.log("댓글번호:"+commentId);
           	 
           	 if(confirm("해당 댓글을 삭제하시겠습니까?")){
    			$.ajax({
    				url:'/sns/deleteComment.do',
    				type:'POST',
    				data:{commentId:commentId},
    				contentType: 'application/json',
    				success:function(response){
    					loadComments(boardId2);
    					alert('삭제되었습니다!');
    					console.log(response);
    					/* postCard.remove(); */
    					
    				},
    				error:function(err){
    					console.error('삭제 중 오류 발생',err);
    				}
    			});       		 
           	 }else{
           		 return false;
           	 }
              })
             
              
             //기존 작성 내용과 함께 모달 띄우기
             $(document).on('click',".edit-button",function(){
            	 console.log("글 수정");
            	 const boardId=$(this).data('post-id');
            	 const postCard=$(this).closest('.card');
            	 console.log("게시글 아이디"+boardId+",게시글 영역"+postCard);
            	 const title=postCard.find('h3').text();
            	 const content=postCard.find('h4').text();
            	 console.log("제목:"+title);
            	 console.log("내용:"+content);
            	 const files=postCard.find('a').map(function(){
            		 console.log("처리 파일 명:"+$(this).text());
            		 console.log("처리 파일 경로:"+$(this).attr("href"));
            		 return {
            			 fileName: $(this).text(),
            		      filePath: $(this).attr("href"),
            		 };
            	
            	 }).get();

            	 console.log("파일명:"+files[0].fileName+",파일경로:"+files[0].filePath);
            	 
        
            	 $('#editBoardTitle').val(title);
            	 $('#editBoardContent').val(content);
            	 
            	  // 첨부파일 목록 표시
            	  const fileList = $("#editFileList");
            	  fileList.empty();

            	  if (files.length > 0) {
            	    files.forEach((file,index)=> {
            	      fileList.append(
            	        `<li>
            	          <span>`+file.fileName+`</span>
            	          <button class="btn btn-sm btn-danger remove-file-button">삭제</button>
            	        </li>`
            	      );
            	    });
            	  } else {
            	    fileList.html("<p>첨부파일이 없습니다.</p>");
            	  }
            	  
            	 $('#editModal').modal("show");
             })
             
             $(document).on('click','.remove-file-button',function(){
            	 event.preventDefault();
            	 console.log("파일삭제");
            	 $(this).closest('li').remove();
            	 
             })
             
             //수정 폼
             
             $(document).on('click','.edit-board',function(){
            	 console.log("수정갑니데이~");
            	 const title=$('#editBoardTitle').val();
            	 const content=$('#editBoardContent').val();
            	 
            	 console.log(title);
            	 //제목, 내용, 수정파일 (확장자, 개수 체크 )
            	 
             })
             
             $("#editFileUpload").on("change", function () {
            	  const files = Array.from(this.files); // 새로 첨부된 파일 목록
            	  const fileList = $("#editFileList");

            	  // 새로 첨부된 파일 목록 추가
            	  files.forEach((file) => {
            	    fileList.append(
            	      `<li>
            	        <span>`+file.name+`</span>
            	        <button class="btn btn-sm btn-danger remove-file-button">삭제</button>
            	      </li>`
            	    );
            	  });

            	  console.log("새로 첨부된 파일:", files.map((file) => file.name));
            	});
 
       
     });


	
</script>
<style>
body {
	width: 100%;
	height: 100%;
}

.mainHeader {
	width: 70%;
	margin: 0 auto;
	border: 1px solid black;
	border-radius: 5px;
	padding: 20px;
	margin-bottom: 20px;
}

.mainBody {
	width: 70%;
	margin: 0 auto;
}

.form-control {
	width: 100%;
}

.form-floating {
	display: flex;
	flex-direction: column;
}

.mb-4 {
	width: 50%;
}

.card-header {
	display: flex;
	flex-direction: column;
}

.button-section {
	display: flex;
	flex-direction: row;
}

.btn btn-primary {
	margin-left: auto;
}
</style>
</head>
<body>

	<div class="mainHeader">
		<!-- 게시글 작성 -->
		<div id="errorContainer" style="display: none; color: red; margin-bottom: 10px; font-weight: bold;"></div>
		<h4>${userId}님환영합니다</h4>
		<input type="hidden" name="menuId" value="${menuId}" id="menuId">
		<div class="writeSection">
			<div class="form-floating">
				<div class="label">
					<label for="boardTitle">제목</label>
				</div>
				<div class="text-area">
					<input type="text" class="form-control" placeholder="제목을 입력해주세요" id="boardTitle" name="boardTitle">
				</div>
			</div>
			<div class="form-floating">
				<div class="label">
					<label for="boardContent">내용</label>
				</div>
				<div class="text-area">
					<input type="text" class="form-control" placeholder="내용을 입력해주세요" id="boardContent" name="boardContent">
				</div>
			</div>
		</div>
		<!-- 파일 첨부 -->
		<div class="mb-4">
			<label for="fileUpload" class="form-label">파일 첨부(첨부 가능 확장자 : .txt,.pdf)</label> <input type="file" id="fileUpload" name="files" class="form-control" multiple accept=".txt,.pdf">
		</div>

		<!-- 미리보기 -->
		<!-- 		<div id="previewContainer" class="mb-4">
			<p class="text-muted">미리보기</p>
			<div id="previewList"></div>
			<input type="hidden" id="thumbnailIndex" name="thumbnailIndex" value="0">
		</div> -->

		<button class="btn btn-primary" id="submitButton">작성하기</button>
	</div>


	<!--게시글 영역-->
	<div class="mainBody">
		<h2>게시글 목록</h2>
		<div id="postList">
			<!-- 게시글 목록 -->

		</div>

	</div>


	<!-- 게시글 수정 모달창 -->

	<div class="modal" tabindex="1" id="editModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">수정하기</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form id="editPostForm">
						<input type="hidden" id="editBoardId">
						<div class="mb-3">
							<label for="editBoardTitle" class="form-label">제목</label> <input type="text" class="form-control" id="editBoardTitle" placeholder="제목을 입력하세요">
						</div>
						<div class="mb-3">
							<label for="editBoardContent" class="form-label">내용</label>
							<textarea class="form-control" id="editBoardContent" rows="3" placeholder="내용을 입력하세요"></textarea>
						</div>
						<div class="mb-3">
							<label class="form-label">첨부파일</label>
							<ul id="editFileList"></ul>
							<label for="editFileUpload" class="form-label mt-2">파일 추가</label> <input type="file" id="editFileUpload" class="form-control" multiple accept=".txt,.pdf">
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소하기</button>
					<button type="button" class="btn btn-primary edit-board">수정하기</button>
				</div>
			</div>
		</div>
	</div>




</body>


</html>