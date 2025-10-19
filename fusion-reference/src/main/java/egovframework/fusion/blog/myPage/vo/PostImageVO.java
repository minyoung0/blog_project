package egovframework.fusion.blog.myPage.vo;

import java.io.Serializable;

public class PostImageVO implements Serializable{
	
	private static final long serialVersionUID = -8402510944659037798L;
	
	public Integer imageId;
	public String ImagePath;
	public Integer postId;
	
	public Integer getImageId() {
		return imageId;
	}
	public void setImageId(Integer imageId) {
		this.imageId = imageId;
	}
	public String getImagePath() {
		return ImagePath;
	}
	public void setImagePath(String imagePath) {
		ImagePath = imagePath;
	}
	public Integer getPostId() {
		return postId;
	}
	public void setPostId(Integer postId) {
		this.postId = postId;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
	
}
