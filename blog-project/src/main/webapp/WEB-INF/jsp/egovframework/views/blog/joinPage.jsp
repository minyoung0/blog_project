<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회원가입</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	background-color: #f8f9fa;
}

.register-container {
	max-width: 900px;
	background: white;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 0 10px rgb(91, 164, 142);
	margin-top: 50px;
}
/* 프로필 미리보기 영역 */
.profile-preview {
	width: 150px;
	height: 150px;
	border: 2px dashed #5BA48E;
	display: flex;
	align-items: center;
	justify-content: center;
	overflow: hidden;
	background: #f1f1f1;
	margin: auto; /* 가운데 정렬 */
}

.profile-preview img {
	width: 100%;
	height: 100%;
	object-fit: cover; /* 이미지 비율 유지하며 꽉 채우기 */
}

.btn-custom {
	background-color: #5BA48E;
	border-color: #5BA48E;
	color: white;
}

.btn-custom:hover {
	background-color: #4A8C77;
	border-color: #4A8C77;
}

.required-text{
	color: red;
    font-size: 0.8rem;
    position: absolute;
    left: 0;
    bottom: -15px;
}

.star{
	color:red;
}
</style>
</head>
<body>
	<div
		class="container d-flex justify-content-center align-items-center vh-50">
		<div class="register-container">
			<h3 class="text-center mb-4 position-relative">회원가입
				   <span class="required-text"> *는 필수입니다</span>
			</h3>

			<div class="row">
				<!-- 왼쪽 열 -->
				<div class="col-md-6">
					<div class="mb-3">
						<label class="form-label"><span class="star">*</span>이름</label> 
						<input type="text" class="form-control" placeholder="이름을 입력하세요" id="name" data-name="이름">
					</div>

					<div class="mb-3">
						<label class="form-label"><span class="star">*</span>아이디</label>
						<div class="input-group">
							<input type="text" class="form-control" placeholder="아이디를 입력하세요" id="userId" data-name="아이디">
							<button class="btn btn-secondary id-doubleCheck">중복 체크</button>
						</div>
					</div>

					<div class="mb-3">
						<label class="form-label"><span class="star">*</span>비밀번호</label> 
						<input type="password" class="form-control" placeholder="비밀번호를 입력하세요" id="password" data-name="비밀번호">
					</div>

					<div class="mb-3">
						<label class="form-label"><span class="star">*</span>비밀번호 확인</label> 
						<input type="password" class="form-control" placeholder="비밀번호를 다시 입력하세요" id="passwordCheck">
					</div>

					<div class="mb-3">
						<label class="form-label"><span class="star">*</span>이메일</label> 
						<input type="email"
							class="form-control" placeholder="이메일을 입력하세요" id="email" data-name="이메일">
					</div>
				</div>

				<!-- 오른쪽 열 -->
				<div class="col-md-6">
					<div class="mb-3">
						<label class="form-label"><span class="star">*</span>닉네임</label>
						<div class="input-group">
							<input type="text" class="form-control" placeholder="닉네임을 입력하세요" id="nickName" data-name="닉네임">
							<button class="btn btn-secondary nickNameCheck">중복 체크</button>
						</div>
					</div>

					<!-- 프로필 이미지 업로드 -->
					<div class="mb-3">
						<label class="form-label">프로필 이미지</label> 
						<input type="file" class="form-control" id="profileImageInput" accept="image/*">
					</div>

					<!-- 프로필 이미지 미리보기 (동그랗게) -->
					<div class="profile-preview" id="profilePreview">
						<span class="text-muted">이미지 미리보기</span>
					</div>
				</div>
			</div>

			<button type="submit" class="btn btn-custom w-100 btn-lg mt-4 joinBtn">회원가입</button>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		$(document).ready(function() {
		    $('#profileImageInput').on('change', function(event) {
		        const file = event.target.files[0];
		        const $preview = $('#profilePreview');
	
		        if (file) {
		            const reader = new FileReader();
		            reader.onload = function(e) {
		                $preview.html(`<img src="`+e.target.result+`" alt="프로필 이미지">`);
		            };
		            reader.readAsDataURL(file);
		        } else {
		            $preview.html('<span class="text-muted">이미지 미리보기</span>');
		        }
		    });

		    let id_check=false;
		    let nickName_check=false;
			$(document).on("click", ".id-doubleCheck", function(e) {
				e.preventDefault();
				console.log("아이디 중복체크");
				const id=$('#userId').val();
				console.log(id);
				
				$.ajax({
					url:'/blog/idDoubleCheck.do',
					type:'post',
					data:{id:id},
					success:function(response){
						alert(response.message);
						if(response.status==="usable"){
							id_check=true;
						}
					},error:function(response){
						console.log("에러");
						alert(response.message);
					}
				})
			})
			
			$(document).on("click",".nickNameCheck",function(e){
				e.preventDefault();
				console.log("닉네임체크");
				const nickName=$('#nickName').val();
				
				$.ajax({
					url:'/blog/nickNameDoubleCheck.do',
					type:'post',
					data:{nickName:nickName},
					success:function(response){
						alert(response.message);
						if(response.status==="usable"){
							nickName_check=true;
						}
					},error:function(response){
						console.log("에러");
						alert(response.message);
					}
				})
				
			})
			
			$(document).on("click", ".joinBtn", function (e) {
			    e.preventDefault();
				const name =$('#name').val(),
				id =$('#userId').val(),
				password =$('#password').val(),
				passwordCheck =$('#passwordCheck').val(),
				email =$('#email').val(),
				nickName =$('#nickName').val(),
				fileInput=$('#profileImageInput').prop("files");
				
			    // **파일이 없을 수도 있으므로 처리**
			    let profileFile = fileInput.length > 0 ? fileInput[0] : null;

			    // 모든 필수 입력 필드 검사
			    let isValid = true;
			    $(".form-control").each(function () {
			        const value = $(this).val();
			        const fieldName = $(this).data("name"); // data-name 값 가져오기
			        if (!value) {
			            alert(fieldName + "을(를) 입력해주십시오");
			            isValid = false;
			            return false; // `.each()` 루프 중단
			        }
			    });
			    if (!isValid) return false; // 필수 입력값이 비어있으면 진행 중단


			    // 정규식 검사
			    const passwordRegex = /^(?=.*[a-z])(?=.*\d)(?=.*[!?@#$^*])[a-z\d!?@#$^*]{8,}$/;
			    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
				///images/egovframework/profile/879df85d-f09a-4a55-b92f-3f0903bd42fd_sample3.png
			    // 아이디 중복 검사 확인
			    if(id_check === false) {
			        alert("아이디 중복체크를 해주십시오");
			        return false;
			    }

			    // 닉네임 중복 검사 확인
			    if (nickName_check === false) {
			        alert("닉네임 중복체크를 해주십시오");
			        return false;
			    }

			    if (!emailRegex.test(email)) {
			        alert("이메일 형식이 틀렸습니다");
			        return false;
			    }
			    if (!passwordRegex.test(password)) {
			        alert("비밀번호 형식이 틀렸습니다");
			        return false;
			    }
			    if (password !== passwordCheck) {
			        alert("비밀번호가 일치하지 않습니다");
			        return false;
			    }
			    
			    
			    // **FormData 생성 (파일 포함)**
			    let formData = new FormData();
			    formData.append("name", name);
			    formData.append("email", email);
			    formData.append("nickName", nickName);
			    formData.append("userId", id);
			    formData.append("password", password);

			    // **파일이 있을 경우에만 추가**
			    if (profileFile) {
			        formData.append("profile", profileFile);
			    }
			    
			    
			    if(confirm("가입하시겠습니까?")){
			    	$.ajax({
			    		url:'/blog/join.do',
			    		type:'post',
		    	       data: formData,
		               contentType: false,
		               processData: false,
			    		success:function(response){
			    			alert(response.message);
			    			location.href="/blog/loginPage.do";
			    		},
			    		error:function(response){
			    			alert(response.message);
			    			console.log("오류");
			    		}
			    	})
			    }else{
			    	return false;
			    }
			});

 
		
 });
	</script>
</body>
</html>
