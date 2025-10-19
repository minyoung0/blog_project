package egovframework.fusion.comment.service;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.fusion.comment.vo.CommentVO;

@Service
public class CommentServiceImpl extends EgovAbstractServiceImpl implements CommentService {

	@Autowired
	CommentMapper commentMapper;

	@Override
	public void addComment(CommentVO commentVO) {
	    // 최상위 댓글: PARENT_COMMENT_ID는 NULL
	    commentVO.setParentCommentId(null);

	    // 댓글 그룹 REF 설정 (MAX COMMENT_REF + 1)
	    int newRef = commentMapper.getMaxCommentRef() + 1;
	    commentVO.setCommentRef(newRef);
	    commentVO.setCommentSeq(0); // 최상위 댓글의 SEQ는 0
	    
	    // 댓글 삽입
	    commentMapper.insertComment(commentVO);
	}

	@Override
	public void addReply(CommentVO commentVO) {

		// 부모 댓글이 반드시 존재해야 함
	    if (commentVO.getParentCommentId() == null) {
	        throw new IllegalArgumentException("대댓글 작성 시 부모 댓글 ID가 필요합니다.");
	    }

	    // 부모 댓글 정보 조회
	    CommentVO parentComment = commentMapper.getCommentById(commentVO.getParentCommentId());
	    if (parentComment == null) {
	        throw new IllegalArgumentException("부모 댓글이 존재하지 않습니다.");
	    }
	    
	    // 부모 댓글의 REF와 SEQ 설정
	    int parentRef = parentComment.getCommentRef();
	    int maxSeq = commentMapper.getMaxCommentSeq(parentRef);

	    commentVO.setCommentRef(parentRef); // 부모 댓글의 REF 상속
	    commentVO.setCommentSeq(maxSeq + 1); // 같은 그룹 내 SEQ 증가

	    // 대댓글 삽입
	    commentMapper.insertReply(commentVO);
	}

	@Override
	public void updateComment(CommentVO commentVO) {
		commentMapper.updateComment(commentVO);
	}

	@Override
	public void deleteComment(int commentId) {
		commentMapper.deleteComment(commentId);
	}

	@Override
	public CommentVO getCommentById(int commentId) {

		return commentMapper.selectCommentById(commentId);
	}

	//댓글 조회
	@Override
	public List<CommentVO> getCommentsByBoardId(int boardId) {
		System.out.println("Fetching comments for boardId: " + boardId);
		return commentMapper.selectCommentsByBoardId(boardId);
	}

}