<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.fusion.user.vo.UserVO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>설문조사폼</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
    font-family: Arial, sans-serif;
    margin: 20px;
}

.container {
    max-width: 800px;
    margin: 0 auto;
}

.title {
    font-size: 28px;
    font-weight: bold;
    margin-bottom: 20px;
    text-align: center;
}

.content {
    margin-bottom: 15px;
    text-align: justify;
}

.button {
    margin-top: 20px;
}

.auth-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}
</style>
</head>
<body>
    <%
    UserVO loggedInUser = (UserVO) session.getAttribute("loggedInUser");
    String userId = (String) session.getAttribute("userId");
    %>
    <div class="container shadow p-4 bg-white rounded">
<%--         <div class="auth-section mb-4">
            <c:choose>
                <c:when test="${loggedInUser == null}">
                    <button type="button" class="btn btn-primary" onclick="location.href='/user/loginPage.do'">로그인</button>
                </c:when>
                <c:otherwise>
                    <span>${userId}님 환영합니다!</span>
                    <button type="button" class="btn btn-outline-danger" onclick="location.href='/user/logout.do'">로그아웃</button>
                </c:otherwise>
            </c:choose>
        </div> --%>
        <div class="title">퓨전소프트 만족도 조사</div>
        <div class="content alert alert-secondary">
            퓨전소프트 회원분들을 대상으로 만족도 조사를 진행합니다. 응답하신 내용은 
            <strong>통계법 33조(비밀의 보호)</strong>에 의거 비밀이 보장되며, 서비스 개선을 위한 자료 외에 어떠한 목적으로도 사용되지 않습니다.
        </div>
        <div class="content">
            <p>많은 참여 부탁드리며, 앞으로도 교육정책 및 교육과정 정보를 보다 빠르게 활용하실 수 있도록 더욱 노력하겠습니다.</p>
            <ul>
                <li><strong>조사주관:</strong> 퓨전소프트</li>
                <li><strong>참여대상:</strong> 회원(로그인 필요)</li>
                <li><strong>참여기간:</strong> 25.2.25(화) ~ 25.2.28(금) 총 4 일간</li>
                <li><strong>참여방법:</strong> 하단의 설문시작 버튼을 클릭하여 총 ${totalQuestion}개의 문항에 답변을 마치면 응모완료</li>
                <li><strong>당첨자발표:</strong> 24.01.15(월), 퓨전소프트 공지사항 게시판</li>
            </ul>
        </div>
        <div class="content alert alert-warning">
            <strong>유의사항:</strong>
            <ul>
                <li>당첨자 선정은 응답 내용의 성실성을 고려하여 선정됩니다.</li>
                <li>1인 1회에 한하여 참여 가능합니다.</li>
            </ul>
        </div>
        <div class="text-center">
            <button id="participateBtn" class="btn btn-success btn-lg">참여하기</button>
        </div>
    </div>
</body>
<script src="https://code.jquery.com/jquery-3.6.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
<script type="text/javascript">
    // 참여하기 버튼 기능
    $('#participateBtn').click(function() {
        const today = new Date().toISOString().split('T')[0];
        const startDate ='${participateStartDate}';
        const endDate = '${participateEndDate}';
	//화면에서 시간을 처리하면 지정된 시간 외에 접근 가능한 방법이 다양함
	//서버에서 처리 
	//->서버에서 현재시간, startdate,enddate불러와서 
	// if (currentDate.isBefore(surveyStartDate) || currentDate.isAfter(surveyEndDate)) {
    //    return ResponseEntity.status(HttpStatus.FORBIDDEN).body("설문 참여 기간이 아닙니다.");
    //}
        
        if (today >= startDate && today <= endDate) {
            $.ajax({
                url: '/survey/checkLogin.do',
                method: 'GET',
                data: { surveyId: 1 },
                success: function(response) {
                    if (response.trim() === 'loggedIn') {
                        $.ajax({
                            url: '/survey/checkParticipation.do',
                            method: 'GET',
                            data: { surveyId: 1 },
                            success: function(participationResponse) {
                                if (participationResponse.trim() === 'notParticipated') {
                                    window.open('/survey/survey.do?surveyId=1',
                                        'SurveyPopup',
                                        'width=1200,height=1600,scrollbars=yes,resizable=yes');
                                } else {
                                    if (confirm('이미 설문에 참여하셨습니다. 수정하시겠습니까?')) {
                                        window.open(`/survey/editSurveyPage.do?surveyId=1&userId=${userId}`,
                                            'SurveyPopup',
                                            'width=1200,height=1600,scrollbars=yes,resizable=yes');
                                    }
                                }
                            },
                            error: function() {
                                alert('참여 이력을 확인하는 중 오류가 발생했습니다.');
                            }
                        });
                    } else {
                        alert('로그인이 필요합니다.');
                        window.location.href = '/user/loginPage.do';
                    }
                },
                error: function() {
                    alert('로그인 상태를 확인하는 중 오류가 발생했습니다.');
                }
            });
        } else {
            alert('현재 설문 참여 기간이 아닙니다.');
        }
    });
</script>
</html>
