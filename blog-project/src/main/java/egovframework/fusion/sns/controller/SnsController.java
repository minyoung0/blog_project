package egovframework.fusion.sns.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import egovframework.fusion.board.service.BoardService;
import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.comment.service.CommentService;
import egovframework.fusion.comment.vo.CommentVO;
import egovframework.fusion.gallery.vo.FileVO;
import egovframework.fusion.sns.service.SnsService;
import egovframework.fusion.sns.vo.FollowVO;

@Controller
public class SnsController {

	@Autowired
	BoardService boardService;

	@Autowired
	SnsService snsService;

	@Autowired
	CommentService commentService;

	@RequestMapping(value = "/sns/snsMainPage.do", method = RequestMethod.GET)
	public String snsMainPage(Model model, HttpServletRequest request, HttpSession session) {
		String RequestMenuId = request.getParameter("menuId");
		String userId = (String) session.getAttribute("userId");

		System.out.println("메뉴아이디" + RequestMenuId);

		model.addAttribute("menuId", RequestMenuId);
		model.addAttribute("userId" + userId);
		return "views/sns/snsMain";
	}

	@RequestMapping(value = "/sns/insBoardPost.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> snsInsBoard(@RequestParam("menuId") int menuId, @RequestParam("title") String title,
			@RequestParam("content") String content,
			@RequestParam(value = "files", required = false) MultipartFile[] files, BoardVO boardVO,
			HttpSession session, HttpServletRequest request) {

		try {

			String userId = (String) session.getAttribute("userId");
			boardVO.setUserId(userId);
			System.out.println("파일:" + files);
			System.out.println("제목: " + title);
			System.out.println("내용: " + content);

			if (userId == null) {
				Map<String, Object> response = new HashMap<>();
				response.put("success", false);
				response.put("message", "로그인 후 다시 시도해주십시오");
				return response;
			}

			// 제목 길이 공백 포함 30자 미만 & 내용 500자미만
			if (title.length() > 30) {
				Map<String, Object> response = new HashMap<>();
				response.put("success", false);
				response.put("message", "제목은 30자까지 가능합니다");
				return response;
			}

			if (content.length() > 100) {
				Map<String, Object> response = new HashMap<>();
				response.put("success", false);
				response.put("message", "내용은 100자까지 가능합니다");
				return response;
			}

			if (files != null) {
				// 파일 처리
				List<FileVO> fileVOList = new ArrayList<>();
				int maxFiles = 3; // 파일 개수 제한
				long maxFileSize = 5 * 1024 * 1024; // 파일 크기 제한 (2MB)
				List<String> Extension = Arrays.asList("txt", "pdf"); // 허용 확장자 목록

				if (files.length > maxFiles) {
					/* throw new RuntimeException("파일은 최대 " + maxFiles + "개까지만 업로드할 수 있습니다."); */
					Map<String, Object> response = new HashMap<>();
					response.put("success", false);
					response.put("message", "파일은 최대 " + maxFiles + "개까지만 업로드할 수 있습니다.");
					return response;
				}

				for (MultipartFile file : files) {
					if (!file.isEmpty()) {
						String originalFilename = file.getOriginalFilename();
						String fileExtension = originalFilename.substring(originalFilename.lastIndexOf(".") + 1)
								.toLowerCase();

						// 파일 확장자 검사
						if (!Extension.contains(fileExtension)) {
							Map<String, Object> response = new HashMap<>();
							response.put("success", false);
							response.put("message", ".txt, .png만 첨부가능합니다. 확인 후 다시 시도해주십시오.");
							return response;
						}

						// 파일 크기 검사
						if (file.getSize() > maxFileSize) {
							Map<String, Object> response = new HashMap<>();
							response.put("success", false);
							response.put("message", "파일 크기는 5MB를 초과할 수 없습니다: " + originalFilename);
							return response;

						}

						// 파일 저장 경로
						String uploadDir = "C:/eGovFrameDev-4.0.0-64bit/workspace/fusion-reference/src/main/resources/imgfolder/";
						String storedFileName = UUID.randomUUID() + "_" + originalFilename;
						String filePath = uploadDir + storedFileName;
						String relativePath = "/imgfolder/" + storedFileName;

						System.out.println("originalFileName: " + originalFilename);

						// 파일 저장
						File dest = new File(filePath);
						file.transferTo(dest);

						// FileVO 생성
						FileVO fileVO = new FileVO();
						fileVO.setOriginalName(originalFilename);
						fileVO.setStoredName(storedFileName);
						fileVO.setFilePath(relativePath);
						fileVOList.add(fileVO);
					}
				}

				boardVO.setBoardTitle(title);
				boardVO.setBoardContent(content);
				boardVO.setMenuId(menuId);
				snsService.savePost(boardVO, fileVOList);
				Map<String, Object> response = new HashMap<>();
				response.put("success", true);
				return response;
			} else {

				boardVO.setBoardTitle(title);
				boardVO.setBoardContent(content);
				boardVO.setMenuId(menuId);
				snsService.savePostWithOutFiles(boardVO);

				Map<String, Object> response = new HashMap<>();
				response.put("success", true);
				return response;
			}

		} catch (Exception e) {
			e.printStackTrace();
			Map<String, Object> response = new HashMap<>();
			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다.");
			return response;
		}

	}

