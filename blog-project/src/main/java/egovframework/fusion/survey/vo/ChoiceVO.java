package egovframework.fusion.survey.vo;

import java.io.Serializable;

public class ChoiceVO implements Serializable{
	private static final long serialVersionUID = -8402510944659037798L;
	
	private int choiceId;
	private String choiceGroupId;
	private String choiceText;
	private String createAt;
	private String updateAt;
	private String createdBy;
	private String updtedBy;
	public int getChoiceId() {
		return choiceId;
	}
	public void setChoiceId(int choiceId) {
		this.choiceId = choiceId;
	}
	public String getChoiceGroupId() {
		return choiceGroupId;
	}
	public void setChoiceGroupId(String choiceGroupId) {
		this.choiceGroupId = choiceGroupId;
	}
	public String getChoiceText() {
		return choiceText;
	}
	public void setChoiceText(String choiceText) {
		this.choiceText = choiceText;
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