package egovframework.blog.blog.myPage.service;

import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.text.StringEscapeUtils;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.blog.blog.myPage.vo.BlogCategoryVO;
import egovframework.blog.blog.myPage.vo.BlogCommentVO;
import egovframework.blog.blog.myPage.vo.BlogLikeVO;
import egovframework.blog.blog.myPage.vo.PostVO;
import egovframework.blog.blog.myPage.vo.ViewVO;
import egovframework.blog.blog.myPage.vo.VisitVO;
import egovframework.blog.blog.user.service.BlogUserMapper;
import egovframework.blog.blog.user.vo.BlogUserVO;

@Service
public class MyPageServiceImpl extends EgovAbstractServiceImpl implements MyPageService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MyPageServiceImpl.class);

	@Autowired
	MyPageMapper myPageMapper;

	@Autowired
	BlogUserMapper blogMapper;
	
	@Autowired
	private HttpServletRequest request;

	

	@Override
	public BlogUserVO getUserInfo(String userId) {
		return blogMapper.getUserInfo(userId);
	}


	@Override
	@Transactional
	public void savePost(PostVO postVo) {
		
	    String TEMP_DIR = request.getServletContext().getRealPath("/temp/");
	    String IMAGE_DIR = request.getServletContext().getRealPath("/images/");
	    // 1️⃣ 게시글 저장
	    myPageMapper.insertPost(postVo);
	    int postId = myPageMapper.getPostId(postVo.getUserId());

	    // 2️⃣ 본문에서 <img src="..."> 태그의 이미지 경로 추출
	    List<String> imageUrls = extractImageUrls(postVo.getContent());
	    System.out.println("추출한 이미지 URL: " + imageUrls);

	    for (String tempUrl : imageUrls) {
	        String fileName = tempUrl.substring(tempUrl.lastIndexOf("/") + 1);
	        Path tempPath = Paths.get(TEMP_DIR + fileName);
	        Path finalPath = Paths.get(IMAGE_DIR + fileName);

	        // 3️⃣ 원본 파일이 존재하는지 확인
	        if (!Files.exists(tempPath)) {
	            System.out.println("⚠️ 원본 파일이 존재하지 않습니다: " + tempPath.toString());
	            continue;  // 파일이 없으면 이동하지 않고 다음 반복으로 넘어감
	        }

	        try {
	            // 4️⃣ 파일 이동 시도
	            Files.copy(tempPath, finalPath, StandardCopyOption.REPLACE_EXISTING);
	            System.out.println("✅ 파일 이동 성공: " + finalPath.toString());

	            // 5️⃣ post_image 테이블에 이미지 정보 저장
	            myPageMapper.insertPostImage(postId, "/images/" + fileName);
	        } catch (IOException e) {
	            System.out.println("❌ 파일 이동 실패: " + e.getMessage());
	        }
	    }
	}
	
	@Override
	public PostVO getPostDetail(int postId) {
		return myPageMapper.getPostDetail(postId);
	}
	
	@Override
	public List<BlogCategoryVO> getCategory(String userId){
		return myPageMapper.getCategory(userId);
	}
	
	@Transactional
	@Override
	public void viewCountUp(int postId,String clientIp,String userId) {
		LocalDate today = LocalDate.now();
		System.out.println("오늘 날짜:"+today);
		System.out.println(postId);
		System.out.println(clientIp);
		System.out.println(userId);
		List<ViewVO> existingView=myPageMapper.existingView(postId,clientIp,userId,today);
		
		if(existingView.isEmpty()) {
			myPageMapper.addViewCount(postId,clientIp,userId,today);
			
		}
	}
	
	@Override
	public BlogCategoryVO getCategoryName(int categoryId) {
		  BlogCategoryVO category = myPageMapper.getCategoryName(categoryId);
		    if (category == null) {
		        category = new BlogCategoryVO();
		        category.setCategoryName("전체");
		    }
		return category;
	}
	
	@Override
	public void addCategory(String categoryName,String visibility,String userId) {
		myPageMapper.addCategory(categoryName,visibility,userId);
	}
	

