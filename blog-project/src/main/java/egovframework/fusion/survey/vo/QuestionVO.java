package egovframework.fusion.survey.vo;

import java.io.Serializable;
import java.util.List;

public class QuestionVO implements Serializable {
	private static final long serialVersionUID = -8402510944659037798L;

	private int questionId;
	private int categoryId;
	private int serveyId;
	private String questionNumber;
	private int parentQuestionId;
	private String questionType;
	private String questionText;
	private int isRequired;
	private int isActive;
	private String createAt;
	private String updateAt;
	private String createdBy;
	private String updtedBy;

	private String categoryName;

	private List<QuestionVO> subQuestions;


	private List<ChoiceVO> choices;
	private List<QuestionVO> children;

	// Getter 및 Setter for subQuestions
	public List<QuestionVO> getSubQuestions() {
		return subQuestions;
	}

	public void setSubQuestions(List<QuestionVO> subQuestions) {
		this.subQuestions = subQuestions;
	}

	public List<QuestionVO> getChildren() {
		return children;
	}

	public void setChildren(List<QuestionVO> children) {
		this.children = children;
	}

	public List<ChoiceVO> getChoices() {
		return choices;
	}

	public void setChoices(List<ChoiceVO> choices) {
		this.choices = choices;
	}

	public String getCategoryName() {
		return categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}

	public int getQuestionId() {
		return questionId;
	}

	public void setQuestionId(int questionId) {
		this.questionId = questionId;
	}

	public int getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(int categoryId) {
		this.categoryId = categoryId;
	}

	public int getServeyId() {
		return serveyId;
	}

	public void setServeyId(int serveyId) {
		this.serveyId = serveyId;
	}

	public String getQuestionNumber() {
		return questionNumber;
	}

	public void setQuestionNumber(String questionNumber) {
		this.questionNumber = questionNumber;
	}

	public int getParentQuestionId() {
		return parentQuestionId;
	}

	public void setParentQuestionId(int parentQuestionId) {
		this.parentQuestionId = parentQuestionId;
	}

	public String getQuestionType() {
		return questionType;
	}

	public void setQuestionType(String questionType) {
		this.questionType = questionType;
	}

	public String getQuestionText() {
		return questionText;
	}

	public void setQuestionText(String questionText) {
		this.questionText = questionText;
	}

	public int getIsRequired() {
		return isRequired;
	}

	public void setIsRequired(int isRequired) {
		this.isRequired = isRequired;
	}

	public int getIsActive() {
		return isActive;
	}

	public void setIsActive(int isActive) {
		this.isActive = isActive;
	}

	public String getCreateAt() {
		return createAt;
	}

	public void setCreateAt(String createAt) {
		this.createAt = createAt;
	}

	public String getUpdateAt() {
		return updateAt;
	}

	public void setUpdateAt(String updateAt) {
		this.updateAt = updateAt;
	}

	public String getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}

	public String getUpdtedBy() {
		return updtedBy;
	}

	public void setUpdtedBy(String updtedBy) {
		this.updtedBy = updtedBy;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}