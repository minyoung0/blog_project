<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="egovframework.fusion.user.vo.UserVO"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<script src="https://cdn.ckeditor.com/ckeditor5/29.1.0/classic/ckeditor.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdn.ckeditor.com/ckeditor5/44.1.0/ckeditor5.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
<link rel="stylesheet" href="https://cdn.ckeditor.com/ckeditor5-premium-features/44.2.0/ckeditor5-premium-features.css" />
<style>
body {
	display: flex;
	flex-direction: column;
}


.nav-tabs {
	height: 50px;
}

.main {
	display: flex;
	flex-direction: column;
}

.ck.ck-editor {
	max-width: 500px;
}

.ck-editor__editable {
	min-height: 300px;
}

.final-header {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	align-items: center;
}

.completedModi {
	display: flex;
	flex-direction: row;
	align-items:center;
}

</style>

<script>
	let key = "${param.key}";
	console.log(key);

	if (key === "reviewInProgress") {

		$("#reviewCompleted-tab").removeClass("active");
		$("#objection-tab").removeClass("active");
		$("#final-tab").removeClass("active");
		$("#reviewInProgress-tab").addClass("active");

		$("#reviewCompleted").removeClass("show active");
		$("#objection").removeClass("show active");
		$("#final").removeClass("show active");
		$("#reviewInProgress").addClass("show active");

	} else if (key === "reviewCompleted") {

		$("#reviewCompleted-tab").addClass("active");
		$("#objection-tab").removeClass("active");
		$("#final-tab").removeClass("active");
		$("#reviewInProgress-tab").removeClass("active");

		$("#reviewCompleted").addClass("show active");
		$("#objection").removeClass("show active");
		$("#final").removeClass("show active");
		$("#reviewInProgress").removeClass("show active");

	} else if (key === "objection") {

		$("#reviewCompleted-tab").removeClass("active");
		$("#objection-tab").addClass("active");
		$("#final-tab").removeClass("active");
		$("#reviewInProgress-tab").removeClass("active");

		$("#reviewCompleted").removeClass("show active");
		$("#objection").addClass("show active");
		$("#final").removeClass("show active");
		$("#reviewInProgress").removeClass("show active");

	} else if (key === "final") {

		$("#reviewCompleted-tab").removeClass("active");
		$("#objection-tab").removeClass("active");
		$("#final-tab").addClass("active");
		$("#reviewInProgress-tab").removeClass("active");

		$("#reviewCompleted").removeClass("show active");
		$("#objection").removeClass("show active");
		$("#final").addClass("show active");
		$("#reviewInProgress").removeClass("show active");

	}

	$(document).ready(function() {
		
		
		//탭 유지
		var activeTab=sessionStorage.getItem('activeTab'); //키에 해당하는 값 받아오기
		
		if(activeTab){
			$('.nav-tabs a[href="'+activeTab+'"]').tab('show');
		}
		
		$('.nav-tabs a').on('show.bs.tab',function(e){ //show.bs.tab : 탭이 표시된 이후 탭표시 시 발생
			var tabId=$(e.target).attr('href');
			sessionStorage.setItem('activeTab',tabId);
		})
		

		//내용 부분 html 전환하기
		const content = document.getElementById('contentByTag').value;
		console.log("내용" + content);
		document.getElementById('contentBox').innerHTML = content;
		
		if(${menuDetail.progressCode} == 2 ||${menuDetail.progressCode} == 4){		
			if(${maxRef}>0){				
				const content2 = document.getElementById('contentByTag2').value;
				document.getElementById('contentBox4').innerHTML=content2;
			}
		document.getElementById('contentBox2').innerHTML = content;

		
		}
		 if(${menuDetail.progressCode} == 4){			
			 document.getElementById('contentBox3').innerHTML = content;
		}
		
		  const titleInput = $('#boardTitle');
	      const contentInput = $('#message');
	      const contentInput2=$('#message2');
	      let contentEditor;
	      
	      //CKEDITOR 설정
	      ClassicEditor
	      .create( document.querySelector( '#classic' ))
	      .then(editor=>{
	      	contentEditor=editor;
	      const content =document.getElementById('contentByTag').value;
	      	
	      	contentEditor.model.document.on('change:data',()=>{
	      		 const editorText=contentEditor.getData();
	      		 const text=editorText.replace(/<[^>]+>/g,'');
	      		 $("#message").val(text).trigger("input");
	      	})
	      })
	      .catch( error => {
	          console.error( error );
	      } );
	      
	      //이의제기 CKEdITOR 
	      ClassicEditor
	      .create( document.querySelector( '#classic2' ))
	      .then(editor=>{
	      	contentEditor=editor;
	      	
	      	contentEditor.model.document.on('change:data',()=>{
	      		 const editorText=contentEditor.getData();
	      		 const text=editorText.replace(/<[^>]+>/g,'');
	      		 $("#message2").val(text).trigger("input");
	      	})
	      })
	      .catch( error => {
	          console.error( error );
	      } );
	      
          contentInput2.on("input", function () {
        	  console.log("ddd")
              const maxLength = 500;
              if ($(this).val().length > maxLength) {
                  alert(`내용은 500자를 초과할 수 없습니다.`);
                  $(this).val($(this).val().substring(0, maxLength)); // 초과된 글자 제거
                  contentEditor.setData($(this).val().substring(0,maxLength));
              }
              $('#contentLength2').text($(this).val().length);
          });

	    
	     
	      // 제목 제한: 30자 초과 시 경고
	      titleInput.on("input", function () {
	          const maxLength = 30;
	          
	          if ($(this).val().length > maxLength) {
	              alert(`제목은 30자를 초과할 수 없습니다.`);
	              $(this).val($(this).val().substring(0, maxLength)); // 초과된 글자 제거
	          }
	          $('#titleLength').text($(this).val().length);
	          
	          
	          // 내용 제한: 500자 초과 시 경고

          contentInput.on("input", function () {
        	  console.log("ddd")
              const maxLength = 500;
              if ($(this).val().length > maxLength) {
                  alert(`내용은 500자를 초과할 수 없습니다.`);
                  $(this).val($(this).val().substring(0, maxLength)); // 초과된 글자 제거
                  contentEditor.setData($(this).val().substring(0,maxLength));
              }
              $('#contentLength').text($(this).val().length);
          });
	          
	          $('#message').on("change",function(){
	        	  console.log("ggg")
	          })

	      });
	      
	      $(document).on("click",".upload", function(e){
	    	  e.preventDefault();
	    	  const title = $('#boardTitle').val();
	    	  const content=$('#message').val();
	    	  const content2=contentEditor.getData();
	    	  const menuId=$('#menuId').val();
	    	  const boardId=$('#boardId').val();
	    	  const adminId=$('#adminId').val();
	    	  const firstBoardId=$('#firstBoardId').val();


	    	  if(${maxRef}>2){
	    		  alert("이의제기는 최대 3번만 가능합니다");
	    		  return false;
	    	  }else{	    		  
		    	  if(confirm("이의제기를 신청하시겠습니까?")){
		    		  $.ajax({
		    			  url:'/progress/insObjection.do',
		    			  type:'post',
		    			  data:{boardContent:content2,adminId:adminId,menuId:menuId,boardId:boardId,firstBoardId:firstBoardId},
		    			  success:function(response){			  
		    				  if(response.success){
		    					  alert('이의제기가 신청되었습니다');
								  location.reload(true);
		    				  }else{
		    					  alert(response.message);
		    				  }
		    			  },error:function(err,xhr){
		    				  console.log(err);
		    				  console.log(xhr.message);
		    			  }
		    		  })
		    	  }else{
		    		  return false;
		    	  } 
	    	  }
	      })
	      
	            
	      $(document).on("click",".admission", function(e){
	    	  e.preventDefault();
	    	  e.stopPropagation();
	    	  const boardId=$('#boardId').val();
	    	  const adminId=$('#adminId').val();
	    	  const firstBoardId=$('#firstBoardId').val();
	    	  console.log("원글 아이디"+firstBoardId);
	  		if(confirm("승인하시겠습니까?")){
				console.log("승인");
				 $.ajax({
					url:'/progress/response.do',
					type:'GET',
					data:{boardId:boardId, code:'admission',content:'admission',adminId:'${menuDetail.adminId}',firstBoardId:firstBoardId},
					success:function(response){
						if(response.success){
							alert("승인되었습니다.");
							location.reload(true);
						}else{
							alert(response.message);
						}
					},error(xhr,status,error){
						console.log(xhr);
						console.log(status);
						console.log(error);
					}
				}) 
			}else{
	    		  return false;
	    	  } 
	      })
	      
	     $(document).on("click",".companion", function(e){
	    	  e.preventDefault();
	    	  e.stopPropagation();
	    	  const boardId=$('#boardId').val();
	    	  const adminId=$('#adminId').val();
	    	  const firstBoardId=$('#firstBoardId').val();
	    	  const responseContent=$('#companion-reason').val();
	    	  console.log("반려 사유:"+responseContent);
	  		if(confirm("반려하시겠습니까?")){
				console.log("승인");
				 $.ajax({
					url:'/progress/response.do',
					type:'GET',
					data:{boardId:boardId, code:'companion',content:responseContent,adminId:'${menuDetail.adminId}',firstBoardId:firstBoardId},
					success:function(response){
						console.log("1111111111111"+response);
						if(response.success){
							alert("반려되었습니다.");
							location.reload(true);
						}else{
							alert(response.message);
						}
					},error(xhr,status,error){
						console.log(xhr);
						console.log(status);
						console.log(error);
					}
				}) 
			}else{
	    		  return false;
	    	  } 
	      })
	      
 	      $(document).on("click",".modiComReason",function(e){
	    	  e.preventDefault();
	    	  e.stopPropagation();
	    	 
    		  const responseId=$('#response_responseId').val(); 
    		  const responseContent=$('#responseCompanion').val();
	    	  console.log("dddd"+responseId);
	
	    	  if(confirm("반려내용을 수정하시겠습니까?")){
		    	  $.ajax({
		    		  url:'/progress/modiComReason.do',
		    		  type:'POST',
		    		  data:{responseId:responseId, responseContent:responseContent},
		    		  success:function(response){
		    			  alert(response.message);
		    			  location.reload(true);
		    		  },error(xhr,status,error){
							console.log(xhr);
							console.log(status);
							console.log(error);
						}
		    	  })
	    	  }else{
	    		  return false;
	    	  }
	    	  
	      }) 
	      
	 

	})
	
	function openPopup(url) {
		window.open(url, 'popup', 'width=800,height=600,scrollbars=yes');
	}
	function moveToObjection() {
		if(${maxRef}>2){
			alert("이의제기는 3회만 가능합니다");
			return false;
		}
		$("#reviewCompleted-tab").removeClass("active");
		$("#objection-tab").addClass("active");
		$("#final-tab").removeClass("active");
		$("#reviewInProgress-tab").removeClass("active");

		$("#reviewCompleted").removeClass("show active");
		$("#objection").addClass("show active");
		$("#final").removeClass("show active");
		$("#reviewInProgress").removeClass("show active");

		const tab = document.getElementById("objection-tab");
		tab.style.display = "inline";

	}
	
 	function companion(){
  		const companionTab=document.getElementById("companion-section");
  		companionTab.style.display="inline";
  	} 
 	
	function openPopup(url) {
		window.open(url, '_blank', 'width=800,height=900,scrollbars=yes');
	}
	
	function modifyCompanion(){
		$('#responseCompanion').prop('disabled',false);
		$('#saveBtn').show();
	}
	function cancelObjection(){
		if(confirm("이의제기 작성을 취소하시겠습니까?")){
			$('.nav-tabs a[href="#reviewCompleted"]').tab('show');
			$("#objection").removeClass("show active");
			$("#objection-tab").hide();
		}else{
			return false;
			}

	}
