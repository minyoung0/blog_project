<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .login-container {
            max-width: 450px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgb(91 164 142);
            margin-top: 50px;
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
    </style>
</head>
<body>
    <div class="container d-flex justify-content-center align-items-center vh-50">
        <div class="login-container">
            <h3 class="text-center mb-4">로그인</h3>
            <form method="post" action="/blog/login.do">
                <!-- 아이디 -->
                <div class="mb-3">
                    <label class="form-label">아이디</label>
                    <input type="text" class="form-control" placeholder="아이디를 입력하세요" id="userId" name="userId">
                </div>

                <!-- 비밀번호 -->
                <div class="mb-3">
                    <label class="form-label">비밀번호</label>
                    <input type="password" class="form-control" placeholder="비밀번호를 입력하세요" id="password" name="password">
                </div>
				<div class="mb-3 text-danger">
                    ${errorMessage}
                </div>
                <!-- 로그인 버튼 -->
                <button type="submit" class="btn btn-custom w-100">로그인</button>

                <!-- 회원가입 이동 버튼 -->
                <div class="text-center mt-3">
                    <a href="/blog/joinPage.do" class="btn btn-outline-secondary w-100">회원가입</a>
                </div>
            </form>
        </div>
    </div>
	<script>
	    document.querySelector("form").target = "_self";
	</script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
