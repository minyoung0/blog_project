package egovframework.fusion.blog.myPage.vo;

import java.io.Serializable;

public class VisitVO implements Serializable{
	
	private static final long serialVersionUID = -8402510944659037798L;
	
	public Integer visitId;
	public String blogUserId;
	public String visitorId;
	public String visitorIp;
	public String visitDate;
	public Integer visitCount;
	
	
	public Integer getVisitCount() {
		return visitCount;
	}
	public void setVisitCount(Integer visitCount) {
		this.visitCount = visitCount;
	}
	public Integer getVisitId() {
		return visitId;
	}
	public void setVisitId(Integer visitId) {
		this.visitId = visitId;
	}
	public String getBlogUserId() {
		return blogUserId;
	}
	public void setBlogUserId(String blogUserId) {
		this.blogUserId = blogUserId;
	}
	public String getVisitorId() {
		return visitorId;
	}
	public void setVisitorId(String visitorId) {
		this.visitorId = visitorId;
	}
	public String getVisitorIp() {
		return visitorIp;
	}
	public void setVisitorIp(String visitorIp) {
		this.visitorIp = visitorIp;
	}
	public String getVisitDate() {
		return visitDate;
	}
	public void setVisitDate(String visitDate) {
		this.visitDate = visitDate;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
}
