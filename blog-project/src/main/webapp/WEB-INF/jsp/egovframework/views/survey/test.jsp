<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>설문조사폼</title>

<style>
.nested {
	margin-left: 50px;
}

ul {
	list-style: none;
	padding: 0;
	margin: 0;
}

.question {
	display: none;
}

#progressBar {
	background-color: #4CAF50;
	height: 20px;
}
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>

document.addEventListener("DOMContentLoaded", function () {

const questions = document.querySelectorAll(".question");

const progressBar = document.getElementById("progressBar");

const progressText = document.getElementById("progressText");

const prevButton = document.getElementById("prevPage");

const nextButton = document.getElementById("nextPage");

const submitButton = document.getElementById("submitButton");

let currentPage = 1;



const questionsPerPage = 3;

const totalQuestions = questions.length;

const totalPages = Math.ceil(totalQuestions / questionsPerPage);



function updateProgressBar() {

const answeredQuestions = Array.from(questions).filter(question => {

const checkboxes = question.querySelectorAll("input[type='checkbox']:checked");

return checkboxes.length > 0;

}).length;



const progress = (answeredQuestions / totalQuestions) * 100;

progressBar.style.width = progress + "%";

progressText.innerText = `${answeredQuestions}/${totalQuestions} 응답 완료`;

}



function showPage(page) {

questions.forEach((question, index) => {

const startIndex = (page - 1) * questionsPerPage;

const endIndex = startIndex + questionsPerPage;

question.style.display = index >= startIndex && index < endIndex ? "block" : "none";

});



prevButton.disabled = page === 1;

nextButton.style.display = page === totalPages ? "none" : "inline-block";

submitButton.style.display = page === totalPages ? "inline-block" : "none";



updateProgressBar();

}



function showFirstUnansweredQuestion() {

// 첫 번째 미응답 문항 찾기

const unansweredQuestion = Array.from(questions).find(question => {

const checkboxes = question.querySelectorAll("input[type='checkbox']:checked");

return checkboxes.length === 0; // 선택된 항목이 없는 경우

});



if (unansweredQuestion) {

// `data-question-id` 속성에서 문항 번호를 가져옴

const questionId = parseInt(unansweredQuestion.getAttribute("data-question-id"), 10); 

console.log(questionId);


const questionIndex = Array.from(questions).indexOf(unansweredQuestion);

console.log("Unanswered Question Index:", questionIndex);

// 미응답 문항 번호 알림

alert(questionId+"번 문항이 미응답되었습니다.");



// 해당 문항이 포함된 페이지로 이동

currentPage = Math.floor(questionIndex/questionsPerPage)+1;

console.log(currentPage);

showPage(currentPage);


// 미응답 문항의 배경색 변경 (강조 효과)

unansweredQuestion.style.transition = "background-color 0.5s"; // 부드러운 전환 효과

unansweredQuestion.style.backgroundColor = "#ffe6e6"; // 강조 색상 (연한 빨강)



// 일정 시간이 지나면 원래 색상으로 복원

setTimeout(() => {

unansweredQuestion.style.backgroundColor = ""; // 기본 색상으로 복원

}, 2000); // 2초 후 복원

} else {

alert("모든 문항에 응답했습니다. 제출 완료!");

document.getElementById("surveyForm").submit();

}

}



submitButton.addEventListener("click", function (event) {

event.preventDefault();

showFirstUnansweredQuestion();

});



nextButton.addEventListener("click", function () {

if (currentPage < totalPages) {

currentPage++;

showPage(currentPage);

}

});



prevButton.addEventListener("click", function () {

if (currentPage > 1) {

currentPage--;

showPage(currentPage);

}

});



const checkboxes = document.querySelectorAll(".limited-checkbox");

checkboxes.forEach(checkbox => {

checkbox.addEventListener("change", function () {

const parentGroup = this.closest("ul");

const groupCheckboxes = parentGroup.querySelectorAll(".limited-checkbox");

const noneOption = parentGroup.querySelector(".none-option");



if (this.classList.contains("none-option")) {

if (this.checked) {

groupCheckboxes.forEach(cb => {

if (cb !== this) cb.checked = false;

});

}

} else {

if (this.checked && noneOption.checked) noneOption.checked = false;



const selectedCheckboxes = Array.from(groupCheckboxes).filter(cb => cb.checked);

if (selectedCheckboxes.length > 2) {

this.checked = false;

alert("최대 두 개까지만 선택 가능합니다.");

}

}



updateProgressBar();

});

});



showPage(currentPage);

});

