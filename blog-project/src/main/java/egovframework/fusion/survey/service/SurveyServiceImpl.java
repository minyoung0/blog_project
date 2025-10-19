package egovframework.fusion.survey.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.gallery.service.GalleryMapper;
import egovframework.fusion.gallery.service.GalleryServiceImpl;
import egovframework.fusion.survey.vo.AnswerVO;
import egovframework.fusion.survey.vo.ChoiceVO;
import egovframework.fusion.survey.vo.QuestionVO;
import egovframework.fusion.survey.vo.ResponseVO;
import egovframework.fusion.survey.vo.SurveyInfoVO;

@Service
public class SurveyServiceImpl extends EgovAbstractServiceImpl implements SurveyService {

	private static final Logger LOGGER = LoggerFactory.getLogger(GalleryServiceImpl.class);

	@Autowired
	SurveyMapper surveyMapper;

	@Override
	public SurveyInfoVO getSurveyById(@Param("surveyId") int surveyId) {
		System.out.println("In service, surveyId: " + surveyId);
		return surveyMapper.getSurveyById(surveyId);
	}

	@Override
	public int getTotalQuestion(@Param("surveyId") int surveyId) {
		return surveyMapper.getTotalQuestion(surveyId);
	}

	@Override
	public List<QuestionVO> getSurveyQuestions(int surveyId) {
		List<QuestionVO> questions = surveyMapper.getSurveyQuestions(surveyId);
		System.out.println("Questions: " + questions); // 디버깅 로그
		return surveyMapper.getSurveyQuestions(surveyId);
	}

	@Override
	public List<QuestionVO> getSurveyQuestionsWithChoices(int surveyId) {
		System.out.println("In service, surveyId: " + surveyId);

		// 질문 리스트 가져오기
		List<QuestionVO> questions = surveyMapper.getSurveyQuestions(surveyId);
		System.out.println("Questions retrieved: " + questions);

		// 선택지 리스트 가져오기
		List<ChoiceVO> choices = surveyMapper.getChoicesBySurvey(surveyId);
		System.out.println("Choices retrieved: " + choices);

		// 각 질문에 선택지 매핑
		for (QuestionVO question : questions) {
			List<ChoiceVO> filteredChoices = choices.stream().filter(choice -> {
				if (choice.getChoiceGroupId() != null) {
					// choiceGroupId가 questionNumber와 일치하는 경우만 포함
					return choice.getChoiceGroupId().equals(question.getQuestionNumber());
				}
				// choiceGroupId가 NULL인 경우, 해당 questionNumber가 매칭되지 않은 질문에만 포함
				return !choices.stream().anyMatch(
						c -> c.getChoiceGroupId() != null && c.getChoiceGroupId().equals(question.getQuestionNumber()));
			}).collect(Collectors.toList());

			// 선택지를 질문에 설정
			question.setChoices(filteredChoices);
		}

		return questions;
	}

	@Override
	public void saveSurveyResponse(ResponseVO responseVO, List<AnswerVO> answerVOList) {
		surveyMapper.insertResponse(responseVO);

		int responseId = responseVO.getResponseId();

		answerVOList.forEach(answer -> {
			// 다중 선택 항목 저장
			if (answer.getChoiceIds() != null) {
				if (answer.getAnswerText() == null) {
					answer.setAnswerText(""); // NULL 대신 빈 문자열로 설정
				}
				answer.getChoiceIds().forEach(choiceId -> {
					AnswerVO normalAnswer = new AnswerVO();
					normalAnswer.setResponseId(responseId);
					normalAnswer.setQuestionId(answer.getQuestionId());
					normalAnswer.setChoiceId(choiceId); // 개별 choiceId 저장
					normalAnswer.setEtcText(null); // "기타" 항목이 아니므로 null
					surveyMapper.insertAnswer(normalAnswer);
				});
			}

			// "기타" 항목 저장
			if (answer.getEtcChoiceId() != null) {
				AnswerVO etcAnswer = new AnswerVO();
				etcAnswer.setResponseId(responseId);
				etcAnswer.setQuestionId(answer.getQuestionId());
				etcAnswer.setChoiceId(answer.getEtcChoiceId()); // 기타 choiceId
				etcAnswer.setEtcText(answer.getEtcText()); // 기타 텍스트
				surveyMapper.insertAnswer(etcAnswer);
			}
			if (answer.getChoiceId() != 0) { // single 타입
				AnswerVO singleAnswer = new AnswerVO();
				singleAnswer.setResponseId(responseId);
				singleAnswer.setQuestionId(answer.getQuestionId());
				singleAnswer.setChoiceId(answer.getChoiceId()); // 선택된 choiceId 저장
				singleAnswer.setEtcText(answer.getEtcText());
				surveyMapper.insertAnswer(singleAnswer);
			}

			// 텍스트 응답 저장
			if (answer.getAnswerText() != null && !answer.getAnswerText().isEmpty()) { // text 타입
				AnswerVO textAnswer = new AnswerVO();
				textAnswer.setResponseId(responseId);
				textAnswer.setQuestionId(answer.getQuestionId());
				textAnswer.setChoiceId(0); // 텍스트 응답이므로 choiceId는 null
				textAnswer.setEtcText(null); // 기타 텍스트는 null
				textAnswer.setAnswerText(answer.getAnswerText()); // 텍스트 응답 저장
				surveyMapper.insertAnswer(textAnswer);
			}
		});
	}

