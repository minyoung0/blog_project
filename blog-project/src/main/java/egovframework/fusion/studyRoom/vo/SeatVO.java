package egovframework.fusion.studyRoom.vo;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Date;

public class SeatVO implements Serializable {

	private static final long serialVersionUID = -8402510944659037798L;

	private Integer seatId;
	private Integer roomId;
	private Integer seatLocation;
	private Integer seatStatus;
	private String disabledReason;
	private String startDate;
	private String endDate;

	private Date start;
	private Date end;
	
	
	
	
	
	public Date getStart() {
		return start;
	}

	public void setStart(Date start) {
		this.start = start;
	}

	public Date getEnd() {
		return end;
	}

	public void setEnd(Date end) {
		this.end = end;
	}

	public Integer getSeatId() {
		return seatId;
	}

	public void setSeatId(Integer seatId) {
		this.seatId = seatId;
	}

	public Integer getRoomId() {
		return roomId;
	}

	public void setRoomId(Integer roomId) {
		this.roomId = roomId;
	}

	public Integer getSeatLocation() {
		return seatLocation;
	}

	public void setSeatLocation(Integer seatLocation) {
		this.seatLocation = seatLocation;
	}

	public Integer getSeatStatus() {
		return seatStatus;
	}

	public void setSeatStatus(Integer seatStatus) {
		this.seatStatus = seatStatus;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getDisabledReason() {
		return disabledReason;
	}

	public void setDisabledReason(String disabledReason) {
		this.disabledReason = disabledReason;
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

}
