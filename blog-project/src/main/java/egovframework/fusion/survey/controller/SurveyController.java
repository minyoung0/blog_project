package egovframework.fusion.survey.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.fusion.main.service.MainService;
import egovframework.fusion.main.vo.MenuVO;
import egovframework.fusion.survey.service.SurveyService;
import egovframework.fusion.survey.vo.AnswerVO;
import egovframework.fusion.survey.vo.ChoiceVO;
import egovframework.fusion.survey.vo.QuestionVO;
import egovframework.fusion.survey.vo.ResponseVO;
import egovframework.fusion.survey.vo.SurveyInfoVO;

@Controller
public class SurveyController {

	@Autowired
	SurveyService surveyService;

	@Autowired
	MainService mainService;
	
	@ModelAttribute("menuList")
	public List<MenuVO> menuList(){
		return mainService.getMenuListModel();
	}
	
	// 메인화면
	@RequestMapping(value = "/survey/main.do", method = RequestMethod.GET)
	public String mainPage(Model model,MenuVO menuVO) {

		int surveyId = 1;
		SurveyInfoVO surveyInfo = surveyService.getSurveyById(surveyId);
		System.out.println("Survey Info: " + surveyInfo);

		int totalCount = surveyService.getTotalQuestion(surveyId);

		if (surveyInfo != null) {
			// 날짜형식 변환
			SimpleDateFormat dateFormat = new SimpleDateFormat("yy.MM.DD (E)");
			String startDateFormatted = dateFormat.format(surveyInfo.getStartDate());
			String endDateFormatted = dateFormat.format(surveyInfo.getEndDate());

			SimpleDateFormat isoFormat = new SimpleDateFormat("yyyy-MM-dd");
			String participateStartDate = isoFormat.format(surveyInfo.getStartDate());
			String participateEndDate = isoFormat.format(surveyInfo.getEndDate());

			long daysBetween = (surveyInfo.getEndDate().getTime() - surveyInfo.getStartDate().getTime())
					/ (1000 * 60 * 60 * 24) + 1; // 총 기간 계산

			model.addAttribute("startDate", startDateFormatted);
			model.addAttribute("endDate", endDateFormatted);
			model.addAttribute("daysBetween", daysBetween);
			model.addAttribute("totalQuestion", totalCount);
			model.addAttribute("participateStartDate", participateStartDate);
			model.addAttribute("participateEndDate", participateEndDate);

		} else {
			model.addAttribute("error", "설문 정보를 찾을 수 없습니다.");
		}
		/* return "/views/survey/main"; */
		return "tiles/survey/main";
	}

	// 버튼 눌렀을때 로그인 여부
	@RequestMapping(value = "/survey/checkLogin.do", method = RequestMethod.GET)
	@ResponseBody
	public String checkLogin(HttpSession session) {
		String userId = (String) session.getAttribute("userId");
		if (userId != null && !userId.isEmpty()) {
			return "loggedIn";
		} else {
			return "notLoggedIn";
		}

	}

