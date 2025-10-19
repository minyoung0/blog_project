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
    min-height: 250px; /* 카드 높이 일정 */
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.post-image {
    width: 100%;
    height: 150px;
    object-fit: cover;
    border-radius: 5px;
}

.post-title {
    font-size: 1.2rem;
    font-weight: bold;
    margin-bottom: 5px;
}

.post-meta {
    font-size: 0.9rem;
    color: #777;
}

.post-content {
    font-size: 0.95rem;
    color: #333;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
}

.btn{
border:2px solid #5BA48E;
}

.btn:hover{
background-color:#5BA48E;
}
</style>
</head>
<body>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center">
        <h2>🌸${userInfo.nickName }의 블로그🌸</h2>
        <button class="btn btn-primary"
            onclick="location.href='/blog/postPage.do'"
            style="background-color: #5BA48E; border: none;">
            <i class="fas fa-pencil-alt"></i> 글 작성
        </button>
    </div>

    <!-- 게시글 목록 (2열) -->
    <c:forEach items="${postList}" var="board" varStatus="status">
        <c:if test="${status.index % 2 == 0}">
            <div class="row post-container">
        </c:if>

        <div class="col-md-6">
            <div class="post-card">
                <!-- 기본 더미 이미지 -->
                <img src="${board.thumbnail}" class="post-image" alt="미리보기 이미지">

                <div class="post-title">${board.title}</div>
                <div class="post-meta">작성자: ${board.nickName} | 작성일: ${board.createAt} | 조회수: ${board.viewCount}</div>

                <!-- 본문 내용 -->
                <p class="post-content">${board.content}</p>
                <a href="/blog/postDetail.do?postId=${board.postId}" class="btn" id="detailBtn" data-post-id="${board.postId }">상세 보기</a>
            </div>
        </div>

        <c:if test="${status.index % 2 == 1 or status.last}">
            </div>
        </c:if>
    </c:forEach>

    <!-- 페이지네이션 -->
    <div>
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <c:if test="${totalPage > 0}">
                    <c:forEach var="i" begin="1" end="${totalPage}">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="/blog/myPage.do?page=${i}&limit=6">${i}</a>
                        </li>
                    </c:forEach>
                </c:if>
            </ul>
        </nav>
    </div>
</div>

<script>

</script>

</body>
</html>
