package egovframework.fusion.blog.myPage.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class BlogCommentVO implements Serializable{
	
	private static final long serialVersionUID = -8402510944659037798L;
	
	public Integer commentId;
	public Integer parentId;
	public Integer postId;
	public String content;
	public String userId;
	public String createAt;
	public String updateAt;
	public String deleteYn;
	public String nickName;
	public String profileImage;
	
	public List<BlogCommentVO> children=new ArrayList<>();
	
	
	public List<BlogCommentVO> getChildren() {
		return children;
	}
	public void setChildren(List<BlogCommentVO> children) {
		this.children = children;
	}
	public String getProfileImage() {
		return profileImage;
	}
	public void setProfileImage(String profileImage) {
		this.profileImage = profileImage;
	}
	public String getNickName() {
		return nickName;
	}
	public void setNickName(String nickName) {
		this.nickName = nickName;
	}
	public Integer getCommentId() {
		return commentId;
	}
	public void setCommentId(Integer commentId) {
		this.commentId = commentId;
	}
	public Integer getParentId() {
		return parentId;
	}
	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}
	public Integer getPostId() {
		return postId;
	}
	public void setPostId(Integer postId) {
		this.postId = postId;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
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
	public String getUpdateAt() {
		return updateAt;
	}
	public void setUpdateAt(String updateAt) {
		this.updateAt = updateAt;
	}
	public String getDeleteYn() {
		return deleteYn;
	}
	public void setDeleteYn(String deleteYn) {
		this.deleteYn = deleteYn;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
	
}
