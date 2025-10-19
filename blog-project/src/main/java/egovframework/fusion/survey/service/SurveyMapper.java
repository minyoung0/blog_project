package egovframework.fusion.survey.service;

import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.survey.vo.AnswerVO;
import egovframework.fusion.survey.vo.ChoiceVO;
import egovframework.fusion.survey.vo.QuestionVO;
import egovframework.fusion.survey.vo.ResponseVO;
import egovframework.fusion.survey.vo.SurveyInfoVO;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface SurveyMapper {
	public SurveyInfoVO getSurveyById(@Param("surveyId") int surveyId);

	public List<QuestionVO> getSurveyQuestionsWithChoices(int surveyId);

	public List<ChoiceVO> getChoices();

	public List<QuestionVO> getSurveyQuestions(int surveyId);

	public List<ChoiceVO> getChoicesBySurvey(int surveyId);

	public int getTotalQuestion(int surveyId);

	// 응답 완료 테이블 삽입
	public void insertResponse(ResponseVO response);

	// 답변 테이블 삽입
	public void insertAnswer(AnswerVO answer);

	// 설문 참여 여부확인
	public int countParticipation(@Param("surveyId") int surveyId, @Param("userId") String userId);
	
	public int getResponseIdBySurveyAndUser(@Param("surveyId") int surveyId, @Param("userId") String userId);

	// 응답 가져오기
	public List<AnswerVO> selectSurveyAnswers(@Param("surveyId") int surveyId, @Param("userId") String userId);

	public void updateSingleChoiceAnswer(AnswerVO answer); // 단일 선택 문항 업데이트

	public void updateMultipleChoiceAnswer(AnswerVO answer); // 다중 선택 문항 업데이트

	public void updateTextAnswer(AnswerVO answer); // 주관식 문항 업데이트

	public void updateEtcTextAnswer(AnswerVO answer); // 기타 텍스트 업데이트

	public void updateResponseUpdateAt(@Param("responseId") int responseId, @Param("updateAt") Date updateAt); // 응답 수정
													

    
 // 1. 응답 수정 시간 업데이트
    public void updateResponse(ResponseVO responseVO);

    // 2. 기존 답변 삭제
    public void deleteAnswersByResponseId(int responseId);

    // 3. 새로운 답변 저장
    public void saveAllAnswers(@Param("answers") List<AnswerVO> answerVOList,@Param("responseId") int responseId);
    
    
    public List<SurveyInfoVO> searchSurvey(@Param("searchType") String searchType, @Param("keyword") String keyword);
}
