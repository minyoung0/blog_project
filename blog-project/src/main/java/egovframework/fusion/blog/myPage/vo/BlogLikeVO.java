package egovframework.fusion.blog.myPage.vo;

import java.io.Serializable;

public class BlogLikeVO implements Serializable{
	
	private static final long serialVersionUID = -8402510944659037798L;
	
	public int likeId;
	public int postId;
	public String userId;
	public String createAt;
	public String cancelYn;
	public String cancelDate;
	
	
	
	public int getLikeId() {
		return likeId;
	}
	public void setLikeId(int likeId) {
		this.likeId = likeId;
	}
	public int getPostId() {
		return postId;
	}
	public void setPostId(int postId) {
		this.postId = postId;
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
	public String getCancelYn() {
		return cancelYn;
	}
	public void setCancelYn(String cancelYn) {
		this.cancelYn = cancelYn;
	}
	public String getCancelDate() {
		return cancelDate;
	}
	public void setCancelDate(String cancelDate) {
		this.cancelDate = cancelDate;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
	
}
