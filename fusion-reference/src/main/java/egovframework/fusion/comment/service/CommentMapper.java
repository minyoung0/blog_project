package egovframework.fusion.comment.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.comment.vo.CommentVO;

@Mapper
public interface CommentMapper {

	void insertComment(CommentVO commentVO);

	void insertReply(CommentVO commentVO);

	void updateComment(CommentVO commentVO);

	void deleteComment(int comment_id);

	CommentVO selectCommentById(int comment_id);

	List<CommentVO> selectCommentsByBoardId(int board_id);

	int getMaxCommentRef();

	int getMaxCommentSeq(int parentBoardId);

	CommentVO getCommentById(@Param("commentId") Integer commentId);
}
