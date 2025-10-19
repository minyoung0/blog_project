package egovframework.fusion.user.vo;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

public class UserVO implements Serializable{

	private static final long serialVersionUID = -8402510944659037798L;

	/* 게시판 */
	private String userId;
	private String userName;
	private String userPassword;
	private String accessRight;
	
	
	
	
	
	public String getAccessRight() {
		return accessRight;
	}




	public void setAccessRight(String accessRight) {
		this.accessRight = accessRight;
	}




	public String getUserId() {
		return userId;
	}




	public void setUserId(String userId) {
		this.userId = userId;
	}




	public String getUserName() {
		return userName;
	}




	public void setUserName(String userName) {
		this.userName = userName;
	}




	public String getUserPassword() {
		return userPassword;
	}




	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}




	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	

	
	
}
