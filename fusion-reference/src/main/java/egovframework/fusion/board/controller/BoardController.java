/*********************************************************
 * 업 무 명 : 게시판 컨트롤러
 * 설 명 : 게시판을 조회하는 화면에서 사용 
 * 작 성 자 : 김민규
 * 작 성 일 : 2022.10.06
 * 관련테이블 : 
 * Copyright ⓒ fusionsoft.co.kr
 *
 *********************************************************/
package egovframework.fusion.board.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.fusion.board.service.BoardService;
import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.comment.service.CommentService;
import egovframework.fusion.comment.vo.CommentVO;
import egovframework.fusion.gallery.service.GalleryService;
import egovframework.fusion.main.service.MainService;
import egovframework.fusion.main.vo.MenuVO;
import egovframework.fusion.user.vo.UserVO;

@Controller
public class BoardController {

	@Autowired
	BoardService boardService;
	@Autowired
	CommentService commentService;
	@Autowired
	GalleryService galleryService;

	@Autowired
	MainService mainService;

	@ModelAttribute("menuList")
	public List<MenuVO> menuList() {
		return mainService.getMenuListModel();
	}

	@RequestMapping(value = "/board/boardList.do", method = RequestMethod.GET)
	public String boardList(@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "limit", required = false, defaultValue = "10") int limit, BoardVO boardVO,
			Model model, MenuVO menuVO, HttpServletRequest request, Object handler,HttpSession session) {

		try {
			String RequestMenuId=request.getParameter("menuId");
			int menuId = Integer.parseInt(RequestMenuId);
			System.out.println("메뉴아이디" + menuId);


			// 전체 게시물 개수
			/* int totalCount = boardService.getTotalBoardCount(); */
			int totalCount = boardService.getTotalBoardCount(menuId);

			int totalPage = (int) Math.ceil((double) totalCount / limit);

			// 페이징 처리
			int startRow = (page - 1) * limit;
			boardVO.setStartRow(startRow);
			boardVO.setLimit(limit);
			boardVO.setMenuId(menuId);
			System.out.println(startRow + "," + limit);
			
			Object userAccess = session.getAttribute("accessRight");
			System.out.println("사용자 권한:"+userAccess);
			// 게시물 리스트 가져오기
			boardVO.setLimit(limit);
			List<BoardVO> boardList = boardService.getBoardListWithPaging(boardVO);

			// 팝업 게시물 리스트 가져오기
			List<BoardVO> popupBoards = boardService.getPopupBoards();

			model.addAttribute("menuId", menuId);
			model.addAttribute("boardList", boardList);
			model.addAttribute("popupBoards", popupBoards);
			model.addAttribute("selectedLimit", limit);
			model.addAttribute("totalPage", totalPage);
			model.addAttribute("currentPage", page);
			model.addAttribute("totalCount", totalCount);
			 model.addAttribute("userAccess",userAccess); 

		} catch (Exception e) {
			e.printStackTrace();
		}

		/* return "views/board/boardList"; */
		return "tiles/board/boardList";
	}

	/*
	 * 게시글 등록 페이지 이동
	 * 
	 */
	@RequestMapping(value = "/board/boardRegister.do", method = RequestMethod.GET)
	public String boardRegister(BoardVO boardVO, Model model,HttpServletRequest request) {
		String RequestMenuId=request.getParameter("menuId");
		int menuId = Integer.parseInt(RequestMenuId);
		System.out.println("메뉴아이디" + menuId);
		
		model.addAttribute("menuId",menuId);
		
		return "views/board/boardRegister";
	}

	/*
	 * 게시글 등록
	 * 
	 */
	@RequestMapping(value = "/board/insBoardPost.do", method = RequestMethod.POST)
	public String insBoardPost(@ModelAttribute BoardVO boardVO, HttpSession session, Model model,
			HttpServletRequest request) {
		String userId = (String) session.getAttribute("userId");
		String RequestMenuId = request.getParameter("menuId");
		int menuId = Integer.parseInt(RequestMenuId);
		System.out.println("메뉴아이디" + menuId);
		System.out.println(((Object)menuId).getClass().getSimpleName());
		
		if (boardVO.getParentBoardId() == null) {
			boardVO.setParentBoardId(0); // 최상위 게시글의 parentBoardId를 0으로 설정
		}
		if (boardVO.getPopupYn() == null) {
//			System.out.println("popupYn 값: " + boardVO.getPopupYn());
			boardVO.setPopupYn(0);
		}
		try {
			boardVO.setUserId(userId);
			boardVO.setMenuId(menuId);
			boardService.insBoardPost(boardVO);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "redirect:/board/boardList.do?menuId="+boardVO.getMenuId();
	}

	@RequestMapping(value = "/board/addReplyBoard.do", method = RequestMethod.POST)
	public String addReply(BoardVO boardVO, HttpSession session, RedirectAttributes redirectAttributes,HttpServletRequest request) {
		try {
			String RequestMenuId = request.getParameter("menuId");
			int menuId = Integer.parseInt(RequestMenuId);
			System.out.println("add Reply 메뉴아이디" + menuId);
			
			// 로그인 사용자 ID 가져오기
			String userId = (String) session.getAttribute("userId");

			// 사용자 ID 설정
			boardVO.setUserId(userId);
			boardVO.setMenuId(menuId);

			// 답글 추가 로직 실행
			boardService.addReplyBoard(boardVO);

			// 성공 메시지
			redirectAttributes.addFlashAttribute("message", "답글이 성공적으로 등록되었습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("message", "답글 등록 중 오류가 발생했습니다.");
		}

		// 답글 작성 후 원래 게시물로 리다이렉트
		return "redirect:/board/boardPost.do?boardId=" + boardVO.getParentBoardId()+"&menuId="+boardVO.getMenuId();
	}

	/*
	 * 게시글 조회
	 * 
	 * @param
	 * 
	 * @return
	 * 
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/boardPost.do", method = RequestMethod.GET)
	public String boardPost(@RequestParam("boardId") int boardId, HttpSession session, BoardVO boardVO, Model model,HttpServletRequest request) {

		UserVO loggedInUser = (UserVO) session.getAttribute("loggedInUser");
		String userId = loggedInUser != null ? loggedInUser.getUserId() : "guest";
		
		String RequestMenuId= request.getParameter("menuId");
		int menuId = Integer.parseInt(RequestMenuId);
		System.out.println("boardPost menuId:"+RequestMenuId);

		try {
			boardVO.setBoardId(boardId);
			boardVO.setMenuId(menuId);

			// 조회수 업데이트
//			boardService.updBoardCnt(boardId, userId);

			if(userId!=null) {
				boolean isViewCountIncreased = galleryService.increaseViewCount(boardId, userId);
				model.addAttribute("viewCountIncreased", isViewCountIncreased); 
			
			}
			
			// 게시글 상세 정보 가져오기
			BoardVO boardPost = boardService.getBoardPost(boardVO);
			System.out.println("boardPost.parentBoardId: " + boardPost.getParentBoardId());

			if (boardPost.getParentBoardId() == 0) {
				boardPost.setParentBoardId(boardPost.getBoardId());
			}

			// 현재 로그인한 사용자의 id 가져오기
			String loggedInUserId = (String) session.getAttribute("userId");

			// 댓글 조회 추가
			List<CommentVO> comments = commentService.getCommentsByBoardId(boardId);

			model.addAttribute("comments", comments);
			model.addAttribute("boardPost", boardPost);
			model.addAttribute("loggedInUserId", loggedInUserId);
			model.addAttribute("parentBoardId", boardPost.getParentBoardId());
			model.addAttribute("menuId",boardVO.getMenuId());

			System.out.println("boardPost.userId: " + boardPost.getUserId());
			System.out.println("loggedInUserId: " + loggedInUserId);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return "views/board/boardPost";
	}

	/*
	 * 게시글 수정 페이지 진입
	 * 
	 * @param
	 * 
	 * @return
	 * 
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/boardPostModify.do", method = RequestMethod.GET)
	public String boardPostModify(BoardVO boardVO, Model model,HttpServletRequest request) {

		try {
			BoardVO boardPost = boardService.getBoardPost(boardVO);
			String RequestMenuId=request.getParameter("menuId");
			int menuId=Integer.parseInt(RequestMenuId);
			
			
			model.addAttribute("menuId",menuId);
			model.addAttribute("boardPost", boardPost);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "views/board/boardPostModify";
	}

	/*
	 * 게시글 수정
	 * 
	 * @param
	 * 
	 * @return
	 * 
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/updBoardPost.do", method = RequestMethod.POST)
	public String updBoardPost(BoardVO boardVO,HttpServletRequest request,Model model) {

		try {
			  String RequestMenuId=request.getParameter("menuId"); 
			  int menuId =Integer.parseInt(RequestMenuId); 
			  System.out.println("메뉴아이디디디디디:" + menuId);
			  boardVO.setMenuId(menuId);
			 
			boardService.updBoardPost(boardVO);
			/* model.addAttribute("menuId",menuId); */
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "redirect:/board/boardPost.do?boardId=" + boardVO.getBoardId()+"&menuId="+boardVO.getMenuId();
		
	}

	/*
	 * 게시글 삭제
	 * 
	 * @param
	 * 
	 * @return
	 * 
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/delBoardPost.do", method = RequestMethod.GET)
	public String delBoardPost(BoardVO boardVO, Model model) {

		try {
			boardService.delBoardPost(boardVO);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "redirect:/board/boardList.do?menuId="+boardVO.getMenuId();
	}

	@RequestMapping(value = "/board/searchBoard.do", method = RequestMethod.GET)
	public String searchBoard(@RequestParam(value = "searchType", required = false) String searchType,
			@RequestParam(value = "keyword", required = false) String keyword, Model model) {
		System.out.println("searchType: " + searchType);
		System.out.println("keyword: " + keyword);
		try {
			if (keyword == null || keyword.trim().isEmpty()) {
				// 검색어가 없을 경우 기본 리스트 반환
				return "redirect:/board/boardList.do";
			}
			List<BoardVO> boardList = boardService.searchBoard(searchType, keyword);
			model.addAttribute("boardList", boardList);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "views/board/boardList";
	}

	@RequestMapping(value = "/board/checkDelBoard.do", method = RequestMethod.POST)
	public String checkDelBoard(@RequestParam("boardIds") List<Integer> boardIds,BoardVO boardVO) {
		try {
			System.out.println("Board IDs: " + boardIds);
			System.out.println(boardVO.getMenuId());
			// 삭제 서비스 호출
			boardService.checkDelBoard(boardIds);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/board/boardList.do?menuId="+boardVO.getMenuId();
	}

	@RequestMapping(value = "/board/boardReplyForm.do", method = RequestMethod.GET)
	public String boardReplyForm(@RequestParam(value = "parentBoardId", required = true) Integer parentBoardId,
			Model model,HttpServletRequest request) {
		String RequestMenuId= request.getParameter("menuId");
		int menuId = Integer.parseInt(RequestMenuId);
		System.out.println("addReply menuId:"+RequestMenuId);
		
		System.out.println("Received parentBoardId: " + parentBoardId);
		
		model.addAttribute("menuId",menuId);
		model.addAttribute("parentBoardId", parentBoardId);
		return "views/board/boardReplyForm";
	}

}
