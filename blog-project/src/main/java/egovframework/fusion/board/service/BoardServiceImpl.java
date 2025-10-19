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

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.progressBoard.vo.ProgressBoardVO;

@Service
public class BoardServiceImpl extends EgovAbstractServiceImpl implements BoardService {

	private static final Logger LOGGER = LoggerFactory.getLogger(BoardServiceImpl.class);

	@Autowired
	BoardMapper boardMapper;

	@Override
	public List<BoardVO> getBoardList(BoardVO boardVo) {
		return boardMapper.getBoardList(boardVo);
	}

	@Override
	public void insBoardPost(BoardVO boardVo) {
		boardMapper.insBoardPost(boardVo);
	}

	@Override
	public BoardVO getBoardPost(BoardVO boardVo) {
		return boardMapper.getBoardPost(boardVo);
	}

	/*
	 * @Override public void updBoardCnt(BoardVO boardVo) {
	 * boardMapper.updBoardCnt(boardVo); }
	 */

	@Override
	public void updBoardCnt(int boardId, String userId) {
		boardMapper.insertViewHistory(boardId, userId);
		boardMapper.updateViewCount(boardId, userId);
	}

	@Override
	public void updBoardPost(BoardVO boardVo) {
		boardMapper.updBoardPost(boardVo);
	}

	@Override
	public void delBoardPost(BoardVO boardVo) {
		boardMapper.delBoardPost(boardVo);
	}

	@Override
	public List<BoardVO> searchBoard(String searchType, String keyword) {
		return boardMapper.searchBoard(searchType, keyword);
	}

	@Override
	public List<BoardVO> searchBoard(String searchType, String keyword, List<Integer> searchBoardIdList) {
		return boardMapper.searchBoard(searchType, keyword, searchBoardIdList);
	}

	@Override
	public List<BoardVO> getPopupBoards() {
		return boardMapper.getPopupBoards();
	}

	@Override
	public List<BoardVO> getBoardListWithLimit(BoardVO boardVo) {
		return boardMapper.getBoardListWithLimit(boardVo);
	}

	@Override
	public void checkDelBoard(List<Integer> boardIds) {
		boardMapper.checkDelBoard(boardIds);
	}

	/*
	 * @Override public int getTotalBoardCount() { return
	 * boardMapper.getTotalBoardCount(); }
	 */
	@Override
	public int getTotalBoardCount(int menuId) {
		return boardMapper.getTotalBoardCount(menuId);
	}

	@Override
	public List<BoardVO> getBoardListWithPaging(BoardVO boardVo) {
		return boardMapper.getBoardListWithPaging(boardVo);
	}

	@Override
	public void addReplyBoard(BoardVO boardVO) {

		// 부모 게시글 정보 조회
		BoardVO parentBoard = boardMapper.getBoardById(boardVO.getParentBoardId());

		// 부모 게시글의 ref와 seq 설정
		int parentRef = parentBoard.getBoardRef();
		int maxSeq = boardMapper.getMaxBoardSeq(parentRef);

		boardVO.setBoardRef(parentRef);
		boardVO.setBoardRefSeq(maxSeq + 1);

		boardMapper.addReplyBoard(boardVO);
	}
	


}
