package egovframework.fusion.studyRoom.controller;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.fusion.main.service.MainService;
import egovframework.fusion.main.vo.MenuVO;
import egovframework.fusion.studyRoom.service.StudyRoomService;
import egovframework.fusion.studyRoom.vo.ReservationVO;
import egovframework.fusion.studyRoom.vo.RoomVO;
import egovframework.fusion.studyRoom.vo.SeatVO;
import egovframework.fusion.studyRoom.vo.StudyRoomVO;

@Controller
public class StudyRoomController {

	@Autowired
	StudyRoomService studyRoomService;
	@Autowired
	MainService mainService;

	@ModelAttribute("menuList")
	public List<MenuVO> menuList() {
		System.out.println(mainService.getMenuListModel());
		return mainService.getMenuListModel();
	}

	@RequestMapping(value = "/studyRoom/main.do", method = RequestMethod.GET)
	public String mainPage(HttpServletRequest request, Model model, StudyRoomVO studyRoomVo, HttpSession session) {
		try {
			int menuId = Integer.parseInt(request.getParameter("menuId"));

			StudyRoomVO siteName = studyRoomService.getSiteName(menuId);

			List<RoomVO> roomList = studyRoomService.getRoomList();

			List<StudyRoomVO> studyRoomOffList = studyRoomService.getStudyRoomOffList();
			List<RoomVO> roomOffList=studyRoomService.getRoomOffList();

			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
			DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");

			for (StudyRoomVO room : studyRoomOffList) {
				LocalDateTime Date = LocalDateTime.parse(room.getUpdateDate(), formatter); // 2025
				LocalDateTime open = LocalDateTime.parse(room.getOpenTime(), formatter);
				LocalDateTime close = LocalDateTime.parse(room.getCloseTime(), formatter);

				String dateFormat = Date.format(dateFormatter);
				String openFormat = open.format(timeFormatter);
				String closeFormat = close.format(timeFormatter);

				if (openFormat.equals("00:00:00") && closeFormat.equals("00:00:00")) {
					room.setUpdateInfo(dateFormat);
				} else {
					room.setUpdateInfo(dateFormat + " " + openFormat + "~" + dateFormat + " " + closeFormat);
				}
			}
			

			for (RoomVO room : roomOffList) {
				LocalDateTime Date = LocalDateTime.parse(room.getStartDate(), formatter); // 
				LocalDateTime open = LocalDateTime.parse(room.getStartDate(), formatter);
				LocalDateTime close = LocalDateTime.parse(room.getEndDate(), formatter);

				String dateFormat = Date.format(dateFormatter);
				String openFormat = open.format(timeFormatter);
				String closeFormat = close.format(timeFormatter);
				String closeDateFormat=close.format(dateFormatter);

				if (openFormat.equals("00:00:00") && closeFormat.equals("00:00:00")) {
					room.setUpdateInfo(dateFormat);
				} else {
					room.setUpdateInfo(dateFormat + " " + openFormat + "~" + closeDateFormat + " " + closeFormat);
				}
			}
			

			model.addAttribute("studyRoomInfo", studyRoomOffList);
			model.addAttribute("roomInfo",roomOffList);
			model.addAttribute("roomList", roomList);
			model.addAttribute("siteName", siteName);
			return "tiles/studyRoom/mainPage";
		} catch (Exception e) {
			e.printStackTrace();
			return "tiles/studyRoom/mainPage";
		}

	}

	@RequestMapping(value = "/studyRoom/chkSeat.do", method = RequestMethod.POST)
	public String chkSeat(@RequestParam("selectDate") String selectDate, @RequestParam("roomId") int roomId,
			Model model) {

		try {

			System.out.println("선택한 날짜: " + selectDate);
			List<SeatVO> seatInfo = studyRoomService.getSeatInfo(roomId);
			List<ReservationVO> reservList = studyRoomService.getReservList(roomId, selectDate);

			LocalDateTime now = LocalDateTime.now();
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

			String formatToday = now.format(formatter);
			// String formatSelectDate=selectDate.format(selectDate, formatter);
			LocalDateTime formatSelectDate = LocalDateTime.parse(selectDate + " 00:00:00", formatter);
			System.out.println("ddddddddddddd" + formatSelectDate);

			model.addAttribute("seatInfo", seatInfo);
			model.addAttribute("today", formatToday);
			model.addAttribute("reservList", reservList);
			model.addAttribute("selectDate", formatSelectDate);
			model.addAttribute("selectedDay", selectDate);
			return "views/studyRoom/ajax/seatContainer";

		} catch (Exception e) {
			e.printStackTrace();

			return "redirect:/views/studyRoom/mainPage";
		}

	}

