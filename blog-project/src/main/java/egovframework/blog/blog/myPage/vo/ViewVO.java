package egovframework.fusion.blog.myPage.vo;

import java.io.Serializable;

public class ViewVO implements Serializable{
	
	private static final long serialVersionUID = -8402510944659037798L;
	
	public Integer viewId;
	public Integer postId;
	public String userId;
	public String viewedDate;
	public String ipAddress;
	public Integer getViewId() {
		return viewId;
	}
	public void setViewId(Integer viewId) {
		this.viewId = viewId;
	}
	public Integer getPostId() {
		return postId;
	}
	public void setPostId(Integer postId) {
		this.postId = postId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getViewedDate() {
		return viewedDate;
	}
	public void setViewedDate(String viewedDate) {
		this.viewedDate = viewedDate;
	}
	public String getIpAddress() {
		return ipAddress;
	}
	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
	
}
