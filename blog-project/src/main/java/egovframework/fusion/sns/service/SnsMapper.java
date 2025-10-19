/*********************************************************
 * 업 무 명 : 게시판 컨트롤러
 * 설 명 : 게시판을 조회하는 화면에서 사용 
 * 작 성 자 : 김민규
 * 작 성 일 : 2022.10.06
 * 관련테이블 : 
 * Copyright ⓒ fusionsoft.co.kr
 *
 *********************************************************/
package egovframework.fusion.sns.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.comment.vo.CommentVO;
import egovframework.fusion.gallery.vo.FileVO;
import egovframework.fusion.gallery.vo.GalleryVO;
import egovframework.fusion.gallery.vo.LikeVO;
import egovframework.fusion.gallery.vo.TagVO;
import egovframework.fusion.sns.vo.FollowVO;
import egovframework.fusion.survey.vo.SurveyInfoVO;

@Mapper
public interface SnsMapper {

	//파일 삽입
	public void insertFile(FileVO fileVO);
	
	//게시글 삽입
	public void insertPost(BoardVO boardVO);
	
	//게시글 가져오기
	public List<BoardVO> getBoardList(Map<String,Object> params);
	
	//파일 가져오기
	public List<FileVO> getFileList(@Param("boardId") int boardId);
	
	//게시글 아이디로 댓글 가오기
	public List<CommentVO> getCommentById(@Param("boardId") int boardId);
	
	//게시글 삭제
	public void deleteBoard(@Param("boardId") int boardId);
	
	//댓글 삭제
	public void deleteComment(@Param("commentId") int commentId);
	
	//게시글 상세
	public List<BoardVO> getBoardDetail(@Param("boardId") int boardId);
	
	//댓글 수정
	public void updComment(CommentVO commentVO);
	
	//파일 삭제
	public void deleteFile(@Param("filePath")String filePath,@Param("boardId")int boardId);
	
	//파일개수
	public int getFileCount(@Param("boardId") int boardId);
	
	//게시글 수정
	public void updBoard(BoardVO boardVO);
	
	//검색결과
	/*
	 * public List<BoardVO> getBoardList(@Param("searchType")String
	 * searchType,@Param("keyword")String keyword,
	 * 
	 * @Param("year")String year,@Param("month")String month,@Param("day")String
	 * day,@Param("pageNum")int pageNum,@Param("pageSize")int pageSize);
	 */
	//팔로우 요청
	public void followRequest(@Param("followerId")String followerId, @Param("followingId")String followingId);
	
	//팔로우 요청 보기
	public List<FollowVO> getFollowRequest(@Param("userId")String userId);
	
	//팔로우 요청 수락
	public void followRequestYes(@Param("userId")String userId,@Param("followerId") String followerId);
	
	public void addFollowRequest(@Param("userId")String userId, @Param("followerId")String followerId);
	
	//팔로우 요청 거절
	public void followRequestNo(@Param("userId")String userId,@Param("followerId") String followerId);
	
	//사용자-작성자 팔로우 관계
	public Integer getFollowStatus(@Param("boardUserId") String boardUserId,@Param("userId")String userId);

	//팔로우 리스트 가져오기
	public List<FollowVO> getFollowerList(@Param("userId")String userId);
	
	//팔로잉 리스트 가져오기
	public List<FollowVO> getFollowingList(@Param("userId")String userId);

	//팔로우 취소
	public void followCancel(@Param("userId") String userId, @Param("followerId")String followerId);

	public String getUserAccessRight(@Param("userId") String userId);
}
