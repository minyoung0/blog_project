<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="egovframework.fusion.user.vo.UserVO"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>게시글 상세보기</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<style>
/* 이미지 슬라이더 */
.carousel-inner img {
	width: 100%;
	height: 400px;
	object-fit: cover;
	border-radius: 8px;
}

.content-container {
	padding: 20px;
	background-color: #f8f9fa;
	border-radius: 10px;
	box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.1);
}

.btn-container {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
}

.like-section {
	display: flex;
	align-items: center;
	gap: 10px;
}

.like-section button {
	display: flex;
	align-items: center;
}

#likeButton i {
	margin-right: 5px; /* 하트 아이콘과 텍스트 사이 간격 */
}

.tag-container a {
	margin-bottom: 5px;
}

.download-section {
	text-align: center;
	margin-top: 20px;
}

.download-section a {
	margin-top: 10px;
}
</style>
</head>
<body>
	<div class="container mt-5">
		<!-- 게시글 카드 -->
		<div class="card shadow-lg mb-4">
			<div class="card-body">
				<h1 class="card-title text-primary">${gallery.boardTitle}</h1>
				<hr>
				<div class="row">
					<!-- 이미지 및 슬라이더 -->
					<div class="col-lg-6">
						<div id="imageCarousel" class="carousel slide" data-bs-ride="carousel">
							<div class="carousel-inner">
								<c:forEach var="file" items="${files}" varStatus="status">
									<div class="carousel-item ${status.first ? 'active' : ''}">
										<img src="/imgfolder/${file.storedName}" alt="${file.originalName}">
										<div class="download-section">
											<p>${file.originalName}</p>
											<a href="/imgfolder/${file.storedName}" class="btn btn-primary btn-sm download-btn" download="${file.originalName}" data-file-id="${file.fileId}"> <i class="fas fa-download"></i> 다운로드 (<span
												class="download-count">${file.fileDowncount}회</span>)
											</a>

										</div>
									</div>
								</c:forEach>
							</div>
							<div class="carousel-inner">
								<c:forEach var="file" items="${files}" varStatus="status">
									<div class="carousel-item ${status.first ? 'active' : ''}">
										<img src="/imgfolder/${file.storedName}" alt="${file.originalName}">
										<div class="download-section">
											<p>${file.originalName}</p>
											<a href="/imgfolder/${file.storedName}" class="btn btn-primary btn-sm download-btn" data-file-id="${file.fileId}"
												onclick="incrementDownloadCount(event, '${file.fileId}', '/imgfolder/${file.storedName}', '${file.originalName}')" style="margin-bottom:20px;'"> <i class="fas fa-download"></i> 다운로드 (<span class="download-count">${file.fileDowncount}회</span>)
											</a>

										</div>
									</div>
								</c:forEach>
							</div>
							<!-- 슬라이더 컨트롤 -->
							<button class="carousel-control-prev" type="button" data-bs-target="#imageCarousel" data-bs-slide="prev">
								<span class="carousel-control-prev-icon" aria-hidden="true"></span> <span class="visually-hidden">Previous</span>
							</button>
							<button class="carousel-control-next" type="button" data-bs-target="#imageCarousel" data-bs-slide="next">
								<span class="carousel-control-next-icon" aria-hidden="true"></span> <span class="visually-hidden">Next</span>
							</button>
						</div>
					</div>
					<!-- 게시글 정보 -->
					<div class="col-lg-6">
						<div class="content-container">
							<p>
								<strong>작성일:</strong> ${gallery.boardRegistDatetime}
							</p>
							<p>
								<strong>작성자:</strong> ${gallery.userName}
							</p>
							<p>
								<strong>조회수:</strong> ${gallery.viewCount}
							</p>
							<div class="like-section">
								<strong>좋아요:</strong> <span id="likeCount" class="badge bg-success">${gallery.likeCount}</span>
								<button id="likeButton" class="btn btn-outline-success btn-sm" data-liked="false">
									<i class="fas fa-thumbs-up"></i> Like
								</button>
							</div>
							<hr>
							<p>
								<strong>내용:</strong> ${gallery.boardContent}
							</p>
						</div>
					</div>
				</div>
				<!-- 태그 -->
				<div class="mt-4">
					<h5>태그</h5>
					<div class="tag-container d-flex gap-2 flex-wrap">
						<c:forEach var="tag" items="${tags}">
							<a href="/gallery/postsByTag.do?tagName=${tag.tagName}" class="btn btn-outline-secondary btn-sm">${tag.tagName}</a>
						</c:forEach>
					</div>
				</div>
				<!-- 수정 및 삭제 버튼 -->
				<div class="mt-4 btn-container">
					<c:if test="${loggedInUser != null && loggedInUser.userId == gallery.userId}">
						<button class="btn btn-warning" onclick="location.href='/gallery/editPost.do?boardId=${gallery.boardId}'">수정하기</button>
						<button class="btn btn-danger" onclick="deletePost(${gallery.boardId})">삭제하기</button>
					</c:if>
				</div>
			</div>
		</div>
	</div>

	<!-- Bootstrap JS -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.1.min.js"></script>
	<script>

    document.addEventListener("DOMContentLoaded", function () {
        const likeButton = document.getElementById("likeButton");
        const likeCount = document.getElementById("likeCount");

        likeButton.addEventListener("click", function () {
            const isLiked = likeButton.getAttribute("data-liked") === "true";
            const newStatus = !isLiked; // 좋아요 상태를 반전
            

            $.ajax({
                type: 'POST',
                url: '/gallery/likePost.do',
                data: JSON.stringify({ boardId: ${gallery.boardId}, liked: newStatus }),
                contentType: 'application/json',
                success: function (response) {
                    if (response.success) {
                        likeCount.textContent = response.likeCount;
                        likeButton.setAttribute("data-liked", newStatus.toString());
                        
                        // 버튼 스타일 업데이트
                        if (newStatus) {
                            likeButton.classList.remove("btn-outline-success");
                            likeButton.classList.add("btn-success");
                            likeButton.innerHTML = '<i class="fas fa-thumbs-up"></i> Liked';
                        } else {
                            likeButton.classList.remove("btn-success");
                            likeButton.classList.add("btn-outline-success");
                            likeButton.innerHTML = '<i class="fas fa-thumbs-up"></i> Like';
                        }
                    } else {
                        alert('좋아요 처리에 실패했습니다.');
                    }
                },
                error: function () {
                    alert('서버 오류가 발생했습니다.');
                }
            });
        });
    });

    // 삭제 버튼 이벤트
    function deletePost(boardId) {
        if (confirm("정말로 삭제하시겠습니까?")) {
            $.ajax({
                type: 'POST',
                url: '/gallery/deletePost.do',
                data: { boardId: boardId },
                success: function(response) {
                    if (response.success) {
                        alert("게시글이 삭제되었습니다.");
                        window.location.href = '/gallery/galleryList.do';
                    } else {
                        alert("게시글 삭제에 실패했습니다.");
                    }
                },
                error: function() {
                    alert("서버 오류가 발생했습니다.");
                }
            });
        }
    }
    
    function incrementDownloadCount(event, fileId, fileUrl,fileName) {
        // 기본 동작 차단 (파일 다운로드 방지)
        event.preventDefault();

        // AJAX 요청으로 다운로드 횟수 증가
        fetch('/gallery/increaseDownloadCount.do', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ fileId: fileId }),
        })
        .then(response => {
            if (response.ok) {
                console.log('다운로드 횟수 증가 성공');
                // 다운로드 트리거
 /*                window.location.href = fileUrl; */
  const anchor = document.createElement('a'); // 임시 `<a>` 태그 생성
            anchor.href = fileUrl;
            anchor.download =fileName; // 다운로드 강제
            anchor.click(); // 다운로드 트리거
            
            } else {
                console.error('다운로드 횟수 증가 실패');
            }
        })
        .catch(error => {
            console.error('AJAX 요청 중 에러 발생:', error);
        });
    }
    