	@RequestMapping(value = "/studyRoom/getSeatInfo.do", method = RequestMethod.POST)
	public String getSeatInfo(@RequestParam("seatId") int seatId, @RequestParam("selectDay") String selectDay,
			Model model, StudyRoomVO studyRoomVo) {
		try {
			System.out.println("selectDate" + selectDay);
			// 해당 날짜의 운영시간
			StudyRoomVO operInfo = studyRoomService.getOperInfo(selectDay);

			// 해당 좌석, 해당 날짜의 예약현황
			List<ReservationVO> reservInfo = studyRoomService.getReservInfo(seatId, selectDay);

			// 해당 좌석 정보
			SeatVO seatInfo = studyRoomService.getSeatOffInfo(seatId);

			System.out.println("운영시간:" + operInfo.getOpenTime() + ", 마감시간:" + operInfo.getCloseTime());
			// 운영시간:2025-02-20 13:00:00, 마감시간:2025-02-20 19:00:00

			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
			DateTimeFormatter timeFormatter2 = DateTimeFormatter.ofPattern("HH:mm:ss");
			// 오픈시간, 마감시간
			LocalDateTime startTime = LocalDateTime.parse(operInfo.getOpenTime(), formatter);
			LocalDateTime endTime = LocalDateTime.parse(operInfo.getCloseTime(), formatter);

			LocalDateTime now = LocalDateTime.now();
			String nowFormat = now.format(dateFormatter);
			LocalDate todayLocal = LocalDate.parse(nowFormat, dateFormatter);

			// selectDay ex)2025-02-20 nowFormat(현재시간 yyyy-mm-dd형태로) 2025-02-20
			if (selectDay.equals(nowFormat)) {
				System.out.println("변환전:" + startTime);
				// 운영시간 vs 현재시간
				// 현재시간이 운영시간보다 지났을경우는 현재시간부터 뜨게
				if (now.isAfter(startTime)) {
					if (now.getMinute() > 0 || now.getSecond() > 0) {
						now = now.plusHours(1).withMinute(0).withSecond(0).withNano(0);
					} else {
						now = now.withSecond(0).withNano(0);
					}
					startTime = now;
				}
				String endTimeFormat = operInfo.getCloseTime().substring(11); // 시간만 잘림
				System.out.println("자르기 전:" + endTime + "자른 후:" + endTimeFormat);
				/* String endTimeFormat=formatDate(operInfo.getCloseTime(),"HH:mm:ss"); */
				LocalTime endLocalTime = LocalTime.parse(endTimeFormat, timeFormatter2);
				endTime = LocalDateTime.of(todayLocal, endLocalTime);
				System.out.println("최종 end" + endTime);

			}

			// 운영시간
			List<String> operTime = new ArrayList<>();
			// select 시간
			List<String> operStart = new ArrayList<>();

			List<String> operEnd = new ArrayList<>();
			// 예약된시간
			List<String> reservList = new ArrayList<>();
			List<String> splitReserv = new ArrayList<>();

			// 예약된시간 반영된 전체 운영시간
			List<Map<String, String>> totalList = new ArrayList<>();

			DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

			// 운영시간 list
			while (startTime.isBefore(endTime)) {
				LocalDateTime nextTime = startTime.plusHours(1);

				if (nextTime.isAfter(endTime)) {

					nextTime = endTime;

				}

				operTime.add(startTime.format(timeFormatter) + " ~ " + nextTime.format(timeFormatter));
				operStart.add(startTime.format(timeFormatter));
				operEnd.add(nextTime.format(timeFormatter));
				startTime = nextTime;
			}

			// 예약된 시간 list
			for (ReservationVO index : reservInfo) {

				// 오픈시간, 마감시간
				LocalDateTime startTime2 = LocalDateTime.parse(index.getStartTime(), formatter);
				LocalDateTime endTime2 = LocalDateTime.parse(index.getEndTime(), formatter);

				while (startTime2.isBefore(endTime2)) {
					LocalDateTime nextTime2 = startTime2.plusHours(1);
					if (nextTime2.isAfter(endTime2)) {
						nextTime2 = endTime2; // 마지막 시간 조정
					}
					reservList.add(startTime2.format(timeFormatter) + " ~ " + nextTime2.format(timeFormatter));
					startTime2 = nextTime2; // 다음 시간으로 이동

				}

			}

			// map 형식으로 예약가능 or 불가능 담기
			for (String oper : operTime) {
				Map<String, String> total = new HashMap<>();
				if (reservList.contains(oper)) {
					total.put("status", "예약불가");
					total.put("time", oper);
				} else {
					total.put("status", "예약가능");
					total.put("time", oper);
				}
				totalList.add(total);
			}
			List<String> modelStart = new ArrayList<>(operStart);

			for (String index : reservList) {
				String first = index.split(" ~ ")[0];
				splitReserv.add(first);
			}

			modelStart.removeAll(splitReserv);

			for (String i : modelStart) {
				System.out.println("남은 시간 : " + i);
			}

			String today = now.format(formatter);

			// 송출용 오픈,마감시간
			LocalDateTime startFormat = LocalDateTime.parse(operInfo.getOpenTime(), formatter);
			LocalDateTime endFormat = LocalDateTime.parse(operInfo.getCloseTime(), formatter);

			System.out.println(totalList);
			ObjectMapper objectMapper = new ObjectMapper();
			String totalListJson = objectMapper.writeValueAsString(totalList);

			LocalDateTime formatSelectDate = LocalDateTime.parse(selectDay + " 00:00:00", formatter);
			System.out.println("dddddddddddddddddd     " + formatSelectDate);

			model.addAttribute("totalListJson", totalListJson);
			model.addAttribute("seatInfo", seatInfo);
			model.addAttribute("openTime", startFormat.format(timeFormatter));
			model.addAttribute("closeTime", endFormat.format(timeFormatter));
			model.addAttribute("selectDay", formatSelectDate);
			model.addAttribute("selectedDay", selectDay);
			model.addAttribute("today", today);
			model.addAttribute("operInfo", operInfo);
			model.addAttribute("totalList", totalList);
			model.addAttribute("operStart", modelStart);
			model.addAttribute("operEnd", operEnd);
			return "views/studyRoom/ajax/ajax_reserv";

		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/views/studyRoom/mainPage";
		}
	}

