
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
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha384-oLsuVjQ4U6yFhX0RAvjsTVGd8+FPqzzASn6vRXq/VhgCrcP8FZq/n0PbAAJ2Ag4B" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<title>갤러리 게시판(작성)</title>
<script type="text/javascript">

$(document).ready(function () {
	//글자수 제한
	  const titleInput = $('#boardTitle');
    const contentInput = $('#boardContent');
    
    // 제목 제한: 20자 초과 시 경고
    titleInput.on('input', function () {
        const maxLength = 50;
        if ($(this).val().length > maxLength) {
            alert(`제목은 50자를 초과할 수 없습니다.`);
            $(this).val($(this).val().substring(0, maxLength)); // 초과된 글자 제거
        }
    });
    
    // 내용 제한: 500자 초과 시 경고
    contentInput.on('input', function () {
        const maxLength = 800;
        if ($(this).val().length > maxLength) {
            alert(`내용은 800자를 초과할 수 없습니다.`);
            $(this).val($(this).val().substring(0, maxLength)); // 초과된 글자 제거
        }
    });
	
	
    const fileInput = $('#fileUpload');
    const fileNamesList = $('#fileNamesList');
    const previewList = $('#previewList');
    const tagInput = $('#tag-input'); // 태그 입력 필드
    const tagContainer = $('#tag-container'); // 태그 컨테이너
    const tagsHidden = $('#tagsHidden'); // 히든 태그 필드
    const thumbnailIndexHidden=$('<input>')
    			.attr('type','hidden')
    			.attr('name','thumbnailIndex')
    			.val(0);
    let tags = []; // 태그 배열

    // 파일 변경 이벤트 처리
    fileInput.on('change', function () {
        const files = Array.from(fileInput[0].files);

        // 파일 수 제한
        if (files.length > 5) {
            alert(`최대 5개의 파일만 선택할 수 있습니다.`);
            fileInput.val(''); // 파일 초기화
            fileNamesList.empty(); // 파일 리스트 초기화
            previewList.empty(); // 미리보기 초기화
            return;
        }

        // 기존 내용 초기화
        fileNamesList.empty();
        previewList.empty();

        files.forEach((file, index) => {
        	
            const listItem = $('<li>').text(file.name).css({
                border: '1px solid #ccc',
                padding: '5px',
                marginBottom: '5px',
                borderRadius: '5px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between'
            });

            const deleteButton = $('<button>')
                .text('X')
                .css({
                    backgroundColor: 'red',
                    color: 'white',
                    border: 'none',
                    borderRadius: '50%',
                    cursor: 'pointer',
                    width: '20px',
                    height: '20px',
                    textAlign: 'center',
                    lineHeight: '20px'
                })
                .on('click', function () {
                    files.splice(index, 1);
                    fileInput.val(''); // 파일 초기화
                    listItem.remove(); // 파일명 삭제
                    $(`#preview-${index}`).remove(); // 미리보기 삭제
                });

            listItem.append(deleteButton);
            fileNamesList.append(listItem);

            // 이미지 미리보기 추가
            const reader = new FileReader();
            reader.onload = function (e) {
            	 const previewItem = $('<div>')
                 .addClass('preview-item')
                 .css({
                     position: 'relative',
                     display: 'inline-block',
                     cursor: 'pointer',
                 })
                 .attr('data-index', index) // 파일 인덱스를 저장
                 .on('click', function () {
                     $('.preview-item').css({ border: '1px solid #ccc' }); // 기존 선택 제거
                     $(this).css({ border: '2px solid red' }); // 선택 표시
                     thumbnailIndexHidden.val(index); // 히든 필드에 선택된 인덱스 저장
                 });
            	 
                const img = $('<img>')
                    .attr('src', e.target.result)
                    .css({
                        width: '100px',
                        height: '100px',
                        objectFit: 'cover',
                        border: '1px solid #ccc',
                        borderRadius: '5px'
                    });

                const deletePreviewButton = $('<button>')
                    .addClass('delete-btn')
                    .text('×')
                    .on('click', function () {
                        files.splice(index, 1);
                        fileInput.val(''); // 파일 초기화
                        previewItem.remove(); // 미리보기 삭제
                        listItem.remove(); // 파일명 삭제
                    });

                previewItem.append(img).append(deletePreviewButton);
                previewList.append(previewItem);
            };
            reader.readAsDataURL(file);
        });
    });

    // 태그 입력 이벤트 처리
    tagInput.on('keydown', function (e) {
        if (e.key === ' ' || e.key === 'Enter') {
            e.preventDefault();
            const tag = tagInput.val().trim();

            // 태그 중복 확인
            if (tags.includes(tag)) {
                alert('이미 추가된 태그입니다.');
                tagInput.val('');
                return;
            }

            // 태그 개수 제한
            if (tags.length >= 5) {
                alert('태그는 최대 5개까지 입력할 수 있습니다.');
                tagInput.val('');
                return;
            }

            // Hidden input 추가
            const hiddenInput = $('<input>')
                .attr('type', 'hidden')
                .attr('name', 'tags')
                .val(tag);
            
            // 태그 중복 확인 및 추가
            if (tag && !tags.includes(tag)) {
                tags.push(tag);

                
                
                // 태그 UI 추가
                const tagItem = $('<div>')
                    .addClass('tag-item')
                    .css({
                        padding: '5px 10px',
                        backgroundColor: '#f0f0f0',
                        borderRadius: '15px',
                        display: 'inline-flex',
                        alignItems: 'center',
                        marginRight: '5px',
                        marginBottom: '5px'
                    })
                    .text(`#\${tag}`);

                const deleteTagButton = $('<button>')
                    .text('×')
                    .css({
                        marginLeft: '5px',
                        backgroundColor: 'red',
                        color: 'white',
                        border: 'none',
                        borderRadius: '50%',
                        cursor: 'pointer',
                        width: '20px',
                        height: '20px',
                        textAlign: 'center',
                        lineHeight: '20px'
                    })
                    .on('click', function () {
                        tags = tags.filter(t => t !== tag);
                        tagItem.remove();
                        updateTagsHidden();
                    });

                tagItem.append(deleteTagButton);
                tagContainer.append(tagItem);

               

                tagContainer.append(hiddenInput);
                tagInput.val('');
            }
        }
    });

    // 히든 태그 필드 업데이트
    function updateTagsHidden() {
        tagsHidden.val(tags.join(','));
    }
    function validateFileSize(input) {
        const maxFileSize = 50 * 1024 * 1024; // 50MB
        const validFiles = [];
        Array.from(input.files).forEach(file => {
            if (file.size > maxFileSize) {
                alert(`파일 "${file.name}" 크기가 50MB를 초과했습니다.`);
            } else {
                validFiles.push(file);
            }
        });

        if (validFiles.length !== input.files.length) {
            input.files = new FileList(...validFiles); // 유효한 파일만 남기기
            previewList.empty(); // 미리보기 재생성
        }
    }
});
function submitForm() {
    // 글 등록 완료 후 부모 창 새로고침 및 현재 창 닫기
    const form = $('#surveyForm');
    const formData = new FormData(form[0]);
	if(confirm('글을 작성하시겠습니까?')){
		 $.ajax({
        url: form.attr('action'),
        method: form.attr('method'),
        data: formData,
        processData: false,
        contentType: false,
        success: function(response) {
            alert("글이 성공적으로 등록되었습니다.");
           
            // 부모 창 새로고침
            if (window.opener) {
                window.opener.location.reload();
            }

            // 현재 창 닫기
            window.close();
        },
        error: function(error) {
            alert("글 등록에 실패했습니다. 다시 시도해주세요.");
            console.error("에러:", error);
        }
    });
	}else{
		return false;
	}
   

    // 기본 submit 동작 방지
    return false;
}

	
</script>
<style>
body {
	background-color: #f8f9fa;
	font-family: Arial, sans-serif;
}

