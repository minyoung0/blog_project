<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi"
	crossorigin="anonymous">

</head>
<body>
	 <nav class="navbar navbar-expand-lg bg-body-tertiary">
		<div class="container-fluid">
			<a class="navbar-brand" href="/main/main.do">HOME</a>
			<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarNav">

				<c:forEach items="${menuList}" var="menu" varStatus="status">
					<c:choose>
						<c:when test="${sessionScope.accessRight eq null}">
							<c:if test="${menu.menuAccessRight =='guest'}">
								<ul class="navbar-nav">
									<c:if test="${menu.boardtypeId == 4}">
										<li class="nav-item"><a class="nav-link" href="javascript:void(0);" onclick="logExternalAccess('${menu.menuId}', 'http://${menu.menuUrl}')">${menu.menuName}</a></li>
									</c:if>
									<c:if test="${menu.boardtypeId != 4}">
										<li class="nav-item"><a class="nav-link" href="${menu.menuUrl}">${menu.menuName}</a></li>
									</c:if>
								</ul>
							</c:if>
						</c:when>
						<c:when test="${sessionScope.accessRight =='normal'}">
							<c:if test="${menu.menuAccessRight =='guest' || menu.menuAccessRight=='normal'}">
								<ul class="navbar-nav">
									<c:if test="${menu.boardtypeId == 4}">
										<li class="nav-item"><a class="nav-link" href="javascript:void(0);" onclick="logExternalAccess('${menu.menuId}', 'http://${menu.menuUrl}')">${menu.menuName}</a></li>
									</c:if>
									<c:if test="${menu.boardtypeId != 4}">
										<li class="nav-item"><a class="nav-link" href="${menu.menuUrl}">${menu.menuName}</a></li>
									</c:if>
								</ul>
							</c:if>
						</c:when>
						<c:when test="${sessionScope.accessRight=='admin'}">
							<c:if test="${menu.menuAccessRight =='guest'||menu.menuAccessRight =='normal'||menu.menuAccessRight=='admin'}">
								<ul class="navbar-nav">
									<c:if test="${menu.boardtypeId == 4}">
										<li class="nav-item"><a class="nav-link" href="javascript:void(0);" onclick="logExternalAccess('${menu.menuId}', 'http://${menu.menuUrl}')">${menu.menuName}</a></li>
									</c:if>
									<c:if test="${menu.boardtypeId != 4}">
										<li class="nav-item"><a class="nav-link" href="${menu.menuUrl}">${menu.menuName}</a></li>
									</c:if>
								</ul>
							</c:if>
						</c:when>
						<c:when test="${sessionScope.accessRight =='superAdmin'}">
							<c:if test="${menu.menuAccessRight =='guest'||menu.menuAccessRight =='normal'||menu.menuAccessRight =='admin'||menu.menuAccessRight=='superAdmin'}">
								<ul class="navbar-nav">
									<c:if test="${menu.boardtypeId == 4}">
										<li class="nav-item"><a class="nav-link" href="javascript:void(0);" onclick="logExternalAccess('${menu.menuId}', 'http://${menu.menuUrl}')">${menu.menuName}</a></li>
									</c:if>
									<c:if test="${menu.boardtypeId != 4}">
										<li class="nav-item"><a class="nav-link" href="${menu.menuUrl}">${menu.menuName}</a></li>
									</c:if>
								</ul>
							</c:if>
						</c:when>
						<c:when test="${menu.menuAccessRight =='guest'}">
								<ul class="navbar-nav">
									<c:if test="${menu.boardtypeId == 4}">
										<li class="nav-item"><a class="nav-link" href="javascript:void(0);" onclick="logExternalAccess('${menu.menuId}', 'http://${menu.menuUrl}')">${menu.menuName}</a></li>
									</c:if>
									<c:if test="${menu.boardtypeId != 4}">
										<li class="nav-item"><a class="nav-link" href="${menu.menuUrl}">${menu.menuName}</a></li>
									</c:if>
								</ul>
								</c:when>
<%-- 						<c:otherwise>
							<c:if test="${menu.menuAccessRight=='normal'}">
								<ul class="navbar-nav">
									<c:if test="${menu.boardtypeId == 4}">
										<li class="nav-item"><a class="nav-link" onclick="window.open('http://${menu.menuUrl}')">${menu.menuName}</a></li>
									</c:if>
									<c:if test="${menu.boardtypeId != 4}">
										<li class="nav-item"><a class="nav-link" href="${menu.menuUrl}">${menu.menuName}</a></li>
									</c:if>
									사용자 권한 ${sessionScope.accessRight}
								</ul>
							</c:if>
						</c:otherwise> --%>
					</c:choose>
				</c:forEach>
			</div>
		</div>
	</nav>
	<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
	<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
	<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
	<script>

		function logExternalAccess(menuId, menuUrl) {
			// AJAX 요청으로 로그 저장
			$.ajax({
				url : '/main/externalLog.do',
				method : 'POST',
				data : {
					menuId : menuId,
					menuUrl : menuUrl
				},
				success : function(response) {
					if (response.success) {
						console.log(response.message);
						// 로그 저장 후 외부 URL 열기
						window.open(menuUrl, '_blank');
					} else {
						console.error('로그 저장 실패:', response.message);
					}
				},
				error : function(error) {
					console.error('AJAX 요청 실패:', error);
					// 실패 시에도 외부 URL 열기
					window.open(menuUrl, '_blank');
				}
			});
		}
	</script>

 
 </body>
</html>