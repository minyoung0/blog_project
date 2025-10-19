package egovframework.fusion.studyRoom.service;

import java.time.LocalDateTime;
import java.util.List;

import egovframework.fusion.studyRoom.vo.ReservationVO;
import egovframework.fusion.studyRoom.vo.RoomVO;
import egovframework.fusion.studyRoom.vo.SeatVO;
import egovframework.fusion.studyRoom.vo.StudyRoomVO;

public interface StudyRoomService {

	//해당 독서실명
	public StudyRoomVO getSiteName(int menuId);
	
	//독서실 내 열람실리스트
	public List<RoomVO> getRoomList();
	
	//열람실 별 좌석 정보 - 사용불가 좌석 정보 포함
	public List<SeatVO> getSeatInfo(int roomId);
	
	//해당 열람실,날짜 별 예약 정보
	public List<ReservationVO> getReservList(int roomId,String selectDate);
	
	//해당 날짜 독서실 운영정보
	public StudyRoomVO getOperInfo(String selectDate);
	
	//해당 좌석,날짜 예약 현황
	public List<ReservationVO> getReservInfo(int seatId, String selectDate);
	
	//좌석 정보
	public SeatVO getSeatOffInfo(int seatId);
	
	//예약
	public int insertReservation(int seatId, String selectReason,String selectDay,String selectStart,String selectEnd,String userId);
	
	
	public List<ReservationVO> getMyReserv(String userId);
	
	//에약취소
	public void cancelReserv(int reservId);
	
	public List<StudyRoomVO> getStudyRoomOffList();
	
	public List<RoomVO> offRoom(String selectDay);
	
	public List<RoomVO> getRoomOffList();
	
	public void insSeat(int roomLocation, int roomId);
	
	public void updStudyRoom(String selectStart,String selectEnd,String selectDaty,String reason);
}