.container {
	max-width: 900px;
	margin: 40px auto;
	background: white;
	padding: 30px;
	border-radius: 8px;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

h1 {
	text-align: center;
	margin-bottom: 30px;
	color: #495057;
}

.form-label {
	font-weight: bold;
}

#previewList {
	display: flex;
	flex-wrap: wrap;
	gap: 10px;
	margin-top: 15px;
}

#previewList img {
	width: 80px;
	height: 80px;
	object-fit: cover;
	border: 1px solid #ddd;
	border-radius: 5px;
	position: relative;
}

#previewList .preview-item {
	position: relative;
}

#previewList .preview-item button {
	position: absolute;
	top: -5px;
	right: -5px;
	background: red;
	color: white;
	border: none;
	border-radius: 50%;
	width: 20px;
	height: 20px;
	font-size: 12px;
	cursor: pointer;
}

#tag-container {
	display: flex;
	flex-wrap: wrap;
	border: 1px solid #ced4da;
	border-radius: 5px;
	padding: 10px;
	background-color: #f8f9fa;
	min-height: 50px;
}

.tag-item {
	background: #6c757d;
	color: black;
	padding: 5px 10px;
	border-radius: 15px;
	margin-right: 10px;
	margin-bottom: 5px;
}

.tag-item button {
	background: none;
	border: none;
	color: white;
	font-size: 14px;
	margin-left: 5px;
	cursor: pointer;
}

.btn-primary {
	width: 100%;
	padding: 10px;
	font-size: 16px;
	border-radius: 5px;
}
</style>
</head>
<body>

	<div class="container">
		<h1>게시글 작성</h1>
		<form method="post" id="surveyForm" action="/gallery/insGallery.do" enctype="multipart/form-data" target="_selft" onsubmit="return submitForm();">
		
			<input type="hidden" name="menuId" value="${menuId}">
			<p>메뉴 아이디: ${menuId}</p>
			<!-- 제목 -->
			<div class="mb-4">
				<label for="boardTitle" class="form-label">제목</label> <input type="text" class="form-control" id="boardTitle" name="boardTitle" placeholder="제목을 입력하세요">
			</div>

			<!-- 내용 -->
			<div class="mb-4">
				<label for="boardContent" class="form-label">내용</label>
				<textarea class="form-control" id="boardContent" name="boardContent" rows="5" placeholder="내용을 입력하세요"></textarea>
			</div>

			<!-- 파일 첨부 -->
			<div class="mb-4">
				<label for="fileUpload" class="form-label">파일 첨부</label> <input type="file" id="fileUpload" name="files" class="form-control" multiple accept=".jpg,.jpeg,.png,.gif">
			</div>

			<!-- 이미지 미리보기 -->
			<div id="previewContainer" class="mb-4">
				<p class="text-muted">미리보기: 대표 이미지를 선택하세요.</p>
				<div id="previewList"></div>
				<input type="hidden" id="thumbnailIndex" name="thumbnailIndex" value="0">
			</div>

			<!-- 태그 -->
			<div class="mb-4">
				<label for="tag-input" class="form-label">태그</label>
				<div id="tag-container" class="form-control"></div>
				<input type="text" id="tag-input" class="form-control mt-2" placeholder="태그를 입력하세요 (스페이스바 또는 엔터)"> <input type="hidden" id="tagsHidden" name="tags[]">
			</div>

			<!-- 등록 버튼 -->
			<button type="submit" class="btn btn-primary">등록하기</button>
		</form>
	</div>
</body>



</html>