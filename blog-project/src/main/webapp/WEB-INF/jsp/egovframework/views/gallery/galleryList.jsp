<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
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
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="egovframework.fusion.user.vo.UserVO"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi"
	crossorigin="anonymous">


<title>퓨전 게시판(목록)</title>

<style>
/* 전체 레이아웃 */
body {
	font-family: 'Arial', sans-serif;
	background-color: #f8f9fa;
	margin: 0;
	padding: 0;
}

h1 {
	text-align: center;
	margin-top: 20px;
	color: #007bff;
}

main {
	padding: 20px;
}

/* 갤러리 그리드 */
.gallery-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
	gap: 20px;
	margin-top: 20px;
}

/* 카드 스타일 */
.gallery-card {
	border: 1px solid #ddd;
	border-radius: 10px;
	overflow: hidden;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	transition: transform 0.2s, box-shadow 0.2s;
	background-color: #fff;
	text-decoration: none;
	color: inherit;
}

.gallery-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

/* 썸네일 스타일 */
.gallery-thumbnail {
	width: 100%;
	height: 200px;
	object-fit: cover;
}

/* 카드 정보 */
.gallery-info {
	padding: 15px;
	text-align: center;
}

.gallery-info h5 {
	font-size: 1.2em;
	font-weight: bold;
	color: #333;
	margin-bottom: 10px;
	display: -webkit-box;
	-webkit-box-orient: vertical;
	overflow: hidden;
	text-overflow: ellipsis;
	line-clamp: 2;
	-webkit-line-clamp: 2;
}

.gallery-info p {
	font-size: 0.95em;
	color: #666;
	margin-bottom: 10px;
	display: -webkit-box;
	-webkit-box-orient: vertical;
	overflow: hidden;
	text-overflow: ellipsis;
	line-clamp: 2;
	-webkit-line-clamp: 2;
	max-height: 3em;
}

.gallery-info .meta {
	font-size: 0.9em;
	color: #888;
}

/* 검색 폼 및 필터 */
form {
	display: flex;
	flex-wrap: wrap;
	gap: 10px;
	margin-bottom: 20px;
}

form .form-select, form .form-control {
	width: auto;
	flex: 1;
}

form .btn-primary {
	height: 38px;
	font-size: 0.95em;
}

/* 페이징 */
.pagination {
	margin-top: 30px;
	justify-content: center;
}

.pagination .page-item.active .page-link {
	background-color: #007bff;
	color: #fff;
	border-color: #007bff;
	font-weight: bold;
}

.pagination .page-link {
	color: #007bff;
	border: 1px solid #ddd;
}

.pagination .page-link:hover {
	background-color: #e9ecef;
	color: #0056b3;
}

/* 로그인/로그아웃 */
.auth-section {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	margin-bottom: 20px;
}

