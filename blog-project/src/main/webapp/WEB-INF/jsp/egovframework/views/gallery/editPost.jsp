
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
<script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha384-oLsuVjQ4U6yFhX0RAvjsTVGd8+FPqzzASn6vRXq/VhgCrcP8FZq/n0PbAAJ2Ag4B" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<title>퓨전 게시판(작성)</title>
<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function () {
  const deletedFilesInput = document.getElementById("deletedFiles");

    // 파일 삭제 버튼 클릭 이벤트
    document.querySelectorAll(".delete-file-button").forEach(button => {
        button.addEventListener("click", function () {
            const fileId = this.dataset.fileId;

            // 삭제할 파일 ID 추가
            let deletedFiles = deletedFilesInput.value ? deletedFilesInput.value.split(",") : [];
            if (!deletedFiles.includes(fileId)) {
                deletedFiles.push(fileId);
                deletedFilesInput.value = deletedFiles.join(",");
            }

            // UI에서 해당 파일 제거
            this.closest("li").remove();
        });
    });
    
    //사용 코드 주석
    const fileInput = $('#newFiles'); // 새로 첨부하는 파일 input
    const fileList = $('.list-group'); // 기존 파일 리스트
    const maxFiles = 5; // 최대 첨부 파일 수
    let selectedFiles = []; // 새로 첨부하는 파일 배열

    // 파일 변경 이벤트 처리
    fileInput.addEventListener('change', function () {
        const newFiles = Array.from(fileInput[0].files); // 새로 선택한 파일들

        // 총 파일 수 확인
        const totalFiles = fileList.children('.list-group-item').length + selectedFiles.length + newFiles.length;
        if (totalFiles > maxFiles) {
            alert(`최대 5개의 파일만 첨부할 수 있습니다.`);
            fileInput.val(''); // 새 파일 초기화
            return;
        }

        // 새 파일 추가
        newFiles.forEach((file, index) => {
            const uniqueIndex = selectedFiles.length + index; // 고유 인덱스 생성
            selectedFiles.push(file);

            // 새 파일 리스트 아이템 생성
            const listItem = $('<li>')
                .addClass('list-group-item d-flex justify-content-between align-items-center')
                .data('file-id', `new-${uniqueIndex}`); // 가상의 파일 ID 설정

            const fileInfo = $('<div>').addClass('d-flex align-items-center');

            const img = $('<img>')
                .attr('src', URL.createObjectURL(file))
                .addClass('img-thumbnail me-3')
                .css({ width: '80px', height: '80px' });

            const fileName = $('<span>').text(file.name);
            fileInfo.append(img, fileName);

            // 삭제 버튼 생성
            const deleteButton = $('<button>')
                .addClass('btn btn-danger btn-sm delete-file-button')
                .text('삭제')
                .on('click', function () {
                    const fileIndex = selectedFiles.findIndex(f => f.name === file.name && f.size === file.size);
                    selectedFiles.splice(fileIndex, 1); // 배열에서 파일 제거
                    listItem.remove(); // 리스트에서 항목 제거
                });

            listItem.append(fileInfo, deleteButton);
            fileList.append(listItem);
            
            //// FileReader를 사용하여 파일 데이터 읽기
const reader = new FileReader();
reader.onload = function (e) {
    const previewItem = $('<div>')
        .addClass('preview-item')
        .css({
            position: 'relative',
            display: 'inline-block',
            cursor: 'pointer',
        });

    const img = $('<img>')
        .attr('src', e.target.result) // FileReader에서 읽은 데이터
        .css({
            width: '100px',
            height: '100px',
            objectFit: 'cover',
            border: '1px solid #ccc',
            borderRadius: '5px',
        });

    const deletePreviewButton = $('<button>')
        .addClass('delete-btn')
        .text('×')
        .on('click', function () {
            // 미리보기 삭제
            previewItem.remove();
        });

    previewItem.append(img).append(deletePreviewButton);
    $('#previewList').append(previewItem); // 미리보기 리스트에 추가
};
reader.readAsDataURL(file); // 파일 읽기
                previewItem.append(img).append(deletePreviewButton);
                previewList.append(previewItem);
            });
        }); 

    const tagInput = document.getElementById("tag-input");
    const tagContainer = document.getElementById("tag-container");
    const tagsHidden = document.getElementById("tagsHidden");

    let tags = [...document.querySelectorAll(".tag-item")].map(tag => tag.innerText.replace('×', '').trim());

    tagInput.addEventListener("keydown", function (e) {
        if (e.key === " " || e.key === "Enter") {
            e.preventDefault();
            const tag = tagInput.value.trim();
            if (tag && !tags.includes(tag)) {
                tags.push(tag);
                const tagElement = document.createElement("div");
                tagElement.className = "tag-item";
                tagElement.innerHTML = `#${tag} <button type="button" class="delete-tag-button" data-tag-name="${tag}">×</button>`;
                tagElement.querySelector(".delete-tag-button").addEventListener("click", function () {
                    tags = tags.filter(t => t !== tag);
                    tagElement.remove();
                    updateTagsHidden();
                });
                tagContainer.appendChild(tagElement);
                updateTagsHidden();
            }
            tagInput.value = "";
        }
    });

    function updateTagsHidden() {
        tagsHidden.value = tags.join(",");
    }
    function addTagToContainer(tag) {
        const tagElement = document.createElement("div");
        tagElement.className = "tag-item d-inline-block me-2 mb-2 p-2 bg-secondary text-white rounded";
        tagElement.innerHTML = `
            #${tag}
            <button type="button" class="delete-tag-button btn btn-sm btn-danger ms-2" data-tag-name="${tag}">×</button>
        `;
        tagElement.querySelector(".delete-tag-button").addEventListener("click", function () {
            tags = tags.filter(t => t !== tag);
            tagElement.remove();
            updateTagsHidden();
        });
        tagContainer.appendChild(tagElement);
    }

    // Hidden 필드 업데이트
    function updateTagsHidden() {
        tagsHidden.value = tags.join(",");
    }

    // 초기 상태에서 삭제 버튼 이벤트 바인딩
    document.querySelectorAll(".delete-tag-button").forEach(button => {
        button.addEventListener("click", function () {
            const tag = this.dataset.tagName;
            tags = tags.filter(t => t !== tag);
            this.parentElement.remove();
            updateTagsHidden();
        });
    });
    }); 