/*    document.addEventListener('DOMContentLoaded', function () {
        // 모든 다운로드 버튼에 이벤트 리스너 추가
        const downloadButtons = document.querySelectorAll('.download-btn');

        button.addEventListener('click', function (event) {
            event.preventDefault(); // 기본 동작 차단
            const fileId = this.getAttribute('data-file-id');
            const fileUrl = this.getAttribute('href');

            // AJAX 요청으로 다운로드 횟수 증가
            fetch('/gallery/updateDownloadCount.do', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ fileId: fileId }),
            })
            .then(response => {
                if (response.ok) {
                    // AJAX 성공 후 파일 다운로드 트리거
                    window.location.href = fileUrl;
                } else {
                    console.error('다운로드 횟수 업데이트 실패');
                }
            })
            .catch(error => {
                console.error('에러 발생:', error);
            });
        });

      });  */


</script>
</body>
</html> --%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>게시글 상세보기</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<style>
/* 이미지 슬라이더 */
.carousel-inner img {
	width: 100%;
	height: 400px;
	object-fit: cover;
	border-radius: 8px;
}

.content-container {
	padding: 20px;
	background-color: #f8f9fa;
	border-radius: 10px;
	box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.1);
}

.btn-container {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
}

.like-section {
	display: flex;
	align-items: center;
	gap: 10px;
}

.like-section button {
	display: flex;
	align-items: center;
}

#likeButton i {
	margin-right: 5px; /* 하트 아이콘과 텍스트 사이 간격 */
}

.tag-container a {
	margin-bottom: 5px;
}

