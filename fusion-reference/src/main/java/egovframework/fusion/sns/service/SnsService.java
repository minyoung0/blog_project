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

import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.comment.vo.CommentVO;
import egovframework.fusion.gallery.vo.FileVO;
import egovframework.fusion.gallery.vo.GalleryVO;
import egovframework.fusion.gallery.vo.LikeVO;
import egovframework.fusion.gallery.vo.TagVO;
import egovframework.fusion.sns.vo.FollowVO;

public interface SnsService {
	public void savePost(BoardVO boardVO, List<FileVO> fileVOList);
	
	public void savePostWithOutFiles(BoardVO boardVO);
	
	public List<BoardVO> getBoardList(int pageNum,int pageSize);
	
	public List<FileVO> getFilesByBoardId(int boardId);
	
	public List<CommentVO> getCommentById(int boardId);
	
	public void deleteBoard(int boardId);
	
	public void deleteComment(int commentId);
	
	public List<BoardVO> getBoardDetail(int boardId);
	
	public void updComment(CommentVO commentVO);
	
	
	//수정- 파일삭제
	public void deleteFile(String filePath,int boardId);
	
	//파일 삭제 후 게시글 파일 개수
	public int getFileCount(int boardId);
	
	//수정-새파일 등록
	public void updFile(List<FileVO>fileVOList);
	
	//수정 - 글 수정
	public void updBoard(BoardVO boardVO);
	
	//검색결과
	public List<BoardVO> searchResultList(String searchType,String keyword,String startDate,String endDate,int pageNum,int pageSize);
	
	//팔로우요청
	public void followRequest(String followerId,String followingId);
	
	//팔로우 요청 - 요청 확인
	public List<FollowVO> getFollowRequest(String userId);
	
	//팔로우 요청 수락
	public void followRequestYes(String userId, String followerId);
	
	public void addFollowRequest(String userId, String followerId);
	
	//팔로우 요청 거절
	public void followRequestNo(String userId, String followerId);

	//세션 사용자와 작성자의 관계
	public Integer getFollowStatus(String boardUserId,String userId);
	
	//팔로워 리스트 가져오기
	public List<FollowVO> getFollowerList(String userId);
	
	//팔로잉 리스트 가져오기
	public List<FollowVO> getFollowingList(String userId);
	
	//팔로우 취소
	public void followCancel(String userId, String followerId);
	
	//사용자 권한 가져오기
	public String getUserAccessRight(String userId);
	
}
