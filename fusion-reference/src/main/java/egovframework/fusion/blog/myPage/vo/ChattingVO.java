package egovframework.fusion.blog.myPage.vo;

import java.io.Serializable;

public class ChattingVO implements Serializable{
	
	private static final long serialVersionUID = -8402510944659037798L;
	
	public Integer roomId;
	public String userId;
	public String user1Id;
	public String user2Id;
	public String createAt;
	public String user1IsActive;
	public String user2IsActive;
	
	public Integer messageId;
	public String senderId;
	public String receiverId;
	public String message;
	public String sendingTime;
	public String updateTime;
	public String readYn;
	public String deleteYn;
	
	public String senderNickName;
	public String receiverNickName;
	public String senderProfile;
	public String receiverProfile;
	
	public String otherUserNickName;
	public String otherUserProfile;
	public String otherUserId;
	public String recentlyTime;
	public String type;
	
	
	
	
	public String getOtherUserId() {
		return otherUserId;
	}
	public void setOtherUserId(String otherUserId) {
		this.otherUserId = otherUserId;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getRecentlyTime() {
		return recentlyTime;
	}
	public void setRecentlyTime(String recentlyTime) {
		this.recentlyTime = recentlyTime;
	}
	public String getOtherUserNickName() {
		return otherUserNickName;
	}
	public void setOtherUserNickName(String otherUserNickName) {
		this.otherUserNickName = otherUserNickName;
	}
	public String getOtherUserProfile() {
		return otherUserProfile;
	}
	public void setOtherUserProfile(String otherUserProfile) {
		this.otherUserProfile = otherUserProfile;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getSenderNickName() {
		return senderNickName;
	}
	public void setSenderNickName(String senderNickName) {
		this.senderNickName = senderNickName;
	}
	public String getReceiverNickName() {
		return receiverNickName;
	}
	public void setReceiverNickName(String receiverNickName) {
		this.receiverNickName = receiverNickName;
	}
	public String getSenderProfile() {
		return senderProfile;
	}
	public void setSenderProfile(String senderProfile) {
		this.senderProfile = senderProfile;
	}
	public String getReceiverProfile() {
		return receiverProfile;
	}
	public void setReceiverProfile(String receiverProfile) {
		this.receiverProfile = receiverProfile;
	}
	public Integer getRoomId() {
		return roomId;
	}
	public void setRoomId(Integer roomId) {
		this.roomId = roomId;
	}
	public String getUser1Id() {
		return user1Id;
	}
	public void setUser1Id(String user1Id) {
		this.user1Id = user1Id;
	}
	public String getUser2Id() {
		return user2Id;
	}
	public void setUser2Id(String user2Id) {
		this.user2Id = user2Id;
	}
	public String getCreateAt() {
		return createAt;
	}
	public void setCreateAt(String createAt) {
		this.createAt = createAt;
	}
	public String getUser1IsActive() {
		return user1IsActive;
	}
	public void setUser1IsActive(String user1IsActive) {
		this.user1IsActive = user1IsActive;
	}
	public String getUser2IsActive() {
		return user2IsActive;
	}
	public void setUser2IsActive(String user2IsActive) {
		this.user2IsActive = user2IsActive;
	}
	public Integer getMessageId() {
		return messageId;
	}
	public void setMessageId(Integer messageId) {
		this.messageId = messageId;
	}
	public String getSenderId() {
		return senderId;
	}
	public void setSenderId(String senderId) {
		this.senderId = senderId;
	}
	public String getReceiverId() {
		return receiverId;
	}
	public void setReceiverId(String receiverId) {
		this.receiverId = receiverId;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getSendingTime() {
		return sendingTime;
	}
	public void setSendingTime(String sendingTime) {
		this.sendingTime = sendingTime;
	}
	public String getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}
	public String getReadYn() {
		return readYn;
	}
	public void setReadYn(String readYn) {
		this.readYn = readYn;
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