	// 설문조사 화면
	@RequestMapping(value = "/survey/survey.do", method = RequestMethod.GET)
	public String surveyPage(@RequestParam("surveyId") int surveyId, Model model,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "pageSize", defaultValue = "5") int pageSize, HttpSession session) {
		System.out.println("Received surveyId: " + surveyId);
		System.out.println("Current Page: " + page);
		/*
		 * int startRow = (page - 1) * pageSize + 1; int endRow = page * pageSize;
		 */

		int totalCount = surveyService.getTotalQuestion(surveyId);

		// 세션에서 저장된 답변 가져오기
		@SuppressWarnings("unchecked")
		Map<String, String> savedAnswers = (Map<String, String>) session.getAttribute("answers");
		if (savedAnswers == null) {
			savedAnswers = new HashMap<>();
		}

		/*
		 * List<QuestionVO> questions =
		 * surveyService.getSurveyQuestionsWithChoicesPaged(surveyId, startRow, endRow);
		 */
		List<QuestionVO> questions = surveyService.getSurveyQuestionsWithChoices(surveyId);
 
		/* model.addAttribute("currentPage", page); */
		model.addAttribute("surveyId", surveyId);
		model.addAttribute("questions", questions);
		model.addAttribute("currentPage", page);
		model.addAttribute("savedAnswers", savedAnswers); // 저장된 답변 전달
		model.addAttribute("totalQuestions", totalCount);

		return "/views/survey/survey";
	}

	// 설문 제출
	@RequestMapping(value = "/survey/submitSurvey.do", method = RequestMethod.POST, consumes = "application/json")
	public ResponseEntity<String> submitSurvey(@RequestBody Map<String, Object> requestData) {
		ObjectMapper objectMapper = new ObjectMapper();

		// Map에서 responseVO 추출
		ResponseVO responseVO = objectMapper.convertValue(requestData.get("responseVO"), ResponseVO.class);

		// Map에서 answerVOList 추출
		List<AnswerVO> answerVOList = ((List<?>) requestData.get("answerVOList")).stream()
				.map(answerMap -> objectMapper.convertValue(answerMap, AnswerVO.class)).collect(Collectors.toList());

		surveyService.saveSurveyResponse(responseVO, answerVOList);
		return ResponseEntity.ok("Survey response saved successflly");
	}

	// 참여이력 확인
	@RequestMapping(value = "/survey/checkParticipation.do", method = RequestMethod.GET)
	@ResponseBody
	public String checkParticipate(@RequestParam int surveyId, HttpSession session, Model model) {
		String userId = (String) session.getAttribute("userId");
		System.out.println(surveyId);
		if (userId == null) {
			return "notLoggedIn";
		}
		/*
		 * int responseId = surveyService.getResponseIdBySurveyAndUser(surveyId,
		 * userId); System.out.println(responseId);
		 */
		boolean isParticipated = surveyService.checkParticipation(surveyId, userId);
		System.out.println("boolean" + isParticipated);
		return isParticipated ? "participated" : "notParticipated";
		/*
		 * if (responseId > 0) { return String.valueOf(responseId); } else { return
		 * "notParticipated"; }
		 */

	}

	// 응답 받아오기-json형태
	@RequestMapping(value = "/survey/editSurvey.do", method = RequestMethod.GET)
	public ResponseEntity<?> getSurveyAnswers(@RequestParam int surveyId, @RequestParam String userId) {
		List<AnswerVO> answers = surveyService.getSurveyAnswers(surveyId, userId);
		return ResponseEntity.ok(answers);
	}

	// 응답 화면에 띄우기
	@RequestMapping(value = "/survey/editSurveyPage.do", method = RequestMethod.GET)
	public String editSurveyPage(@RequestParam int surveyId, @RequestParam String userId, Model model) {

		// 설문 응답 데이터 가져오기
		List<AnswerVO> answers = surveyService.getSurveyAnswers(surveyId, userId);
		List<QuestionVO> questions = surveyService.getSurveyQuestionsWithChoices(surveyId); // 설문 문항 가져오기

		int totalCount = surveyService.getTotalQuestion(surveyId);
		int responseId = surveyService.getResponseIdBySurveyAndUser(surveyId, userId);

		// JSP에 전달할 데이터
		model.addAttribute("answers", answers);
		model.addAttribute("questions", questions);
		model.addAttribute("surveyId", surveyId);
		model.addAttribute("userId", userId);
		model.addAttribute("totalQuestions", totalCount);
		model.addAttribute("responseId", responseId);
		System.out.println("answers" + answers);
		System.out.println("questions:" + questions);

		// JSP 파일 경로 반환
		return "views/survey/editSurveyPage"; // WEB-INF/views/survey/editSurveyPage.jsp
	}

	// 수정
	@RequestMapping(value = "/survey/updateSurvey.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<String> updateSurvey(@RequestBody Map<String, Object> requestData) {
		ObjectMapper objectMapper = new ObjectMapper();
		System.out.println("RequestData"+requestData);
		try {
			// Map에서 responseVO 추출
			ResponseVO responseVO = objectMapper.convertValue(requestData.get("responseVO"), ResponseVO.class);

			// Map에서 answerVOList 추출
			List<AnswerVO> answerVOList = ((List<?>) requestData.get("answerVOList")).stream()
					.map(answerMap -> objectMapper.convertValue(answerMap, AnswerVO.class))
					.collect(Collectors.toList());

			// 설문 수정 서비스 호출
			surveyService.updateSurveyResponse(responseVO, answerVOList);

			return ResponseEntity.ok("Survey response updated successfully");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to update survey response");
		}
	}

}