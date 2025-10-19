package egovframework.fusion.survey.vo;

import java.io.Serializable;

public class QuestionCategoryVO implements Serializable{
	private static final long serialVersionUID = -8402510944659037798L;
	
	private int categoryId;
	private String categoryName;
	private String createAt;
	private String updateAt;
	private String createdBy;
	private String updtedBy;
	
	
	public int getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(int categoryId) {
		this.categoryId = categoryId;
	}
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
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