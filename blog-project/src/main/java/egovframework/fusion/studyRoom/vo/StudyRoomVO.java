package egovframework.fusion.studyRoom.vo;

import java.io.Serializable;

public class StudyRoomVO implements Serializable {

	private static final long serialVersionUID = -8402510944659037798L;

	private Integer studyRoomId;
	private String openTime;
	private String closeTime;
	private String studyRoomName;
	private Integer id;
	private String updateDate;
	private String updateReason;
	private String updateInfo;
	
	
	
	public void setUpdateInfo(String updateInfo) {
		this.updateInfo = updateInfo;
	}

	public Object getUpdateInfo() {
		return updateInfo;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getUpdateReason() {
		return updateReason;
	}

	public void setUpdateReason(String updateReason) {
		this.updateReason = updateReason;
	}

	public Integer getStudyRoomId() {
		return studyRoomId;
	}

	public void setStudyRoomId(Integer studyRoomId) {
		this.studyRoomId = studyRoomId;
	}

	public String getOpenTime() {
		return openTime;
	}

	public void setOpenTime(String openTime) {
		this.openTime = openTime;
	}

	public String getCloseTime() {
		return closeTime;
	}

	public void setCloseTime(String closeTime) {
		this.closeTime = closeTime;
	}

	public String getStudyRoomName() {
		return studyRoomName;
	}

	public void setStudyRoomName(String studyRoomName) {
		this.studyRoomName = studyRoomName;
	}
	
	

	public String getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
