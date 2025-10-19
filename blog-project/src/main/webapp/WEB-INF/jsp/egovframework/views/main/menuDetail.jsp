<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메뉴 상세 페이지</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.6.1.js"></script>
</head>
<body class="container mt-5">
    <div class="card p-4 shadow-lg">
        <h2 class="text-center mb-4">메뉴 상세 페이지</h2>
        <ul class="list-group list-group-flush">
            <li class="list-group-item"><strong>메뉴 아이디:</strong> ${menuDetail.menuId}</li>
            <li class="list-group-item"><strong>메뉴명:</strong> ${menuDetail.menuName}</li>
            <li class="list-group-item"><strong>메뉴 주소:</strong> ${menuDetail.menuUrl}</li>
            <li class="list-group-item"><strong>메뉴 생성 날짜:</strong> ${menuDetail.menuCreateAt}</li>
            <li class="list-group-item"><strong>메뉴 접근 권한:</strong> ${menuDetail.menuAccessRight}</li>
            <li class="list-group-item"><strong>메뉴 활성화 여부:</strong> ${menuDetail.deleteYn == 0 ? 'O' : 'X'}</li>
            <li class="list-group-item"><strong>메뉴 게시판 타입:</strong> ${menuDetail.boardtypeName}</li>
        </ul>
        <div class="mt-4 text-center">
            <button type="button" onclick="openPopup('/main/menuModifyPage.do?menuId=${menuDetail.menuId}')" class="btn btn-primary">수정하기</button>
            <button type="button" id="deleteButton" class="btn btn-danger">해당 메뉴 삭제하기</button>
        </div>
    </div>
    <script>
        function openPopup(url) {
            window.open(url, 'popup', 'width=900,height=800,scrollbars=yes');
        }

        $(document).ready(function() {
            $("#deleteButton").click(function() {
                if (confirm('삭제하시겠습니까?')) {
                    $.ajax({
                        url:'/main/deleteMenu.do',
                        type: 'POST',
                        data: {menuId: ${menuDetail.menuId}},
                        success: function(response) {
                            if(response.status === "success") {
                                alert(response.message);
                                window.close();
                                opener.location.reload();
                            } else {
                                alert(response.message);
                            }
                        },
                        error: function(request, status, error) {
                            console.error("code: " + request.status);
                            console.error("message: " + request.responseText);
                            console.error("error: " + error);
                        }
                    });
                }
            });
        });
    </script>
</body>
</html>
