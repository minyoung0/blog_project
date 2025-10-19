<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메뉴 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <h2 class="mb-4 text-center">메뉴 관리</h2>
        
        <form id="deleteForm" action="/main/checkDelMenu.do" method="post">
            <div class="table-responsive">
                <table class="table table-hover table-bordered text-center align-middle">
                    <thead class="table-primary">
                        <tr>
                            <th>선택</th>
                            <th>게시판 이름</th>
                            <th>게시판 주소</th>
                            <th>접근권한</th>
                            <th>게시판 타입</th>
                            <th>화면 노출 여부</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${menuAllList}" var="menu">
                            <tr>
                                <td><input type="checkbox" name="menuIds" value="${menu.menuId}"></td>
                                <td><a href="#" onclick="openPopup('/main/menuDetail.do?menuId=${menu.menuId}')" class="text-decoration-none">${menu.menuName}</a></td>
                                <td>${menu.menuUrl}</td>
                                <td>${menu.menuAccessRight}</td>
                                <td>${menu.boardtypeName}</td>
                                <td>
                                    <span class="badge ${menu.deleteYn == 0 ? 'bg-success' : 'bg-danger'}">
                                        ${menu.deleteYn == 0 ? 'O' : 'X'}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <div class="d-flex justify-content-between">
                <button type="button" id="deleteButton" class="btn btn-danger">선택 메뉴 비활성화</button>
                <button type="button"id="addMenu" onclick="openPopup('/main/addMenuPage.do')" class="btn btn-primary">메뉴 추가</button>
            </div>
        </form>
        
        <nav aria-label="Page navigation" class="mt-4">
            <ul class="pagination justify-content-center">
                <c:if test="${totalPage > 0}">
                    <c:forEach var="i" begin="1" end="${totalPage}">
                        <li class="page-item ${currentPage == i ? 'active' : ''}"><a class="page-link" href="/main/menuManagement.do?page=${i}&limit=${selectedLimit}">${i}</a></li>
                    </c:forEach>
                </c:if>
            </ul>
        </nav>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.6.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openPopup(url) {
            window.open(url, 'popup', 'width=800,height=600,scrollbars=yes');
        }

        $(document).ready(function() {
            $("#deleteButton").click(function(e) {
            	e.preventDefault();
                const checkedItems = $("input[name='menuIds']:checked");
                if (checkedItems.length === 0) {
                    alert("비활성화할 게시글을 선택하세요.");
                    return;
                }
                if (confirm("선택한 게시글을 비활성화하시겠습니까?")) {
                    $("#deleteForm").submit();
                }
            });
        });
    </script>
</body>
</html>
