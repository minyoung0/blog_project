package egovframework.fusion.progressBoard.service;

import java.util.List;

import egovframework.fusion.progressBoard.vo.ProgressBoardVO;
import egovframework.fusion.progressBoard.vo.ProgressResponseVO;

public interface ProgressBoardService {
	
	//요청게시글 등록
	public void insBoardProgress(String title,String content,String admin,String userId,int menuId);
	
	//게시글 가져오기
	public List<ProgressBoardVO> getBoardList();
	
	//게시글 가져오기 - 페이징
	public List<ProgressBoardVO> getBoardListWithPaging(ProgressBoardVO progressBoardVO);
	
	//boardId 상세조회
	public ProgressBoardVO getMenuDetail(int boardId);
	
	//최신 게시글
	public ProgressBoardVO latestBoard(int boardId);
	
	//전체 게시글- 이력조회
	public List<ProgressBoardVO> totalBoard(int boardId);
	
	//응답 조회
	public ProgressResponseVO getResponse(int boardId);
	
	//최대 이의제기수
	public int getMaxRef(int boardId);
	
	//수정하기
	public void modifyProgressBoard(String title,String content,int boardId);
	
	//이의제기글 작성
	public void insObjection(String title,String content,String adminId,String userId,int menuId, int boardId);

	
	public int countBoard(ProgressBoardVO progressBoardVO);
	
	public void updateProgressCode(String code,int boardId);
	
	public void insProgressResponse(String code,int boardId,String progressContent,String adminId);

	//응답 수정
	public void modiComReason(int responseId, String responseContent);
	
	public ProgressBoardVO getLatestBoardByUserId(String userId);
}
