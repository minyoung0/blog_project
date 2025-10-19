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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.fusion.board.service.BoardServiceImpl;
import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.comment.vo.CommentVO;
import egovframework.fusion.gallery.vo.FileVO;
import egovframework.fusion.gallery.vo.GalleryVO;
import egovframework.fusion.gallery.vo.LikeVO;
import egovframework.fusion.gallery.vo.TagVO;
import egovframework.fusion.sns.vo.FollowVO;

@Service
public class SnsServiceImpl extends EgovAbstractServiceImpl implements SnsService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SnsServiceImpl.class);
	
	@Autowired
	SnsMapper snsMapper;
	
	@Override
	public void savePost(BoardVO boardVO, List<FileVO> fileVOList) {

		// 게시글 저장
		snsMapper.insertPost(boardVO);

		// 파일정보 저장
		for (FileVO fileVO : fileVOList) {
			fileVO.setBoardId(boardVO.getBoardId());
			snsMapper.insertFile(fileVO);
		}


	}
	
	@Override
	public void savePostWithOutFiles(BoardVO boardVO) {
		snsMapper.insertPost(boardVO);
	}
	
	@Override
	public List<BoardVO> getBoardList(int pageNum,int pageSize){
		int offset=(pageNum - 1) * pageSize;
		Map<String,Object> params = new HashMap<>();
		params.put("keyword","");
		params.put("searchType","");
		params.put("startDate","");
		params.put("endDate","");
		params.put("offset",offset);
		params.put("pageSize",pageSize);
		return snsMapper.getBoardList(params);
	}
	
	//검색
	@Override
	public List<BoardVO> searchResultList(String searchType,String keyword,String startDate,String endDate,int pageNum,int pageSize){
		int offset=pageNum  * pageSize;
		Map<String,Object> params = new HashMap<>();
		params.put("keyword",keyword);
		params.put("searchType",searchType);
		params.put("startDate",startDate);
		params.put("endDate",endDate);
		params.put("offset",offset);
		params.put("pageSize",pageSize);
		return snsMapper.getBoardList(params);
	}
	
	@Override
	public List<FileVO> getFilesByBoardId(int boardId){
		return snsMapper.getFileList(boardId);
	}
	
	@Override
	public List<CommentVO> getCommentById(int boardId){
		return snsMapper.getCommentById(boardId);
	}
	
	@Override
	public void deleteBoard(int boardId) {
		snsMapper.deleteBoard(boardId);
	}
	
	@Override
	public void deleteComment(int commentId) {
		snsMapper.deleteComment(commentId);
	}
	
	@Override
	public List<BoardVO> getBoardDetail(int boardId){
		return snsMapper.getBoardDetail(boardId);
	}
	
	@Override
	public void updComment(CommentVO commentVO) {
		snsMapper.updComment(commentVO);
	}
	
	@Override
	public void deleteFile(String filePath,int boardId) {
		snsMapper.deleteFile(filePath,boardId);
	}
	

	//파일 삭제 후 게시글 파일 개수
	@Override
	public int getFileCount(int boardId) {
		return snsMapper.getFileCount(boardId);
	}
	
	//수정-새파일 등록
	@Override
	public void updFile(List<FileVO>fileVOList) {
		for (FileVO fileVO : fileVOList) {
			snsMapper.insertFile(fileVO);
		}

	}
	
	//수정 - 글 수정
	@Override
	public void updBoard(BoardVO boardVO) {
		snsMapper.updBoard(boardVO);
	}
	
	
	//팔로우요청
	@Override
	public void followRequest(String followerId,String followingId) {
		snsMapper.followRequest(followerId,followingId);
	}
	
	//팔로우요청-요청확인
	@Override
	public List<FollowVO> getFollowRequest(String userId){
		return snsMapper.getFollowRequest(userId);
	}
	//팔로우 요청 수락
	@Override
	public void followRequestYes(String userId, String followerId) {
		snsMapper.followRequestYes(userId,followerId);
	}
	
	@Override
	public void addFollowRequest(String userId, String followerId) {
		snsMapper.addFollowRequest(userId,followerId);
	}
	
	//팔로우 요청 거절
	@Override
	public void followRequestNo(String userId, String followerId) {
		snsMapper.followRequestNo(userId,followerId);
	}
	//사용자 - 작성자 팔로우 관계
	@Override
	public Integer getFollowStatus(String boardUserId,String userId) {
		return snsMapper.getFollowStatus(boardUserId,userId);
	}
	
	//팔로워 리스트 가져오기
	@Override
	public List<FollowVO> getFollowerList(String userId){
		return snsMapper.getFollowerList(userId);
	}
	
	//팔로잉 리스트 가져오기
	@Override
	public List<FollowVO> getFollowingList(String userId){
		return snsMapper.getFollowingList(userId);
	}
	
	//팔로우 취소
	@Override
	public void followCancel(String userId, String followerId) {
		snsMapper.followCancel(userId,followerId);
	}
	
	//사용자권한 가져오기
	@Override
	public String getUserAccessRight(String userId) {
		return snsMapper.getUserAccessRight(userId);
	}
	
}