</script>

</head>

<body>

	<h1>설문조사</h1>

	<div id="progressContainer" style="display: flex; align-items: center; gap: 10px;">

		<div id="progressBar" style="width: 0%; height: 20px;"></div>

		<span id="progressText"></span>

	</div>

	<form action="/survey/submitSurvey.do" method="POST" id="surveyForm">

		<div id="questionsContainer">

			<!-- 9개의 문항 하드코딩 -->

			<div class="question" data-question-id="1">

				<p>
					<strong>문항 1.</strong> 다음 중 해당되는 항목을 선택하세요. (최대 2개)
				</p>

				<ul>

					<li><input type="checkbox" name="question_1" value="1" class="limited-checkbox"> 선택지 1</li>

					<li><input type="checkbox" name="question_1" value="2" class="limited-checkbox"> 선택지 2</li>

					<li><input type="checkbox" name="question_1" value="none" class="limited-checkbox none-option"> 없음</li>

					<li><input type="checkbox" name="question_1" value="etc" class="limited-checkbox etc-option"> 기타 <input type="text" class="etc-textbox" style="display: none;"
						placeholder="기타 내용을 입력하세요"></li>

				</ul>

			</div>

			<div class="question" data-question-id="2">

				<p>
					<strong>문항 2.</strong> 다음 중 해당되는 항목을 선택하세요. (최대 2개)
				</p>

				<ul>

					<li><input type="checkbox" name="question_2" value="1" class="limited-checkbox"> 선택지 1</li>

					<li><input type="checkbox" name="question_2" value="2" class="limited-checkbox"> 선택지 2</li>

					<li><input type="checkbox" name="question_2" value="none" class="limited-checkbox none-option"> 없음</li>

					<li><input type="checkbox" name="question_2" value="etc" class="limited-checkbox etc-option"> 기타 <input type="text" class="etc-textbox" style="display: none;"
						placeholder="기타 내용을 입력하세요"></li>

				</ul>

			</div>

			<div class="question" data-question-id="3">

				<p>
					<strong>문항 3.</strong> 다음 중 해당되는 항목을 선택하세요. (최대 2개)
				</p>

				<ul>

					<li><input type="checkbox" name="question_3" value="1" class="limited-checkbox"> 선택지 1</li>

					<li><input type="checkbox" name="question_3" value="2" class="limited-checkbox"> 선택지 2</li>

					<li><input type="checkbox" name="question_3" value="none" class="limited-checkbox none-option"> 없음</li>

					<li><input type="checkbox" name="question_3" value="etc" class="limited-checkbox etc-option"> 기타 <input type="text" class="etc-textbox" style="display: none;"
						placeholder="기타 내용을 입력하세요"></li>

				</ul>

			</div>

			<div class="question" data-question-id="4">

				<p>
					<strong>문항 4.</strong> 다음 중 해당되는 항목을 선택하세요. (최대 2개)
				</p>

				<ul>

					<li><input type="checkbox" name="question_4" value="1" class="limited-checkbox"> 선택지 1</li>

					<li><input type="checkbox" name="question_4" value="2" class="limited-checkbox"> 선택지 2</li>

					<li><input type="checkbox" name="question_4" value="none" class="limited-checkbox none-option"> 없음</li>

					<li><input type="checkbox" name="question_4" value="etc" class="limited-checkbox etc-option"> 기타 <input type="text" class="etc-textbox" style="display: none;"
						placeholder="기타 내용을 입력하세요"></li>

				</ul>

			</div>

			<div class="question" data-question-id="5">

				<p>
					<strong>문항 5.</strong> 다음 중 해당되는 항목을 선택하세요. (최대 2개)
				</p>

				<ul>

					<li><input type="checkbox" name="question_5" value="1" class="limited-checkbox"> 선택지 1</li>

					<li><input type="checkbox" name="question_5" value="2" class="limited-checkbox"> 선택지 2</li>

					<li><input type="checkbox" name="question_5" value="none" class="limited-checkbox none-option"> 없음</li>

					<li><input type="checkbox" name="question_5" value="etc" class="limited-checkbox etc-option"> 기타 <input type="text" class="etc-textbox" style="display: none;"
						placeholder="기타 내용을 입력하세요"></li>

				</ul>

			</div>

			<div class="question" data-question-id="6">

				<p>
					<strong>문항 6.</strong> 다음 중 해당되는 항목을 선택하세요. (최대 2개)
				</p>

				<ul>

					<li><input type="checkbox" name="question_6" value="1" class="limited-checkbox"> 선택지 1</li>

					<li><input type="checkbox" name="question_6" value="2" class="limited-checkbox"> 선택지 2</li>

					<li><input type="checkbox" name="question_6" value="none" class="limited-checkbox none-option"> 없음</li>

					<li><input type="checkbox" name="question_6" value="etc" class="limited-checkbox etc-option"> 기타 <input type="text" class="etc-textbox" style="display: none;"
						placeholder="기타 내용을 입력하세요"></li>

				</ul>

			</div>

			<div class="question" data-question-id="7">

				<p>
					<strong>문항 7.</strong> 다음 중 해당되는 항목을 선택하세요. (최대 2개)
				</p>

				<ul>

					<li><input type="checkbox" name="question_7" value="1" class="limited-checkbox"> 선택지 1</li>

					<li><input type="checkbox" name="question_7" value="2" class="limited-checkbox"> 선택지 2</li>

					<li><input type="checkbox" name="question_7" value="none" class="limited-checkbox none-option"> 없음</li>

					<li><input type="checkbox" name="question_7" value="etc" class="limited-checkbox etc-option"> 기타 <input type="text" class="etc-textbox" style="display: none;"
						placeholder="기타 내용을 입력하세요"></li>

				</ul>

			</div>

			<div class="question" data-question-id="8">

				<p>
					<strong>문항 8.</strong> 다음 중 해당되는 항목을 선택하세요. (최대 2개)
				</p>

				<ul>

					<li><input type="checkbox" name="question_8" value="1" class="limited-checkbox"> 선택지 1</li>

					<li><input type="checkbox" name="question_8" value="2" class="limited-checkbox"> 선택지 2</li>

					<li><input type="checkbox" name="question_8" value="none" class="limited-checkbox none-option"> 없음</li>

					<li><input type="checkbox" name="question_8" value="etc" class="limited-checkbox etc-option"> 기타 <input type="text" class="etc-textbox" style="display: none;"
						placeholder="기타 내용을 입력하세요"></li>

				</ul>

			</div>

			<div class="question" data-question-id="9">

				<p>
					<strong>문항 9.</strong> 다음 중 해당되는 항목을 선택하세요. (최대 2개)
				</p>

				<ul>

					<li><input type="checkbox" name="question_9" value="1" class="limited-checkbox"> 선택지 1</li>

					<li><input type="checkbox" name="question_9" value="2" class="limited-checkbox"> 선택지 2</li>

					<li><input type="checkbox" name="question_9" value="none" class="limited-checkbox none-option"> 없음</li>

					<li><input type="checkbox" name="question_9" value="etc" class="limited-checkbox etc-option"> 기타 <input type="text" class="etc-textbox" style="display: none;"
						placeholder="기타 내용을 입력하세요"></li>

				</ul>

			</div>

			<!-- 반복 -->

			<!-- 문항 2~9까지 추가 (위와 동일한 구조) -->

			<!-- 직접 복사 후 변경 -->

		</div>

		<div id="pagination">

			<button type="button" id="prevPage" disabled>이전</button>

			<button type="button" id="nextPage">다음</button>

		</div>

		<button type="submit" id="submitButton" style="display: none;">제출</button>

	</form>

</body>

</html>

s
