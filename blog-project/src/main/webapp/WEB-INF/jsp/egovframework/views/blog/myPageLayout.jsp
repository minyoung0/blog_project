<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>Insert title here</title>
</head>
<style>
.row{
	display:flex;
	flex-direction:row;
	justify-content:space-evenly;
}
</style>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
<body>

    <!-- 헤더 (기존 유지) -->
    <tiles:insertAttribute name="header"/>

    <!-- 마이페이지 컨테이너 -->
    <div class="container mt-3 sideBody">
        <div class="row">
            <!-- 왼쪽 카테고리 -->
            <div class="col-md-3 sidebar">
                <tiles:insertAttribute name="sidebar"/>
            </div>

            <!-- 오른쪽 본문 -->
            <div class="col-md-8 content">
                <tiles:insertAttribute name="content"/>
            </div>
        </div>
    </div>

</body>
</html>