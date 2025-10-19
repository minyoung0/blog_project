package egovframework.fusion.comment.service;

import java.util.List;

import org.springframework.stereotype.Service;

import egovframework.fusion.comment.vo.CommentVO;


public interface CommentService{
	
	/*
	 * public void addComment(CommentVO commentVO); // 댓글 작성
	 * 
	 * public List<CommentVO> commentList(int boardId); // 댓글 조회
	 * 
	 * public void updateComment(CommentVO commentVO); // 댓글 수정
	 * 
	 * public void deleteComment(CommentVO commentVO); // 댓글 삭제
	 * 
	 * public void addReplyComment(CommentVO commentVO);
	 */
	
    public void addComment(CommentVO commentVO);
    public void addReply(CommentVO commentVO);
    public void updateComment(CommentVO commentVO);
    public void deleteComment(int comment_id);
    public CommentVO getCommentById(int comment_id);
    public List<CommentVO> getCommentsByBoardId(int board_id);
}