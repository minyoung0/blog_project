package egovframework.fusion.survey.vo;

import java.io.Serializable;
import java.util.Date;

public class ResponseVO implements Serializable {
	private static final long serialVersionUID = -8402510944659037798L;

	private int responseId;
	private String userId;
	private int surveyId;
	private Date responseCreateAt;
	private Date responseUpdateAt;

	public int getResponseId() {
		return responseId;
	}

	public void setResponseId(int responseId) {
		this.responseId = responseId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public int getSurveyId() {
		return surveyId;
	}

	public void setSurveyId(int surveyId) {
		this.surveyId = surveyId;
	}


	public Date getResponseCreateAt() {
		return responseCreateAt;
	}

	public void setResponseCreateAt(Date responseCreateAt) {
		this.responseCreateAt = responseCreateAt;
	}

	public Date getResponseUpdateAt() {
		return responseUpdateAt;
	}

	public void setResponseUpdateAt(Date responseUpdateAt) {
		this.responseUpdateAt = responseUpdateAt;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}