package egovframework.fusion.studyRoom.service;


import java.time.LocalDateTime;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.fusion.studyRoom.vo.ReservationVO;
import egovframework.fusion.studyRoom.vo.RoomVO;
import egovframework.fusion.studyRoom.vo.SeatVO;
import egovframework.fusion.studyRoom.vo.StudyRoomVO;

@Mapper
public interface StudyRoomMapper {

	public StudyRoomVO getSiteName(@Param("menuId") int menuId);
	
	public List<RoomVO> getRoomList();
	
	public List<SeatVO> getSeatInfo(@Param("roomId")int roomId);
	
	public List<ReservationVO> getReservList(@Param("roomId")int roomId, @Param("selectDate")String selectDate);

	public StudyRoomVO getOperUpdateInfo(@Param("selectDate")String selectDate);
	
	public StudyRoomVO getOperDefaultInfo();
	
	public List<ReservationVO> getReservInfo(@Param("seatId")int seatId,@Param("selectDate")String selectDate);

	public SeatVO getSeatOffInfo(@Param("seatId")int seatId);
	
	public void insertReservation(@Param("seatId")int seatId,@Param("selectDay")String selectDay, @Param("selectReason")String selectReason,
			@Param("startDateTime")LocalDateTime startDateTime,@Param("endDateTime")LocalDateTime endDateTime,@Param("userId")String userId);
	public List<ReservationVO> getMyReserv(@Param("userId")String userId);
	
	public void cancelReserv(@Param("reservId")int reservId);
	
	public List<StudyRoomVO> getStudyRoomOffList();
	
	public List<RoomVO> offRoom(@Param("selectDay") String selectDay);
	
	public List<RoomVO> getRoomOffList();
	
	public void insSeat(@Param("roomLocation")int roomLocation, @Param("roomId")int roomId);
	
	public int getReservedCount(@Param("seatId") int seatId, @Param("selectDay") String selectDay, @Param("selectStart")String selectStart, @Param("selectEnd")String selectEnd);

	public void updStudyRoom(@Param("selectStart")String selectStart,@Param("selectEnd")String selectEnd,@Param("selectDay")String selectDay,@Param("reason")String reason);

	public void cancelByManager(@Param("selectStart")String selectStart,@Param("selectEnd")String selectEnd,@Param("selectDay")String selectDay);
}
