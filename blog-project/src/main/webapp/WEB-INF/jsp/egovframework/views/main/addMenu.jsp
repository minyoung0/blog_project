<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>메뉴 추가</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.6.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0">메뉴 추가 페이지</h4>
        </div>
        <div class="card-body">
            <form>
                <div class="mb-3">
                    <label for="menuType" class="form-label">메뉴 유형</label>
                    <select name="menuType" id="menuType" class="form-select">
                        <option value="normal">글게시판</option>
                        <option value="gallery">갤러리게시판</option>
                        <option value="survey">설문게시판</option>
                        <option value="link">링크형게시판</option>
                        <option value="progress">진행단계 게시판</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="accessRight" class="form-label">접근 권한</label>
                    <select name="accessRight" id="accessRight" class="form-select">
                        <option value="guest">비회원</option>
                        <option value="normal">일반회원</option>
                        <option value="admin">일반 관리자</option>
                        <option value="superAdmin">슈퍼 관리자</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="menuName" class="form-label">메뉴 이름</label>
                    <input type="text" id="menuName" class="form-control" placeholder="메뉴 이름을 입력해주세요">
                </div>

                <div class="mb-3 d-flex align-items-center">
                    <input type="text" class="form-control me-2" name="linkDirect" id="linkDirect" placeholder="링크 주소를 입력하세요 ex)www.naver.com" value="1">
                    <button type="button" class="btn btn-outline-info" onclick="urlChk();" id="urlCheckButton">URL 체크</button>
                </div>
                <div id="result" class="text-danger"></div>

                <div class="d-flex justify-content-end mt-4">
                    <button type="button" id="submitButton" class="btn btn-success">
                        <i class="bi bi-plus-circle"></i> 추가
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function isValidURL(url) {
    var RegExp = /[\w\-]+(\.[\w\-]+)+[/#?]?.*$/;
    return RegExp.test(url);
}

function urlChk() {
    var url = $("#linkDirect").val();
    var message = isValidURL(url) ? "올바른 URL 입니다." : "URL을 정확히 입력해주세요.";
    $("#result").html(message);
}

$(function() {
    $("#linkDirect, #urlCheckButton").hide();
    $("#menuType").change(function() {
        if ($("#menuType").val() == "link") {
            $("#linkDirect, #urlCheckButton").show();
        } else {
            $("#linkDirect, #urlCheckButton").hide();
        }
    });
});

$("#submitButton").click(function() {
    if ($("#menuName").val() === "") {
        alert("메뉴명을 입력하세요");
        return false;
    } else if ($("#menuType").val() === "link" && $("#linkDirect").val() === "") {
        alert("링크를 입력하세요");
        return false;
    }

    const menuType = $("#menuType").val();
    const menuName = $("#menuName").val();
    const accessRight = $("#accessRight").val();
    let linkUrl = "";
    let boardtypeId = 0;

    if (menuType === "normal") {
        boardtypeId = 1;
        linkUrl = "/board/boardList.do";
    } else if (menuType === "gallery") {
        boardtypeId = 2;
        linkUrl = "/gallery/galleryList.do";
    } else if (menuType === "survey") {
        boardtypeId = 3;
        linkUrl = "/survey/main.do";
    } else if (menuType === "link") {
        boardtypeId = 4;
        linkUrl = $("#linkDirect").val();
    } else if (menuType === "progress") {
        boardtypeId = 7;
        linkUrl = "/progress/progressMain.do";
    }

    const formData = {
        boardtypeId: boardtypeId,
        menuName: menuName,
        menuUrl: linkUrl,
        accessRight: accessRight
    };

    if (confirm('추가하시겠습니까?')) {
        $.ajax({
            url: '/main/addMenu.do',
            type: 'POST',
            data: JSON.stringify(formData),
            contentType: 'application/json',
            success: function(data) {
                alert("메뉴가 정상적으로 추가되었습니다");
                window.close();
                opener.location.reload();
            },
            error: function(err) {
                alert("메뉴 추가 중 에러가 발생했습니다.");
            }
        });
    } else {
        return false;
    }
});
</script>
</body>
</html>
