package egovframework.fusion.gallery.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.gallery.service.GalleryService;
import egovframework.fusion.gallery.vo.FileVO;
import egovframework.fusion.gallery.vo.GalleryVO;
import egovframework.fusion.gallery.vo.LikeVO;
import egovframework.fusion.gallery.vo.TagVO;
import egovframework.fusion.main.service.MainService;
import egovframework.fusion.main.vo.MenuVO;

//	갤러리

@Controller
public class GalleryController {

	@Autowired
	GalleryService galleryService;

	@Autowired
	MainService mainService;

	@ModelAttribute("menuList")
	public List<MenuVO> menuList(){
		return mainService.getMenuListModel();
	}
	
	@RequestMapping(value = "/gallery/galleryList.do", method = RequestMethod.GET)
	public String galleryList(MenuVO menuVO, GalleryVO galleryVO, BoardVO boardVO, Model model,
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "limit", required = false, defaultValue = "10") int limit,HttpServletRequest request, HttpSession session) {
		try {

			String RequestMenuId=request.getParameter("menuId");
			int menuId = Integer.parseInt(RequestMenuId);
			System.out.println("메뉴아이디~:" + menuId);
			
			// 페이지 시작 행 계산
			int startRow = (page - 1) * limit;

			// 페이징 정보를 VO에 설정
			galleryVO.setStartRow(startRow);
			galleryVO.setLimit(limit);
			galleryVO.setMenuId(menuId);


			List<GalleryVO> galleryList = galleryService.getGalleryList(galleryVO);

			for (GalleryVO gallery : galleryList) {
				// 해당 게시글의 파일 리스트 가져오기
				List<FileVO> files = galleryService.getFilesByBoardId(gallery.getBoardId());

				System.out.println("No files found for Board ID: " + gallery.getBoardId());
				if (files != null && !files.isEmpty()) {
					// isThumbnail이 1인 파일을 찾음
					FileVO thumbnailFile = files.stream().filter(file -> file.getIsThumbnail() == "1").findFirst()
							.orElse(files.get(0)); // 없으면 첫 번째 파일로 설정
					gallery.setThumbnailPath("/imgfolder/" + thumbnailFile.getStoredName());
					System.out.println(thumbnailFile.getStoredName());
				} else {
					// 첨부파일이 없는 경우 기본 썸네일 이미지 설정 (옵션)
					gallery.setThumbnailPath("/imgfolder/default-thumbnail.png");
				}
			}
			// 전체 게시물 수 가져오기
			int totalCount = galleryService.getTotalCount(boardVO);

			// 총 페이지 수 계산
			int totalPage = (int) Math.ceil((double) totalCount / limit);

			// Model에 데이터 추가
			model.addAttribute("menuId",menuId);
			model.addAttribute("galleryList", galleryList);
			model.addAttribute("totalPage", totalPage);
			model.addAttribute("currentPage", page);
			model.addAttribute("selectedLimit", limit);

		} catch (Exception e) {
			e.printStackTrace();
		}
		/* return "views/gallery/galleryList"; */
		return "tiles/gallery/galleryList";
	}

	@RequestMapping(value = "/gallery/galleryRegister.do", method = RequestMethod.GET)
	public String galleryRegister( Model model,HttpServletRequest request) {
		String RequestMenuId=request.getParameter("menuId");
		int menuId = Integer.parseInt(RequestMenuId);
		System.out.println("메뉴아이디" + menuId);
		
		model.addAttribute("menuId",menuId);
		return "views/gallery/galleryRegister";
	}

	@RequestMapping(value = "/gallery/insGallery.do",method=RequestMethod.POST)
	public String insGalleryPost(GalleryVO galleryVO, @RequestParam("files") MultipartFile[] files, // MultipartFile 배열로
																									// 받기
			HttpSession session, @RequestParam("tags") String[] tags, // 태그 배열로 받기
			@RequestParam("thumbnailIndex") int thumbnailIndex,HttpServletRequest request) {
		try {
			String userId = (String) session.getAttribute("userId");
			galleryVO.setUserId(userId);
			
			String RequestMenuId = request.getParameter("menuId");
			int menuId = Integer.parseInt(RequestMenuId);

			// 1. 파일 처리
			List<FileVO> fileVOList = new ArrayList<>();
			for (int i = 0; i < files.length; i++) {
				MultipartFile file = files[i];
				if (!file.isEmpty()) {
					// 파일 저장 경로
					String uploadDir = "C:/eGovFrameDev-4.0.0-64bit/workspace/fusion-reference/src/main/resources/imgfolder/";
					String originalFilename = file.getOriginalFilename();
					String storedFileName = UUID.randomUUID() + "_" + originalFilename;
					String filePath = uploadDir + storedFileName;
					String relativePath = "/imgfolder/" + storedFileName;
					// 파일 저장
					File dest = new File(filePath);
					file.transferTo(dest);

					// FileVO 생성
					FileVO fileVO = new FileVO();
					fileVO.setOriginalName(originalFilename);
					fileVO.setStoredName(storedFileName);
					fileVO.setFilePath(relativePath);
					fileVO.setIsThumbnail(i == thumbnailIndex ? "1" : "0");
					fileVOList.add(fileVO);
				}
			}

			// 2. 태그 처리
			List<TagVO> tagVOList = Arrays.stream(tags).map(tag -> {
				TagVO tagVO = new TagVO();
				tagVO.setTagName(tag);
				return tagVO;
			}).collect(Collectors.toList());

			// 3. 서비스 호출
			galleryVO.setMenuId(menuId);
			galleryService.savePost(galleryVO, fileVOList, tagVOList);

		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
		return "redirect:/gallery/galleryList.do?menuId="+galleryVO.getMenuId();
	}

	@RequestMapping(value = "/gallery/galleryDetail.do", method = RequestMethod.GET)
	public String galleryDetail(@RequestParam("boardId") int boardId, Model model, HttpSession session) {

		try {

			String userId = (String) session.getAttribute("userId");

			// 게시글 정보 가져오기
			GalleryVO gallery = galleryService.getGalleryById(boardId);

			// 해당 게시글의 파일 리스트 가져오기
			List<FileVO> files = galleryService.getFilesByBoardId(boardId);

			// 해당 게시글 태그 리스트 가져오기
			List<TagVO> tags = galleryService.getTagsByBoardId(boardId);

			// 조회수 증가 처리
			if(userId!=null) {
				boolean isViewCountIncreased = galleryService.increaseViewCount(boardId, userId);
				model.addAttribute("viewCountIncreased", isViewCountIncreased); 
			
			}
			

			// 사용자의 좋아요 상태 확인
			/*
			 * boolean isLiked = false; if (loggedInUserId != null) { isLiked =
			 * galleryService.checkUserLiked(boardId, loggedInUserId); }
			 */
			model.addAttribute("gallery", gallery);
			model.addAttribute("files", files);
			model.addAttribute("tags", tags);
			/* model.addAttribute("isLiked",isLiked); */
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
		return "views/gallery/galleryDetail";
	}

	@RequestMapping(value = "/gallery/deletePost.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deletePost(@RequestParam("boardId") int boardId) {
		Map<String, Object> response = new HashMap<>();
		try {
			galleryService.DeletePost(boardId); // 삭제 처리 서비스 호출
			response.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
		}
		return response;
	}

	@RequestMapping(value = "/gallery/postsByTag.do", method = RequestMethod.GET)
	public String postsByTag(@RequestParam("tagName") String tagName, Model model) {
		try {
			List<GalleryVO> galleries = galleryService.getPostsByTag(tagName);

			// 각 게시글에 대해 썸네일 정보를 추가로 가져오기
			for (GalleryVO gallery : galleries) {
				String thumbnailPath = galleryService.getThumbnailByBoardId(gallery.getBoardId());
				gallery.setThumbnailPath(thumbnailPath); // 썸네일 경로 설정
			}

			model.addAttribute("galleries", galleries);
			model.addAttribute("tagName", tagName);
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
		return "views/gallery/postsByTag";
	}

	@RequestMapping(value = "gallery/gallerySearch.do", method = RequestMethod.GET)
	public String searchGallery(@RequestParam(value = "searchType") String searchType,
			@RequestParam(value = "keyword") String keyword,
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "limit", required = false, defaultValue = "10") int limit, Model model) {
		System.out.println("searchType: " + searchType);
		System.out.println("keyword: " + keyword);
		try {
			if (keyword == null || keyword.trim().isEmpty()) {
				// 검색어가 없을 경우 기본 리스트 반환
				return "redirect:/gallery/galleryList.do";
			}

			// 페이지 시작 행 계산
			int startRow = (page - 1) * limit;

			// GalleryVO에 페이징 정보와 검색 조건 설정
			GalleryVO galleryVO = new GalleryVO();
			galleryVO.setStartRow(startRow);
			galleryVO.setLimit(limit);
			galleryVO.setSearchType(searchType);
			galleryVO.setKeyword(keyword);

			// 검색 결과 가져오기
			List<GalleryVO> galleryList = galleryService.searchGallery(galleryVO);

			// 검색된 게시물 총 개수 가져오기
			int totalCount = galleryService.getSearchResultCount(galleryVO);

			// 총 페이지 수 계산
			int totalPage = (int) Math.ceil((double) totalCount / limit);

			// Model에 데이터 추가
			model.addAttribute("galleryList", galleryList);
			model.addAttribute("totalPage", totalPage);
			model.addAttribute("currentPage", page);
			model.addAttribute("selectedLimit", limit);
			model.addAttribute("searchType", searchType);
			model.addAttribute("keyword", keyword);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return "views/gallery/galleryList";
	}

	@RequestMapping(value = "/gallery/incrementDownloadCount.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> increaseDownloadCount(@RequestBody Map<String, Object> request) {
		Map<String, Object> response = new HashMap<>();
		try {
			int fileId = Integer.valueOf(request.get("fileId").toString());
			int newCount = galleryService.incrementDownloadCount(fileId);
			response.put("success", true);
			response.put("downloadCount", newCount);
		} catch (Exception e) {
			response.put("success", false);
			response.put("message", "다운로드 횟수 증가 처리 중 오류가 발생했습니다.");
		}
		return ResponseEntity.ok(response);
	}

	@RequestMapping(value = "/gallery/editPost.do", method = RequestMethod.GET)
	public String editPostPage(@RequestParam("boardId") int boardId, Model model) {

		try {
			GalleryVO gallery = galleryService.getGalleryById(boardId);
			List<FileVO> files = galleryService.getFilesByBoardId(boardId);
			List<TagVO> tags = galleryService.getTagsByBoardId(boardId);
			model.addAttribute("gallery", gallery);
			model.addAttribute("files", files);
			model.addAttribute("tags", tags);

		} catch (Exception e) {
			return "error";
		}

		return "views/gallery/editPost";
	}

	@RequestMapping(value = "/gallery/editPost.do", method = RequestMethod.POST)
	public String UpdGalleryPost(@ModelAttribute GalleryVO galleryVO, Model model,
			@RequestParam(value = "newFiles", required = false) List<MultipartFile> newFiles,
			@RequestParam(value = "deletedFiles", required = false) String deletedFiles) {
		try {
			galleryService.updGalleryPost(galleryVO);

			// 삭제할 파일 처리
			if (deletedFiles != null && !deletedFiles.isEmpty()) {
				List<Long> deletedFileIds = Arrays.stream(deletedFiles.split(",")).map(Long::parseLong)
						.collect(Collectors.toList());
				galleryService.deleteFiles(deletedFileIds);
			}

			// 새 파일 처리
			// 3. 새 파일 업로드 처리
			if (newFiles != null && !newFiles.isEmpty()) {
				List<FileVO> newFileVOList = new ArrayList<>();
				for (MultipartFile file : newFiles) {
					if (!file.isEmpty()) {
						// 파일 저장 경로 설정
						String uploadDir = "C:/eGovFrameDev-4.0.0-64bit/workspace/fusion-reference/src/main/resources/imgfolder/";
						String originalFilename = file.getOriginalFilename();
						String storedFileName = UUID.randomUUID() + "_" + originalFilename;
						String filePath = uploadDir + storedFileName;
						String relativePath = "/imgfolder/" + storedFileName;

						// 파일 저장
						File dest = new File(filePath);
						file.transferTo(dest);

						// FileVO 생성
						FileVO fileVO = new FileVO();
						fileVO.setBoardId(galleryVO.getBoardId()); // 게시글 ID
						fileVO.setOriginalName(originalFilename);
						fileVO.setStoredName(storedFileName);
						fileVO.setFilePath(relativePath);
						fileVO.setIsThumbnail("0"); // 기본값으로 썸네일 아님
						newFileVOList.add(fileVO);
					}
				}
				galleryService.addFiles(newFileVOList);
				// 새 파일 업로드 처리
				/*
				 * if (newFiles != null && !newFiles.isEmpty()) { for (MultipartFile file :
				 * newFiles) { String filePath = galleryService.saveFile(file);
				 * galleryService.saveFileMetadata(board.getId(), filePath,
				 * file.getOriginalFilename()); } }
				 */
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/gallery/galleryDetail.do?boardId=" + galleryVO.getBoardId();
	}

	// 다운로드 수 카운트
	@RequestMapping(value = "/gallery/increaseDownloadCount.do", method = RequestMethod.POST)
	public ResponseEntity<?> updateDownloadCount(@RequestBody Map<String, Object> requestData) {

		int fileId = Integer.valueOf(requestData.get("fileId").toString());
		System.out.println("Request Data: " + requestData);
		System.out.println("Extracted fileId: " + fileId);
		try {
			galleryService.incrementDownloadCount(fileId);
			return ResponseEntity.ok().build();
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("다운로드 횟수 업데이트 실패");
		}
	}

	@RequestMapping(value = "/gallery/likePost.do", method = RequestMethod.POST)
	public ResponseEntity<?> likePost(@RequestBody LikeVO likeVO, HttpSession session) {
		/*
		 * try { int likeCount = galleryService.toggleLike(likeVO); return
		 * ResponseEntity.ok(Map.of("success", true, "likeCount", likeCount)); } catch
		 * (Exception e) { return
		 * ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
		 * .body(Map.of("success", false, "message", "서버 오류가 발생했습니다.")); }
		 */

		String userId = (String) session.getAttribute("userId");
		System.out.println(userId);
		if (userId == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
					.body(Map.of("success", false, "message", "로그인이 필요합니다."));
		}

		likeVO.setUserId(userId); // 로그인 사용자 ID 설정

		try {
			int likeCount = galleryService.toggleLike(likeVO);
			return ResponseEntity.ok(Map.of("success", true, "likeCount", likeCount));
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body(Map.of("success", false, "message", "서버 오류가 발생했습니다."));
		}
	}
	
	@RequestMapping(value="/gallery/test.do",method=RequestMethod.GET)
	public String testPage() {
		return "/views/gallery/test";
	}
}
