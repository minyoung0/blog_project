package egovframework.fusion.studyRoom.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.fusion.progressBoard.service.ProgressBoardServiceImpl;
import egovframework.fusion.studyRoom.vo.ReservationVO;
import egovframework.fusion.studyRoom.vo.RoomVO;
import egovframework.fusion.studyRoom.vo.SeatVO;
import egovframework.fusion.studyRoom.vo.StudyRoomVO;

@Service
public class StudyRoomServiceImpl extends EgovAbstractServiceImpl implements StudyRoomService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ProgressBoardServiceImpl.class);

	@Autowired
	StudyRoomMapper studyRoomMapper;

	@Override
	public StudyRoomVO getSiteName(int menuId) {
		return studyRoomMapper.getSiteName(menuId);
	}

	@Override
	public List<RoomVO> getRoomList() {
		return studyRoomMapper.getRoomList();
	}

	@Override
	public List<SeatVO> getSeatInfo(int roomId) {
		return studyRoomMapper.getSeatInfo(roomId);
	}
	
	
	@Override
	public List<ReservationVO> getReservList(int roomId,String selectDate){
		return studyRoomMapper.getReservList(roomId,selectDate);
	}
	
	@Override
	public StudyRoomVO getOperInfo(String selectDate) {
		StudyRoomVO isUpdate=studyRoomMapper.getOperUpdateInfo(selectDate);
		if(isUpdate !=null) {
			return studyRoomMapper.getOperUpdateInfo(selectDate);
		}else {
			return studyRoomMapper.getOperDefaultInfo();
		}
	}
	
	
	@Override
	public List<ReservationVO> getReservInfo(int seatId, String selectDate){
		return studyRoomMapper.getReservInfo(seatId,selectDate);
	}
	
	@Override
	public SeatVO getSeatOffInfo(int seatId) {
		return studyRoomMapper.getSeatOffInfo(seatId);
	}
	
	@Override
	@Transactional
	public int insertReservation(int seatId, String selectReason,String selectDay,String selectStart,String selectEnd,String userId) {
		
		System.out.println("dd"+selectDay+"    start:"+selectStart+"   end:"+selectEnd);
		int result;
		
		int reserved = studyRoomMapper.getReservedCount(seatId,selectDay,selectStart,selectEnd);
		
		if(reserved>0) {
			result=0;
			return result;
		}else {
			DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
			DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
			DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
	
			
			LocalDate date = LocalDate.parse(selectDay, dateFormatter);
			LocalTime startTime = LocalTime.parse(selectStart, timeFormatter);
			LocalTime endTime = LocalTime.parse(selectEnd, timeFormatter);
	
			
			LocalDateTime startDateTime = LocalDateTime.of(date, startTime);
			LocalDateTime endDateTime = LocalDateTime.of(date, endTime);
			
			studyRoomMapper.insertReservation(seatId,selectDay,selectReason,startDateTime,endDateTime,userId);
			result=1;
			return result;
		}

	}

	@Override
	public List<ReservationVO> getMyReserv(String userId){
		return studyRoomMapper.getMyReserv(userId);
	}
	
	@Override
	public void cancelReserv(int reservId) {
		studyRoomMapper.cancelReserv(reservId);
	}
	
	@Override
	public List<StudyRoomVO> getStudyRoomOffList(){
		return studyRoomMapper.getStudyRoomOffList();
	}
	
	@Override
	public List<RoomVO> offRoom(String selectDay){
		return studyRoomMapper.offRoom(selectDay);
	}
	
	
	@Override
	public List<RoomVO> getRoomOffList(){
		return studyRoomMapper.getRoomOffList();
	}
	
	@Override
	public void insSeat(int roomLocation,int roomId) {
		studyRoomMapper.insSeat(roomLocation,roomId);
	}
	
	@Override
	public void updStudyRoom(String selectStart,String selectEnd,String selectDay,String reason) {
		//새로운 독서실 운영정보 등록
		studyRoomMapper.updStudyRoom(selectStart,selectEnd,selectDay,reason);
		
		//해당 날짜에 예약 취소
		studyRoomMapper.cancelByManager(selectStart,selectStart,selectEnd);
		
	}
}