	@Override
	public boolean checkParticipation(int surveyId, String userId) {
		int count = surveyMapper.countParticipation(surveyId, userId);
		return count > 0;
	}

	@Override
	public int getResponseIdBySurveyAndUser(int surveyId, String userId) {
		Integer responseId = surveyMapper.getResponseIdBySurveyAndUser(surveyId, userId);
		return responseId != null ? responseId : 0; // null 방지
	}

	@Override
	public List<AnswerVO> getSurveyAnswers(int surveyId, String userId) {
		return surveyMapper.selectSurveyAnswers(surveyId, userId);
	}

	@Override
	public void updateResponseUpdateAt(int responseId) {
		surveyMapper.updateResponseUpdateAt(responseId, new Date());
	}

	
	 @Override
	    public void updateSurveyResponse(ResponseVO responseVO, List<AnswerVO> answerVOList) {
		 System.out.println("AnswerVO LIst:"+answerVOList);
	        // 1. 응답 수정 시간 업데이트
	        responseVO.setResponseUpdateAt(new Date());
	        surveyMapper.updateResponse(responseVO);

	        // 2. 기존 답변 삭제
	        surveyMapper.deleteAnswersByResponseId(responseVO.getResponseId());

	     // 3. 새로운 답변 저장
	        if (answerVOList != null && !answerVOList.isEmpty()) {
	            int responseId = responseVO.getResponseId();

	            answerVOList.forEach(answer -> {
	            	System.out.println("AnswerVO"+answer);
	            	System.out.println("EtcText: "+answer.getEtcText());
	            	System.out.println("EtcChoiceId"+answer.getEtcChoiceId());
	                // 다중 선택 항목 저장
	                if (answer.getChoiceIds() != null) {
	                    if (answer.getAnswerText() == null) {
	                        answer.setAnswerText(""); // NULL 대신 빈 문자열로 설정
	                    }
	                    answer.getChoiceIds().forEach(choiceId -> {
	                        AnswerVO normalAnswer = new AnswerVO();
	                        normalAnswer.setResponseId(responseId);
	                        normalAnswer.setQuestionId(answer.getQuestionId());
	                        normalAnswer.setChoiceId(choiceId); // 개별 choiceId 저장
	                        normalAnswer.setEtcText(null); // "기타" 항목이 아니므로 null
	                        surveyMapper.insertAnswer(normalAnswer);
	                    });
	                }

	                // "기타" 항목 저장
	                if (answer.getEtcChoiceId() != null) {
	                    AnswerVO etcAnswer = new AnswerVO();
	                    etcAnswer.setResponseId(responseId);
	                    etcAnswer.setQuestionId(answer.getQuestionId());
	                    etcAnswer.setChoiceId(answer.getEtcChoiceId()); // 기타 choiceId
	                    etcAnswer.setEtcText(answer.getEtcText()); // 기타 텍스트
	                    System.out.println("Inserting Answer: " + etcAnswer);
	                    surveyMapper.insertAnswer(etcAnswer);
	                }

	                // 단일 선택 항목 저장
	                if (answer.getChoiceId() != 0) { // single 타입
	                    AnswerVO singleAnswer = new AnswerVO();
	                    singleAnswer.setResponseId(responseId);
	                    singleAnswer.setQuestionId(answer.getQuestionId());
	                    singleAnswer.setChoiceId(answer.getChoiceId()); // 선택된 choiceId 저장
	                    singleAnswer.setEtcText(answer.getEtcText());
	                    surveyMapper.insertAnswer(singleAnswer);
	                }

	                // 텍스트 응답 저장
	                if (answer.getAnswerText() != null && !answer.getAnswerText().isEmpty()) { // text 타입
	                    AnswerVO textAnswer = new AnswerVO();
	                    textAnswer.setResponseId(responseId);
	                    textAnswer.setQuestionId(answer.getQuestionId());
	                    textAnswer.setChoiceId(0); // 텍스트 응답이므로 choiceId는 null
	                    textAnswer.setEtcText(null); // 기타 텍스트는 null
	                    textAnswer.setAnswerText(answer.getAnswerText()); // 텍스트 응답 저장
	                    surveyMapper.insertAnswer(textAnswer);
	                }
	            });
	        }
	    }
	 
	 @Override
	 	public List<SurveyInfoVO> searchSurvey(String searchType, String keyword){
		 return surveyMapper.searchSurvey(searchType,keyword);
	 }
	 

	 

}