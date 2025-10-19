package egovframework.fusion.survey.vo;

import java.io.Serializable;
import java.util.Date;

public class SurveyInfoVO implements Serializable {
	private static final long serialVersionUID = -8402510944659037798L;

	private int surveyId;
	private Date startDate;
	private Date endDate;
	private int isActive;
	private String createAt;
	private String updateAt;
	private String createdBy;
	private String updtedBy;
	private String surveyName;
	
	

	public String getSurveyName() {
		return surveyName;
	}

	public void setSurveyName(String surveyName) {
		this.surveyName = surveyName;
	}

	public int getSurveyId() {
		return surveyId;
	}

	public void setSurveyId(int surveyId) {
		this.surveyId = surveyId;
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
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