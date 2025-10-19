package egovframework.fusion.studyRoom.vo;

import java.io.Serializable;

public class RoomVO implements Serializable {

	private static final long serialVersionUID = -8402510944659037798L;

	private Integer roomId;
	private String roomName;
	private Integer studyroomId;
	private String startDate;
	private String endDate;
	private String disabledReason;
	private String updateInfo;
	
	
	
	public void setUpdateInfo(String updateInfo) {
		this.updateInfo = updateInfo;
	}

	public Object getUpdateInfo() {
		return updateInfo;
	}

	public Integer getRoomId() {
		return roomId;
	}

	public void setRoomId(Integer roomId) {
		this.roomId = roomId;
	}


	public String getRoomName() {
		return roomName;
	}

	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}

	public Integer getStudyroomId() {
		return studyroomId;
	}

	public void setStudyroomId(Integer studyroomId) {
		this.studyroomId = studyroomId;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getDisabledReason() {
		return disabledReason;
	}

	public void setDisabledReason(String disabledReason) {
		this.disabledReason = disabledReason;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