.auth-section span {
	font-size: 16px;
	color: #555;
}
</style>
</head>
<body>
	<%
	UserVO loggedInUser = (UserVO) session.getAttribute("loggedInUser");
	String userId = (String) session.getAttribute("userId");
	%>
	
	<div class="container">
		<h1>
			<a href="/gallery/galleryList.do" style="text-decoration: none; color: inherit;">동물 갤러리</a>
		</h1>
		<!-- 로그인/로그아웃 -->
		<div class="auth-section">
			<c:choose>
				<c:when test="${loggedInUser == null}">
					<button type="button" class="btn btn-outline-primary" onclick="location.href='/user/loginPage.do'">로그인</button>
				</c:when>
				<c:otherwise>
					<span>${userId}님</span>
					<button type="button" class="btn btn-outline-primary" onclick="location.href='/user/logout.do'">로그아웃</button>
					<!-- <a href="/gallery/galleryRegister.do" class="btn btn-primary"><i class="fas fa-edit"></i> 글 작성</a> -->
					<a onclick="openPopup('/gallery/galleryRegister.do')"  class="btn btn-primary"><i class="fas fa-edit"></i> 글 작성</a>
					<!-- <a href="javascript:void(0);" class="gallery-card" onclick="openPopup('/gallery/galleryRegister.do')" class="btn btn-primary"><i class="fas fa-edit"></i> 글 작성</a> -->
				</c:otherwise>
			</c:choose>
		</div>

	<!-- 검색 및 필터 -->
		<form action="/gallery/gallerySearch.do" method="get">
			<select name="limit" class="form-select" onchange="this.form.submit()">
				<option value="" selected>게시글 수</option>
				<option value="10" ${selectedlimit==10 ? 'selected':''}>10개</option>
				<option value="20" ${selectedlimit==20 ? 'selected':''}>20개</option>
				<option value="30" ${selectedlimit==30 ? 'selected':''}>30개</option>
			</select> <select name="searchType" class="form-select">
				<option value="title" ${param.searchType == 'title' ? 'selected' : ''}>제목</option>
				<option value="content" ${param.searchType == 'content' ? 'selected' : ''}>내용</option>
				<option value="writer" ${param.searchType == 'writer' ? 'selected' : ''}>작성자</option>
				<option value="tag" ${param.searchType == 'tag' ? 'selected' : ''}>태그</option>
				<option value="imgName" ${param.searchType == 'tag' ? 'selected' : ''}>이미지명</option>
			</select> <input type="text" name="keyword" class="form-control" placeholder="검색어 입력" value="${param.keyword}">
			<button type="submit" class="btn btn-primary">검색</button>
		</form>

	<!-- 갤러리 -->
	    <div class="gallery-grid">
        <c:forEach var="gallery" items="${galleryList}">
            <a href="/gallery/galleryDetail.do?boardId=${gallery.boardId}" class="gallery-card">
                <img src="${gallery.thumbnailPath}" alt="${gallery.boardTitle}" class="gallery-thumbnail">
                <div class="gallery-info">
                    <h5>${gallery.boardTitle}</h5>
                    <p>${gallery.boardContent}</p>
                    <div class="meta">
                        작성일: ${gallery.boardRegistDatetime} | 작성자: ${gallery.userName} <br>
                        조회수: ${gallery.viewCount} | 좋아요: ${gallery.likeCount}
                    </div>
                </div>
            </a>
        </c:forEach>
    </div>
	<%
	if (loggedInUser != null) {
	%>
	<div class="card-header">
		<a onclick="openPopup('/gallery/galleryRegister.do?menuId=${menuId}')" class="btn btn-primary"><i class="fas fa-edit"></i> 글 작성</a>
	</div>
	<%
	}
	%><br>

	<div class="gallery-grid">
		<c:choose>
			<c:when test="${not empty galleryList}">
				<c:forEach var="gallery" items="${galleryList}">
					<a href="/gallery/galleryDetail.do?boardId=${gallery.boardId}" class="gallery-card">
					<a href="javascript:void(0);" class="gallery-card" onclick="openPopup('/gallery/galleryDetail.do?boardId=${gallery.boardId}')"> <img src="${gallery.thumbnailPath}" alt="${gallery.boardTitle}"
						class="gallery-thumbnail">
						<div class="gallery-info">
							<h5>${gallery.boardTitle}</h5>
							<p>${gallery.boardContent}</p>
							<div class="meta">
								작성일: ${gallery.boardRegistDatetime} | 작성자: ${gallery.userName} <br> 조회수: ${gallery.viewCount} | 좋아요: ${gallery.likeCount}
							</div>
						</div>
					</a>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<div class="no-results">
					<p>일치하는 항목이 없습니다.</p>
				</div>
			</c:otherwise>
		</c:choose>
	</div>

	<!-- 페이징 -->
	<nav aria-label="Page navigation">
		<ul class="pagination">
			<c:if test="${totalPage > 0}">
				<c:forEach var="i" begin="1" end="${totalPage}">
					<li class="page-item ${currentPage == i ? 'active' : ''}"><a class="page-link" href="/gallery/galleryList.do?menuId=${menuId}&page=${i}&limit=${selectedLimit}">${i}</a></li>
				</c:forEach>
			</c:if>
		</ul>
	</nav>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		function openPopup(url) {
			window.open(url, 'popup', 'width=900,height=800,scrollbars=yes');
		}
	</script>
