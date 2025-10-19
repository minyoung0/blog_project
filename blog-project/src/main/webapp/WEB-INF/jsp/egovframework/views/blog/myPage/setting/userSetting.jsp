<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사용자 설정</title>

<!-- ✅ Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.1.min.js"></script>

<style>
    .delete-account {
        font-size: 0.875rem;
        color: #dc3545;
        text-align: right;
        display: block;
        margin-bottom: 15px;
    }

    .profile-preview {
        width: 100%;
        height: 80%;
        object-fit: cover;
    }
</style>
</head>
<body>

<div class="container mt-5">
    <div class="card shadow p-4">
        <div class="row">
            <!-- ✅ 왼쪽: 프로필 사진 + 파일 선택 -->
            <div class="col-md-5 text-center">
                <img id="preview" src="${userInfo.profileImage }" class="profile-preview mb-2" alt="프로필">
                <input type="file" class="form-control form-control-sm mt-2" id="profileImage">
            </div>

            <!-- ✅ 오른쪽: 닉네임 / 바이오 -->
            <div class="col-md-8">
                <div class="mb-3">
                    <label for="nickname" class="form-label">닉네임</label>
                    <input type="text" class="form-control" id="nickname" placeholder="닉네임 입력" value="${userInfo.nickName}">
                </div>
                <div class="mb-3">
                    <label for="bio" class="form-label">바이오</label>
                    <textarea class="form-control" id="bio" rows="3" placeholder="자기소개를 입력하세요">${userInfo.bio}</textarea>
                </div>

                <!-- ✅ 회원탈퇴 (오른쪽 정렬, 저장 위) -->
                <div class="text-end">
                    <a href="#" class="delete-account" id="delete-account">회원탈퇴</a>
                </div>

                <!-- ✅ 저장 버튼 -->
                <div class="d-grid gap-2">
                    <button type="button" class="btn btn-primary">저장</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ✅ 프로필 미리보기 JS -->
<script>
$(document).ready(function(){
    $('#profileImage').on('change', function(e){
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(evt){
                $('#preview').attr('src', evt.target.result);
            };
            reader.readAsDataURL(file);
        }
    });
    
    $('delete-account').on('click',function(){
    	if(confirm("회원탈퇴하시겠습니까? 탈퇴하면 사용자의 정보는 모두 삭제됩니다.")){
    		
    	}else{}
    })
});
</script>

</body>
</html>