// 🔹 본문에서 이미지 URL을 추출하는 메서드
	private List<String> extractImageUrls(String content) {
	    List<String> imageUrls = new ArrayList<>();

	    // 1️⃣ HTML 엔티티 디코딩 (ex: &lt; → <, &gt; → >, &quot; → ")
	    String decodedContent = StringEscapeUtils.unescapeHtml4(content);
	    
	    // 2️⃣ 정규식 패턴 적용
	    Pattern pattern = Pattern.compile("<img[^>]+src=[\"']([^\"']+)[\"']");
	    Matcher matcher = pattern.matcher(decodedContent);

	    while (matcher.find()) {
	        imageUrls.add(matcher.group(1));  // `src="..."` 값만 추출하여 리스트에 저장
	    }
	    
	    return imageUrls;
	}
	
	@Override
	public int getTotalPost(String userId,int categoryId) {
		return myPageMapper.getTotalPost(userId,categoryId);
	}

	@Override
	public List<PostVO> getPostListWithPaging(PostVO postVo){
		List<PostVO> list=myPageMapper.getPostListWithPaging(postVo);
		Pattern imgPattern = Pattern.compile("<img[^>]+src=['\"]([^'\"]+)['\"]");
		
		for (PostVO post : list) {
			String content = post.getContent();
			// 🔹 HTML 엔터티 변환 (ex: `&quot;` → `"`)
			String decodedContent = StringEscapeUtils.unescapeHtml4(content);

			Matcher matcher = imgPattern.matcher(decodedContent);

			post.setCreateAt(formatDate(post.getCreateAt()));
			post.setContent(cleanContent(cleanContent(decodedContent)));

			if (matcher.find()) {
				// 첫 번째 이미지의 src 값을 추출하여 썸네일로 설정
				post.setThumbnail(matcher.group(1));
				String imageUrl = matcher.group(1);
				System.out.println("추출된 이미지 URL: " + imageUrl);
			} else {
				// 이미지가 없으면 기본 썸네일 설정
				post.setThumbnail("http://localhost:8080/temp/basic.png");
			}
		}
		
		return list;
	}
	
	@Override
	public List<PostVO> getTotalList(){
		List<PostVO> list=myPageMapper.getTotalList();
		
		for(PostVO post : list) {
			post.setCreateAt(formatDate(post.getCreateAt()));
			post.setContent(StringEscapeUtils.unescapeHtml4(post.getContent()));
		}
		
		return list;
	}
	
	@Override
	@Transactional
	public void addVisit(VisitVO visitVo) {
		LocalDate now = LocalDate.now();
		String today = now.toString();
		visitVo.setVisitDate(today);
		int ExistVisit=myPageMapper.existVisit(visitVo);
		if(ExistVisit == 0) {			
			myPageMapper.addVisit(visitVo);
		}
	
	}
	
	@Override
	public int todayVisit(String blogUserId,String today) {
		return myPageMapper.todayVisit(blogUserId,today);
	}
	
	@Override
	public int totalVisit(String blogUserId) {
		return myPageMapper.totalVisit(blogUserId);
	}
	
	@Override
	public void subscribe(String blogOwnerId,String userId) {
		myPageMapper.subscribe(blogOwnerId,userId);
	}
	
	@Override
	public String getStatus(String userId,String blogUserId) {
		return myPageMapper.getStatus(userId,blogUserId);
	}
	
	@Override
	public List<VisitVO> getVisitStats(String userId,String startDate,String endDate) {
		return myPageMapper.getVisitStats(userId,startDate,endDate);
	}
	
	@Override
	public List<VisitVO> getVisitStatsNormal(String userId){
		return myPageMapper.getVisitStatsNormal(userId);
	}
	
	@Override
	public List<BlogCommentVO> getComment(int postId){
		 List<BlogCommentVO> flatList=myPageMapper.getComment(postId);
		 return buildCommentTree(flatList);
	}
	
	@Override
	public void addComment(BlogCommentVO commentVo) {
		myPageMapper.addComment(commentVo);
	}
	
	@Override
	public void updateComment(BlogCommentVO commentVo) {
		myPageMapper.updateComment(commentVo);
	}
	
	@Override
	public void deleteComment(int commentId) {
		myPageMapper.deleteComment(commentId);
	}
	
	@Override
	public void addLike(BlogLikeVO likeVo) {
		//좋아요 기록 있는지 확인( 취소여부 Y -> N로 update/ 취소여부 N -> Y로 update / 없으면 N으로 추가)
		String exist = myPageMapper.getExistLike(likeVo);
		System.out.println("[addLike]: "+exist);
		if("Y".equals(exist)) {
			System.out.println("[addLike] 좋아요 다시 누름");
			myPageMapper.recoverLike(likeVo);
		}else if( "N".equals(exist)) {
			System.out.println("[addLike] 좋아요 취소");
			myPageMapper.cancelLike(likeVo);
		}else {
			System.out.println("[addLike] 새로운 좋아요");
			myPageMapper.insertLike(likeVo);
		}
				
		
	}
		
	
	public List<BlogCommentVO> buildCommentTree(List<BlogCommentVO> flatList){
		Map<Integer,BlogCommentVO> commentMap=new HashMap<>();
		List<BlogCommentVO> roots= new ArrayList<>();
		
		 // ✅ 먼저 commentMap에 모두 등록
	    for (BlogCommentVO comment : flatList) {
	        commentMap.put(comment.getCommentId(), comment);
	    }

	    // ✅ 그 다음에 부모-자식 연결
	    for (BlogCommentVO comment : flatList) {
	        Integer parentId = comment.getParentId();
	        if (parentId == null) {
	            roots.add(comment);
	        } else {
	            BlogCommentVO parent = commentMap.get(parentId);
	            if (parent != null) {
	                parent.getChildren().add(comment);
	            } else {
	                // parent 못 찾은 경우 예외 처리 or 로그
	                roots.add(comment);
	            }
	        }
	    }
		
		return roots;
	}
	
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