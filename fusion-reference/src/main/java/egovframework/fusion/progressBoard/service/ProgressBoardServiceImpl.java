package egovframework.fusion.progressBoard.service;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.fusion.progressBoard.vo.ProgressBoardVO;
import egovframework.fusion.progressBoard.vo.ProgressResponseVO;


@Service
public class ProgressBoardServiceImpl extends EgovAbstractServiceImpl implements ProgressBoardService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ProgressBoardServiceImpl.class);
	
	@Autowired
	ProgressBoardMapper progressBoardMapper;

	@Override
	public void insBoardProgress(String title,String content,String admin,String userId,int menuId) {
		progressBoardMapper.insBoardProgress(title,content,admin,userId,menuId);
	}
	
	@Override
	public List<ProgressBoardVO> getBoardList(){
		return progressBoardMapper.getBoardList();
	}
	
	@Override
	public List<ProgressBoardVO> getBoardListWithPaging(ProgressBoardVO progressBoardVO){
		return progressBoardMapper.getBoardListWithPaging(progressBoardVO);
	}
	
	@Override
	public ProgressBoardVO getMenuDetail (int boardId){
		return progressBoardMapper.getMenuDetail(boardId);
	}
	
	@Override
	public ProgressBoardVO latestBoard(int boardId){
		return progressBoardMapper.latestBoard(boardId);
	}
	
	@Override
	public List<ProgressBoardVO> totalBoard(int boardId){
		return progressBoardMapper.totalBoard(boardId);
	}
	
	@Override
	public ProgressResponseVO getResponse(int boardId) {
		return progressBoardMapper.getResponse(boardId);
	}
	
	@Override
	public void modifyProgressBoard(String title,String content,int boardId) {
		progressBoardMapper.modifyProgressBoard(title,content,boardId);
	}
	
	@Override
	public void insObjection(String title,String content,String adminId,String userId,int menuId, int boardId) {
		int maxRef=progressBoardMapper.getMaxBoardRef(boardId);
		int insertRef=maxRef+1;
		progressBoardMapper.insObjection(title,content,adminId,userId,menuId,boardId,insertRef);
	}
	
	@Override
	public int getMaxRef(int boardId) {
		return progressBoardMapper.getMaxBoardRef(boardId);
	}
	
	@Override
	public int countBoard(ProgressBoardVO progressBoardVO) {
		return progressBoardMapper.countBoard(progressBoardVO);
	}
	
	@Override
	public void updateProgressCode(String code,int boardId) {
		progressBoardMapper.updateProgressCode(code,boardId);
	}
	
	@Override
	public void insProgressResponse(String code,int boardId,String progressContent,String adminId) {
		int progressCode;
		if(code.equals("admission")) {
			//승인
			progressCode=2;
		}else {
			//반려
			progressCode=1;
		}
		progressBoardMapper.insProgressResponse(code,boardId,progressContent,progressCode,adminId);
	}
	
	@Override
	public void modiComReason(int responseId, String responseContent) {
		progressBoardMapper.modiComReason(responseId,responseContent);
	}

	
	@Override
	public ProgressBoardVO getLatestBoardByUserId(String userId) {
		return progressBoardMapper.getLatestBoardByUserId(userId);
	}
	
}