	@RequestMapping(value = "/sns/getBoardList.do", method = RequestMethod.GET)
	@ResponseBody
	public List<Map<String, Object>> getBoardList(BoardVO boardVO, @Param("page") int page, @Param("size") int size) {

		try { // 게시글 목록 조회 로직 (예: DB 조회)
			List<BoardVO> boardList = snsService.getBoardList(page, size);

			List<Map<String, Object>> response = new ArrayList<>();

			for (BoardVO board : boardList) {
				Map<String, Object> post = new HashMap<>();
				post.put("title", board.getBoardTitle());
				post.put("content", board.getBoardContent());
				post.put("user", board.getUserName());
				post.put("boardId", board.getBoardId());
				post.put("scrapOriginalUser", board.getScrapFromUserId());

				// 파일 목록 추가
				List<FileVO> files = snsService.getFilesByBoardId(board.getBoardId());
				List<Map<String, Object>> fileList = new ArrayList<>();
				for (FileVO file : files) {
					fileList.add(Map.of("originalName", file.getOriginalName(), "filePath", file.getFilePath()));
				}
				post.put("files", fileList);

				response.add(post);
			}
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			return Collections.emptyList();
		}

	}

	@RequestMapping(value = "/sns/addComment.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> snsInsComment(@RequestBody Map<String, Object> requestData, CommentVO commentVO) {
		Integer boardId = (Integer) requestData.get("boardId");
		String comment = (String) requestData.get("text");
		String userId = (String) requestData.get("userId");
		System.out.println("게시글 아이디:" + boardId + "댓글:" + comment + "작성자 이름:" + userId);

		String userAccessRight = snsService.getUserAccessRight(userId);

		try {
			commentVO.setUserId(userId);
			commentVO.setBoardId(boardId);
			commentVO.setCommentContent(comment);
			commentVO.setCommentRef(0);
			commentVO.setCommentSeq(0);

			commentService.addComment(commentVO);

			Map<String, Object> response = new HashMap<>();
			response.put("success", true);
			response.put("userAccess", userAccessRight);
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			Map<String, Object> response = new HashMap<>();
			response.put("error", false);
			return response;
		}
	}

	@RequestMapping(value = "/sns/getComments.do", method = RequestMethod.GET)
	public String getCommentList(CommentVO commentVO, @RequestParam("boardId") int boardId, Model model) {
		System.out.println("게시글 아이디ㅇㅇㅇㅇㅇ:" + boardId);
		try {
			// 게시글 목록 조회 로직 (예: DB 조회)
			List<CommentVO> commentList = snsService.getCommentById(boardId);

			model.addAttribute("commentList", commentList);
			return "views/sns/ajax_comment";

		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/views/sns/snsMainPage.do";
		}

	}

	// 게시글 삭제
	@RequestMapping(value = "/sns/deleteBoard.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteBoard(@RequestParam("boardId") int boardId) {
		System.out.println("삭제하려는 게시글 아이디:" + boardId);
		try {
			snsService.deleteBoard(boardId);

			Map<String, Object> response = new HashMap<>();
			response.put("success", true);

			return response;
		} catch (Exception e) {
			e.printStackTrace();

			Map<String, Object> response = new HashMap<>();
			response.put("error", false);

			return response;
		}
	}

	// 댓글 삭제
	@RequestMapping(value = "/sns/deleteComment.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteComment(@RequestParam("commentId") int commentId) {
		System.out.println("삭제하려는 댓글 아이디:" + commentId);
		try {
			snsService.deleteComment(commentId);

			Map<String, Object> response = new HashMap<>();
			response.put("success", true);

			return response;
		} catch (Exception e) {
			e.printStackTrace();

			Map<String, Object> response = new HashMap<>();
			response.put("error", false);

			return response;
		}
	}