/* 
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
    } */

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

#previewList img {
	width: 100px;
	height: 100px;
	object-fit: cover;
	border-radius: 5px;
	margin-right: 10px;
	border: 1px solid #ddd;
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
	color: white;
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

	<main>
		<div class="container mt-5">
			<h1 class="text-center mb-4">게시글 작성</h1>
			<form method="post" id="boardForm" action="/gallery/editPost.do" enctype="multipart/form-data">
				<input type="hidden" name="boardId" value="${gallery.boardId}">

				<!-- 제목 입력 -->
				<div class="mb-3">
					<label for="boardTitle" class="form-label">제목</label> <input type="text" class="form-control" id="boardTitle" name="boardTitle" value="${gallery.boardTitle}" required>
				</div>

				<!-- 내용 입력 -->
				<div class="mb-3">
					<label for="boardContent" class="form-label">내용</label>
					<textarea class="form-control" id="boardContent" name="boardContent" rows="5">${gallery.boardContent}</textarea>
				</div>

				<!-- 현재 파일 리스트 -->
				<%-- <div class="mb-3">
					<label class="form-label">현재 파일</label>
					<ul class="list-group">
						<c:forEach var="file" items="${files}">
							<li class="list-group-item d-flex justify-content-between align-items-center">
								<div class="d-flex align-items-center">
									<img src="/imgfolder/${file.storedName}" alt="${file.originalName}" class="img-thumbnail me-3" style="width: 80px; height: 80px;"> ${file.originalName}
								</div>
								<div class="d-flex align-items-center">
									<button type="button" class="btn btn-danger btn-sm delete-file-button" data-file-id="${file.fileId}">삭제</button>
								</div>
							</li>
						</c:forEach>
					</ul>
					<input type="hidden" id="deletedFiles" name="deletedFiles" value="">
				</div> --%>
				<div class="mb-3">
					<label class="form-label">현재 파일</label>
					<ul class="list-group">
						<c:forEach var="file" items="${files}">
							<li class="list-group-item d-flex justify-content-between align-items-center">
								<div class="d-flex align-items-center">
									<img src="/imgfolder/${file.storedName}" alt="${file.originalName}" class="img-thumbnail me-3" style="width: 80px; height: 80px;"> ${file.originalName}
								</div>
								<div class="d-flex align-items-center">
									<button type="button" class="btn btn-danger btn-sm delete-file-button" data-file-id="${file.fileId}">삭제</button>
								</div>
							</li>
						</c:forEach>
					</ul>
					<input type="hidden" id="deletedFiles" name="deletedFiles" value="">
				</div>

				<!-- 새 파일 추가 -->
				<div class="mb-3">
					<label for="newFiles" class="form-label">새 파일 추가</label> <input type="file" name="newFiles" id="newFiles" class="form-control" multiple>
				</div>
				<div id="previewList" class="d-flex flex-wrap"></div>

				<%-- <!-- 현재 파일 리스트 -->
				<div class="mb-3">
					<label class="form-label">현재 파일</label>
					<ul class="list-group">
						<c:forEach var="file" items="${files}">
							<li class="list-group-item d-flex justify-content-between align-items-center">
								<div class="d-flex align-items-center">
									<img src="/imgfolder/${file.storedName}" alt="${file.originalName}" class="img-thumbnail me-3" style="width: 80px; height: 80px;"> ${file.originalName}
								</div>
								<div class="d-flex align-items-center">
									<button type="button" class="btn btn-danger btn-sm delete-file-button">삭제</button>
								</div>
							</li>
						</c:forEach>
					</ul>
				</div>

				<!-- 새 파일 추가 -->
				<div class="mb-3">
					<label for="newFiles" class="form-label">새 파일 추가</label> <input type="file" name="newFiles" id="newFiles" class="form-control" multiple>
				</div> --%>
				<!-- 태그 입력 -->
				<div class="mb-3">
					<label for="tag-input" class="form-label">태그</label>
					<div id="tag-container" class="form-control" style="min-height: 50px; display: flex; flex-wrap: wrap;">
						<%-- 			<c:forEach var="tag" items="${tags}">
							<span class="badge bg-secondary me-2">#${tag.tagName}</span>
						</c:forEach> --%>
						<c:forEach var="tag" items="${tags}">
							<div class="tag-item">
								#${tag.tagName}
								<button type="button" class="delete-tag-button btn btn-sm btn-danger ms-2" data-tag-name="${tag.tagName}">×</button>
							</div>
						</c:forEach>
					</div>
					<input type="text" id="tag-input" class="form-control mt-2" placeholder="해시태그를 입력하세요 (스페이스바 또는 엔터)"> <input type="hidden" id="tagsHidden" name="tags[]">
				</div>

				<!-- 등록 버튼 -->
				<div class="text-center">
					<button type="submit" class="btn btn-primary">등록하기</button>
				</div>
			</form>
		</div>

	</main>
</body>
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<script>


    </script>
</html>