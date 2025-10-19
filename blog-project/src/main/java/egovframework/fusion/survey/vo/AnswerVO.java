package egovframework.fusion.survey.vo;

import java.io.Serializable;
import java.util.List;

public class AnswerVO implements Serializable {
	private static final long serialVersionUID = -8402510944659037798L;

	private int answerId;
	private int responseId;
	private int questionId;
	private int choiceId;
	private String answerText;
	private List<Integer> choiceIds;
	private Integer etcChoiceId; 
	private String etcText;  

	
	
	public List<Integer> getChoiceIds() {
		return choiceIds;
	}

	public void setChoiceIds(List<Integer> choiceIds) {
		this.choiceIds = choiceIds;
	}

	public Integer getEtcChoiceId() {
		return etcChoiceId;
	}

	public void setEtcChoiceId(Integer etcChoiceId) {
		this.etcChoiceId = etcChoiceId;
	}

	public String getEtcText() {
		return etcText;
	}

	public void setEtcText(String etcText) {
		this.etcText = etcText;
	}

	public int getAnswerId() {
		return answerId;
	}

	public void setAnswerId(int answerId) {
		this.answerId = answerId;
	}

	public int getResponseId() {
		return responseId;
	}

	public void setResponseId(int responseId) {
		this.responseId = responseId;
	}

	public int getQuestionId() {
		return questionId;
	}

	public void setQuestionId(int questionId) {
		this.questionId = questionId;
	}

	public int getChoiceId() {
		return choiceId;
	}

	public void setChoiceId(int choiceId) {
		this.choiceId = choiceId;
	}

	public String getAnswerText() {
		return answerText;
	}

	public void setAnswerText(String answerText) {
		this.answerText = answerText;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}