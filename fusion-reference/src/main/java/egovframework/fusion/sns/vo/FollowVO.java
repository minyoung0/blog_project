package egovframework.fusion.sns.vo;

import java.io.Serializable;
import java.util.Date;

public class FollowVO  implements Serializable{
	private static final long serialVersionUID = -8402510944659037798L;
	
	private int id;
	private String followerId;
	private String followingId;
	private int followStatus;
	private Date follow_create_at;
	private Date follow_update_at;
	
	private String userId;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getFollowerId() {
		return followerId;
	}
	public void setFollowerId(String followerId) {
		this.followerId = followerId;
	}
	public String getFollowingId() {
		return followingId;
	}
	public void setFollowingId(String followingId) {
		this.followingId = followingId;
	}
	public int getFollowStatus() {
		return followStatus;
	}
	public void setFollowStatus(int followStatus) {
		this.followStatus = followStatus;
	}
	public Date getFollow_create_at() {
		return follow_create_at;
	}
	public void setFollow_create_at(Date follow_create_at) {
		this.follow_create_at = follow_create_at;
	}
	public Date getFollow_update_at() {
		return follow_update_at;
	}
	public void setFollow_update_at(Date follow_update_at) {
		this.follow_update_at = follow_update_at;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
	
}
