 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi"
	crossorigin="anonymous">
<title>회원가입</title>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <div class="card-header text-center">
                        <h2>회원가입</h2>
                    </div>
                    <div class="card-body">
                        <form method="post" action="/user/insUser.do">
                            <div class="mb-3">
                                <label for="userName" class="form-label">이름</label>
                                <input type="text" id="userName" name="userName" class="form-control" placeholder="이름을 입력하세요" required>
                            </div>
                            <div class="mb-3">
                                <label for="userId" class="form-label">아이디</label>
                                <input type="text" id="userId" name="userId" class="form-control" placeholder="아이디를 입력하세요" required>
                            </div>
                            <div class="mb-3">
                                <label for="userPassword" class="form-label">비밀번호</label>
                                <input type="password" id="userPassword" name="userPassword" class="form-control" placeholder="비밀번호를 입력하세요" required>
                            </div>
                            <!-- 에러 메시지 -->
                            <div class="mb-3 text-danger">
                                ${errorMessage}
                            </div>
                            <div class="d-flex justify-content-between">
                                <button type="submit" class="btn btn-primary">회원가입하기</button>
                                <a href="/user/loginPage.do" class="btn btn-secondary">취소</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>

</html>