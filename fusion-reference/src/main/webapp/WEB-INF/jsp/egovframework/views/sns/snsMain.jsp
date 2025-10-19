<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SNS 메인화면</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<script type="text/javascript">
	 $(document).ready(function () {
         const fileInput = $('#fileUpload');
         const fileNamesList = $('#fileNamesList');
         const postList = $('#postList');
         const followRequestList=$('#follow-request-section');
         const requestCount=$('#requestCount');
     	//글자수 제한
   	  const titleInput = $('#boardTitle');
       const contentInput = $('#boardContent');
       const commentInput=$('.commentArea');
       
       // 제목 제한: 30자 초과 시 경고
       titleInput.on('input', function () {
           const maxLength = 30;
           
           if ($(this).val().length > maxLength) {
               alert(`제목은 30자를 초과할 수 없습니다.`);
               $(this).val($(this).val().substring(0, maxLength)); // 초과된 글자 제거
           }
           $('#titleLength').text($(this).val().length);
           
           
       });
       
       // 내용 제한: 100자 초과 시 경고
       contentInput.on('input', function () {
           const maxLength = 100;
           if ($(this).val().length > maxLength) {
               alert(`내용은 100자를 초과할 수 없습니다.`);
               $(this).val($(this).val().substring(0, maxLength)); // 초과된 글자 제거
           }
           $('#contentLength').text($(this).val().length);
       });

   	
   	
         // 파일 선택 이벤트
         fileInput.on('change', function () {
             const files = Array.from(fileInput[0].files);
             const allowedExtensions = ['txt'];
             const maxFiles = 3;

             // 기존 파일 목록 초기화
             fileNamesList.empty();

         });

         // 게시글 작성
         let uploadedFiles=[];
         //게시글 업로드 파일 미리보기
         $("#fileUpload").on("change", function () {
        	    const files = Array.from(this.files);
        	    const filePreview = $("#filePreview");

        	    // 새로 첨부된 파일을 미리보기 리스트에 추가
        	    files.forEach((file, index) => {
        	    	uploadedFiles.push(file);

        	        const fileIndex = uploadedFiles.length - 1; // 파일 인덱스
        	        const listItem = `
        	            <li class="list-group-item d-flex justify-content-between align-items-center" data-index="`+fileIndex+`">
        	                <span>`+file.name+`</span>
        	                <button class="btn btn-sm btn-danger remove-file-button">삭제</button>
        	            </li>
        	        `;
        	        filePreview.append(listItem);
        	    });

        	    console.log("업로드된 파일 목록:", uploadedFiles.map(f => f.name));
        	});
         
         
      	//글 작성 파일 삭제 버튼 클릭 시
         $(document).on("click", ".remove-file-button", function () {
             const listItem = $(this).closest("li");
             const fileIndex = listItem.data("index");

             console.log("삭제할 파일 인덱스:", fileIndex);

             // 파일 목록에서 제거
             uploadedFiles.splice(fileIndex, 1);

             // 미리보기 리스트에서 제거
             listItem.remove();

             console.log("삭제 후 파일 목록:", uploadedFiles.map(f => f.name));
         });

      	//글 작성 버튼 
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
             if(uploadedFiles.length>0){
            	 Array.from(uploadedFiles).forEach(file => {
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
         
         let keyword=null;
         let searchType=null;
/*          let year=null;
         let month=null;
         let day=null; */
         let startDate=null;
         let endDate=null;
         
         //검색
         $(document).on('click','.searchMainCode',function(){
        	 console.log("검색 로직 수행예정");
        	 searchType=document.getElementById("searchType").value;
        	  keyword=document.getElementById("keyword").value;
        	  
        	 
        	 console.log("검색타입:"+searchType+",키워드:"+keyword);

    		 startDate=$('#startDate').val();
    		 endDate=$('#endDate').val();
    		 console.log("시작일"+startDate);
  
    	    currentPage = 0;
    	    $('#postList').empty();
 /*    	    console.log(year+","+month+","+day); */
 
 			console.log(searchType);
 
    	    loadPosts(searchType, keyword, startDate,endDate);

         })
         
         
         
         /////////////////////////////////////////////////////////////////////////////////////////////////
    	//게시글 불러오기
         function loadPosts(searchType, keyword,startDate,endDate) {
        	 console.log(searchType)
        	 if(searchType===1){
        		 searchType="";
        	 }
    		if(loading){
    			return;
    		}
    		loading=true;
    		
    		const data = { page: currentPage, size: maxBoard, startDate: startDate, endDate:endDate, searchType:searchType,keyword : keyword};

        	 console.log("!!!!!!!!!!"+data.keyword);
             $.ajax({
                 url: '/sns/getBoardList.do',
                 type: 'GET',
                 dataType:'json',
                 data:data,
                 success: function (response) {
                	 console.log(response);
                	 console.log("loadPost page:"+currentPage);
                	 if(response.length>0){             		 
                		 currentPage++;	
                		 console.log("현재페이지:"+currentPage);
                	 }else{
                		 console.log("더이상 게시글없음");
                		 $(window).off('scroll');
		                	 }
				
					if(currentPage==1){
						$('#post-container').html("");
					}
					
	
					 let template = $('.post-template');
					 
					 response.forEach(post => {
						 
			        	    const highlight = (text, keyword) => {
			        	        const regex = new RegExp(keyword, 'gi'); 
			        	        return text.replace(regex, `<span class="highlight" style="background:yellow;">`+keyword+`</span>`);
			        	    };

			        	    // 하이라이트 적용 범위 결정
			        	    let user = post.user;
			        	    let content = post.content;
			        	    let title = post.title;
							
			        	    
			        	    if (keyword) {
			        	        if (searchType === 'writer') {
			        	            user = highlight(post.user, keyword);
			        	        } else if (searchType === 'content') {
			        	            content = highlight(post.content, keyword);
			        	        } 
			        	    }
		 
					     let newPost = template.clone();  // 템플릿 복사
					     newPost.removeClass('post-template');
					     newPost.addClass('post');
					     newPost.show();
						console.log("제목:"+post.title+",내용:"+post.content+",작성자:"+post.user+"사용자와 작성자의 관계:"+post.followStatus);
						
					 
					     newPost.find('.post-title').html(post.title);
					     console.dir(newPost.find('.post-title'));
					     newPost.find('.post-content').html(post.content);
					     newPost.find('.post-user').html(post.user);
					     newPost.find('.post-writeDate').html(post.writeDate);
					     
					     if(post.scrapOriginalUser!=null){					    	 
					     newPost.find('.post-scrapOriginalUser').html("출처:"+post.scrapOriginalUser);
					     }
					
					    
					     newPost.find('.comment-container').attr('id',`comment-container-`+post.boardId);
					     newPost.find('.edit-button').attr('data-post-id', post.boardId);
					     newPost.find('.delete-button').attr('data-post-id', post.boardId);
					     newPost.find('.comment-button').attr('data-post-id', post.boardId);
					     newPost.find('.scrap-button').attr('data-post-id', post.boardId);
					     newPost.find('.follow').attr('data-follow-id',post.user);
					     newPost.find('.follow-ing').attr('data-follow-id',post.user);
					     newPost.find('.followed').attr('data-follow-id',post.user);
					
					   
					     let fileListContainer=newPost.find('.post-files');
					     if(post.files&&post.files.length>0){
					    	 post.files.forEach(file=>{					    		 
					    	 let fileItem=`<li><a href="`+file.filePath+`" style="text-decoration:none; color:black;" download="`+file.originalName+`"> `+file.originalName+`</a></li>`;
					    	 fileListContainer.append(fileItem);
					    	 })
					     }else{
					    	 fileListContainer.append("<li>첨부파일없음</li>")
					   
					     }
					     
					     if(post.followStatus===1){
					    	 console.log("followStatus 1");
					    	 newPost.find('.follow-ing').show();
					     }else if(post.followStatus===2){
					    	 console.log("followStatus 2");
					    	 newPost.find('.followed').show();
					     }else if(post.followStatus===0){
					    	 console.log("followStatus 0");
					    	 newPost.find('.follow').show();
					     }
					     
					     $('#post-container').append(newPost);
		               	 loading=false;
		                 })
                },                 
                 error: function (xhr) {
                     console.error('게시글 목록 로드 중 오류 발생:', xhr);
                     alert(xhr.responseText);
                     loading=false;
                 }
             });
         }
    	
    	
    	
    	
         // 스크롤
         $(window).on('scroll', function () {
        	if ($(window).scrollTop() + $(window).height() >= $(document).height()-5) {
        		console.log("searchType:"+searchType);
                 loadPosts(searchType, keyword,startDate,endDate);
        	}
            
         });

         // 페이지 로드 시 기존 게시글 목록 가져오기
         loadPosts(currentPage);
         
         ////////////////게시글 html
         function addPostToList(post,keyword,searchType) {
        	 var userId = '<%=(String) session.getAttribute("userId")%>';
        	 console.log("사용자"+userId);
        	 	console.log("사용자 권한:"+post.accessRight);
        	 	
        	    const highlight = (text, keyword) => {
        	        const regex = new RegExp(keyword, 'gi'); 
        	        return text.replace(regex, `<span class="highlight" style="background:yellow;">`+keyword+`</span>`);
        	    };

        	    // 하이라이트 적용 범위 결정
        	    let user = post.user;
        	    let content = post.content;
        	    let title = post.title;
				
        	    
        	    if (keyword) {
        	        if (searchType === 'writer') {
        	            user = highlight(post.user, keyword);
        	        } else if (searchType === 'content') {
        	            content = highlight(post.content, keyword);
        	        } 
        	    }

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
           	const userAccess=$(this).data('user-access');
           		console.log("댓글 버튼"+userAccess);
			const commentSection=postCard.find('.comment-section');
			const commentSection2=$('.comment-container');
			
		             // 댓글 입력 및 리스트 영역 추가
              if (commentSection.length === 0) {
                  const commentSection = `
                      <div class="comment-section mt-3" id="comment-section" >
                          <div class="input-group">
                              <input type="text" class="form-control commentArea" placeholder="댓글을 입력해주세요" id="commentInput-`+boardId+`">
                              <div >
                              	<span id="commentLength" class="commentLength">0</span>/30 자
                              </div>
                              <button class="btn btn-primary addCommentButton" data-post-id="`+boardId+`" id="addCommentButton">댓글 달기</button>
                          </div>
                      </div>`;
                  postCard.append(commentSection);

                  // 댓글 리스트 불러오기
                  loadComments(boardId,userAccess);
                  commentSection2.toggle();
              }
		    const comment=$(`#commentInput-`+boardId);
			comment.on('input', function () {
		           const maxLength = 30;
		           if ($(this).val().length > maxLength) {
		               alert(`내용은 30자를 초과할 수 없습니다.`);
		               $(this).val($(this).val().substring(0, maxLength)); // 초과된 글자 제거
		           }
		           $('.commentLength').text($(this).val().length);
		       });
        
              commentSection.toggle();
              commentSection2.toggle();
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
        	                commentInput.val(''); // 댓글 입력창 초기화")
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
           function loadComments(boardId,userAccess) {

        	 var userId = '<%=(String) session.getAttribute("userId")%>';
        	 console.log("무슨 보드아이디여:"+boardId);
        	    $.ajax({
        	        url: '/sns/getComments.do', // 댓글 리스트 API 엔드포인트
        	        type: 'GET',
        	        data: { boardId: boardId },
        	        dataType:'html',
        	        success: function (response) {
        	        	const commentContainer=$('#comment-container-'+boardId);
        	        	commentContainer.html(response);
        	        	console.log(commentContainer);
						console.log(response);
						console.log("댓글 리스트 불러오기 성공");
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
         
         //댓글 수정하기 
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
    				dataType:'json',
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
             
              
              /////////////////////////////////////////////////////////////////////////////////////////////////////
         let existingFiles = [];
		 let newFiles=[];
		 let deleteExistingFiles=[];
         //기존 작성 내용과 함께 모달 띄우기
         $(document).on('click',".edit-button",function(){
        	 
      
        	 console.log("글 수정");
        	 const boardId=$(this).data('post-id');
        	 const postCard=$(this).closest('.card');
        	 const title=postCard.find('h3').text();
        	 const content=postCard.find('h4').text();
        	 existingFiles=postCard.find('a').map(function(){
        		 console.log("처리 파일 명:"+$(this).text());
        		 console.log("처리 파일 경로:"+$(this).attr("href"));
        		 return {
        			 fileName: $(this).text(),
        		      filePath: $(this).attr("href"),
        		 };
        	
        	 }).get();
        	 
  	 		//기존 내용 db에서 가져오기
        	 $.ajax({
        		 url:'/sns/getBoardDetail.do',
        		 type:'GET',
        		 data:{boardId:boardId},
        		 success:function(response){
        		 	 $('#editBoardTitle').val(response.title);
                	 $('#editBoardContent').val(response.content);
        		 },
        		 error:function(err){
        			 alert(err);
        		 }
        	 })
        	 
        	 
        	 console.log("게시글 아이디"+boardId+",게시글 영역"+postCard);
/*         	 console.log("제목:"+title);
        	 console.log("내용:"+content);
        	  */
    
        	 $('#editBoardTitle').val(title);
        	 $('#editBoardContent').val(content);
        	 
        	  // 첨부파일 목록 표시
        	  const fileList = $("#editFileList");
        	  fileList.empty();

        	  if (existingFiles.length > 0) {
        		  existingFiles.forEach((file,index)=> {
        	      fileList.append(
        	        `<li data-index="`+index+`" data-type="existing" data-path="`+file.filePath+`">
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
        	 
        	  const fileItem = $(this).closest("li");
        	  const fileType = fileItem.data("type");
        	  const fileIndex = fileItem.data("index");
        	 /*  const filePath=$('.card-body').find('a').attr("href"); */
        	  const filePath=fileItem.data("path");
        	  
        	  console.log("삭제하려는 파일 경로:"+filePath);
        	  console.log(fileItem);
        	  console.log(fileType);
        	  console.log(fileIndex);
        	  
        	  if(fileType==="existing"){
        		  console.log("삭제하는 파일 정보:"+existingFiles[fileIndex]);
        		  existingFiles.splice(fileIndex,1);
        		  deleteExistingFiles.push(filePath);
        		  
        	  }else if(fileType==="new"){
        		  console.log("삭제하는 파일 정보:"+newFiles[fileIndex]);
        		  newFiles.splice(fileIndex,1)
        	  }
        	  
        	 console.log("파일삭제");
        	 $(this).closest('li').remove();
        	 
         })
         
         //수정 폼
         
         $(document).on('click','.edit-board',function(){
        	 const boardId=$('.edit-button').data('post-id');
        	  const editFileInput=$('#editFileUpload');
        	 const title=$('#editBoardTitle').val();
        	 const content=$('#editBoardContent').val();
        	 const files = editFileInput[0].files
        	 
        	 
        	 console.log("게시글아이디:"+boardId);
        	 console.log("수정갑니데이~");
        	 console.log("파일"+editFileInput[0].files);
        	 console.log("기존의 파일"+existingFiles);
        	 
        	 const formData=new FormData();
        	 formData.append('title',title);
        	 formData.append('content',content);
        	 formData.append('boardId',boardId);
        	 
        	 

        	  // 새로 업로드된 파일 추가
        	  newFiles.forEach((file) => {
        	    formData.append("files", file);
        	  });
        	  
        	  deleteExistingFiles.forEach((file)=>{
        		  formData.append("deleteFiles",file);
        	  })

        	 
        	 for (const value of formData.values()) {
        		  console.log(value);
        		};
        	
        	for(const x of formData.entries()){
        		console.log(x);
        	}

        	 console.log(formData);
        	 //제목, 내용, 수정파일 (확장자, 개수 체크 )
        	 if(confirm('수정하시겠습니까?')){
        		 $.ajax({
	                 url: '/sns/updBoardPost.do',
	                 type: 'POST',
	                 data: formData,
	                 contentType: false,
	                 processData: false,
	                 success: function (response) {
	                     if (response.success) {
	                         alert('게시글 수정이 완료되었습니다!');
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
        	 }else{
        		 return false;
        	 }
        	 

        	 
         })
         
         $("#editFileUpload").on("change", function () {
        	  const files = Array.from(this.files); // 새로 첨부된 파일 목록
        	  const fileList = $("#editFileList");

        	  // 새로 첨부된 파일 목록 추가
        	  files.forEach((file,index) => {
        		  newFiles.push(file);
        	  console.log("newFilesLength:"+newFiles.length);
        	  console.log(index);
        	    fileList.append(
        	      `<li data-index="`+(newFiles.length-1)+`" data-type="new">
        	        <span>`+file.name+`</span>
        	        <button class="btn btn-sm btn-danger remove-file-button">삭제</button>
        	      </li>`
        	    );
        	  
        	  });

        	  console.log("새로 첨부된 파일:", files.map((file) => file.name));
        	});
         
         


         //날짜 검색 이벤트
		  const selectType = document.getElementById("searchType");
         selectType.addEventListener("change",function(){
        	 const keyword=document.getElementById("keyword");
        	 const dateselectSection=document.getElementById("dateselectSection");
        	 
        	 if(this.value==="writeDate"){
        		 dateselectSection.style.display="inline";
        		 keyword.style.display="none";
        	 }
        	 else{
        		 dateselectSection.style.display="none";
        		 keyword.style.display="inline";
        	 }
         })
         
         
         //내 팔로우 모달창
         $(document).on('click','.my-follow-button',function(){
        	 $('#followModal').modal("show");
        	 //팔로우 요청 수 받아오기
        	 $.ajax({
        		 url:'/sns/getFollowDetail.do',
        		 type:'GET',
        		 success:function(response){
        			 requestCount.empty();
        			 const count=`(`+response.count+`)`;
        			 requestCount.append(count);
        			 console.log(response);
        			 //팔로워
         			 const followerList = response.followerList; 
        	            const followContainer = $('#followerListUl');
        	            followContainer.empty(); 
        	            followerList.forEach(follow => {
        	            	console.log(follow);
        	                followContainer.append(`<li class="list-group-item"><i class="bi bi-person"></i>`+follow.followingId+`</li>`);
        	            }); 
        	         //팔로잉    
        	            const followingList = response.followingList; 
        	            const followingContainer = $('#followingListUl'); 
        	            followingContainer.empty();
        	            followingList.forEach(following => {
        	             followingContainer.append(`<li class="list-group-item" id="followingListSection"><i class="bi bi-person"></i>`+following.followerId+`<button type="button" class="btn btn-outline-danger followCancel" data-follow-id="`+following.followerId+`">팔로우 취소</button></li>`);
        	            });
        			 
        		 },
        		 error:function(err){
        			 console.log(err);
        			 
        		 }
        	 })
        	 
       
        	 
         })
         

         
         //내 팔로우 모달 -요청 모달
         $(document).on('click','.myFollowRequest',function(){  
        	 //팔로워 아이디 = 내 아이디 & 상태 =2
        	 followRequestList.empty();
        	 $.ajax({
        		 url:'/sns/getFollowRequest.do',
        		 type:'GET',
        		 success:function(response){
        			 console.log("요청 리스트 호출 완료");
        			 console.log(response.message);
                  	response.forEach(post=>{
        			 console.log("@@@@수락 or 거절 하려는 아이디"+post.followingId);
                 		const followRequestItem=`<div>
                 			<ul class="list-group">
                 				<li class="list-group-item" id="followRequestUser">`+post.followingId+`
	                    				<div class="followRequest-button">
	                    					<button class="btn btn-outline-info followRequestYes" data-following-id="`+post.followingId+`">수락</button>
	                    					<button class="btn btn-outline-warning followRequestNo" data-following-id="`+post.followingId+`">거절</button>
	                    				</div>
                 				</li>
                 			</ul>
                 		</div>`;
                 		followRequestList.append(followRequestItem);
                 	}) 
        			 
        		 },
        		 error:function(err){
        			 console.log("요청 중 에러발생");
        		 }
        	 })
        	 
        	 $('#myFollowRequestModal').modal("show");
         })
         
  
         //상대 팔로우 
         $(document).on('click','.follow',function(){
        	 console.log("팔로우버튼 동작");
        	 //작성자 - 팔로워
        	 const follower = $(this).data('follow-id');
        	 const following = '<%=(String) session.getAttribute("userId")%>';    
        	 const button=$(this);
        	
        	 console.log(follower);
        	 console.log(following);
        	 //나 - 팔로잉
        	 if(confirm("팔로우 하시겠습니까?")){
        		 $.ajax({
        			 url:'/sns/followRequest.do',
        			 type:'POST',
        			 data:{
        				 followerId:follower,
        				 followingId:following
        			 },
            		 dataType:'json',
                     success: function (response) {
                    	 alert("팔로우신청이 완료되었습니다");
                      	 $('.follow[data-follow-id="'+follower+'"]')
                    	 .removeClass(' follow btn-outline-secondary')
                    	 .addClass('follow-ing btn-secondary ')
                    	 .text('요청중')
               
                    	},
                     error: function (err) {
                         // 서버 오류 발생 시
                         alert(err);
                     }
        			 
        			 
        		 })
        	 }else {return false;}
        	 
         })
         
         //팔로우 수락
         $(document).on('click','.followRequestYes',function(){
        	 console.log("수락입니더~");
        	 const followerId = $(this).data('following-id');
           	 const userId = '<%=(String) session.getAttribute("userId")%>';  
           	 const followRequestSection=$(this).closest('.list-group-item');
        	 console.log("나한테 팔로우 요청한 사람 아이디:"+followerId);
        	 
        	 if(confirm("수락하시겠습니까?")){
        		      	 $.ajax({
        		 url:'/sns/followRequestYes.do',
        		 type:'GET',
        		 data:{followerId:followerId},
                 success: function (response) {
                	 alert("수락하였습니다");
                	 followRequestSection.remove();
                	 loadPosts();
                	},
                 error: function (err) {
                     // 서버 오류 발생 시
                     alert(err);
                 }
        	 })
        	 }else{
        		 return false;
        	 }
   
         })
         
         //팔로우 거절
         $(document).on('click','.followRequestNo',function(){
        	 console.log("거절입니더~");
        	 const followerId = $(this).data('following-id');
         	 const userId = '<%=(String) session.getAttribute("userId")%>';  
        	 console.log("나한테 팔로우 요청한 사람 아이디:"+followerId);
        	 const followRequestSection=$(this).closest('.list-group-item');
        	 
        	 $.ajax({
        		 url:'/sns/followRequestNo.do',
        		 type:'GET',
        		 data:{followerId:followerId},
                 success: function (response) {
                	 alert("거절하였습니다");
                	 followRequestSection.remove();
                	 loadPosts();
                	},
                 error: function (err) {
                     // 서버 오류 발생 시
                     alert(err);
                 }
        	 })
         })
         
         
         
         //요청 모달 닫힐때
         $('#myFollowRequestModal').on('hidden.bs.modal',function(){
        
        	 $.ajax({
        		 url:'/sns/getFollowDetail.do',
        		 type:'GET',
        		 success:function(response){
        			 requestCount.empty();
        			 const count=`(`+response.count+`)`;
        			 requestCount.append(count);
        			 
     	            const followingList = response.followingList; 
    	            const followingContainer = $('#followingListUl'); 
    	            followingContainer.empty();
    	            followingList.forEach(following => {
    	             followingContainer.append(`<li class="list-group-item" ><i class="bi bi-person"></i>`+following.followerId+`<button type="button" class="btn btn-outline-danger">팔로우 취소</button></li>`);
    	            });
        		 },
        		 error:function(err){
        			 console.log(err);
        			 
        		 }
        	 }) 
        	 

         })
         
         $('#followModal').on('hidden.bs.modal',function(){
        	 location.reload();
         })
         
         //팔로우 한 사람 취소 목록
         $(document).on('click','.followCancel',function(){
        	 const followingSection=$(this).closest('.list-group-item');
        	 console.log("팔로우한 사람 취소하깅~");
        	 const followerId = $(this).data('follow-id');
        	 console.log("취소할 사람"+followerId);
        	 if(confirm("팔로우를 취소하시겠습니까?")){
        		 $.ajax({
        			 url:'/sns/followCancel.do',
        			 type:'GET',
        			 data:{followerId:followerId},
                     success: function (response) {
                    	 alert("팔로우를 취소하였습니다");
                    	 followingSection.remove();
                     },
                     error: function (err) {
                         // 서버 오류 발생 시
                         alert(err);
                     }
        		 })
        	 }else{
        		 return false;
        	 }
         })
         
         //팔로우 한 사람 취소 메인화면
             $(document).on('click','.followed',function(){
        	 console.log("팔로우한 사람 취소하깅~");
        	 const followerId = $(this).data('follow-id');
        	 console.log("취소할 사람"+followerId);
        	 if(confirm("팔로우를 취소하시겠습니까?")){
        		 $.ajax({
        			 url:'/sns/followCancel.do',
        			 type:'GET',
        			 data:{followerId:followerId},
                     success: function (response) {
                    	 alert("취소하였습니다");
                       	 $('.followed[data-follow-id="'+followerId+'"]')
                    	 .removeClass(' followed btn-secondary')
                    	 .addClass('follow btn-outline-secondary')
                    	 .text('팔로우')
                    	},
                     error: function (err) {
                         // 서버 오류 발생 시
                         alert(err);
                     }
        		 })
        	 }else{
        		 return false;
        	 }
         })
         
         
         //요청 취소
        
         $(document).on('click','.follow-ing',function(){
        	 console.log("요청 취소하깅~");
        	 const followerId = $(this).data('follow-id');
        	 console.log("요청취소할 사람"+followerId);
        	 if(confirm("팔로우 요청을 취소하시겠습니까?")){
        		 $.ajax({
        			 url:'/sns/followCancel.do',
        			 type:'GET',
        			 data:{followerId:followerId},
                     success: function (response) {
                    	 alert("취소하였습니다");
                       	 $('.follow-ing[data-follow-id="'+followerId+'"]')
                    	 .removeClass(' following btn-secondary')
                    	 .addClass('follow btn-outline-secondary')
                    	 .text('팔로우')
                    	},
                     error: function (err) {
                         // 서버 오류 발생 시
                         alert(err);
                     }
        		 })
        	 }else{
        		 return false;
        	 }
         })
         
         $(document).ready(function () {
        	  $(".modal-dialog").draggable({
        	    handle: ".modal-header"
        	  });
        	});
         
     var now_utc = Date.now() // 지금 날짜를 밀리초로
     // getTimezoneOffset()은 현재 시간과의 차이를 분 단위로 반환
     var timeOff = new Date().getTimezoneOffset()*60000; // 분단위를 밀리초로 변환
     // new Date(now_utc-timeOff).toISOString()은 '2022-05-11T18:09:38.134Z'를 반환
     var today = new Date(now_utc-timeOff).toISOString().split("T")[0];
     document.getElementById("startDate").setAttribute("max", today);
     document.getElementById("endDate").setAttribute("max", today); 
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
	border-radius: 5px;
	padding: 20px;
	margin-bottom: 20px;
}

.mainBody {
	width: 70%;
	margin: 0 auto;
}

.searchBody {
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

.followHeader {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
}

.userAndFollow {
	display: flex;
	flex-direction: row;
}

#follow-request-section {
	display: flex;
	flex-direction: row;
}

.followerList {
	
}

.followingList {
	
}

.boardButton {
	display: flex;
}

.edit-button .delete-button {
	margin-left: auto;
}

.mb-3 {
	width: 70%;
	margin: 0 auto;
}
</style>
</head>
<body>

	<div class="mainHeader">
		<div class="container my-4 p-4 border rounded shadow-sm bg-light">
			<h4 class="text-center">${userId}님환영합니다</h4>
			<div class="d-flex justify-content-between">
				<button class="btn btn-outline-primary my-follow-button">나의
					팔로우</button>
			</div>

			<input type="hidden" name="menuId" value="${menuId}" id="menuId">

			<!-- 제목 입력 -->
			<div class="mb-3">
				<label for="boardTitle" class="form-label fw-bold">제목</label> <input
					type="text" class="form-control" placeholder="제목을 입력해주세요(30자 제한)"
					id="boardTitle" name="boardTitle"> <small
					class="text-muted"><span id="titleLength">0</span>/30 자</small>
			</div>

			<!-- 내용 입력 -->
			<div class="mb-3">
				<label for="boardContent" class="form-label fw-bold">내용</label>
				<textarea class="form-control" placeholder="내용을 입력해주세요(100자 제한)"
					id="boardContent" name="boardContent" rows="3"></textarea>
				<small class="text-muted"><span id="contentLength">0</span>/100
					자</small>
			</div>

			<!-- 파일 첨부 -->
			<div class="mb-3">
				<label for="fileUpload" class="form-label">파일 첨부 (첨부 가능 확장자:
					.txt, .pdf)</label> <input type="file" id="fileUpload" name="files"
					class="form-control" multiple accept=".txt,.pdf">
				<ul id="filePreview" class="list-group mt-2"></ul>
			</div>

			<button class="btn btn-primary w-100" id="submitButton">작성하기</button>
		</div>

	</div>
	<div class="searchBody">
		<form action="/sns/boardSearch.do" method="get">
			<select name="searchType" class="form-select" id="searchType">
				<option value="">선택하세요</option>
				<option value="writer"
					${param.searchType == 'writer' ? 'selected' : ''}>작성자</option>
				<option value="content"
					${param.searchType == 'content' ? 'selected' : ''}>내용</option>
				<option value="writeDate"
					${param.searchType == 'writeDate' ? 'selected' : ''}>작성날짜</option>
			</select>
			<div id="dateselectSection" style="display: none;">
				<input type="date" id="startDate">~<input type="date"
					id="endDate">

			</div>
			<input id="keyword" type="text" name="keyword" class="form-control"
				placeholder="검색어 입력" value="${param.keyword}">
			<button type="button" class="btn btn-primary searchMainCode">검색</button>
		</form>
	</div>


	<!--게시글 영역-->
	<div class="mainBody">
		<h2>게시글 목록</h2>
		<div id="postList">
			<!-- 게시글 목록 -->

		</div>
	</div>

	<div class="card mb-3 post-template" style="display: none;">
		<div
			class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
			<h5 class="mb-0">
				작성자: <span class="post-user"></span>
			</h5>
			<div>
				<button type="button" class="btn btn-sm btn-outline-light follow"
					style="display: none;">팔로우</button>
				<button type="button" class="btn btn-sm btn-light followed"
					style="display: none;">팔로잉</button>
				<button type="button" class="btn btn-sm btn-secondary follow-ing"
					style="display: none;">요청중</button>
			</div>
		</div>

		<div class="card-body">
			<h3 class="post-title fw-bold"></h3>
			<h6 class="text-muted">
				작성 날짜: <span class="post-writeDate"></span>
			</h6>

			<p class="post-content mt-3"></p>

			<!-- 첨부파일 -->
			<div class="mt-3">
				<h6>
					<i class="bi bi-paperclip"></i> 첨부파일
				</h6>
				<ul class="post-files list-group"></ul>
			</div>

			<!-- 버튼 섹션 -->
			<div class="mt-3 d-flex gap-2">
				<button class="btn btn-sm btn-outline-primary comment-button">댓글</button>
				<button class="btn btn-sm btn-outline-success scrap-button">스크랩하기</button>
				<button class="btn btn-sm btn-outline-warning edit-button">수정</button>
				<button class="btn btn-sm btn-outline-danger delete-button">삭제</button>
			</div>

			<!-- 댓글 영역 -->
			<div class="comment-container mt-3"></div>
		</div>
	</div>


	<div id="post-container"></div>

	<!-- 게시글 수정 모달창 -->

	<div class="modal" tabindex="1" id="editModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">수정하기</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form id="editPostForm">
						<input type="hidden" id="editBoardId">
						<div class="mb-3">
							<label for="editBoardTitle" class="form-label">제목</label> <input
								type="text" class="form-control" id="editBoardTitle"
								placeholder="제목을 입력하세요">
						</div>
						<div class="mb-3">
							<label for="editBoardContent" class="form-label">내용</label>
							<textarea class="form-control" id="editBoardContent" rows="3"
								placeholder="내용을 입력하세요"></textarea>
						</div>
						<div class="mb-3">
							<label class="form-label">첨부파일</label>
							<ul id="editFileList"></ul>
							<label for="editFileUpload" class="form-label mt-2">파일 추가</label>
							<input type="file" id="editFileUpload" class="form-control"
								multiple accept=".txt,.pdf">
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">취소하기</button>
					<button type="button" class="btn btn-primary edit-board">수정하기</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 팔로우 팔로잉 리스트 모달창 -->

	<!-- ✅ 팔로우/팔로잉 목록 모달 -->
	<div class="modal fade" id="followModal" tabindex="-1"
		aria-labelledby="followModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<!-- 모달 크기 조정 -->
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title fw-bold">${userId}님의팔로우 목록</h5>
					<button type="button"
						class="btn btn-outline-warning myFollowRequest">
						요청 <span id="requestCount" class="badge bg-danger">0</span>
					</button>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>

				<div class="modal-body">
					<!-- 팔로워 목록 -->
					<div class="mb-4">
						<h5>
							<i class="bi bi-people"></i> 팔로워
						</h5>
						<ul id="followerListUl" class="list-group">
							<!-- 팔로워 목록 동적 추가 -->
						</ul>
					</div>

					<!-- 팔로잉 목록 -->
					<div>
						<h5>
							<i class="bi bi-person-check"></i> 팔로잉
						</h5>
						<ul id="followingListUl" class="list-group">
							<!-- 팔로잉 목록 동적 추가 -->
						</ul>
					</div>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>

	<!-- ✅ 팔로우 요청 모달 -->
	<div class="modal fade" id="myFollowRequestModal" tabindex="-1"
		aria-labelledby="myFollowRequestModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<!-- 모달 크기 조정 -->
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title fw-bold">팔로우 요청 목록</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>

				<div class="modal-body">
					<div id="follow-request-section">
						<ul class="list-group">
							<!-- 요청 리스트 동적 추가 -->
						</ul>
					</div>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>


</body>


</html>