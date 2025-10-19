package egovframework.fusion.blog.myPage.vo;

import java.io.Serializable;

public class SubscribeVO implements Serializable{
	
	private static final long serialVersionUID = -8402510944659037798L;
	
	public Integer subscriptionId;
	public String subscriberId;
	public String blogOwnerId;
	public String subscribedAt;
	public String unSubscribedAt;
	public String status;
	public Integer getSubscriptionId() {
		return subscriptionId;
	}
	public void setSubscriptionId(Integer subscriptionId) {
		this.subscriptionId = subscriptionId;
	}
	public String getSubscriberId() {
		return subscriberId;
	}
	public void setSubscriberId(String subscriberId) {
		this.subscriberId = subscriberId;
	}
	public String getBlogOwnerId() {
		return blogOwnerId;
	}
	public void setBlogOwnerId(String blogOwnerId) {
		this.blogOwnerId = blogOwnerId;
	}
	public String getSubscribedAt() {
		return subscribedAt;
	}
	public void setSubscribedAt(String subscribedAt) {
		this.subscribedAt = subscribedAt;
	}
	public String getUnSubscribedAt() {
		return unSubscribedAt;
	}
	public void setUnSubscribedAt(String unSubscribedAt) {
		this.unSubscribedAt = unSubscribedAt;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
}
