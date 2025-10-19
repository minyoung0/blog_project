<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메뉴 수정</title>
<!-- ✅ Bootstrap & jQuery -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
</head>
<body class="container mt-5">
    
    <div class="card shadow p-4">
        <h2 class="text-center text-primary">메뉴 수정</h2>
        <hr>

        <form id="menuForm">
            <input type="hidden" name="menuId" value="${menuDetail.menuId}" id="hiddenMenuId">
            
            <!-- 게시판 타입 -->
            <div class="mb-3">
                <label class="form-label fw-bold">📌 메뉴 게시판 타입</label>
                <input type="text" class="form-control" value="${menuDetail.boardtypeName}" disabled>
            </div>

            <!-- 메뉴 접근 권한 -->
            <div class="mb-3">
                <label for="accessRight" class="form-label fw-bold">🔑 메뉴 접근 권한</label>
                <select name="accessRight" id="accessRight" class="form-select">
                    <option value="guest" ${menuDetail.menuAccessRight eq 'guest' ? 'selected' : ''}>비회원</option>
                    <option value="normal" ${menuDetail.menuAccessRight eq 'normal' ? 'selected' : ''}>일반회원</option>
                    <option value="admin" ${menuDetail.menuAccessRight eq 'admin' ? 'selected' : ''}>일반 관리자</option>
                    <option value="superAdmin" ${menuDetail.menuAccessRight eq 'superAdmin' ? 'selected' : ''}>슈퍼 관리자</option>
                </select>
            </div>

            <!-- 메뉴명 -->
            <div class="mb-3">
                <label for="menuName" class="form-label fw-bold">🏷️ 메뉴명</label>
                <input type="text" id="menuName" value="${menuDetail.menuName }" class="form-control">
            </div>

            <!-- 메뉴 URL -->
            <div id="menuUrlHidden" class="mb-3">
                <label for="menuUrl" class="form-label fw-bold">🔗 메뉴 주소</label>
                <input type="text" id="menuUrl" value="${menuDetail.menuUrl}" class="form-control">
            </div>

            <!-- 링크 입력 -->
            <div class="mb-3">
                <label for="linkDirect" class="form-label fw-bold">🔗 링크 입력</label>
                <input type="text" class="form-control" name="linkDirect" id="linkDirect" placeholder="링크 주소를 입력하세요">
            </div>

            <!-- 메뉴 활성화 여부 -->
            <div class="mb-3">
                <label class="form-label fw-bold">⚡ 메뉴 활성화 여부</label>
                <div class="form-check">
                    <input type="radio" name="deleteYn" value="deleteNo" id="active" class="form-check-input" ${menuDetail.deleteYn eq 0 ? 'checked' : ''}>
                    <label for="active" class="form-check-label">활성화</label>
                </div>
                <div class="form-check">
                    <input type="radio" name="deleteYn" value="deleteYes" id="inactive" class="form-check-input" ${menuDetail.deleteYn eq 1 ? 'checked' : ''}>
                    <label for="inactive" class="form-check-label">비활성화</label>
                </div>
            </div>

            <!-- 버튼 -->
            <div class="d-flex justify-content-end mt-4">
                <button type="button" id="submitButton" class="btn btn-primary me-2">수정</button>
                <button type="button" class="btn btn-outline-secondary" onclick="window.close()">취소</button>
            </div>
        </form>
    </div>

    <script>
        $(function () {
            $("#linkDirect").hide();
            $("#menuUrlHidden").hide();

            // 메뉴 타입 변경 시 URL 표시
            $("#menuType").change(function () {
                if ($("#menuType").val() === "link") {
                    $("#menuUrlHidden").show();
                } else {
                    $("#menuUrlHidden").hide();
                }
            });

            // 수정 버튼 클릭
            $("#submitButton").on("click", function () {
                const menuName = $("#menuName").val();
                const accessRight = $("#accessRight").val();
                const deleteYn = $("input[type='radio']:checked").val();
                const menuId = $("#hiddenMenuId").val();

                let deleteYn2 = deleteYn === "deleteNo" ? '0' : '1';

                const formData = {
                    menuName: menuName,
                    accessRight: accessRight,
                    deleteYn: deleteYn2,
                    menuId: menuId
                };

                console.log(formData);

                if (confirm("메뉴를 수정하시겠습니까?")) {
                    $.ajax({
                        url: "/main/menuModify2.do",
                        type: "POST",
                        data: JSON.stringify(formData),
                        contentType: "application/json",
                        success: function (data) {
                            alert("메뉴가 정상적으로 수정되었습니다.");
                            window.close();
                            opener.location.reload();
                        },
                        error: function (err) {
                            alert("메뉴 수정 중 에러가 발생했습니다.");
                        }
                    });
                }
            });
        });
    </script>
</body>
</html>
