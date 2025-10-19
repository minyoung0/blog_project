<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.fusion.user.vo.UserVO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>설문조사폼</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 20px;
}

.container {
	width: 600px;
	margin: 0 auto;
}

.title {
	font-size: 24px;
	font-weight: bold;
	margin-bottom: 20px;
}

.content {
	margin-bottom: 15px;
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
	<div>

	<div class="auth-section">
		<c:choose>
			<c:when test="${loggedInUser == null}">
				<button type="button" class="btn btn-outline-primary" onclick="location.href='/user/loginPage.do'">로그인</button>
			</c:when>
			<c:otherwise>
				<span>${userId}님</span>
				<button type="button" class="btn btn-outline-primary" onclick="location.href='/user/logout.do'">로그아웃</button>
			</c:otherwise>
		</c:choose>
	</div>

		<div class="container">
			<div class="title">퓨전소프트 만족도 조사</div>
			<div class="content">퓨전소프트 회원분들을 대상으로 만족도 조사를 진행합니다. 응답하신 내용은 통계법 33조(비밀의 보호)에 의거 비밀이 보장 되며, 서비스 개선을 위한 자료 외에 어떠한 목적으로도 사용되지 않음을 약속드립니다.</div>
			<div class="content">많은 참여 부탁드리며, 앞으로도 교육정책 및 교육과정 정보를 보다 빠르게 활용하실 수 있도록 더욱 노력하겠습니다</div>
			<div class="content">
				<strong>조사주관:</strong> 퓨전소프트 <br> 
				<strong>참여대상:</strong> 회원(로그인 필요) <br> 
				<strong>참여기간:</strong> ${startDate}~${endDate} 총 ${daysBetween}일간<br> 
				<strong>참여방법:</strong> 하단의 설문시작 버튼을 클릭하여 총 ${totalQuestion}개의 문항에 답변을 마치면 응모완료
				<br> <strong>당첨자발표:</strong>24.01. 15(월), 퓨전소프트 공지사항 게시판
			</div>
			<div class="content">
				<strong>유의사항:</strong><br> -당첨자 선정은 응답 내용의 성실성 등을 고려하여 선정됩니다.<br> -1인 1회에 한하여 참여 가능합니다.
			</div>
			<button id="participateBtn">참여하기</button>
		</div>
	</div>
</body>
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
<script type="text/javascript">
	//참여하기
/* 	$('#participateBtn').click(function() {
		$.ajax({
			url : '/survey/checkLogin.do',
			method : 'GET',
			data:{surveyId:1},
			success : function(response) {
				if (response.trim() === 'loggedIn') {
					//로그인 되어있는 경우
					window.open('/survey/survey.do?surveyId=1', // 팝업 창에 표시할 URL
					'SurveyPopup', // 팝업 창 이름
					'width=1200,height=1600,scrollbars=yes,resizable=yes');
				} else {
					//로그인 안되어있는 경우
					alert('로그인이 필요합니다');
					window.location.href = '/user/loginPage.do';
				}
			},
			error : function() {
				alert('로그인 상태를 확인하는 중 오류가 발생했습니다');
			}
		})
	}) */
	
	 $('#participateBtn').click(function() {
        const today = new Date().toISOString().split('T')[0]; // 오늘 날짜
        const startDate ='${participateStartDate}'; // 서버에서 전달된 startDate
        const endDate = '${participateEndDate}'; // 서버에서 전달된 endDate
        console.log("today:"+today+",startDate:"+startDate+",endDate"+endDate);

        if (today >= startDate && today <= endDate) {
            // 현재 날짜가 참여 기간에 포함된 경우
            $.ajax({
                url: '/survey/checkLogin.do',
                method: 'GET',
                data: { surveyId: 1 },
                success: function(response) {
                	 if (response.trim() === 'loggedIn') {
                         // 로그인되어 있는 경우
                         // 참여 이력 확인 요청
                         /* $.ajax({
                             url: '/survey/checkParticipation.do',
                             method: 'GET',
                             data: { surveyId: 1 },
                             success: function(participationResponse) {
                                 if (participationResponse.trim() === 'participated') {
                                         if (confirm('이미 설문에 참여하셨습니다. 수정하시겠습니까?')) {
                                             // "네"를 선택한 경우
                                             window.open('/survey/editSurveyPage.do?surveyId=1&userId=${userId}', // 수정하기 페이지
                                                 'SurveyPopup', // 팝업 창 이름
                                                 'width=1200,height=1600,scrollbars=yes,resizable=yes');
                                         }
                                         // "아니오"를 선택하면 아무 작업도 하지 않음
                                 } else {
                                     // 참여 이력이 없는 경우
                                     window.open('/survey/survey.do?surveyId=1', // 새 설문 참여 페이지
                                         'SurveyPopup',
                                         'width=1200,height=1600,scrollbars=yes,resizable=yes');
                                 }
                             },
                             error: function() {
                                 alert('참여 이력을 확인하는 중 오류가 발생했습니다.');
                             }
                         }); */
                		 $.ajax({
                			    url: '/survey/checkParticipation.do',
                			    method: 'GET',
                			    data: { surveyId: 1 },
                			    success: function(response) {
                			    	console.log("Server response:", response); // 서버 응답 확인
                			    	
                			        if (response === 'notLoggedIn') {
                			            alert('로그인이 필요합니다');
                			            window.location.href = '/user/loginPage.do';
                			        } else if (response === 'notParticipated') {
                			            window.open('/survey/survey.do?surveyId=1',
                			                'SurveyPopup',
                			                'width=1200,height=1600,scrollbars=yes,resizable=yes');
                			        } else {
                			        	const responseId = response ? response.trim() : null;

                			            // responseId를 수정 페이지로 전달
                			            if (confirm('이미 설문에 참여하셨습니다. 수정하시겠습니까?')) {
                			                window.open(/survey/editSurveyPage.do?surveyId=1&userId=${userId},
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
                        // 로그인되어 있지 않은 경우
                        alert('로그인이 필요합니다');
                        window.location.href = '/user/loginPage.do';
                    }
                },
                error: function() {
                    alert('로그인 상태를 확인하는 중 오류가 발생했습니다');
                }
            });
        } else {
            // 참여 기간이 아닌 경우
            alert('현재 설문 참여 기간이 아닙니다.');
        }
    });
</script>
</html>