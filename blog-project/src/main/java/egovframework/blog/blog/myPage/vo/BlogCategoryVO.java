package egovframework.fusion.blog.myPage.vo;

import java.io.Serializable;

public class BlogCategoryVO implements Serializable{
	
	private static final long serialVersionUID = -8402510944659037798L;
	
	public Integer categoryId;
	public String categoryName;
	public String visibility;
	public String userId;
	public String createAt;
	public String disableYn;
	public Integer getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(Integer categoryId) {
		this.categoryId = categoryId;
	}
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public String getVisibility() {
		return visibility;
	}
	public void setVisibility(String visibility) {
		this.visibility = visibility;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getCreateAt() {
		return createAt;
	}
	public void setCreateAt(String createAt) {
		this.createAt = createAt;
	}
	public String getDisableYn() {
		return disableYn;
	}
	public void setDisableYn(String disableYn) {
		this.disableYn = disableYn;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
	
}
