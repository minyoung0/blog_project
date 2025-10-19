package egovframework.fusion.blog.myPage.service;


import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.fusion.blog.myPage.vo.BlogCategoryVO;
import egovframework.fusion.blog.myPage.vo.BlogCommentVO;
import egovframework.fusion.blog.myPage.vo.BlogLikeVO;
import egovframework.fusion.blog.myPage.vo.PostVO;
import egovframework.fusion.blog.myPage.vo.ViewVO;
import egovframework.fusion.blog.myPage.vo.VisitVO;
import egovframework.fusion.blog.user.vo.BlogUserVO;


@Mapper
public interface MyPageMapper {

	public void insertPost(PostVO postVo);
	
	public int getPostId(@Param("userId")String userId);
	
	public void insertPostImage(@Param("postId")int postId,@Param("filePath")String filePath);

	public int getTotalPost(@Param("userId") String userId,@Param("categoryId")int categoryId);
	
	public List<PostVO> getPostListWithPaging(PostVO postVo);
	
	public PostVO getPostDetail(@Param("postId")int postId);
	
	public List<BlogCategoryVO> getCategory(@Param("userId")String userId);
	
	public List<ViewVO> existingView(@Param("postId")int postId,@Param("clientIp")String clientIp,@Param("userId")String userId,
			@Param("today")LocalDate today);
	
	public void addViewCount(@Param("postId")int postId,@Param("clientIp")String clientIp,@Param("userId")String userId,
			@Param("today")LocalDate today);
	
	public List<PostVO> postByCategory(@Param("categoryId")int categoryId,@Param("blogUserId")String blogUserId);
	
	public BlogCategoryVO getCategoryName(@Param("categoryId")int categoryId);

	public void addCategory(@Param("categoryName")String categoryName,@Param("visibility")String visibility,@Param("userId")String userId);

	public List<PostVO> getTotalList();
	
	public void addVisit(VisitVO visitVo);
	
	public int todayVisit(@Param("blogUserId")String blogUserId, @Param("today")String today);
	
	public int totalVisit(@Param("blogUserId")String blogUserId);
	
	public void subscribe(@Param("blogOwnerId")String blogOwnerId,@Param("userId")String userId);
	
	public String getStatus(@Param("userId")String userId, @Param("blogUserId")String blogUserId);

	public List<VisitVO> getVisitStats(@Param("userId")String userId,@Param("startDate")String startDate,@Param("endDate")String endDate);
	
	public List<VisitVO> getVisitStatsNormal(@Param("userId")String userId);

	public List<BlogCommentVO> getComment(@Param("postId")int postId);
	
	public void addComment(BlogCommentVO commentVo);
	
	public void updateComment(BlogCommentVO commentVo);
	
	public void deleteComment(@Param("commentId")int commentId);
	
	public int existVisit(VisitVO visitVo);
	
	public String getExistLike(BlogLikeVO likeVo);
	
	public void recoverLike(BlogLikeVO likeVo);
	
	public void cancelLike(BlogLikeVO likeVo);
	
	public void insertLike(BlogLikeVO likeVo);
}