</script>
</head>
<body>
	<%
	UserVO loggedInUser = (UserVO) session.getAttribute("loggedInUser");
	%>
	<div class="main">
		<div class="navClass">
			<ul class="nav nav-tabs" id="myTab" role="tablist">
				<c:if test="${menuDetail.progressCode eq 1 || menuDetail.progressCode eq 3}">
					<li class="nav-item" role="presentation"><a class="nav-link active" id="reviewInProgress-tab" data-bs-toggle="tab" href="#reviewInProgress" data-bs-target="#reviewInProgress" type="button"
						role="tab" aria-controls="reviewInProgress" aria-selected="true"><c:if test="${maxRef>0}">${maxRef}차 이의제기</c:if>검토중</a></li>
				</c:if>

				<c:if test="${menuDetail.progressCode eq 2}">
					<li class="nav-item" role="presentation"><a class="nav-link active" id="reviewInProgress-tab" data-bs-toggle="tab" href="#reviewInProgress" data-bs-target="#reviewInProgress" type="button"
						role="tab" aria-controls="reviewInProgress" aria-selected="true"><c:if test="${maxRef>0}">${maxRef}차 이의제기</c:if>검토중</a></li>
					<li class="nav-item" role="presentation"><a class="nav-link" id="reviewCompleted-tab" data-bs-toggle="tab" href="#reviewCompleted" data-bs-target="#reviewCompleted" type="button" role="tab"
						aria-controls="reviewCompleted" aria-selected="false"><c:if test="${maxRef>0}">${maxRef}차 이의제기</c:if>검토완료</a></li>
				</c:if>
				<c:if test="${menuDetail.progressCode eq 4}">
					<li class="nav-item" role="presentation">
						<a class="nav-link active" id="reviewInProgress-tab" data-bs-toggle="tab" href="#reviewInProgress" data-bs-target="#reviewInProgress" type="button"
						role="tab" aria-controls="reviewInProgress" aria-selected="true"><c:if test="${maxRef>0}">${maxRef}차 이의제기</c:if>검토중</a></li>
					<li class="nav-item" role="presentation"><a class="nav-link" id="reviewCompleted-tab" data-bs-toggle="tab" href="#reviewCompleted" data-bs-target="#reviewCompleted" type="button" role="tab"
						aria-controls="reviewCompleted" aria-selected="false"><c:if test="${maxRef>0}">${maxRef}차 이의제기</c:if>검토완료</a></li>
					<li class="nav-item" role="presentation"><a class="nav-link" id="final-tab" data-bs-toggle="tab" data-bs-target="#final" href="#final" type="button" role="tab" aria-controls="final"
						aria-selected="false">최종</a></li>
				</c:if>

				<li class="nav-item" role="presentation"><a class="nav-link" id="objection-tab" data-bs-toggle="tab" data-bs-target="#objection" type="button" href="#objection" role="tab"
					aria-controls="objection" aria-selected="false" style="display: none">이의제기</a></li>
			</ul>

		</div>

		<!-- 검토중 -->
		<div class="tab-content" id="myTabContent">
			<div class="tab-pane fade show active" id="reviewInProgress" role="tabpanel" aria-labelledby="reviewInProgress-tab">
				<div class="container-fluid px-4">
					<h1 class="mt-4">게시글 조회</h1>
					<div class="card mb-4">
						<div class="card-body">
							<c:if test="${menuDetail.boardTitle ne null }">
								<div class="mb-3">
									<label for="title" class="form-label">제목</label> <input type="text" class="form-control" id="title" name="title" value=" ${menuDetail.boardTitle}" readOnly>
								</div>
							</c:if>

							<div class="mb-3">
								<label for="content" class="form-label">내용</label>
								<textarea class="form-control" id="contentByTag" name="content" style="display: none;" readOnly>${menuDetail.boardContent}</textarea>
								<div class="ck-content form-control" id="contentBox"></div>
							</div>
							<div class="mb-3">
								<label for="writer" class="form-label">작성자</label> <input type="text" class="form-control" id="writer" name="writer" value="${menuDetail.userId}" disabled>
							</div>
							<div class="mb-3">
								<label for="writer" class="form-label">담당 관리자</label> <input type="text" class="form-control" id="writer" name="writer" value="${menuDetail.adminId}" disabled>
							</div>
							<div class="mb-3">
								<label for="writer" class="form-label">작성일자</label> <input type="text" class="form-control" id="writer" name="writer" value="${menuDetail.boardCreateAt}" disabled>
							</div>
							<c:if test="${menuDetail.boardUpdateAt ne null }">
								<div class="mb-3">
									<label for="writer" class="form-label">수정일자</label> <input type="text" class="form-control" id="writer" name="writer" value="${menuDetail.boardUpdateAt}" disabled>
								</div>
							</c:if>

							<c:if test="${menuDetail.progressCode eq 1 && loggedInUser.userId eq menuDetail.userId}">
								<a href="/progress/progressBoardModify.do?boardId=${menuDetail.boardId}&menuId=${menuId}&firstBoardId=${firstBoardId}" class="btn btn-outline-primary">수정하기</a>
							</c:if>

						</div>
						<c:if test="${menuDetail.adminId eq loggedInUser.userId && menuDetail.progressCode eq 1}">

							<div class="mb-3">
								<button type="button" class="btn btn-outline-primary admission" style="margin-left: 17px;">승인</button>
								<button type="button" class="btn btn-outline-danger" onclick="companion()">반려</button>
								<div class="mb-3" style="margin-left: 17px; margin-top: 17px; display: none;" id="companion-section">
									<label for="companion-reason">반려 사유:</label> <input type="text" id="companion-reason">
									<button type="button" class="btn btn-danger companion">등록</button>
								</div>

							</div>
						</c:if>
					</div>
				</div>
			</div>
			<!-- 검토완료 -->
			<div class="tab-pane fade" id="reviewCompleted" role="tabpanel" aria-labelledby="reviewCompleted-tab">
				<c:if test="${menuDetail.progressCode eq 2 || menuDetail.progressCode eq 4}">
					<div class="container-fluid px-4">
						<h1 class="mt-4"><c:if test="${maxRef>0}">${maxRef}차 이의제기</c:if> 검토완료</h1>
						<div class="card mb-4">
							<div class="card-body">
								<c:if test="${menuDetail.boardTitle ne null }">
									<div class="mb-3">
										<label for="title" class="form-label">제목</label> <input type="text" class="form-control" id="title" name="title" value=" ${menuDetail.boardTitle}" readOnly>
									</div>
								</c:if>
								<div class="mb-3">
									<label for="content" class="form-label">내용</label>
									<textarea class="form-control" id="contentByTag" name="content" style="display: none;'" readOnly>${menuDetail.boardContent}</textarea>
									<div class="ck-content form-control" id="contentBox2"></div>
								</div>
								<div class="mb-3">
									<label for="writer" class="form-label">작성자</label> 
									<input type="text" class="form-control" id="writer" name="writer" value="${menuDetail.userId}" disabled>
								</div>
								<div class="mb-3">
									<label for="writer" class="form-label">담당 관리자</label> 
									<input type="text" class="form-control" id="writer" name="writer" value="${menuDetail.adminId}" disabled>
								</div>
								<div class="mb-3">
									<label for="writer" class="form-label">작성일</label> <input type="text" class="form-control" id="writer" name="writer" value="${menuDetail.boardCreateAt}" disabled>
								</div>
								<c:if test="${menuDetail.boardUpdateAt ne null }">
									<div class="mb-3">
										<label for="writer" class="form-label">수정일자</label> <input type="text" class="form-control" id="writer" name="writer" value="${menuDetail.boardUpdateAt}" disabled>
									</div>
								</c:if>
								<div class="mb-3">
									<label for="writer" class="form-label">검토 결과</label>
									<c:if test="${response.responseCode eq 2 }">
										<label style="font-size: 17px; font-weight: bold; color: red;"><i class="bi bi-caret-right-fill"></i>${response.subCodeName}</label>
										<input type="text" class="form-control" id="writer" name="writer" value="승인" disabled>
									</c:if>
									<c:if test="${response.responseCode eq 1 }">
										<label  for="writer" class="form-label" style="font-size: 17px; font-weight: bold; color: blue;"><i class="bi bi-caret-right-fill"></i>${response.subCodeName}</label>
										<div class="completedModi">
											<label style="width:100px;">반려사유<i class="bi bi-caret-right-fill"></i></label>
											<input type="text" class="form-control" id="responseCompanion" name="writer" value="${response.responseContent}" disabled>
											<button id="saveBtn" style="display: none;" class="btn btn-danger modiComReason">수정</button>
										</div>
									</c:if>
								</div>
								<c:if test='${menuDetail.progressCode eq 2 && loggedInUser.userId eq menuDetail.userId}'>
									<button type="button" id="objectionBtn" class="btn btn-outline-info" onclick="moveToObjection()">
										이의제기<br> <span style="font-size: 13px;">(남은 횟수: ${3-maxRef}회)</span>
									</button>
								</c:if>
								<c:if test="${menuDetail.progressCode eq 2 && loggedInUser.userId eq menuDetail.adminId }">
									<button type="button" id="objectionBtn" class="btn btn-outline-info" onclick="modifyCompanion()">반려사유 수정하기</button>
								</c:if>
							</div>

						</div>
					</div>
				</c:if>
				<c:if test="${maxRef>0 }">
					<div class="container-fluid px-4">
						<h1 class="mt-4">원글</h1>
						<div class="card mb-4">
							<div class="card-body">
								<c:if test="${firstBoard.boardTitle ne null }">
									<div class="mb-3">
										<label for="title" class="form-label">제목</label> <input type="text" class="form-control" id="title" name="title" value=" ${firstBoard.boardTitle}" readOnly>
									</div>
								</c:if>
								<div class="mb-3">
									<label for="content" class="form-label">내용</label>
									<textarea class="form-control" id="contentByTag2" name="content" style="display: none;'" readOnly>${firstBoard.boardContent}</textarea>
									<div class="ck-content form-control" id="contentBox4"></div>
								</div>
								<div class="mb-3">
									<label for="writer" class="form-label">작성자</label> <input type="text" class="form-control" id="writer" name="writer" value="${firstBoard.userId}" disabled>
								</div>
								<div class="mb-3">
									<label for="writer" class="form-label">담당 관리자</label> <input type="text" class="form-control" id="writer" name="writer" value="${firstBoard.adminId}" disabled>
								</div>
								<div class="mb-3">
									<label for="writer" class="form-label">작성일</label> <input type="text" class="form-control" id="writer" name="writer" value="${firstBoard.boardCreateAt}" disabled>
								</div>
								<c:if test="${menuDetail.boardUpdateAt ne null }">
									<div class="mb-3">
										<label for="writer" class="form-label">수정일자</label> <input type="text" class="form-control" id="writer" name="writer" value="${menuDetail.boardUpdateAt}" disabled>
									</div>
								</c:if>
								<div class="mb-3">
									<label for="writer" class="form-label">검토 결과</label>
									<c:if test="${firstResponse.responseCode eq 2 }">
										<label style="font-size: 17px; font-weight: bold; color: red;"><i class="bi bi-caret-right-fill"></i>${firstResponse.subCodeName}</label>
										<input type="text" class="form-control" id="writer" name="writer" value="승인" disabled>
									</c:if>
									<c:if test="${firstResponse.responseCode eq 1 }">
										<label  for="writer" class="form-label" style="font-size: 17px; font-weight: bold; color: blue;"><i class="bi bi-caret-right-fill"></i>${firstResponse.subCodeName}</label>
										<div class="completedModi">
											<label style="width:100px;">반려사유<i class="bi bi-caret-right-fill"></i></label>
											<input type="text" class="form-control" id="responseCompanion" name="writer" value="${firstResponse.responseContent}" disabled>
											<button id="saveBtn" style="display: none;" class="btn btn-danger modiComReason">수정</button>
										</div>
									</c:if>
								</div>

							</div>

						</div>
					</div>
				</c:if>
			</div>
			<!-- 이의제기 -->
			<div class="tab-pane fade" id="objection" role="tabpanel" aria-labelledby="objection-tab">
				<input type="hidden" value="${menuDetail.boardId}" id="boardId"> <input type="hidden" value="${menuDetail.adminId}" id="adminId"> <input type="hidden"
					value="${response.responseId}" id="response_responseId">
				<div class="container-fluid px-4">
					<h1 class="mt-4">이의제기 작성</h1>
					<div class="card mb-4">
						<div class="card-body">
							<form method="post" id="boardForm" action="">
								<input type="hidden" value="${menuId}" id="menuId"> <input type="hidden" value="${firstBoardId }" id="firstBoardId">
								<div id="classic2"></div>
								<input type="text" id="message2" name="message" class="form-ciontrol" style="display: none" />
								<div>
									<span id="contentLength2">0</span>/500 자
								</div>
								<a href="#" class="btn btn-outline-secondary " onclick="cancelObjection()">취소</a>
								<button class="btn btn-outline-warning upload">등록하기</button>
							</form>
						</div>
					</div>
				</div>

			</div>
			<!-- 최종 -->
			<div class="tab-pane fade" id="final" role="tabpanel" aria-labelledby="final-tab">
				<c:if test="${menuDetail.progressCode eq 4}">
					<div class="container-fluid px-4">
						<div class="final-header">
							<h1 class="mt-4">검토 최종 게시글 조회</h1>
							<button type="button" class="btn btn-outline-secondary" style="height: 40px;" onclick="openPopup('/progress/getTotalBoard.do?boardId=${firstBoardId}')">이력조회</button>
						</div>
						<div class="card mb-4">
							<div class="card-body">
								<c:if test="${menuDetail.boardTitle ne null }">
									<div class="mb-3">
										<label for="title" class="form-label">제목</label> <input type="text" class="form-control" id="title" name="title" value=" ${menuDetail.boardTitle}" readOnly>
									</div>
								</c:if>
								<div class="mb-3">
									<label for="content" class="form-label">내용</label>
									<textarea class="form-control" id="contentByTag" name="content" style="display: none;'" readOnly>${menuDetail.boardContent}</textarea>
									<div class="ck-content form-control" id="contentBox3"></div>
								</div>
								<div class="mb-3">
									<label for="writer" class="form-label">작성자</label> <input type="text" class="form-control" id="writer" name="writer" value="${menuDetail.userId}" disabled>
								</div>
								<div class="mb-3">
									<label for="writer" class="form-label">담당 관리자</label> <input type="text" class="form-control" id="writer" name="writer" value="${menuDetail.adminId}" disabled>
								</div>
								<div class="mb-3">
									<label for="writer" class="form-label">작성일</label> <input type="text" class="form-control" id="writer" name="writer" value="${menuDetail.boardCreateAt}" disabled>
								</div>
								<c:if test="${menuDetail.boardUpdateAt ne null }">
									<div class="mb-3">
										<label for="writer" class="form-label">수정일자</label> <input type="text" class="form-control" id="writer" name="writer" value="${menuDetail.boardUpdateAt}" disabled>
									</div>
								</c:if>
								<div class="mb-3">
									<label for="writer" class="form-label">검토 결과</label>
									<c:if test="${response.responseCode eq 2 }">
										<label>${response.subCodeName}</label>
										<input type="text" class="form-control" id="writer" name="writer" value="승인" disabled>
									</c:if>
									<c:if test="${response.responseCode eq 1 }">
										<label  for="writer" class="form-label" style="font-size: 17px; font-weight: bold; color: blue;"><i class="bi bi-caret-right-fill"></i>${response.subCodeName}</label>
										<div class="completedModi">
											<label style="width:100px;">반려사유<i class="bi bi-caret-right-fill"></i></label>
											<input type="text" class="form-control" id="responseCompanion" name="writer" value="${response.responseContent}" disabled>
											<button id="saveBtn" style="display: none;" class="btn btn-danger modiComReason">수정</button>
										</div>
									</c:if>
								</div>
							</div>
						</div>
					</div>
				</c:if>
			</div>
		</div>
	</div>

</body>
</html>