<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha384-oLsuVjQ4U6yFhX0RAvjsTVGd8+FPqzzASn6vRXq/VhgCrcP8FZq/n0PbAAJ2Ag4B" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<style>
.wrapper {
	display: flex;
	flex-direction: column;
}

ul, li {
	list-style: none;
}

.tab-content {
	margin-top: 50px;
}

.mainCodeInfo {
	display: flex;
	flex-direction: column;
}

#cmmnList {
	display: flex;
	flex-direction: column;
	border: 1px solid #EDEDED;
	border-radius: 5px;
	padding: 10px;
	margin: 10px;
}
</style>
<script>
$(document).ready(function(){
	  //대분류 코드 등록
    $('#submitButton').click(function () {
        const mainCodeId = $('#mainCodeId').val();
        const mainCodeName = $('#mainCodeName').val();
        const mainCodeDescription = $('#mainCodeDescription').val();
        var deleteYn = $("input[type='radio']:checked").val();

        console.log(mainCodeId);
        console.log(mainCodeName);
        console.log(mainCodeDescription);
        
        // 유효성 검사
        if (!mainCodeId.trim()) {
            alert('코드ID를 입력해주세요.');
            return;
        }else if(!mainCodeName.trim()){
        	  alert('코드명을 입력해주세요.');
              return;
        }else if(!mainCodeDescription.trim()){
      	  alert('코드 상세정보를 입력해주세요.');
          return;
    	}
        
		if (deleteYn === "deleteNo") {
			deleteYn2 = '0';
		} else if (deleteYn === "deleteYes") {
			deleteYn2 = '1';
		}

        // FormData 생성
        const formData = new FormData();
        formData.append('mainCodeId', mainCodeId);
        formData.append('mainCodeName', mainCodeName);
        formData.append('mainCodeDescription',mainCodeDescription);
        formData.append('deleteYn',deleteYn2);
       
        
        console.log(formData);
        // 대분류 코드 등록
		if(confirm("수정하시겠습니까?")){
         $.ajax({
            url: '/main/updMainCode.do',
            type: 'POST',
            data: formData,
            contentType: false,
            processData: false,
            success: function (response) {
                if (response.success) {
                    alert('대분류 공통코드 수정이 완료되었습니다!');
                    window.opener.location.reload();
                    window.close();
                } else {
                    //파일 오류 메시지가 있을 경우
                    displayErrorMessage(response.message);
                }
            },
            error: function (err) {
                // 서버 오류 발생 시
                console.error(err);
                displayErrorMessage('수정 중 오류가 발생했습니다.');
            }
        });
		}

    });
	  
    function displayErrorMessage(message) {
	    const errorContainer = $('#errorContainer');
	    errorContainer.text(message).show();
	    setTimeout(() => errorContainer.fadeOut(), 5000); // 5초 후 사라짐
	}
	
})
</script>
</head>
<body>
	<div class="wrapper">
		<div class="mainCodeInfo">

			<h3>대분류 공통코드 추가 페이지</h3>
			
			<br>
			<div class="tab-pane fade show active" id="cmmnList" role="tabpanel" aria-labelledby="cmmnList-tab">
				<c:choose>
					<c:when test="${not empty mainCodeList}">
						<ul>
							<li><h4>대분류 코드 정보</h4></li>
							<li>코드ID - 코드 명 : 상세정보</li>
							<c:forEach var="mainCode" items="${mainCodeList}">
								<li><a href="#" id="mainCodeName-${mainCode.mainCodeId }" style="text-decoration: none; , color: black; margin-bottom: 10px;">${mainCode.mainCodeId} - ${mainCode.mainCodeName } : ${mainCode.mainCodeDescription }</a></li>
							</c:forEach>
						</ul>
					</c:when>
					<c:otherwise>
						<div class="no-results">
							<p>일치하는 항목이 없습니다.</p>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
		<div class="addMainCodeSection">
			<form method="post" id="addMainCode">
				<div class="codeIdSection">
					<label for="mainCodeId">코드Id</label> <input type="text" class="form-control" id="mainCodeId" name="boardTitle" value="${codeDetail.mainCodeId}" disabled/>
				</div>
				<div class="codeNameSection">
					<label for="mainCodeName">코드명</label> <input type="text" class="form-control" id="mainCodeName" name="boardTitle" value="${codeDetail.mainCodeName}">
				</div>
				<div class="codeDescriptionSection">
					<label for="mainCodeDescription">코드상세정보</label> <input type="text" class="form-control" id="mainCodeDescription" name="boardTitle" value="${codeDetail.mainCodeDescription}">
				</div>
				<div class="codeDeleteYn">
					<c:choose>
						<c:when test="${codeDetail.deleteYn eq 0}">
							<input type="radio" name="deleteYn" value="deleteNo" checked />활성화
					<input type="radio" name="deleteYn" value="deleteYes" />비활성화
				
				</c:when>
						<c:when test="${codeDetail.deleteYn eq 1}">
							<input type="radio" name="deleteYn" value="deleteNo" />활성화
					<input type="radio" name="deleteYn" value="deleteYes" checked />비활성화
				
				</c:when>
					</c:choose>
				</div>
				<div id="errorContainer" style="display: none; color: red; margin-bottom: 10px; font-weight: bold;"></div>
				<button type="button" class="btn btn-primary" id="submitButton">수정하기</button>
			</form>

		</div>
	</div>

</body>
</html>