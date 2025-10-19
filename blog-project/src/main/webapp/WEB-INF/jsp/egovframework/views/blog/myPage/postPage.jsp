<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 작성</title>
<link type="text/css" href="/resources/ckeditor5/sample/css/sample.css" rel="stylesheet" media="screen" />
<script src="https://cdn.ckeditor.com/ckeditor5/29.1.0/classic/ckeditor.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi"
	crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script><style>
    .editor-container {
        max-width: 800px;
        margin: 20px auto;
        padding: 20px;
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }
    .editor-title {
        font-size: 1.5rem;
        font-weight: bold;
        margin-bottom: 15px;
    }
    
    .ck.ck-editor {
	width:100%;
}

.ck-editor__editable {
	min-height: 300px;
}
</style>
</head>
<body>

<div class="editor-container">
    <h2 class="editor-title">글 작성</h2>
        <!-- 제목 입력 -->
        <div class="mb-3">
            <label for="title" class="form-label">제목</label>
            <input type="text" id="title" name="title" class="form-control" required>
        </div>

        <!-- 공개 범위 선택 -->
        <div class="mb-3">
            <label class="form-label">공개 범위</label>
            <select class="form-select" name="visibility" id="visibility">
                <option disabled="true" selected="true">선택하세요</option>
                <option value="public">공개</option>
                <option value="private">비공개</option>
            </select>
        </div>

        <!-- 카테고리 선택 -->
        <div class="mb-3">
            <label class="form-label">카테고리</label>
            <select class="form-select" name="category" id="category">
                <option disabled="true" selected="true">선택하세요</option>
                <c:forEach items="${category}" var="c">
                	<option value="${c.categoryId }">${c.categoryName } - ${c.categoryId }</option>
                </c:forEach>
            </select>
        </div>

        <!-- 스마트에디터 본문 -->
        <div class="mb-3">
            <label class="form-label">내용</label>
           <!--  <textarea id="smartEditor" name="content" rows="10" cols="100"></textarea> -->
           <div id="classic"></div>
        </div>

        <!-- 글 작성 버튼 -->
        <button type="button" class="btn btn-primary" id="insPostBtn" style="background-color:#5BA48E; border:none;">등록하기</button>

</div>


<script type="text/javascript">

	$(document).ready(function () {
	    let contentEditor;
	
	    ClassicEditor
	        .create(document.querySelector('#classic'), {
	            ckfinder: {
	                uploadUrl: '/blog/uploadImage.do'  // 🚀 파일 업로드를 처리할 서버 URL
	            },
	            toolbar: [
	                'heading', '|', 'bold', 'italic', 'link', 'bulletedList', 'numberedList',
	                '|', 'imageUpload', 'blockQuote', 'undo', 'redo'
	            ],
	            image: {
	                toolbar: ['imageTextAlternative', 'imageStyle:full', 'imageStyle:side']
	            }
	        })
	        .then(editor => {
	            contentEditor = editor;
	            console.log("ckeditor 로드 완료!");
	        })
	        .catch(error => {
	        	
	            console.error(error);
	        });
	    
	    $('#insPostBtn').click(function(){
	    	const title= $('#title').val(),
	    	userId = '<%=(String) session.getAttribute("userId")%>',
	    	content=contentEditor.getData(),
	    	category=$('#category').val(),
	    	visibility=$('#visibility').val();
	    	console.log("dd"+category);
	    	//제목 100자 제한
	    	if(confirm("등록하시겠습니까?")){
		    	$.ajax({
		    		url:'/blog/savePost.do',
		    		type:'post',
		    		data:{title:title, content:content, userId:userId,
		    			categoryId:category,visibility:visibility},
		    		success:function(){
		    			alert("✔️등록되었습니다!");
		    			window.location.href="/blog/myPage.do";
		    			
		    		},error:function(error){
		    			alert(error);
		    		}
		    	})
	    	}else{
	    		return false;
	    	}
	    })
	});

</script>

</body>
</html>
