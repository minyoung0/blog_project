package egovframework.fusion.progressBoard.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.fusion.progressBoard.vo.ProgressBoardVO;
import egovframework.fusion.progressBoard.vo.ProgressResponseVO;

@Mapper
public interface ProgressBoardMapper {

	public void insBoardProgress(@Param("boardTitle")String title,@Param("boardContent")String content,@Param("adminId")String admin,@Param("userId")String userId,
			@Param("menuId")int menuId);

	public List<ProgressBoardVO> getBoardList();
	
	public List<ProgressBoardVO> getBoardListWithPaging(ProgressBoardVO progressBoardVO);
	
	public ProgressBoardVO getMenuDetail(@Param("boardId")int boardId);
	
	public ProgressBoardVO latestBoard(@Param("boardId")int boardId);
	
	public List<ProgressBoardVO> totalBoard(@Param("boardId") int boardId);
	
	public ProgressResponseVO getResponse(@Param("boardId")int boardId);
	
	public void modifyProgressBoard(@Param("boardTitle")String title,@Param("boardContent")String content,@Param("boardId")int boardId);
	
	public int getMaxBoardRef(@Param("boardId")int boardId);
	
	public void insObjection(
			@Param("boardTitle")String title,@Param("boardContent")String content,@Param("adminId")String admin,@Param("userId")String userId,
			@Param("menuId")int menuId,@Param("boardId")int boardId,@Param("insertRef")int insertRef);
	
	public int countBoard(ProgressBoardVO progressBoardVO);
	
	public void updateProgressCode(@Param("code")String code,@Param("boardId")int boardId);
	
	public void insProgressResponse(@Param("code")String code,@Param("boardId")int boardId,
			@Param("progressContent")String progressContent,@Param("progressCode")int progressCode,
			@Param("adminId")String adminId);
	
	public void modiComReason(@Param("responseId")int responseId, @Param("responseContent") String responseContent);
	
	public ProgressBoardVO getLatestBoardByUserId(@Param("userId") String userId);
}
