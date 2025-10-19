<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.fusion.user.vo.UserVO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link type="text/css" href="/resources/ckeditor5/sample/css/sample.css" rel="stylesheet" media="screen" />
<script src="https://cdn.ckeditor.com/ckeditor5/29.1.0/classic/ckeditor.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi"
	crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>


<style>
.ck.ck-editor {
	max-width: 500px;
}

.ck-editor__editable {
	min-height: 300px;
}
</style>
<script type="text/javascript">
function moveToList(url){
	opener.location.href=url;
	window.close();
}

$(document).ready(function(){
 	  const titleInput = $('#boardTitle');
      const contentInput = $('#message');
      let contentEditor;
      
      ClassicEditor
      .create( document.querySelector( '#classic' ))
      .then(editor=>{
      	contentEditor=editor;
      	
      	contentEditor.model.document.on('change:data',()=>{
      		 const editorText=contentEditor.getData();
      		 const text=editorText.replace(/<[^>]+>/g,'');
      		 $("#message").val(text).trigger("input");
      	})
      })
      .catch( error => {
          console.error( error );
      } );

     
      // 제목 제한: 30자 초과 시 경고
      titleInput.on("input", function () {
          const maxLength = 30;
          
          if ($(this).val().length > maxLength) {
              alert(`제목은 30자를 초과할 수 없습니다.`);
              $(this).val($(this).val().substring(0, maxLength)); // 초과된 글자 제거
          }
          $('#titleLength').text($(this).val().length);
          
          
          // 내용 제한: 100자 초과 시 경고
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
    	  const admin=$('#selectAdmin').val();
    	  const content2=contentEditor.getData();
    	  const menuId=$('#menuId').val();
    	  console.log("menuId"+menuId);

    	  console.log("dddddd"+content2);

    	  
    	  if(confirm("신청하시겠습니까?")){
    		  $.ajax({
    			  url:'/progress/insBoard.do',
    			  type:'post',
    			  data:{boardTitle:title,boardContent:content2,adminId:admin,menuId:menuId},
    			  success:function(response){			  
    				  if(response.success){
    					  alert('신청되었습니다');
    					 /* opener.location.reload();
    					  window.close(); */
    					  window.location.replace('/progress/progredssBoardDetail.do?boardId='+response.boardId+'&menuId='+menuId);
    				  }else{
    					  alert(response.message);
    				  }
    			  },error:function(err){
    				  console.log(err)
    			  }
    		  })
    	  }else{
    		  return false;
    	  } 
      })
      
      
})
</script>
</head>
<body>
	<main class="mt-5 pt-5">
		<div class="container-fluid px-4">
			<h1 class="mt-4">게시글 작성</h1>
			<div class="card mb-4">
				<div class="card-body">
					<form method="post" id="boardForm" action="">
						<div class="mb-3">
							<input type="hidden" value="${menuId}"id="menuId">
							<label for="title" class="form-label">제목</label> <input type="text" class="form-control" id="boardTitle" name="boardTitle" value="">
							<div>
								<span id="titleLength">0</span>/30 자
							</div>
						</div>
						<div class="mb-3">
							<label for="selectAdmin">담당 관리자</label> <select id="selectAdmin" class="form-select">
								<option>선택해주세요</option>
								<c:forEach items="${adminList}" var="admin">
									<option value="${admin.userId }">${admin.userName }</option>
								</c:forEach>
							</select>
						</div>
						<label for="content" class="form-label">내용</label>
						<div id="classic"></div>
						<input type="text" id="message" name="message" class="form-ciontrol" style="display:none;" />
						<div>
							<span id="contentLength">0</span>/500 자
						</div>
						<a href="#" class="btn btn-outline-secondary" onclick="closePage()">목록</a>
						<button class="btn btn-outline-warning upload">등록하기</button>
					</form>
				</div>
			</div>
		</div>
		<script>

    </script>
	</main>
</body>

</html>