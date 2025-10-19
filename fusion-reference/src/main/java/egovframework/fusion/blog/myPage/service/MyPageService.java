package egovframework.fusion.blog.myPage.service;



import java.util.List;

import egovframework.fusion.blog.myPage.vo.BlogCategoryVO;
import egovframework.fusion.blog.myPage.vo.BlogCommentVO;
import egovframework.fusion.blog.myPage.vo.BlogLikeVO;
import egovframework.fusion.blog.myPage.vo.PostVO;
import egovframework.fusion.blog.myPage.vo.VisitVO;
import egovframework.fusion.blog.user.vo.BlogUserVO;

public interface MyPageService {
	
	//사용자 정보 가져오기
	public BlogUserVO getUserInfo(String userId);
	
	//게시글 저장
	public void savePost(PostVO postVo);
	
	//전체 게시글 수
	public int getTotalPost(String userId,int categoryId);
	
	//게시물 리스트 
	public List<PostVO> getPostListWithPaging(PostVO postVo);
	
	//게시물 조회
	public PostVO getPostDetail(int postId);
	
	//본인 카테고리 가져오기 
	public List<BlogCategoryVO> getCategory(String userId);
	
	public void viewCountUp(int postId,String clientIp,String userId);

	public BlogCategoryVO getCategoryName(int categoryId);
	
	public void addCategory(String categoryName,String visibility,String userId);
	
	public List<PostVO> getTotalList();
	
	public void addVisit(VisitVO visitVo);
	
	public int todayVisit(String blogUserId,String today);
	
	public int totalVisit(String blogUserId);
	
	public void subscribe(String blogOwnerId,String userId);
	
	public String getStatus(String userId, String blogUserId);
	
	public List<VisitVO> getVisitStats(String userId,String startDate,String endDate);
	
	public List<VisitVO> getVisitStatsNormal(String userId);
	
	public List<BlogCommentVO> getComment(int postId);
	
	public void addComment(BlogCommentVO commentVo);
	
	public void updateComment(BlogCommentVO commentVo);
	
	public void deleteComment(int commentId);
	
	public void addLike(BlogLikeVO likeVo);
}