	// 수정- 게시글 정보가져오기
	@RequestMapping(value = "/sns/getBoardDetail.do", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getBoardDetail(@RequestParam("boardId") int boardId, BoardVO boardVO) {
		try {

			List<BoardVO> boardList = snsService.getBoardDetail(boardId);

			Map<String, Object> response = new HashMap<>();

			for (BoardVO board : boardList) {
				response.put("title", board.getBoardTitle());
				response.put("content", board.getBoardContent());

			}
			return response;
		} catch (Exception e) {

			e.printStackTrace();
			Map<String, Object> response = new HashMap<>();
			response.put("error", false);

			return response;
		}
	}

	// 스크랩
	@RequestMapping(value = "/sns/scrapBoard.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> scrapBoard(@RequestParam("boardId") int boardId, BoardVO boardVO, HttpSession session) {
		String userId = (String) session.getAttribute("userId");
		boardVO.setUserId(userId);
		System.out.println("스크랩하려는 유저 아이디:" + userId);
		try {

			List<BoardVO> boardList = snsService.getBoardDetail(boardId);

			Map<String, Object> response = new HashMap<>();

			for (BoardVO board : boardList) {
				Map<String, Object> post = new HashMap<>();

				String scrapedTitle = board.getBoardTitle();
				String scrapedContent = board.getBoardContent();
				String OriginalUser = board.getUserId();

				boardVO.setBoardTitle("[스크랩]" + scrapedTitle);
				boardVO.setBoardContent(scrapedContent);
				boardVO.setScrapFromUserId(OriginalUser);
				boardVO.setUserId(userId);
				System.out.println("스크랩한 제목:" + boardVO.getBoardTitle());

				// 파일 목록 추가
				List<FileVO> fileVOList = snsService.getFilesByBoardId(board.getBoardId());
				List<Map<String, Object>> fileList = new ArrayList<>();
				for (FileVO file : fileVOList) {
					fileList.add(Map.of("originalName", file.getOriginalName(), "filePath", file.getFilePath()));
				}
				post.put("files", fileList);

				snsService.savePost(boardVO, fileVOList);
			}

			response.put("sucess", true);
			return response;

		} catch (Exception e) {
			Map<String, Object> response = new HashMap<>();
			e.printStackTrace();
			response.put("error", false);

			return response;
		}
	}

	// 댓글 수정
	@RequestMapping(value = "/sns/editComment.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updComment(@RequestBody Map<String, Object> requestData, CommentVO commentVO,
			HttpSession session) {
		int commentId = (int) requestData.get("commentId");
		String comment = (String) requestData.get("commentText");
		String Id = (String) requestData.get("boardId");
		int boardId = Integer.parseInt(Id);
		String userId = (String) session.getAttribute("useId");

		try {
			System.out.println("댓글 아이디:" + commentId + ",댓글 내용:" + comment + ",게시글 아이디:" + boardId);

			commentVO.setBoardId(boardId);
			commentVO.setUserId(userId);
			commentVO.setCommentId(commentId);
			commentVO.setCommentContent(comment);

			snsService.updComment(commentVO);

			Map<String, Object> response = new HashMap<>();
			response.put("success", true);
			return response;
		} catch (Exception e) {
			Map<String, Object> response = new HashMap<>();
			e.printStackTrace();
			response.put("error", false);
			return response;
		}
	}

	// 게시글 수정
	@RequestMapping(value = "/sns/updBoardPost.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updInsBoard(@RequestParam("boardId") int boardId, @RequestParam("title") String title,
			@RequestParam("content") String content,
			@RequestParam(value = "files", required = false) MultipartFile[] files,
			@RequestParam(value = "deleteFiles", required = false) List<String> deleteFiles, BoardVO boardVO,
			HttpSession session, HttpServletRequest request, FileVO filevo) {

		try {
			System.out.println("삭제할 파일:" + deleteFiles);
			String userId = (String) session.getAttribute("userId");
			boardVO.setUserId(userId);
			System.out.println("수정할 게시글 아이디:" + boardId);
			List<FileVO> storedFileList = snsService.getFilesByBoardId(boardId);

			int count = storedFileList.size();

			// 제목 길이 공백 포함 30자 미만 & 내용 500자미만
			if (title.length() > 30) {
				Map<String, Object> response = new HashMap<>();
				response.put("success", false);
				response.put("message", "제목은 30자까지 가능합니다");
				return response;
			}

			if (content.length() > 100) {
				Map<String, Object> response = new HashMap<>();
				response.put("success", false);
				response.put("message", "내용은 100자까지 가능합니다");
				return response;
			}

			// 삭제하고 남은 파일 개수
			if (deleteFiles != null && !deleteFiles.isEmpty()) {
				for (FileVO value : storedFileList) {
					System.out.println("저장된 파일 :" + value.getFilePath());
					for (String file : deleteFiles) {
						System.out.println("파일 주소" + file);
						if (value.getFilePath().equals(file)) {
							count--;
						}
					}
				}
			}

			int newFileCount = (files != null) ? files.length : 0;
			int totalCount = count + newFileCount;
			System.out.println(count);

			// 사용자 없으면 alert
			if (userId == null) {
				Map<String, Object> response = new HashMap<>();
				response.put("success", false);
				response.put("message", "로그인 후 다시 시도해주십시오");
				return response;
			}

			if (files != null) {
				// 파일 처리
				List<FileVO> fileVOList = new ArrayList<>();
				int maxFiles = 3; // 파일 개수 제한
				long maxFileSize = 5 * 1024 * 1024; // 파일 크기 제한 (2MB)
				List<String> Extension = Arrays.asList("txt", "pdf"); // 허용 확장자 목록

				if (totalCount > maxFiles) {
					Map<String, Object> response = new HashMap<>();
					response.put("success", false);
					response.put("message", "파일은 최대 " + maxFiles + "개까지만 업로드할 수 있습니다.");
					return response;
				}

				for (MultipartFile file : files) {
					if (!file.isEmpty()) {
						String originalFilename = file.getOriginalFilename();
						String fileExtension = originalFilename.substring(originalFilename.lastIndexOf(".") + 1)
								.toLowerCase();

						// 파일 확장자 검사
						if (!Extension.contains(fileExtension)) {
							Map<String, Object> response = new HashMap<>();
							response.put("success", false);
							response.put("message", ".txt, .png만 첨부가능합니다. 확인 후 다시 시도해주십시오.");
							return response;
						}

						// 파일 크기 검사
						if (file.getSize() > maxFileSize) {
							Map<String, Object> response = new HashMap<>();
							response.put("success", false);
							response.put("message", "파일 크기는 5MB를 초과할 수 없습니다: " + originalFilename);
							return response;

						}

						// 파일 저장 경로
						String uploadDir = "C:/eGovFrameDev-4.0.0-64bit/workspace/fusion-reference/src/main/resources/imgfolder/";
						String storedFileName = UUID.randomUUID() + "_" + originalFilename;
						String filePath = uploadDir + storedFileName;
						String relativePath = "/imgfolder/" + storedFileName;

						System.out.println("originalFileName: " + originalFilename);

						// 파일 저장
						File dest = new File(filePath);
						file.transferTo(dest);

						// FileVO 생성
						FileVO fileVO = new FileVO();
						fileVO.setOriginalName(originalFilename);
						fileVO.setStoredName(storedFileName);
						fileVO.setFilePath(relativePath);
						fileVO.setBoardId(boardId);
						fileVOList.add(fileVO);
					}
				}
				snsService.updFile(fileVOList);
			}
			boardVO.setBoardTitle(title);
			boardVO.setBoardContent(content);
			boardVO.setScrapFromUserId("");
			boardVO.setBoardId(boardId);
			snsService.updBoard(boardVO);
			if (deleteFiles != null && !deleteFiles.isEmpty()) {

				for (String filePath : deleteFiles) {
					System.out.println("파일삭제");
					snsService.deleteFile(filePath, boardId);
				}

			}
			Map<String, Object> response = new HashMap<>();
			response.put("success", true);
			return response;

		} catch (

		Exception e) {
			e.printStackTrace();
			Map<String, Object> response = new HashMap<>();
			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다.");
			return response;
		}

	}

	@RequestMapping(value = "/sns/boardSearch.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> boardSearch(@RequestParam("searchType") String searchType,
			@RequestParam("keyword") String keyword, BoardVO boardVO,
			@RequestParam(value = "year", required = false) String year,
			@RequestParam(value = "month", required = false) String month,
			@RequestParam(value = "day", required = false) String day) {
		try {
			System.out.println("검색타입:" + searchType + ",키워드" + keyword);
			System.out.println("년도:" + year + "월:" + month + "일:" + day);

			// searchType == writeDate일때는 분리해서 해야됨....
			if (searchType.equals("writeDate")) {
				if (year.equals("년도 선택")) {
					Map<String, Object> response = new HashMap<>();
					response.put("false", false);
					response.put("message", "년도를 입력하세요");
					return response;
				} else if (month.equals("월 선택")) {
					Map<String, Object> response = new HashMap<>();
					response.put("false", false);
					response.put("message", "월을 입력하세요");
					return response;
				} else if (day.equals("일 선택")) {
					Map<String, Object> response = new HashMap<>();
					response.put("false", false);
					response.put("message", "일을 입력하세요");
					return response;
				}
			}

			Map<String, Object> response = new HashMap<>();
			response.put("false", false);
			response.put("message", "날짜를 입력하세요");
			return response;

		} catch (Exception e) {
			Map<String, Object> response = new HashMap<>();
			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다.");
			return response;
		}
	}

	// 팔로우 요청
	@RequestMapping(value = "/sns/followRequest.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> followRequest(@RequestParam("followerId") String followerId,
			@RequestParam("followingId") String followingId) {
		try {

			System.out.println("팔로우 할 사람:" + followerId + ",팔로우하는 사람:" + followingId);

			snsService.followRequest(followerId, followingId);

			Map<String, Object> response = new HashMap<>();
			response.put("success", true);
			response.put("message", "팔로우 신청 완료");
			return response;
		} catch (Exception e) {
			Map<String, Object> response = new HashMap<>();
			response.put("false", false);
			response.put("message", "오류발생");
			return response;
		}
	}

	// 내 팔로우 -요청 리스트
	@RequestMapping(value = "/sns/getFollowRequest.do", method = RequestMethod.GET)
	@ResponseBody
	public List<Map<String, Object>> getFollowRequest(HttpSession session, FollowVO followVO) {
		try {
			String userId = (String) session.getAttribute("userId");
			List<Map<String, Object>> response = new ArrayList<>();

			List<FollowVO> followRequestList = snsService.getFollowRequest(userId);

			for (FollowVO follow : followRequestList) {
				Map<String, Object> post = new HashMap<>();
				post.put("followerId", follow.getFollowerId());
				post.put("followingId", follow.getFollowingId());
				post.put("followStatus", follow.getFollowStatus());
				post.put("id", follow.getId());
				response.add(post);
			}
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			return Collections.emptyList();
		}
	}

	// 팔로우 요청 수 & 팔로우 팔로잉 리스트
	@RequestMapping(value = "/sns/getFollowDetail.do", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> getFollowRequestCount(HttpSession session) {
		String userId = (String) session.getAttribute("userId");
		Map<String, Object> response = new HashMap<>();
		try {

			// 팔로우 요청 카운트 수
			List<FollowVO> followRequestList = snsService.getFollowRequest(userId);
			int followRequestCount = followRequestList.size();
			response.put("count", followRequestCount);

			// 팔로워 리스트 수
			List<FollowVO> followerList = snsService.getFollowerList(userId);
			response.put("followerList", followerList);

			// 팔로잉 리스트 수
			List<FollowVO> followingList = snsService.getFollowingList(userId);
			response.put("followingList", followingList);

			response.put("message", "나의 팔로우 정보 가져오기 성공");
			return response;
		} catch (Exception e) {

			response.put("error", false);
			response.put("message", "팔로우 신청 오류");
			return response;
		}
	}

	@RequestMapping(value = "/sns/followRequestYes.do", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> followRequestYes(HttpSession session, @Param("followerId") String followerId) {
		try {

			String userId = (String) session.getAttribute("userId");

			snsService.followRequestYes(userId, followerId);
			snsService.addFollowRequest(userId, followerId);

			Map<String, Object> response = new HashMap<>();

			response.put("message", "팔로우 수락 완료");
			return response;
		} catch (Exception e) {
			Map<String, Object> response = new HashMap<>();
			response.put("message", "팔로우 수락 오류");
			return response;
		}
	}

	@RequestMapping(value = "/sns/followRequestNo.do", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> followRequestNo(HttpSession session, @Param("followerId") String followerId) {
		try {
			String userId = (String) session.getAttribute("userId");
			snsService.followRequestNo(userId, followerId);
			Map<String, Object> response = new HashMap<>();

			response.put("message", "팔로우 거절 완료");
			return response;
		} catch (Exception e) {
			Map<String, Object> response = new HashMap<>();
			response.put("message", "팔로우 거절 오류발생");
			return response;
		}
	}

	@RequestMapping(value = "/sns/followCancel.do", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> followCancel(@RequestParam("followerId") String followerId, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		try {
			String userId = (String) session.getAttribute("userId");
			System.out.println("내 아이디:" + userId + ",취소할 사람" + followerId);
			snsService.followCancel(userId, followerId);

			response.put("message", "팔로우 취소 완료");
			return response;
		} catch (Exception e) {
			response.put("message", "팔로우 취소 중 오류발생");
			return response;
		}
	}

}