</body>
</html> --%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>퓨전 게시판(목록)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 전체 레이아웃 */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }

        h1 {
            text-align: center;
            margin-top: 20px;
            color: #007bff;
        }

        main {
            padding: 20px;
        }

        /* 갤러리 그리드 */
        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        /* 카드 스타일 */
        .gallery-card {
            border: 1px solid #ddd;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s, box-shadow 0.2s;
            background-color: #fff;
            text-decoration: none;
            color: inherit;
        }

        .gallery-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }

        /* 썸네일 스타일 */
        .gallery-thumbnail {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        /* 카드 정보 */
        .gallery-info {
            padding: 15px;
            text-align: center;
        }

        .gallery-info h5 {
            font-size: 1.2em;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        .gallery-info p {
            font-size: 0.95em;
            color: #666;
            margin-bottom: 10px;
        }

        .gallery-info .meta {
            font-size: 0.9em;
            color: #888;
        }

        /* 검색 및 필터 */
        form {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
        }

        form .form-select, form .form-control {
            width: auto;
            flex: 1;
        }

        form .btn-primary {
            height: 38px;
            font-size: 0.95em;
        }

        /* 페이징 */
        .pagination {
            margin-top: 30px;
            justify-content: center;
        }

        .pagination .page-item.active .page-link {
            background-color: #007bff;
            color: #fff;
            border-color: #007bff;
            font-weight: bold;
        }

        .pagination .page-link {
            color: #007bff;
            border: 1px solid #ddd;
        }

        .pagination .page-link:hover {
            background-color: #e9ecef;
            color: #0056b3;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>동물 갤러리</h1>
        <!-- 검색 폼 -->
        <form>
            <select class="form-select">
                <option value="10" selected>10개</option>
                <option value="20">20개</option>
                <option value="30">30개</option>
            </select>
            <select class="form-select">
                <option value="title">제목</option>
                <option value="content">내용</option>
                <option value="writer">작성자</option>
            </select>
            <input type="text" class="form-control" placeholder="검색어 입력">
            <button type="submit" class="btn btn-primary">검색</button>
        </form>

        <!-- 갤러리 리스트 -->
        <div class="gallery-grid">
            <a href="javascript:void(0);" class="gallery-card" onclick="openPopup('/gallery/test.do')">
                <img src="/imgfolder/sample1.jpg" alt="샘플 게시글 1" class="gallery-thumbnail">
                <div class="gallery-info">
                    <h5>우리집 강아지</h5>
                    <p>귀엽죵</p>
                    <div class="meta">
                        작성일: 2025-02-28 | 작성자: my2 <br>
                        조회수: 10 | 좋아요: 1
                    </div>
                </div>
            </a>

            <a href="javascript:void(0);" class="gallery-card">
                <img src="/imgfolder/sample2.jpg" alt="샘플 게시글 2" class="gallery-thumbnail">
                <div class="gallery-info">
                    <h5>고양이</h5>
                    <p>너무 귀여운 고양이</p>
                    <div class="meta">
                        작성일: 2025-02-27 | 작성자: 불닭보끔면 <br>
                        조회수: 20 | 좋아요: 8
                    </div>
                </div>
            </a>

            <a href="javascript:void(0);" class="gallery-card">
                <img src="/imgfolder/sample3.png" alt="샘플 게시글 3" class="gallery-thumbnail">
                <div class="gallery-info">
                    <h5>냥냥이</h5>
                    <p>냥냥냥냥</p>
                    <div class="meta">
                        작성일: 2025-02-26 | 작성자: 동해번쩍서해번쩍 <br>
                        조회수: 15 | 좋아요: 3
                    </div>
                </div>
            </a>
        </div>

        <!-- 페이징 -->
        <nav aria-label="Page navigation">
            <ul class="pagination">
                <li class="page-item active"><a class="page-link" href="#">1</a></li>
            </ul>
        </nav>
    </div>

    <script>
        function openPopup(url) {
            window.open(url, 'popup', 'width=900,height=800,scrollbars=yes');
        }
    </script>

</body>
</html>
