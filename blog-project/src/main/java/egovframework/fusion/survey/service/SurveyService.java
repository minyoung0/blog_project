package egovframework.fusion.survey.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.survey.vo.AnswerVO;
import egovframework.fusion.survey.vo.ChoiceVO;
import egovframework.fusion.survey.vo.QuestionVO;
import egovframework.fusion.survey.vo.ResponseVO;
import egovframework.fusion.survey.vo.SurveyInfoVO;

public interface SurveyService {

	public SurveyInfoVO getSurveyById(@Param("surveyId") int surveyId);

	public int getTotalQuestion(@Param("surveyId") int surveyId);

	public List<QuestionVO> getSurveyQuestions(int surveyId);

	public List<QuestionVO> getSurveyQuestionsWithChoices(int surveyId);

	public void saveSurveyResponse(ResponseVO responseVO, List<AnswerVO> answerVOList);

	public boolean checkParticipation(int surveyId, String userId);

	public int getResponseIdBySurveyAndUser(int surveyId, String userId);

	public List<AnswerVO> getSurveyAnswers(int surveyId, String userId);

	public void updateResponseUpdateAt(int responseId);
	
	public void updateSurveyResponse(ResponseVO responseVO, List<AnswerVO> answerVOList);
	
	public List<SurveyInfoVO> searchSurvey(String searchType, String keyword);
	
	
}