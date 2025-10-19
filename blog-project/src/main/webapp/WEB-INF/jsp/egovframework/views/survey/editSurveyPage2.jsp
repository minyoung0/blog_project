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
	margin-left: 50px; /* 들여쓰기 기본값 */
}

ul {
	list-style: none; /* Bullet Point 제거 */
	padding: 0; /* 기본 패딩 제거 */
	margin: 0; /* 기본 마진 제거 */
}

.question {
	display: none; /* 기본적으로 모든 질문 숨김 */
}
/* 문항번호를 강조 */
.question p strong {
	font-weight: bold;
	font-size: 1em; /* 크기를 약간 키움 */
	color: #333; /* 강조된 색상 */
}

/* categoryName을 강조 */
.category-name {
	font-weight: bold;
	font-size: 1em; /* 크기 유지 */
	margin-left: 10px; /* 문항번호와 간격 */
}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function () {
	
	
	// "기타" 옵션 체크박스와 텍스트박스 연결
    const etcOptions = document.querySelectorAll(".etc-option");

    etcOptions.forEach(checkbox => {
        const textbox = checkbox.parentElement.querySelector(".etc-textbox");

        checkbox.addEventListener("change", function () {
            if (this.checked) {
                textbox.style.display = "inline-block"; // 체크되면 텍스트박스 표시
            } else {
                textbox.style.display = "none"; // 체크 해제되면 텍스트박스 숨김
                textbox.value = ""; // 기존 입력값 초기화
            }
        });
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
	
	
	
	
    console.log("DOM fully loaded and parsed");

    // 모든 질문을 가져오기
    const questions = document.querySelectorAll(".question, .sub-question");

    // 이전/다음/제출 버튼
    const prevButton = document.getElementById("prevPage");
    const nextButton = document.getElementById("nextPage");
    const submitButton = document.getElementById("submitButton");
    const totalQuestions=${totalQuestions};
    console.log("totalQuestions:"+totalQuestions);

    // 총 페이지 수 계산 (data-page 속성 기반)
    const totalPages = Math.max(...Array.from(questions).map(q => parseInt(q.dataset.page, 10)));
    let currentPage = 1;

    // 페이지 표시 함수
    function showPage(page) {
        questions.forEach(question => {
            const questionPage = parseInt(question.dataset.page, 10);
            question.style.display = questionPage === page ? "block" : "none";
        });

        // 버튼 상태 업데이트
        prevButton.disabled = page === 1;
        nextButton.style.display = page === totalPages ? "none" : "inline-block";
        submitButton.style.display = page === totalPages ? "inline-block" : "none";
    }

    

    // 이전 버튼 클릭 핸들러
    prevButton.addEventListener("click", function () {
        if (currentPage > 1) {
            currentPage--;
            showPage(currentPage);
        }
    });

    // 다음 버튼 클릭 핸들러
    nextButton.addEventListener("click", function () {
        if (currentPage < totalPages) {
            currentPage++;
            showPage(currentPage);
        }
    });

    // 첫 번째 페이지 표시
     showPage(currentPage);
    
     document.getElementById("surveyForm").addEventListener("submit", function (event) {
    	    event.preventDefault();
    	    
    	    const responseId = document.querySelector("input[name='responseId']").value;
    	    const surveyId = document.querySelector("input[name='surveyId']").value;
    	    const answers = [];
    	    const currentAnswers = collectCurrentAnswers();

    	    // 바뀐 값만 가져오기
    	    const changedAnswers = getChangedAnswers(initialAnswers, currentAnswers);

    	    console.log("Changed Answers:", changedAnswers);
    	    const questions = document.querySelectorAll(".question, .sub-question");
    	    questions.forEach((question) => {
    	        const questionId = question.getAttribute("data-question-id");
    	        const questionType = question.getAttribute("data-question-type");
    	        if (!questionId || !questionType) {
    	            console.warn(`질문 속성이 누락되었습니다: questionId=${questionId}, questionType=${questionType}`);
    	            return;
    	        }
    	        if (questionType === "single") {
    	            const selectedOption = question.querySelector("input[type='radio']:checked");
    	            if (selectedOption) {
    	                answers.push({
    	                    questionId: parseInt(questionId),
    	                    choiceId: parseInt(selectedOption.value),
    	                    etcText: selectedOption.classList.contains("etc-option")
    	                        ? question.querySelector(".etc-textbox").value.trim()
    	                        : null,
    	                });
    	            }
    	        } else if (questionType === "multiple") {
    	            const selectedOptions = question.querySelectorAll("input[type='checkbox']:checked");
    	            const choiceIds = Array.from(selectedOptions).map(opt => parseInt(opt.value));
    	            const etcChoice = Array.from(selectedOptions).find(opt => opt.classList.contains("etc-option"));

    	            answers.push({
    	                questionId: parseInt(questionId),
    	                choiceIds: choiceIds,
    	                etcText: etcChoice ? question.querySelector(".etc-textbox").value.trim() : null,
    	            });
    	        } else if (questionType === "text") {
    	            const textAnswer = question.querySelector("textarea").value.trim();
    	            if (textAnswer) {
    	                answers.push({
    	                    questionId: parseInt(questionId),
    	                    answerText: textAnswer,
    	                });
    	            }
    	        }
    	    });
    	    console.log("수집된 데이터:", answers);
    	    // Fetch 요청
    	    fetch(`/survey/updateSurvey.do?responseId=${responseId}`, {
    	        method: "POST",
    	        headers: {
    	            "Content-Type": "application/json",
    	        },
    	        body: JSON.stringify(answers),
    	    })
    	        .then(response => {
    	            if (!response.ok) {
    	                throw new Error(`HTTP error! status: ${response.status}`);
    	            }
    	            return response.text();
    	        })
    	        .then(data => {
    	            alert("설문 수정이 성공적으로 저장되었습니다!");
    	            console.log("Response:", data);
    	            window.close();
    	        })
    	        .catch(error => {
    	            console.error("Error:", error);
    	            alert("설문 수정 중 오류가 발생했습니다.");
    	        });
    	});
});
    //응답 불러오기
    const surveyId=document.querySelector("input[name='surveyId']").value;
    const userId=document.getElementById("surveyForm").getAttribute("data-user-id");
    fetch(`/survey/editSurvey.do?surveyId=${surveyId}&userId=${userId}&resp`)
    .then(response => {
        if (!response.ok) {
            throw new Error("Failed to fetch survey answers.");
        }
        return response.json(); // JSON 데이터를 파싱
    })
    .then(data => {
        console.log("Fetched Answers:", data); // 데이터를 콘솔에서 확인
        populateAnswers(data); // 데이터를 화면에 반영
    })
    .catch(error => {
        console.error("Error fetching survey answers:", error);
    });

    //답변 가져오기

function populateAnswers(answers) {
    answers.forEach(answer => {
        console.log("Processing Answer:", answer); // 현재 처리 중인 답변 데이터를 콘솔에 출력

        const questionElement = document.querySelector(`.question[data-question-id='\${answer.questionId}']`);
        if (questionElement) {
            const questionType = questionElement.getAttribute("data-question-type");

            // Single-choice 처리
            if (questionType === "single") {
                console.log("Single-choice Answer:", answer);
                const radioInput = questionElement.querySelector(`input[type='radio'][value='\${answer.choiceId}']`);
                if (radioInput) {
                    radioInput.checked = true;

                    // "기타" 텍스트 처리
                    if (answer.etcText) {
                        const etcTextbox = radioInput.parentElement.querySelector(".etc-textbox");
                        if (etcTextbox) {
                            etcTextbox.style.display = "inline-block";
                            etcTextbox.value = answer.etcText;
                        }
                    }
                }
            }
            // Multiple-choice 처리
            else if (questionType === "multiple") {
                console.log("Multiple-choice Answer:", answer);
                if (answer.choiceIds) {
                    answer.choiceIds.forEach(choiceId => {
                        console.log(`Setting checkbox for Choice ID: ${choiceId}`);
                        const checkboxInput = questionElement.querySelector(`input[type='checkbox'][value='\${choiceId}']`);
                        if (checkboxInput) checkboxInput.checked = true;
                    });
                }

                // "기타" 텍스트 처리
                if (answer.etcText) {
                    const etcTextbox = questionElement.querySelector(".etc-textbox");
                    if (etcTextbox) {
                        etcTextbox.style.display = "inline-block";
                        etcTextbox.value = answer.etcText;
                    }
                }
            }
            // Text 처리
            else if (questionType === "text") {
                console.log("Text Answer:", answer);
                const textarea = questionElement.querySelector("textarea");
                if (textarea) {
                    textarea.value = answer.answerText;
                }
            }
        } else {
            console.warn(`Question Element not found for Question ID: ${answer.questionId}`);
        }
    });
    
    
}
    
    

/*     //바뀐 값만 수정하기
function getChangedAnswers(initialAnswers, currentAnswers) {
	 const changedAnswers = [];

	    currentAnswers.forEach(current => {
	        const initial = initialAnswers.find(item => item.questionId === current.questionId);

	        if (!initial) {
	            // 기존에 없는 새로운 응답
	            changedAnswers.push(current);
	        } else {
	            // 값이 변경된 항목만 추가
	            const isChanged = (
	                initial.choiceId !== current.choiceId || // 단일 선택 비교
	                JSON.stringify(initial.choiceIds) !== JSON.stringify(current.choiceIds) || // 다중 선택 비교
	                initial.answerText !== current.answerText || // 텍스트 응답 비교
	                initial.etcText !== current.etcText // "기타" 텍스트 비교
	            );

	            if (isChanged) {
	                changedAnswers.push(current);
	            }
	        }
	    });

	    return changedAnswers;

}; */


    

   

</script>


</head>
<body>

	<h1>설문조사 수정</h1>
	<form action="/survey/updateSurvey.do" method="POST" id="surveyForm" data-user-id="${userId}">

		<!-- 숨겨진 필드로 surveyId 추가 -->
		<input type="hidden" name="surveyId" value="${surveyId}" /> <input type="hidden" name="responseId" value="${responseId}" />

		<div id="questionsContainer">
			<c:set var="page" value="1" />
			<c:set var="questionCount" value="0" />
			<c:forEach var="question" items="${questions}">
				<!-- 대문항 렌더링 -->
				<c:if test="${question.parentQuestionId == 0}">
					<c:if test="${questionCount == 5}">
						<!-- 페이지가 5개를 초과하면 새 페이지로 이동 -->
						<c:set var="page" value="${page + 1}" />
						<c:set var="questionCount" value="0" />
					</c:if>
					<!-- 대문항 questionId 렌더링 -->
					<div class="question" data-page="${page}" data-question-id="${question.questionId}" data-question-type="${question.questionType != null ? question.questionType : ''}">
						<p>
							<strong>문항 ${question.questionNumber}.</strong>
							<c:choose>
								<c:when test="${not empty question.categoryName}">
									<span class="category-name">[${question.categoryName}]</span>
								</c:when>
							</c:choose>
							${question.questionText}
						</p>
						<c:choose>
							<c:when test="${question.questionType == 'single'}">
								<ul>
									<c:forEach var="choice" items="${question.choices}">
										<c:if test="${question.questionNumber!=16}">
											<li><input type="radio" name="question_${question.questionId}" value="${choice.choiceId}" class="${choice.choiceText == '기타' ? 'etc-option' : ''}"> ${choice.choiceText} <input
												type="text" class="etc-textbox" style="display: none;" placeholder="기타 내용을 입력하세요"></li>
										</c:if>


									</c:forEach>
								</ul>
							</c:when>
							<c:when test="${question.questionType == 'multiple'}">
								<ul>
									<c:forEach var="choice" items="${question.choices}">
										<li><input type="checkbox" name="question_${question.questionId}" value="${choice.choiceId}"
											class="limited-checkbox ${choice.choiceText == '없음' ? 'none-option' : ''} ${choice.choiceText == '기타' ? 'etc-option' : ''}"> ${choice.choiceText} <input type="text"
											class="etc-textbox" style="display: none;" placeholder="기타 내용을 입력하세요"></li>

									</c:forEach>

								</ul>
							</c:when>
							<c:when test="${question.questionType == 'text'}">
								<textarea name="question_${question.questionId}" rows="3" cols="50" placeholder="답변을 입력하세요"></textarea>
							</c:when>
						</c:choose>
					</div>
					<c:set var="questionCount" value="${questionCount + 1}" />

					<!-- 소문항 렌더링 -->
					<c:forEach var="subQuestion" items="${questions}">
						<c:if test="${subQuestion.parentQuestionId == question.questionId}">
							<!-- 소문항 questionId 렌더링 -->
							<div class="sub-question nested" data-page="${page}" data-question-id="${subQuestion.questionId}" data-question-type="${subQuestion.questionType}">
								<strong>문항 ${subQuestion.questionNumber}.</strong> ${subQuestion.questionText}
								<!-- subQuestion의 questionId와 questionNumber 표시 -->
								<c:choose>
									<c:when test="${subQuestion.questionType == 'single'}">
										<ul>
											<c:forEach var="choice" items="${subQuestion.choices}">
												<li><input type="radio" name="question_${subQuestion.questionId}" value="${choice.choiceId}"> ${choice.choiceText}</li>
											</c:forEach>
										</ul>
									</c:when>
									<c:when test="${subQuestion.questionType == 'multiple'}">
										<ul>
											<c:forEach var="choice" items="${subQuestion.choices}">
												<li>
													<!-- 체크박스 처리 --> <input type="checkbox" name="question_${subQuestion.questionId}" value="${choice.choiceId}"
													class="limited-checkbox ${choice.choiceText == '없음' ? 'none-option' : ''} ${choice.choiceText == '기타' ? 'etc-option' : ''}"
													<c:forEach var="answer" items="${answers}">
                           <c:if test="${answer.questionId == subQuestion.questionId && answer.choiceId == choice.choiceId}">
                               checked
                           </c:if>
                       </c:forEach>>
													${choice.choiceText} <!-- "기타" 텍스트 박스 처리 --> <c:if test="${choice.choiceText == '기타'}">
														<input type="text" class="etc-textbox" placeholder="기타 내용을 입력하세요"
															<c:forEach var="answer" items="${answers}">
                               <c:if test="${answer.questionId == subQuestion.questionId && answer.choiceId == choice.choiceId && not empty answer.etcText}">
                                   value="${answer.etcText}" 
                                   style="display: inline-block;"
                               </c:if>
                           </c:forEach>>
													</c:if>
												</li>
											</c:forEach>
										</ul>
									</c:when>


									<c:when test="${subQuestion.questionType == 'text'}">
										<textarea name="question_${subQuestion.questionId}" rows="3" cols="50" placeholder="답변을 입력하세요"></textarea>
									</c:when>
								</c:choose>
							</div>
						</c:if>
					</c:forEach>
				</c:if>
			</c:forEach>

		</div>



		<div id="pagination">
			<button type="button" id="prevPage" disabled>이전</button>
			<button type="button" id="nextPage">다음</button>
		</div>

		<button type="submit" style="display: none;" id="submitButton">제출</button>
	</form>


	<script>
	document.addEventListener("DOMContentLoaded", function () {
	    
	});
</script>
</body>
</html>