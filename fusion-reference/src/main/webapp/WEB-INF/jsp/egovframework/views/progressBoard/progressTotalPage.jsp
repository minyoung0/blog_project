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
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">

<style>
body {
	display: flex;
	flex-direction: column;
}

ul, li {
	list-style: none;
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
	margin: 0 30px;
	justify-content: space-between;
	align-items: center;
	justify-content: space-between;
}

.card {
	margin-top: 20px;
}

.completedModi {
	display: flex;
	flex-direction: row;
	align-items:center;
}
</style>
<script>
	$(document).ready(function(){

		$('.contentBox').each(function(){
			console.log("1111111");
			var content = $(this).data('content');
			console.log("내용"+content);
			$(this).html(content);
		})
	
	})
	
	var renderedImg=new Array;
	
	var contWidth=200,
		padding=5;
	
	function pdfPrint(){
		
		
		if(confirm("다운로드 하시겠습니까?")){
			var {jsPDF} = window.jspdf;
			var lists=document.querySelectorAll(".card-body"),
			deferreds=[],
		    doc = new jsPDF('p', 'mm', 'a4'),
		    listsLeng=lists.length;
			
			for(var i=0;i<listsLeng;i++){
				var deferred=$.Deferred();
				deferreds.push(deferred.promise());
				generateCanvas(i,doc,deferred,lists[i]);
			}
			
			
			$.when.apply($,deferreds).then(function(){
				var sorted=renderedImg.sort(function(a,b){return a.num<b.num?-1:1}),
				curHeight=padding,
				sortedLeng=sorted.length;
				
				for(var i=0;i<sortedLeng;i++){
					var sortedHeight=sorted[i].height,
					sortedImage=sorted[i].image;
					
					if(curHeight+sortedHeight>297 -padding*2){
						doc.addPage();
						curHeight=padding;
						doc.addImage(sortedImage,'jpeg',padding,curHeight,contWidth,sortedHeight);
						curHeight+=sortedHeight;
					}else{
						doc.addImage(sortedImage,'jpeg',padding,curHeight,contWidth,sortedHeight);
						curHeight+=sortedHeight;
					}
				}
				const downLoadName=`${firstBoard.boardTitle}`+"_"+`${firstBoard.userId}`+"_담당:"+`${firstBoard.adminId}`+"_"+`${formatDate}`+".pdf";
		        doc.save(downLoadName);
		        
		        curHeight=padding;
		        renderedImg=new Array;
			})
			
			console.log(lists.length);

		}else{return false;}
			 
		}
	
	function generateCanvas(i,doc,deferred,curList){
		var pdfWidth=$(curList).outerWidth()*0.2645,
		pdfHeight=$(curList).outerHeight()*0.2645,
		heightCalc=contWidth*pdfWidth/pdfWidth;
		html2canvas(curList).then(
					function(canvas){
						var img=canvas.toDataURL('image/jpeg',1.0);
						var imgWidth=contWidth;
						var imgHeight=imgWidth*(canvas.height/canvas.width);
						renderedImg.push({num:i,image:img,height:imgHeight});
						deferred.resolve();
					}
				)
	}
</script>
</head>
<body>
	<!-- 검토중 -->
	<div class="tab-content" id="myTabContent">
		<c:set var="num" value="${totalSize}" />
		<div class="tab-pane fade show active" id="reviewInProgress" role="tabpanel" aria-labelledby="reviewInProgress-tab">
			<div class="final-header">
				<h1 class="mt-4">이력 조회</h1>
				<button type="button" class="btn btn-outline-secondary" style="height: 40px;" onclick="pdfPrint()">PDF 출력</button>
			</div>
			<c:forEach items="${total}" var="board" varStatus="status">
				<div class="container-fluid px-4">
					<div class="card mb-4">
						<div class="card-body"> <!-- 반복되는 태그 -->
							<c:if test="${(num-status.count)>0}">
								<h2>${num-status.count}차이의제기</h2>
							</c:if>
							<c:if test="${ (num-status.count) eq 0}">
								<h2>원글</h2>
							</c:if>

							<c:if test="${board.boardTitle ne null }">
								<div class="mb-3">
									<label for="title" class="form-label">제목</label> <input type="text" class="form-control" id="title" name="title" value=" ${board.boardTitle}" readOnly>
								</div>
							</c:if>

							<div class="mb-3">
								<label for="content" class="form-label">내용</label>
								<textarea class="form-control" id="contentByTag" name="content" style="display: none;" readOnly>${board.boardContent}</textarea>
								<div class="ck-content form-control contentBox" id="contentBox" data-content="${board.boardContent}"></div>
							</div>
							<c:if test="${board.boardRef eq 0}">							
								<div class="mb-3">
									<label for="writer" class="form-label">작성자</label> <input type="text" class="form-control" id="writer" name="writer" value="${board.userId}" disabled>
								</div>
								<div class="mb-3">
									<label for="writer" class="form-label">담당 관리자</label> <input type="text" class="form-control" id="writer" name="writer" value="${board.adminId}" disabled>
								</div>
							</c:if>
							<div class="mb-3">
								<label for="writer" class="form-label">작성일자</label> <input type="text" class="form-control" id="writer" name="writer" value="${board.boardCreateAt}" disabled>
							</div>
									<c:if test="${board.boardUpdateAt ne null }">
									<div class="mb-3">
										<label for="writer" class="form-label">수정일자</label> <input type="text" class="form-control" id="writer" name="writer" value="${board.boardUpdateAt}" disabled>
									</div>
								</c:if>
							<h4>검토 결과</h4>
							<c:forEach items="${totalResponse }" var="response">
								<div class="">
									<c:if test="${board.boardId eq response.boardId}">
										<c:if test="${response.responseCode eq 2 }">
											<label style="font-size: 17px; font-weight: bold; color: red;"><i class="bi bi-caret-right-fill"></i>${response.subCodeName}</label>
											<!-- 	<input type="text" class="form-control" id="writer" name="writer" value="승인" disabled> -->
										</c:if>
										<c:if test="${response.responseCode eq 1 }">
										<label  for="writer" class="form-label" style="font-size: 17px; font-weight: bold; color: blue;"><i class="bi bi-caret-right-fill"></i>${response.subCodeName}</label>
										<div class="completedModi">
											<label style="width:100px;">반려사유<i class="bi bi-caret-right-fill"></i></label>
											<input type="text" class="form-control" id="responseCompanion" name="writer" value="${response.responseContent}" disabled>
											<button id="saveBtn" style="display: none;" class="btn btn-danger modiComReason">수정</button>
										</div>
									</c:if>
									</c:if>
								</div>
							</c:forEach>
						</div>
					</div>
				</div>
			</c:forEach>

		</div>

	</div>

</body>
</html>