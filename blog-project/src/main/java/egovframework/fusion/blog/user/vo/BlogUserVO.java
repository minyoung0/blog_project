package egovframework.fusion.blog.user.vo;

import java.io.Serializable;

public class BlogUserVO implements Serializable {
	private static final long serialVersionUID = -8402510944659037798L;

	public String userId;
	public String password;
	public String userName;
	public String email;
	public String profileImage;
	public String createAt;
	public String nickName;
	public String userAccessRight;
	public String bio;
	
	

	public String getBio() {
		return bio;
	}

	public void setBio(String bio) {
		this.bio = bio;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getProfileImage() {
		return profileImage;
	}

	public void setProfileImage(String profileImage) {
		this.profileImage = profileImage;
	}

	public String getCreateAt() {
		return createAt;
	}

	public void setCreateAt(String createAt) {
		this.createAt = createAt;
	}

	public String getNickName() {
		return nickName;
	}

	public void setNickName(String nickName) {
		this.nickName = nickName;
	}

	public String getUserAccessRight() {
		return userAccessRight;
	}

	public void setUserAccessRight(String userAccessRight) {
		this.userAccessRight = userAccessRight;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