.download-section {
	text-align: center;
	margin-top: 20px;
}

.download-section a {
	margin-top: 10px;
}
</style>
</head>
<body>
	<div class="container mt-5">
		<!-- 게시글 카드 -->
		<div class="card shadow-lg mb-4">
			<div class="card-body">
				<h1 class="card-title text-primary">샘플 게시글 제목</h1>
				<hr>
				<div class="row">
					<!-- 이미지 및 슬라이더 -->
					<div class="col-lg-6">
						<div id="imageCarousel" class="carousel slide" data-bs-ride="carousel">
							<div class="carousel-inner">
								<div class="carousel-item active">
									<img src="/imgfolder/sample1.jpg" alt="샘플 이미지 1">
									<div class="download-section">
										<p>sample1.jpg</p>
										<a href="/imgfolder/sample1.jpg" class="btn btn-primary btn-sm download-btn" download="sample1.jpg"> 
											<i class="fas fa-download"></i> 다운로드 (5회)
										</a>
									</div>
								</div>
								<div class="carousel-item">
									<img src="/imgfolder/sample2.jpg" alt="샘플 이미지 2">
									<div class="download-section">
										<p>sample2.jpg</p>
										<a href="/imgfolder/sample2.jpg" class="btn btn-primary btn-sm download-btn" download="sample2.jpg"> 
											<i class="fas fa-download"></i> 다운로드 (3회)
										</a>
									</div>
								</div>
							</div>
							<!-- 슬라이더 컨트롤 -->
							<button class="carousel-control-prev" type="button" data-bs-target="#imageCarousel" data-bs-slide="prev">
								<span class="carousel-control-prev-icon" aria-hidden="true"></span> 
								<span class="visually-hidden">Previous</span>
							</button>
							<button class="carousel-control-next" type="button" data-bs-target="#imageCarousel" data-bs-slide="next">
								<span class="carousel-control-next-icon" aria-hidden="true"></span> 
								<span class="visually-hidden">Next</span>
							</button>
						</div>
					</div>
					<!-- 게시글 정보 -->
					<div class="col-lg-6">
						<div class="content-container">
							<p><strong>작성일:</strong> 2025-02-28</p>
							<p><strong>작성자:</strong> 관리자</p>
							<p><strong>조회수:</strong> 10</p>
							<div class="like-section">
								<strong>좋아요:</strong> <span id="likeCount" class="badge bg-success">7</span>
								<button id="likeButton" class="btn btn-outline-success btn-sm">
									<i class="fas fa-thumbs-up"></i> Like
								</button>
							</div>
							<hr>
							<p><strong>내용:</strong> 이 게시글은 샘플 게시글입니다. 여기에 게시글의 내용이 들어갑니다.</p>
						</div>
					</div>
				</div>
				<!-- 태그 -->
				<div class="mt-4">
					<h5>태그</h5>
					<div class="tag-container d-flex gap-2 flex-wrap">
						<a href="#" class="btn btn-outline-secondary btn-sm">샘플태그1</a>
						<a href="#" class="btn btn-outline-secondary btn-sm">샘플태그2</a>
					</div>
				</div>
				<!-- 수정 및 삭제 버튼 -->
				<div class="mt-4 btn-container">
					<button class="btn btn-warning">수정하기</button>
					<button class="btn btn-danger">삭제하기</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Bootstrap JS -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
	<script>

    document.addEventListener("DOMContentLoaded", function () {
        const likeButton = document.getElementById("likeButton");
        const likeCount = document.getElementById("likeCount");

        likeButton.addEventListener("click", function () {
            let currentLikes = parseInt(likeCount.textContent, 10);
            if (likeButton.classList.contains("btn-outline-success")) {
                likeCount.textContent = currentLikes + 1;
                likeButton.classList.remove("btn-outline-success");
                likeButton.classList.add("btn-success");
                likeButton.innerHTML = '<i class="fas fa-thumbs-up"></i> Liked';
            } else {
                likeCount.textContent = currentLikes - 1;
                likeButton.classList.remove("btn-success");
                likeButton.classList.add("btn-outline-success");
                likeButton.innerHTML = '<i class="fas fa-thumbs-up"></i> Like';
            }
        });
    });

    // 삭제 버튼 이벤트
    function deletePost() {
        if (confirm("정말로 삭제하시겠습니까?")) {
            alert("게시글이 삭제되었습니다.");
            window.location.href = '/gallery/galleryList.do';
        }
    }

    // 다운로드 횟수 증가 (AJAX 없이)
    function incrementDownloadCount(fileUrl, fileName) {
        const anchor = document.createElement('a'); // 임시 `<a>` 태그 생성
        anchor.href = fileUrl;
        anchor.download = fileName; // 다운로드 강제
        anchor.click(); // 다운로드 트리거
    }

</script>
</body>
</html>

