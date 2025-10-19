<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>태그: ${tagName} 게시물</title>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border: none;
            border-radius: 10px;
        }
        .card img {
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            object-fit: cover;
            height: 200px;
        }
        .card-title {
            font-size: 1.25rem;
            font-weight: bold;
        }
        .btn-primary {
            background-color: #007bff;
            border: none;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        h1 {
            font-size: 2.5rem;
            font-weight: bold;
            color: #343a40;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h1 class="text-center mb-5">태그: ${tagName}</h1>
        <div class="row g-4">
            <c:forEach var="gallery" items="${galleries}">
                <div class="col-lg-4 col-md-6">
                    <div class="card h-100">
                        <img src="${gallery.thumbnailPath}" class="card-img-top" alt="${gallery.boardTitle}">
                        <div class="card-body">
                            <h5 class="card-title">${gallery.boardTitle}</h5>
                            <p class="card-text text-truncate">${gallery.boardContent}</p>
                            <a href="/gallery/galleryDetail.do?boardId=${gallery.boardId}" class="btn btn-primary w-100">자세히 보기</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>