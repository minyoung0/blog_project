<%@page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>카테고리 관리</title>

    <!-- ✅ Bootstrap 5 -->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background-color: #f5f5f5; }
        .container-custom { max-width: 900px; margin: 40px auto; background: white; padding: 30px; border-radius: 10px;}
        .box { height: 450px; border: 2px solid #5BA48E; border-radius: 10px; overflow-y: auto; background: white; padding: 15px; text-align: center; }
        .box-title { font-size: 18px; font-weight: bold; color: white; background: #5BA48E; padding: 12px; border-radius: 8px 8px 0 0; }
        .btn-header { background: #5BA48E; color: white; border: none; padding: 8px 12px; border-radius: 5px; margin-right: 5px; }
        .btn-header:hover { background: #4A907D; }
        .list-group-item { cursor: pointer; transition: 0.2s; padding: 12px; font-size: 16px; text-align: left; }
        .list-group-item:hover { background: #d4ede7; }
        .selected { background: #A8D5C2 !important; }
        .category-details { border: 2px solid #5BA48E; border-radius: 10px; padding: 20px; background: white; height: 100%; }
    </style>
</head>
<body>

<div class="container-custom">
    <h3 class="text-center mb-4 text-dark">카테고리 관리</h3>

    <!-- ✅ 상단 버튼 -->
    <div class="d-flex justify-content-end mb-3">
        <button class="btn btn-header" id="openAddCategoryModal">+ 카테고리 추가</button>
        <button class="btn btn-header" id="deleteCategory">- 삭제</button>
    </div>

    <div class="row">
        <!-- ✅ 왼쪽: 활성화된 카테고리 목록 -->
        <div class="col-md-5">
            <div class="box">
                <div class="box-title">카테고리 목록</div>
                <ul id="categoryList" class="list-group mt-3">
                    <c:forEach var="category" items="${categoryList}">
                        <li class="list-group-item category-item" data-id="${category.categoryId}" 
                            data-name="${category.categoryName}" data-status="${category.disableYn}" 
                            data-visibility="${category.visibility}">
                            ${category.categoryName}
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>

        <!-- ✅ 오른쪽: 카테고리 상세 정보 -->
        <div class="col-md-7" >
            <div class="category-details" id="category-details" style="display:none;">
                <h4>카테고리 상세 정보</h4>
                <input type="hidden" id="editCategoryId">
                <div class="mb-3">
                    <label>카테고리 명:</label>
                    <input type="text" id="editCategoryName" class="form-control" placeholder="카테고리 이름">
                </div>
                <div class="mb-3">
                    <label>활성화 여부:</label>
                    <select id="editCategoryStatus" class="form-select">
                        <option value="Y">활성화</option>
                        <option value="N">비활성화</option>
                    </select>
                </div>
                <div class="mb-3">
                	 <label class="mt-3">공개 여부:</label>
                	<select id="categoryVisibility" class="form-select">
                    	<option value="private">비공개</option>
                    	<option value="neighbors">이웃공개</option>
                    	<option value="public">전체공개</option>
                	</select>
                </div>
                <button class="btn btn-header" id="updateCategory">수정</button>
            </div>
        </div>
    </div>
</div>

<!-- ✅ 카테고리 추가 모달 -->
<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">새 카테고리 추가</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <label>카테고리 명:</label>
                <input type="text" id="newCategoryName" class="form-control" placeholder="카테고리 이름">
                <label class="mt-3">공개 여부:</label>
                <select id="categoryVisibility" class="form-select">
                    <option value="private">비공개</option>
                    <option value="neighbors">이웃공개</option>
                    <option value="public">전체공개</option>
                </select>
            </div>
            <div class="modal-footer">
                <button class="btn btn-header" id="saveCategory">저장</button>
                <button class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>

<!-- ✅ Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
$(document).ready(function() {
    // ✅ 카테고리 추가 모달 열기
    $("#openAddCategoryModal").click(function() {
        $("#addCategoryModal").modal("show");
    });

    // ✅ 카테고리 추가
    $("#saveCategory").click(function(e) {
    	e.preventDefault();
        var newCategoryName = $("#newCategoryName").val().trim();
        var visibility = $("#categoryVisibility").val();
		console.log("카테고리명: "+newCategoryName);
		console.log(visibility);
	
        if (newCategoryName !== "") {
        	if(confirm("새로운 카테고리를 추가하시겠습니까?")){
	            $.ajax({
	                url: "/blog/setting/addCategory.do",
	                type: "POST",
	                data: { categoryName: newCategoryName, visibility: visibility },
	                success: function(response) {
	                    $("#addCategoryModal").modal("hide");
	                    window.location.reload();
	                }
	            });
        	}else{
        		return false;
        	}
        } else {
            alert("카테고리 이름을 입력하세요.");
        }
    });

    // ✅ 카테고리 클릭 시 오른쪽에 정보 표시
   $(document).on("click", ".category-item", function() {
    var categoryId = $(this).data("id");  // ✅ 클릭한 카테고리의 ID 가져오기
    console.log("카테고리 ID:", categoryId);

    $.ajax({
        url: "/blog/setting/getCategoryDetail.do",  // ✅ 카테고리 상세 조회 API
        type: "GET",
        data: { categoryId: categoryId },
        success: function(response) {
            console.log("카테고리 상세 정보:", response);

            // ✅ 응답 데이터가 `categoryDetail` 안에 있음
            var category = response.categoryDetail;

            // ✅ 가져온 데이터를 오른쪽 상세 정보 영역에 반영
            $("#editCategoryId").val(category.categoryId);
            $("#editCategoryName").val(category.categoryName);
            $("#editCategoryStatus").val(category.disableYn);
            $("#categoryVisibility").val(category.visibility);

            // ✅ 상세 정보창 표시
            $("#category-details").show();
        },
        error: function(xhr, status, error) {
            console.error("카테고리 상세 정보 불러오기 실패:", error);
        }
    });
});

    // ✅ 카테고리 수정
    $("#updateCategory").click(function() {
        var categoryId = $("#editCategoryId").val();
        var newCategoryName = $("#editCategoryName").val().trim();
        var newStatus = $("#editCategoryStatus").val();

        $.ajax({
            url: "/category/update",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({ categoryId: categoryId, categoryName: newCategoryName, disableYn: newStatus }),
            success: function(response) {
                $(`li[data-id='${categoryId}']`).text(newCategoryName).data("name", newCategoryName).data("status", newStatus);
            }
        });
    });
    
    

});
</script>

</body>
</html>
