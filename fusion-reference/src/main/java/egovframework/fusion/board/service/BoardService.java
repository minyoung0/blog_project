/*********************************************************
 * 업 무 명 : 게시판 컨트롤러
 * 설 명 : 게시판을 조회하는 화면에서 사용 
 * 작 성 자 : 김민규
 * 작 성 일 : 2022.10.06
 * 관련테이블 : 
 * Copyright ⓒ fusionsoft.co.kr
 *
 *********************************************************/
package egovframework.fusion.board.service;

import java.util.List;

import egovframework.fusion.board.vo.BoardVO;

public interface BoardService {

	public List<BoardVO> getBoardList(BoardVO boardVo);

	public void insBoardPost(BoardVO boardVo);

	public BoardVO getBoardPost(BoardVO boardVo);

	/* public void updBoardCnt(BoardVO boardVo); */
	public void updBoardCnt(int boardId, String userId);

	public void updBoardPost(BoardVO boardVo);

	public void delBoardPost(BoardVO boardVo);

	public List<BoardVO> searchBoard(String searchType, String keyword);
	
	public List<BoardVO> searchBoard(String searchType, String keyword, List<Integer> searchBoardIdList );

	public List<BoardVO> getPopupBoards();

	public List<BoardVO> getBoardListWithLimit(BoardVO boardVo);

	public void checkDelBoard(List<Integer> boardIds);

	/* public int getTotalBoardCount(); */
	public int getTotalBoardCount(int menuId);

	public List<BoardVO> getBoardListWithPaging(BoardVO boardVo);

	public void addReplyBoard(BoardVO boardVo);
}