	@RequestMapping(value = "/studyRoom/insApply.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insApply(@RequestParam("selectReason") String selectReason,
			@RequestParam("startTime") String selectStart, @RequestParam("endTime") String selectEnd,
			@RequestParam("seatId") int seatId, @RequestParam("selectDay") String selectDay, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		try {
			String userId = (String) session.getAttribute("userId");
			System.out.println("userId:" + userId);
			int result=studyRoomService.insertReservation(seatId, selectReason, selectDay, selectStart, selectEnd, userId);
			
			if(result==0) {
				response.put("success", true);
				response.put("message", "이미 예약된 좌석입니다");
				return response;
			}else {				
				response.put("success", true);
				response.put("message", "신청완료되었습니다");
				return response;
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.put("fail", false);
			response.put("message", "오류발생");
			return response;
		}

	}

	@RequestMapping(value = "/studyRoom/getReservList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getMyReserv(HttpSession session) {

		Map<String, Object> response = new HashMap<>();
		try {
			String userId = (String) session.getAttribute("userId");
			System.out.println("userId:" + userId);
			List<ReservationVO> myReservList = studyRoomService.getMyReserv(userId);

			for (ReservationVO reserv : myReservList) {
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

				LocalDateTime date = LocalDateTime.parse(reserv.getReservDate(), formatter);
				LocalDateTime startTime = LocalDateTime.parse(reserv.getStartTime(), formatter);
				LocalDateTime endTime = LocalDateTime.parse(reserv.getEndTime(), formatter);
				DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

				reserv.setReservDate(date.format(dateFormatter));
				reserv.setStartTime(startTime.format(timeFormatter));
				reserv.setEndTime(endTime.format(timeFormatter));

				System.out.println("1111" + reserv);
			}

			response.put("list", myReservList);
			response.put("success", true);
			response.put("message", "신청완료");
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			response.put("fail", false);
			response.put("message", "오류발생");
			return response;
		}
	}

	@RequestMapping(value = "/studyRoom/cancelReserv.do", method = RequestMethod.POST)
	@ResponseBody
	public void cancelReserv(@RequestParam("reservId") int reservId) {
		try {
			studyRoomService.cancelReserv(reservId);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/studyRoom/offRoom.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> offRoom(@RequestParam("selectDay") String selectDay) {
		Map<String, Object> response = new HashMap<>();
		try {
			List<RoomVO> offRoomList=studyRoomService.offRoom(selectDay);
			
			response.put("offRoomList",offRoomList);
			response.put("message","조회성공");
			return response;
		} catch (Exception e) {
			response.put("message","조회실패");
			return response;
		}
	}

	
	@RequestMapping(value="/studyRoom/managementPage.do",method=RequestMethod.GET)
	public String managementPage(Model model) {
		
		List<RoomVO> roomList = studyRoomService.getRoomList();
		
		
		model.addAttribute("roomList",roomList);
		return "views/studyRoom/managementPage";
	}
	
	@RequestMapping(value="/studyRoom/getSeat.do", method=RequestMethod.POST)
	public String getSeat(Model model, @RequestParam("roomId")int roomId) {
		try {
			List<SeatVO> seatList=studyRoomService.getSeatInfo(roomId);
			
			model.addAttribute("seatList",seatList);
			return "views/studyRoom/ajax/mangementSeat";
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	@RequestMapping(value="/studyRoom/addSeat.do",method=RequestMethod.POST)
	@ResponseBody
	public void addSeat(@RequestParam("roomLocation")int roomLocation, @RequestParam("roomId") int roomId) {
		try {
			studyRoomService.insSeat(roomLocation,roomId);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="/studyRoom/updStudyRoom.do",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> updStudyRoom (@RequestParam("selectStart")String selectStart,
			@RequestParam("selectEnd")String selectEnd, @RequestParam("selectDay") String selectDay,
			@RequestParam("reason")String reason){
			Map<String,String> response=new HashMap<>();
			System.out.println("날짜:"+selectDay+"  , 시작날짜:"+selectStart+"    ,종료날짜:"+selectEnd);
		try {
			
			studyRoomService.updStudyRoom(selectStart,selectEnd,selectDay,reason);
			
			
			response.put("message",selectStart+" ~ "+selectEnd+" 독서실 운영변경완료");
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			response.put("message","오류발생");
			return response;
		}
	}

};