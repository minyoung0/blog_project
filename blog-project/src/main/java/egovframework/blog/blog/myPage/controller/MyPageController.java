package egovframework.blog.blog.myPage.controller;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import egovframework.blog.blog.myPage.service.MyPageService;
import egovframework.blog.blog.myPage.vo.BlogCategoryVO;
import egovframework.blog.blog.myPage.vo.BlogCommentVO;
import egovframework.blog.blog.myPage.vo.BlogLikeVO;
import egovframework.blog.blog.myPage.vo.PostVO;
import egovframework.blog.blog.myPage.vo.VisitVO;
import egovframework.blog.blog.user.service.BlogUserService;
import egovframework.blog.blog.user.vo.BlogUserVO;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.text.StringEscapeUtils;
import org.aspectj.util.GenericSignature.SimpleClassTypeSignature;
import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

@Controller
public class MyPageController {

	@Autowired
	BlogUserService userService;

	@Autowired
	MyPageService myPageService;
	
	@Autowired
	private HttpServletRequest request;

	private static final String TEMP_DIR = "C:/upload/temp/"; // 임시 저장 경로

	@GetMapping("blog/mainPage.do")
	public String mainPage(Model model,HttpSession session) {
		try {			
			String userId=(String)session.getAttribute("userId");
			List<PostVO> totalList = myPageService.getTotalList();
			
			for(PostVO post:totalList) {
				post.setStatus(myPageService.getStatus(userId,post.getUserId()));
				
			}
			
			model.addAttribute("post", totalList);
			return "tiles/blog/mainPage";
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	@PostMapping(value="/blog/getComment.do")
	@ResponseBody
	public Map<String,Object> getComment(@RequestParam("postId")int postId){
		Map<String,Object> response = new HashMap<>();
		try {
			List<BlogCommentVO> commentList= myPageService.getComment(postId);
			
 			response.put("commentList", commentList);
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			
			response.put("error", "서버 오류발생");
			return response;
		}
	}
	
	@PostMapping(value="/blog/addComment.do")
	@ResponseBody
	public void addComment(BlogCommentVO commentVo,@RequestParam("userId")String userId,@RequestParam("postId")int postId,@RequestParam(value="parentId",required=false)Integer parentId,@RequestParam("content")String content) {
		try {
			commentVo.setPostId(postId);
			commentVo.setParentId(parentId);
			commentVo.setContent(content);
			commentVo.setUserId(userId);
			
			myPageService.addComment(commentVo);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@GetMapping(value = "/blog/myPage.do")
	public String myPage(HttpSession session, PostVO postVo,VisitVO visitVo, Model model,
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "limit", required = false, defaultValue = "6") int limit,
			@RequestParam(value = "categoryId", required = false, defaultValue = "0") int categoryId,
			@RequestParam(value = "blogUserId", required = false, defaultValue = "") String blogUserId,
			HttpServletRequest request) {
		
		try {			
			int totalCount = myPageService.getTotalPost(blogUserId, categoryId);
			int totalPage = (int) Math.ceil((double) totalCount / limit);
			int startRow = (page - 1) * limit;
			String loggedInUser=(String) session.getAttribute("userId");
			String clientIp = getClientIp(request);
			
			if(loggedInUser==null || loggedInUser.equals("")) {
				loggedInUser="guest";
			}

			
			BlogCategoryVO categoryName = myPageService.getCategoryName(categoryId);
			
			postVo.setLimit(limit);
			postVo.setStartRow(startRow);
			postVo.setUserId(blogUserId);
			postVo.setCategoryId(categoryId);
			postVo.setBlogUserId(blogUserId);
			
			List<PostVO> postList = myPageService.getPostListWithPaging(postVo);
			
			if(!loggedInUser.equals(blogUserId) && categoryId==0) {
				visitVo.setVisitorId(loggedInUser);
				visitVo.setBlogUserId(blogUserId);
				visitVo.setVisitorIp(clientIp);
				myPageService.addVisit(visitVo);
			}
			

			model.addAttribute("categoryName", categoryName);
			model.addAttribute("totalPage", totalPage);
			model.addAttribute("postList", postList);
			return "blogTiles/myPage/myPageMain";
		} catch (Exception e) {
			e.printStackTrace();
			return "blogTiles/myPage/myPageMain";
		}
		
	}

	@GetMapping(value = "/blog/postPage.do")
	public String postPage(Model model, HttpSession session) {
		String userId = (String) session.getAttribute("userId");
		List<BlogCategoryVO> categoryList = myPageService.getCategory(userId);

		model.addAttribute("category", categoryList);
		return "blogTiles/myPage/postPage";
	}

	@PostMapping("/blog/uploadImage.do")
	@ResponseBody
	public ResponseEntity<?> uploadImage(@RequestParam("upload") MultipartFile file) {
		Map<String, Object> response = new HashMap<>();

		try {
			// 🔹 확장자 확인 (이미지 파일만 업로드 가능)
			String originalFilename = file.getOriginalFilename();
			String fileExtension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
			List<String> allowedExtensions = Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".bmp");

			if (!allowedExtensions.contains(fileExtension)) {
				response.put("error", "이미지 파일만 업로드 가능합니다.");
				return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
			}

			// 🔹 파일명 생성 (UUID 적용)
			String fileName = UUID.randomUUID().toString() + fileExtension;
			// 🔹 실제 웹 루트에 위치한 temp 폴더 경로
	        String uploadDir = request.getServletContext().getRealPath("/temp/");
	        Path tempPath = Paths.get(uploadDir, fileName);
	        Files.createDirectories(tempPath.getParent());

			// 🔹 파일을 임시 폴더에 저장
			file.transferTo(tempPath.toFile());

			String baseUrl = ServletUriComponentsBuilder.fromCurrentContextPath().toUriString();

			// 🔹 클라이언트(CKEditor)로 임시 URL 반환
			/* String tempUrl = "/temp/" + fileName; */
			String tempUrl = baseUrl + "/temp/" + fileName; // 절대 경로 반환
			response.put("uploaded", 1);
			response.put("url", tempUrl);

			return ResponseEntity.ok(response);

		} catch (IOException e) {
			response.put("error", "파일 업로드 실패: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		} catch (Exception e) {
			e.printStackTrace();
			response.put("error", "파일 업로드 실패: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	@PostMapping(value = "/blog/savePost.do")
	public ResponseEntity<?> savePost(PostVO postVo, @RequestParam("title") String title,
			@RequestParam("content") String content, @RequestParam("userId") String userId,
			@RequestParam("categoryId") int categoryId, @RequestParam("visibility") String visibility) {
		try {
			postVo.setTitle(title);
			postVo.setContent(content);
			postVo.setUserId(userId);
			postVo.setCategoryId(categoryId);
			System.out.println(content);
			myPageService.savePost(postVo);

			return ResponseEntity.ok("게시글 저장 완료");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("게시글 저장 실패: " + e.getMessage());
		}
	}

	@GetMapping(value = "/blog/postDetail.do")
	public String postDetailPage(@RequestParam("postId") int postId, Model model, HttpSession session,
			@RequestParam("blogUserId") String blogUserId, 
			HttpServletRequest request) {
		String userId = (String) session.getAttribute("userId");
		String clientIp = getClientIp(request);


		if (userId == null || userId.equals("")) {
			userId = "guest";
		}

		// 상세페이지 정보
		PostVO post = myPageService.getPostDetail(postId);

		// 조회수 증가
		myPageService.viewCountUp(postId, clientIp, userId);

		post.setContent(StringEscapeUtils.unescapeHtml4(post.getContent()));
		post.setCreateAt(formatDate(post.getCreateAt()));
		model.addAttribute("post", post);

		return "blogTiles/myPage/postDetail";
	}
	
	@GetMapping(value="/blog/getVisit.do")
	@ResponseBody
	public Map<String,Integer> getVisit(HttpSession session){
		Map<String,Integer> response = new HashMap<>();
		String blogUserId = (String) session.getAttribute("blogUserId");
		System.out.println("getVisit - session blogUserID: "+blogUserId);
		String today = LocalDate.now().toString();
		try {
			int todayVisit=myPageService.todayVisit(blogUserId,today);
			int totalVisit=myPageService.totalVisit(blogUserId);
			response.put("todayVisits",todayVisit);
			response.put("totalVisits",totalVisit);
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			response.put("error", null);
			return response;
		}
	}

	@GetMapping(value = "/blog/settings.do")
	public String settingPage() {
		return "blogTiles/myPage/setting";
	}
	@PostMapping(value="/blog/subscribe.do")
	@ResponseBody
	public void subscribe(@RequestParam("ownerId")String ownerId,HttpSession session) {
		try {
			String userId=(String)session.getAttribute("userId");
			myPageService.subscribe(ownerId,userId);			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@GetMapping(value="/blog/visitStats.do")
	@ResponseBody
	public Map<String,Object> getVisitStats(HttpSession session,@RequestParam("startDate") String startDate,
			@RequestParam("endDate")String endDate){
		Map<String,Object> response = new HashMap<>();
		String userId=(String)session.getAttribute("userId");
		try {
			List<VisitVO> visitStats=myPageService.getVisitStats(userId,startDate,endDate);
			 response.put("visitStats", visitStats);
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			response.put("message", "error");
			return response;
		}
	}
	
	@GetMapping(value="/blog/visitStatsNormal.do")
	@ResponseBody
	public Map<String,Object> getVisitStatsNormal(HttpSession session){
		Map<String,Object> response = new HashMap<>();
		String userId=(String)session.getAttribute("userId");
		try {
			List<VisitVO> visitStats=myPageService.getVisitStatsNormal(userId);
			 response.put("visitStats", visitStats);
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			response.put("message", "error");
			return response;
		}
	}
	
	@PostMapping(value="/blog/updateComment.do")
	@ResponseBody
	public void updateComment(BlogCommentVO commentVo,@RequestParam("commentId")int commentId,@RequestParam("content")String content) {
		try {
			commentVo.setCommentId(commentId);
			commentVo.setContent(content);
			myPageService.updateComment(commentVo);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@GetMapping(value="/blog/deleteComment.do")
	@ResponseBody
	public void deleteComment(@RequestParam("commentId")int commentId) {
		try {
			myPageService.deleteComment(commentId);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@GetMapping(value="/blog/addLike.do")
	@ResponseBody
	public void addLike(BlogLikeVO likeVo,@RequestParam("postId")int postId,HttpSession session) {
		try {			
			String userId= (String)session.getAttribute("userId");
			
			likeVo.setUserId(userId);
			likeVo.setPostId(postId);
			
			myPageService.addLike(likeVo);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private String getClientIp(HttpServletRequest request) {
		String ip = request.getHeader("X-Forwarded-For");
		if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("HTTP_CLIENT_IP");
		}
		if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("HTTP_X_FORWARDED_FOR");
		}
		if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}

		// IPv6 ::1을 127.0.0.1로 변환
		if ("0:0:0:0:0:0:0:1".equals(ip)) {
			ip = "127.0.0.1";
		}

		return ip;
	}

	// 날짜 포맷
	public String formatDate(String date) {
		DateTimeFormatter inputFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

		DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd");

		LocalDateTime dateTime = LocalDateTime.parse(date, inputFormat);
		String formattedDate = dateTime.format(dateFormat);
		return formattedDate;
	}

	public String cleanContent(String htmlContent) {
		if (htmlContent == null) {
			return "";
		}
		// HTML 태그 제거 후 순수한 텍스트만 추출
		return Jsoup.clean(htmlContent, Safelist.none()).trim();
	}
}
