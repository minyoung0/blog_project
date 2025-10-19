<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>설정 화면</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<style>
    .tab-content {
        margin-top: 20px;
        padding: 20px;

        border-top: none;
        background-color: #fff;
    }
</style>
</head>
<body>

<div class="container mt-4">
    <h2>설정 화면</h2>

    <!-- ✅ 네비게이션 탭 -->
    <ul class="nav nav-tabs" id="settingsTab" role="tablist">
        <!-- 이웃 관리 탭 -->
        <li class="nav-item" role="presentation">
            <a class="nav-link active" id="neighbors-tab" data-bs-toggle="tab" href="#neighbors" role="tab">
   				구독 관리
			</a>
        </li>
        <!-- 카테고리 관리 탭 -->
        <li class="nav-item" role="presentation">
            <a class="nav-link" id="category-tab" data-bs-toggle="tab" href="#category" role="tab">카테고리 관리</a>
        </li>
        <!-- 방문객 통계 탭 -->
        <li class="nav-item" role="presentation">
            <a  class="nav-link" id="stats-tab" data-bs-toggle="tab" href="#stats" role="tab">
            	방문객 통계
            </a>
        </li>
        <!-- 사용자 설정 탭 -->
        <li class="nav-item" role="presentation">
            <a  class="nav-link" id="settings-tab" data-bs-toggle="tab" href="#userSetting" role="tab"> 사용자 설정</a>
        </li>
    </ul>

    <!-- ✅ 탭 콘텐츠 -->
    <div class="tab-content" id="settingsTabContent">
	    <div class="tab-pane fade show active" id="neighbors" role="tabpanel" aria-labelledby="neighbors-tab"></div>
	    <div class="tab-pane fade" id="category" role="tabpanel" aria-labelledby="category-tab"></div>
	    <div class="tab-pane fade" id="stats" role="tabpanel" aria-labelledby="stats-tab"></div>
	    <div class="tab-pane fade" id="userSetting" role="tabpanel" aria-labelledby="settings-tab"></div>
	</div>
	<jsp:include page="../chattingLayout.jsp" />
</div>

<script>
$(document).ready(function(){
    // ✅ 1️⃣ 현재 저장된 탭을 가져와서 활성화
    var activeTab = sessionStorage.getItem('activeTab'); // 키에 해당하는 값 받아오기
    
    if(activeTab){
    	var tabElement = document.querySelector('.nav-link[href="'+activeTab+'"]');
        console.log("tbaElement: "+tabElement);
        if (tabElement) {
            new bootstrap.Tab(tabElement).show();
            loadTabContent(tabElement); 
        }
    } else {
        // 기본적으로 첫 번째 탭 내용 로드
        loadTabContent($('.nav-link.active'));
    }
    $('.nav-link').on('click', function (e) {
        console.log("✅ 탭 이벤트 발생!");
        console.log("e.target:", e.target);
        console.log("e.target.hash:", e.target.hash);
    	 var targetTab = e.target.hash;
         sessionStorage.setItem('activeTab', targetTab);
         console.log("탭:", targetTab);
         loadTabContent(e.target);
    });

    // ✅ 2️⃣ 탭 클릭 시 현재 탭을 sessionStorage에 저장
/*      document.querySelectorAll('.nav-link').forEach(function(tab){
        tab.addEventListener('shown.bs.tab', function(e) { // ✅ Bootstrap 5의 이벤트 사용
            var tabId = e.target.getAttribute('data-bs-target'); // ✅ data-bs-target 사용
            sessionStorage.setItem('activeTab', tabId);
        });
    }); */
     
	
	});
	function loadTabContent(tabElement) {
	    // 💡 jQuery 객체일 경우, DOM 요소로 변환
	    if (tabElement instanceof jQuery) {
	        tabElement = tabElement[0];
	    }
	
	    var targetId = tabElement.hash.replace("#", "");
	    const tabContainer = document.getElementById(targetId);
	
	    $.ajax({
	        url: '/blog/setting/' + targetId + ".do",
	        type: 'GET',
	        success: function (response) {
	    		$(tabContainer).html(response);
        		console.log("불러오기 성공");
	        },
	        error: function (err) {
	            console.log(err);
	        }
	    });
	}

</script>

</body>
</html>
