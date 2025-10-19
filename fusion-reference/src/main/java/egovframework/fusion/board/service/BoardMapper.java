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
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import egovframework.fusion.board.vo.BoardVO;

@Mapper
public interface BoardMapper {

	public List<BoardVO> getBoardList(BoardVO boardVo);

	public void insBoardPost(BoardVO boardVo);

	public BoardVO getBoardPost(BoardVO boardVo);

	/* public void updBoardCnt(BoardVO boardVo); */
	public void insertViewHistory(@Param("boardId") int boardId, @Param("userId") String userId);

	public void updateViewCount(@Param("boardId") int boardId, @Param("userId") String userId);

	public void updBoardPost(BoardVO boardVo);

	public void delBoardPost(BoardVO boardVo);

	public List<BoardVO> searchBoard(@Param("searchType") String searchType, @Param("keyword") String keyword);
	
	public List<BoardVO> searchBoard(@Param("searchType") String searchType, @Param("keyword") String keyword, @Param("boardMenuIds")List<Integer> searchBoardIdList);

	public List<BoardVO> getPopupBoards();

	public List<BoardVO> getBoardListWithLimit(BoardVO boardVo);

	public void checkDelBoard(@Param("boardMenuIds")List<Integer> boardIds);

	public List<BoardVO> getBoardListWithPaging(BoardVO boardVo);

	/* public int getTotalBoardCount(); */

	public int getTotalBoardCount(@Param("menuId")int menuId);

	public void addReplyBoard(BoardVO boardVo); // 답글 추가 메소드

	BoardVO getBoardById(@Param("boardId") int boardId); // 부모 게시글 가져오기

	int getMaxBoardRef();

	int getMaxBoardSeq(int parentBoardId);
}
