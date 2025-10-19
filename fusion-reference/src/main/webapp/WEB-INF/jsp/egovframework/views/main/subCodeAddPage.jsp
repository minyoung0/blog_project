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
	$(document).ready(function() {
		$('a')
		.each(
				function() {
					const id = this.id;
					console.log(id);
					if (id.startsWith("mainCodeName-")) {
						document.getElementById(id).onclick = function() {
							console.log("클릭");
							const mainCodeId = id
									.split('-')[1];
							console.log(mainCodeId);
							const subCodeSection = document
									.getElementById("subCodeSection-"
											+ mainCodeId);

							if (subCodeSection.style.display === "none"
									|| subCodeSection.style.display === "") {
								subCodeSection.style.display = "inline";
							} else {
								subCodeSection.style.display = "none";
							}
						}
					}
				})
			
					
					  $('#submitButton').click(function () {
					        const mainCodeId = document.getElementById("mainCodeId").value;
					        const subCodeId = $('#subCodeId').val();
					        const mainCodeName = $('#mainCodeName').val();
					        const mainCodeDescription = $('#mainCodeDescription').val();
					        var chkStyle=/\d/;

					        console.log(mainCodeId);
					        console.log(subCodeId);
					        console.log(mainCodeName);
					        console.log(mainCodeDescription);
					        
					        // 유효성 검사
							if(!subCodeId.trim()){
					        	  alert('소문항코드ID를 입력해주세요.');
					              return;
					        }else if(!mainCodeName.trim()){
					        	  alert('코드명을 입력해주세요.');
					              return;
					        }else if(!mainCodeDescription.trim()){
					      	  alert('코드 상세정보를 입력해주세요.');
					          return;
					    	}
					      
		/* 			        if(!chkStyle.test(subCodeId)){
					        	alert("소문항 코드는 숫자만 가능합니다");
					        	return;
					        } */

					        // FormData 생성
					        const formData = new FormData();
					        formData.append('mainCodeId', mainCodeId);
					        formData.append('subCodeId', subCodeId);
					        formData.append('mainCodeName', mainCodeName);
					        formData.append('mainCodeDescription',mainCodeDescription);

					       
					        
					        console.log(formData);
					        // 대분류 코드 등록
							if(confirm("추가하시겠습니까?")){
					         $.ajax({
					            url: '/main/addSubCode.do',
					            type: 'POST',
					            data: formData,
					            contentType: false,
					            processData: false,
					            success: function (response) {
					                if (response.success) {
					                    alert('새로운 소문항 공통코드 작성이 완료되었습니다!');
					                    window.opener.location.reload();
					                    window.close();
					                } else {
					                   alert(response.message);
					                }
					            },
					            error: function (err) {
					                // 서버 오류 발생 시
					                console.error(err);
					            }
					        });
							}

					    });			
								
	})
</script>
</head>
<body>
	<div class="wrapper">
		<div class="mainCodeInfo">

			<h3>소분류 공통코드 추가 페이지</h3>

			<br>
			<div class="tab-pane fade show active" id="cmmnList" role="tabpanel" aria-labelledby="cmmnList-tab">
				<c:choose>
					<c:when test="${not empty mainCodeList}">
						<ul>
							<li>코드ID - 코드 명</li>
							<c:forEach var="mainCode" items="${mainCodeList}">
								<li><a href="#" id="mainCodeName-${mainCode.mainCodeId }" style="text-decoration: none; , color: black; margin-bottom: 10px;">${mainCode.mainCodeId} - ${mainCode.mainCodeName }</a></li>
								<div class="subCodeSection" style="display: none;" id="subCodeSection-${mainCode.mainCodeId }">
									<c:forEach var="subCode" items="${subCodeList}">
										<c:if test="${mainCode.mainCodeId eq subCode.mainCodeId}">
											<li style="padding-left: 20px;">${subCode.mainCodeId}-${subCode.subCodeId}:${subCode.subCodeName}</li>
										</c:if>
									</c:forEach>
								</div>
							</c:forEach>
						</ul>
					</c:when>

				</c:choose>
			</div>
		</div>
		<div class="addMainCodeSection">
			<form method="post" id="addMainCode">
				<div class="codeIdSection">
					<label for="mainCodeId">대문항 코드Id</label> <!-- <input type="text" class="form-control" id="mainCodeId" name="mainCodeId" value=""> -->
					<select id="mainCodeId">
		
						<c:forEach items="${mainCodeList}" var="mainCode" >
							<option value="${mainCode.mainCodeId}">${mainCode.mainCodeId}</option>
						</c:forEach>
					</select>
				</div>
				<div class="codeIdSection">
					<label for="subCodeId">소문항 코드Id</label> <input type="text" class="form-control" id="subCodeId" name="subCodeId" value="">
				</div>
				<div class="codeNameSection">
					<label for="mainCodeName">코드명</label> <input type="text" class="form-control" id="mainCodeName" name="mainCodeName" value="">
				</div>
				<div class="codeDescriptionSection">
					<label for="mainCodeDescription">코드상세정보</label> <input type="text" class="form-control" id="mainCodeDescription" name="mainCodeDescription" value="">
				</div>
				<button type="button" class="btn btn-primary" id="submitButton">추가하기</button>
			</form>

		</div>
	</div>
</body>
</html>