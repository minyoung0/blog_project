package egovframework.fusion.progressBoard.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import egovframework.fusion.main.service.MainService;
import egovframework.fusion.main.vo.MenuVO;
import egovframework.fusion.progressBoard.service.ProgressBoardService;
import egovframework.fusion.progressBoard.vo.ProgressBoardVO;
import egovframework.fusion.progressBoard.vo.ProgressResponseVO;
import egovframework.fusion.user.vo.UserVO;

@Controller
public class ProgressBoardController {

	@Autowired
	MainService mainService;

	@Autowired
	ProgressBoardService progressBoardService;

	@ModelAttribute("menuList")
	public List<MenuVO> menuList() {
		System.out.println(mainService.getMenuListModel());
		return mainService.getMenuListModel();
	}

	// (진행단계)게시판 이동
	@RequestMapping(value = "/progress/progressMain.do", method = RequestMethod.GET)
	public String progressMainPage(Model model,
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "limit", required = false, defaultValue = "5") int limit,
			@RequestParam(value="menuId") int menuId2,ProgressBoardVO progressBoardVO, HttpServletRequest request,HttpSession session) {
		try {
			Object userAccessObject = session.getAttribute("accessRight");
			String userAccess= String.valueOf(userAccessObject); 
			String userId = (String) session.getAttribute("userId");
			
			String menuIdString = request.getParameter("menuId");
			int menuId = Integer.parseInt(menuIdString);


			int startRow = (page - 1) * limit;

			progressBoardVO.setLimit(limit);
			progressBoardVO.setStartRow(startRow);
			progressBoardVO.setUserId(userId);
			progressBoardVO.setUserAccess(userAccess);
			progressBoardVO.setMenuId(menuId);
			int totalCount=progressBoardService.countBoard(progressBoardVO);
			int totalPage = (int) Math.ceil((double) totalCount / limit);
			List<ProgressBoardVO> boardListWithPaging = progressBoardService.getBoardListWithPaging(progressBoardVO);

			for (ProgressBoardVO board : boardListWithPaging) {
				//날짜 yyyy/mm/dd 형태 format
				String test = formatDate(board.getBoardCreateAt());
				board.setBoardCreateAt(test);
				// boardID당 최신 글 정보 
				ProgressBoardVO latestBoardDetail=progressBoardService.latestBoard(board.getBoardId());
				board.setSubCodeName(latestBoardDetail.getSubCodeName());
				//boardId당 최대 ref
				int maxRef=progressBoardService.getMaxRef(board.getBoardId());
				board.setMaxRef(maxRef);
			}
			
			model.addAttribute("menuId", menuId);
			model.addAttribute("count", totalCount);
			model.addAttribute("totalPage", totalPage);
			model.addAttribute("currentPage", page);
			model.addAttribute("selectedLimit", limit);
			model.addAttribute("boardList", boardListWithPaging);
			return "tiles/progressBoard/progressBoardMain";
		}catch(Exception e) {
			e.printStackTrace();
			return "tiles/progressBoard/progressBoardMain";
		}
	
	}

	//등록페이지
	@RequestMapping(value = "/progress/progressRegister.do", method = RequestMethod.GET)
	public String progressRegisterPate(Model model, HttpServletRequest request) {
		String menuIdString = request.getParameter("menuId");
		int menuId = Integer.parseInt(menuIdString);
		System.out.println("dsfsdfsfs" + menuIdString);

		List<UserVO> adminList = mainService.getAdminList();
		model.addAttribute("menuId", menuId);
		model.addAttribute("adminList", adminList);
		return "views/progressBoard/progressBoardRegister";
	}

	//등록
	@RequestMapping(value = "/progress/insBoard.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insBoard(@RequestParam("boardTitle") String title,
			@RequestParam("boardContent") String content, @RequestParam("adminId") String admin,
			@RequestParam("menuId") int menuId, HttpSession session, HttpServletRequest request) {
		String userId = (String) session.getAttribute("userId");
		System.out.println("insBoard MenuId" + menuId);
		System.out.println("insBoard");
		System.out.println("제목:" + title + ",내용:" + content + ",관리자:" + admin + "사용자:" + userId);
		Map<String, Object> response = new HashMap<>();
		try {
			if (title.length() > 500) {
				response.put("fail", false);
				response.put("message", "내용은 500자까지 가능합니다");
				return response;
			}
			if (title.equals("")) {
				response.put("fail", false);
				response.put("message", "제목을 입력해주세요");
				return response;
			}
			if (content.equals("")) {
				response.put("fail", false);
				response.put("message", "내용을 입력해주세요");
				return response;
			}

			progressBoardService.insBoardProgress(title, content, admin, userId, menuId);
			ProgressBoardVO board= progressBoardService.getLatestBoardByUserId(userId);
			response.put("boardId",board.getBoardId());
			response.put("success", true);
			response.put("message", "신청완료");
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "오류 발생");
			return response;
		}
	}

	// 상세보기
	@RequestMapping(value = "/progress/progredssBoardDetail.do", method = RequestMethod.GET)
	public String boardDetail(ProgressBoardVO progressBoardVO, HttpServletRequest request, Model model) {
		try {
			String board = request.getParameter("boardId");
			String menu = request.getParameter("menuId");
			System.out.println("boardId:" + board);
			int boardId = Integer.parseInt(board);
			int menuId = Integer.parseInt(menu);
			
			//해당 메뉴 아이디 글 가져오기
			ProgressBoardVO menuDetail = progressBoardService.getMenuDetail(boardId);
			
			//최신 글 1개
			ProgressBoardVO latestBoard = progressBoardService.latestBoard(boardId);
			
			//최신 글 보드 아이디
			int latestBoardId=latestBoard.getBoardId();
			
			//해당 아이디 응답 가져오기 
			ProgressResponseVO response= progressBoardService.getResponse(latestBoardId);
			
			//첫 글에 대한 응답
			ProgressResponseVO firstResponse = progressBoardService.getResponse(boardId);
			//maxRef
			int maxRef=progressBoardService.getMaxRef(boardId);
			
			menuDetail.setBoardCreateAt(formatDate(menuDetail.getBoardCreateAt()));
			latestBoard.setBoardCreateAt(formatDate(latestBoard.getBoardCreateAt()));
			if(latestBoard.getBoardUpdateAt() != null) {				
				latestBoard.setBoardUpdateAt(formatDate(latestBoard.getBoardUpdateAt()));
			}
			model.addAttribute("firstBoardId", boardId);
			model.addAttribute("menuDetail",latestBoard); 
			model.addAttribute("firstBoard",menuDetail);
			model.addAttribute("response",response);
			model.addAttribute("firstResponse",firstResponse);
			model.addAttribute("menuId", menuId);
			model.addAttribute("maxRef",maxRef);
			//model.addAttribute("latestBoard",latestBoard);
			return "views/progressBoard/progressBoardDetail";
		} catch (Exception e) {
			e.printStackTrace();
			return "views/progressBoard/progressBoardDetail";
		}

	}

	// 수정하기 페이지
	@RequestMapping(value = "/progress/progressBoardModify.do", method = RequestMethod.GET)
	public String boardModifyPage(Model model, HttpServletRequest request) {
		try {
			int boardId = Integer.parseInt(request.getParameter("boardId"));
			int menuId = Integer.parseInt(request.getParameter("menuId"));
			int firstBoardId=Integer.parseInt(request.getParameter("firstBoardId"));
			ProgressBoardVO menuDetail = progressBoardService.getMenuDetail(boardId);
			
			int maxRef=progressBoardService.getMaxRef(firstBoardId);

			model.addAttribute("menuId", menuId);
			model.addAttribute("boardId", boardId);
			model.addAttribute("menuDetail", menuDetail);
			model.addAttribute("maxRef",maxRef);
			return "views/progressBoard/progressBoardModify";
		} catch (Exception e) {
			e.printStackTrace();
			return "views/progressBoard/progressBoardModify";
		}
	}

	// 수정하기
	@RequestMapping(value = "/progress/modifyBoard.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> modifyBoard(@RequestParam("boardTitle") String title,
			@RequestParam("boardContent") String content, @RequestParam("menuId") int menuId,
			@RequestParam("boardId") int boardId, HttpSession session, HttpServletRequest request) {
		String userId = (String) session.getAttribute("userId");

		
		Map<String, Object> response = new HashMap<>();
		try {
			if (title.length() > 500) {
				response.put("fail", false);
				response.put("message", "500자까지 가능합니다");
				return response;
			}
			if (content.equals("")) {
				response.put("fail", false);
				response.put("message", "내용을 입력해주세요");
				return response;
			}

			progressBoardService.modifyProgressBoard(title, content, boardId);
			response.put("success", true);
			response.put("message", "신청완료");
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "오류 발생");
			return response;
		}
	}

	// 이의제기
	@RequestMapping(value = "/progress/insObjection.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insObjection(
			@RequestParam("boardContent") String content, @RequestParam("menuId") int menuId,
			@RequestParam("boardId") int boardId,@RequestParam("adminId")String adminId,
			@RequestParam("firstBoardId") String firstBoardId,HttpSession session, HttpServletRequest request) {
		
		String userId = (String) session.getAttribute("userId");
		System.out.println("insBoard MenuId" + menuId);
		System.out.println("insBoard");
		System.out.println(",내용:" + content + ",관리자:" + adminId + "사용자:" + userId);
		int boardId2=Integer.parseInt(firstBoardId);
		Map<String, Object> response = new HashMap<>();
		int maxRef=progressBoardService.getMaxRef(boardId2);
		System.out.println("maxRef:"+maxRef);
		try {
			if(maxRef>2) {
				response.put("fail", false);
				response.put("message", "이의제기는 3번만 신청할 수 있습니다");
				return response;
			}
			String title="";
			String code="objection";
			//언글 boardId
			System.out.println("원글 아이디 "+firstBoardId);
			
			progressBoardService.insObjection(title, content, adminId, userId, menuId,boardId2);
			progressBoardService.updateProgressCode(code,boardId);
			response.put("success", true);
			response.put("message", "신청완료");
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "오류 발생");
			return response;
		}

	}
	
	//승인 및 반려
	
	@RequestMapping(value="/progress/response.do",method=RequestMethod.GET)
	@ResponseBody
	public Map<String,Object> admission(@RequestParam("boardId")int boardId,@RequestParam("code")String code,@RequestParam("content")String progressContent,
			@RequestParam("adminId")String adminId, @RequestParam("firstBoardId")String firstBoardId){
		Map<String, Object> response = new HashMap<>();
			
		try {
			
			int boardId2=Integer.parseInt(firstBoardId);
			int maxRef=progressBoardService.getMaxRef(boardId2);
			System.out.println("firstBoardId"+boardId2);
			System.out.println("이 아이디의 maxRef"+maxRef);
			System.out.println("boardId:"+boardId+",코드:"+code+",content:"+progressContent);
				if(maxRef==3) {
					if(code.equals("admission")) {
						code="admission";
					}else {						
						code="finalAdmission";
					}
				}
				
			
			//원글 progress_code 검토완료 or 최종으로 변경
			progressBoardService.updateProgressCode(code,boardId);
			//progress_response 등록
			progressBoardService.insProgressResponse(code,boardId,progressContent,adminId);
			response.put("success", true);
			response.put("message", "승인완료");
			return response;
		}catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "오류 발생");
			return response;
		}
	}
	
	//이력조회
	@RequestMapping(value="/progress/getTotalBoard.do",method=RequestMethod.GET)
	public String finalTotalPage(Model model,HttpServletRequest request,HttpSession session) {
		String firstBoardId=(String)request.getParameter("boardId");
		int boardId=Integer.parseInt(firstBoardId);
		System.out.println("첫번째 보드 아이디: "+firstBoardId);
		
		List<ProgressResponseVO> totalResponse=new ArrayList();
		
		//전체 게시글 
		List<ProgressBoardVO> totalBoard=  progressBoardService.totalBoard(boardId);
		
		for (ProgressBoardVO board : totalBoard) {
			String test = formatDate(board.getBoardCreateAt());
			board.setBoardCreateAt(test);
			
			if(board.getBoardUpdateAt()!=null) {
				board.setBoardUpdateAt(formatDate(board.getBoardUpdateAt()));
			}
			
			int id=board.getBoardId();
			System.out.println("이 페이지에 가져와야될 response id"+id);
			totalResponse.add(progressBoardService.getResponse(id));
		}
		
		ProgressBoardVO firstBoard=progressBoardService.getMenuDetail(boardId);
		
		String firstBoardCreateAt=formatDate2(firstBoard.getBoardCreateAt());
		System.out.println("pdf"+firstBoardCreateAt);
		//전체 응답 
		
		int boardSize=totalBoard.size();
		model.addAttribute("boardId",boardId);
		model.addAttribute("total",totalBoard);
		model.addAttribute("totalSize",boardSize);
		model.addAttribute("totalResponse",totalResponse);
		model.addAttribute("firstBoard",firstBoard);
		model.addAttribute("formatDate",firstBoardCreateAt);
		return "/views/progressBoard/progressTotalPage";
	}
	
	//이의제기 내용 수정
	@RequestMapping(value="/progress/modiComReason.do",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> modiComReason(@RequestParam("responseId")String id, @RequestParam("responseContent")String responseContent){
	
		Map<String, Object> response = new HashMap<>();
		try {
			int responseId=Integer.parseInt(id);
			
			progressBoardService.modiComReason(responseId,responseContent);
			
			response.put("success", true);
			response.put("message", "수정완료");
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "오류 발생");
			return response;
		}
		
	}
	

	public String formatDate(String date) {
		DateTimeFormatter inputFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
		DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm");

		LocalDateTime dateTime = LocalDateTime.parse(date, inputFormat);
		String formattedDate = dateTime.format(dateFormat);
		return formattedDate;
	}
	
	public String formatDate2(String date) {
		DateTimeFormatter inputFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
		
		DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("yyMMdd");

		LocalDateTime dateTime = LocalDateTime.parse(date, inputFormat);
		String formattedDate = dateTime.format(dateFormat);
		return formattedDate;
	}

}
