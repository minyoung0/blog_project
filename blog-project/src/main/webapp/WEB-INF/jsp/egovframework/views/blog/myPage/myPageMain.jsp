<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 메인</title>
<link rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
	
<style>
.post-container {
    margin-top: 20px;
}

.post-card {
    padding: 15px;
    border-radius: 8px;
    border: 1px solid #ddd;
    background: #fff;
    margin-bottom: 15px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    height:100%;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    gap:5px;
}

.post-image {
    width: 100%;
    height: 150px;
    object-fit: cover;
    border-radius: 5px;
}

.post-title {
    font-size: 1.1rem;
    font-weight: bold;
    margin-bottom: 5px;
}

.post-meta {
    font-size: 0.9rem;
    color: #777;
}

.post-data{
	font-size: 0.9rem;
    color: #777;

}

.post-content {
    font-size: 0.9rem;
    color: #333;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
    height:100%;
}

.btn{
border:1px solid #5BA48E;
}

.btn:hover{
background-color:#5BA48E;
}

.pagination{
	margin-top:20px;
}
</style>
</head>
<body>
<% String userId= (String)session.getAttribute("userId"); %>
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center">
        <h4>🌸${userInfo.nickName }의 블로그🌸 - ${categoryName.categoryName} </h4>
        <c:if test="${userInfo.userId eq userId }">
	        <button class="btn btn-primary"
	            onclick="location.href='/blog/postPage.do'"
	            style="background-color: #5BA48E; border: none;">
	            <i class="fas fa-pencil-alt"></i> 글 작성
	        </button>
        </c:if>
    </div>

	<c:choose>
	    <c:when test="${not empty postList}">
	        <!-- 🔹 게시글 목록을 2개씩 출력 (2열 구조) -->
	        <div class="row post-container">
	            <c:forEach items="${postList}" var="board" varStatus="status">
	                <!-- 🔹 2개씩 새로운 row 시작 -->
	                <c:if test="${status.index % 2 == 0 && status.index != 0}">
	        </div><div class="row post-container"> <!-- 닫고 새 row 열기 -->
	                </c:if>
	
	                <div class="col-md-6">
	                    <div class="post-card">
	                        <!-- 썸네일 -->
	                        <img src="${board.thumbnail}" class="post-image" alt="미리보기 이미지">
	
	                        <!-- 제목 -->
	                        <div class="post-title">${board.title}</div>
	
	                        <!-- 작성 정보 -->
	                        <div class="post-meta">작성자: ${board.nickName} | 작성일: ${board.createAt}</div>
	                        <div class="post-data"><i class="bi bi-eye-fill"></i> ${board.viewCount} | <i class="bi bi-hand-thumbs-up-fill"></i></div>
	
	                        <!-- 본문 -->
	                        <p class="post-content">${board.content}</p>
	
	                        <!-- 상세 보기 버튼 -->
	                        <a href="/blog/postDetail.do?postId=${board.postId}&blogUserId=${board.userId}" class="btn" id="detailBtn" data-post-id="${board.postId }">상세 보기</a>
	                    </div>
	                </div>
	            </c:forEach>
	        </div> <!-- 마지막 row 닫기 -->
	    </c:when>
	    <c:otherwise>
		    <div class="no-posts text-center mt-5">
		        <i class="bi bi-file-earmark-text text-secondary" style="font-size: 3rem;"></i>
		        <p class="mt-3 text-muted">등록된 게시물이 없습니다.</p>
		        <c:if test="${userInfo.userId eq userId}">
		            <button class="btn btn-primary mt-2" onclick="location.href='/blog/postPage.do'">
		                <i class="bi bi-pencil-square"></i> 첫 게시글 작성하기
		            </button>
		        </c:if>
		    </div>
		</c:otherwise>
	</c:choose>


    <!-- 페이지네이션 -->
    <div>
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <c:if test="${totalPage > 0}">
                    <c:forEach var="i" begin="1" end="${totalPage}">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="/blog/myPage.do?blogUserId=${userInfo.userId}&page=${i}&limit=6">${i}</a>
                        </li>
                    </c:forEach>
                </c:if>
            </ul>
        </nav>
    </div>
</div>
<jsp:include page="../chattingLayout.jsp" />
<script>

</script>

</body>
</html>
