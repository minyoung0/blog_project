package egovframework.fusion.studyRoom.vo;

import java.io.Serializable;
import java.time.LocalDateTime;

public class ReservationVO implements Serializable {

	private static final long serialVersionUID = -8402510944659037798L;

	private Integer reservId;
	private Integer seatId;
	private String userId;
	private String reservCreateAt;
	private String startTime;
	private String endTime;
	private Integer reservStatus;
	private String reservReason;
	private String reservDate;
	
	private LocalDateTime startDateTime;
	private LocalDateTime endDateTime;
	private Integer seatLocation;


	private String roomName;
	
	
	

	public Integer getSeatLocation() {
		return seatLocation;
	}

	public void setSeatLocation(Integer seatLocation) {
		this.seatLocation = seatLocation;
	}

	public String getRoomName() {
		return roomName;
	}

	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}

	public String getReservDate() {
		return reservDate;
	}

	public void setReservDate(String reservDate) {
		this.reservDate = reservDate;
	}

	public LocalDateTime getStartDateTime() {
		return startDateTime;
	}

	public void setStartDateTime(LocalDateTime startDateTime) {
		this.startDateTime = startDateTime;
	}

	public LocalDateTime getEndDateTime() {
		return endDateTime;
	}

	public void setEndDateTime(LocalDateTime endDateTime) {
		this.endDateTime = endDateTime;
	}

	public String getReservReason() {
		return reservReason;
	}

	public void setReservReason(String reservReason) {
		this.reservReason = reservReason;
	}

	public Integer getReservId() {
		return reservId;
	}

	public void setReservId(Integer reservId) {
		this.reservId = reservId;
	}

	public Integer getSeatId() {
		return seatId;
	}

	public void setSeatId(Integer seatId) {
		this.seatId = seatId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getReservCreateAt() {
		return reservCreateAt;
	}

	public void setReservCreateAt(String reservCreateAt) {
		this.reservCreateAt = reservCreateAt;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public Integer getReservStatus() {
		return reservStatus;
	}

	public void setReservStatus(Integer reservStatus) {
		this.reservStatus = reservStatus;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
