
package egovframework.fusion.comment.vo;

import java.io.Serializable;

public class CommentVO implements Serializable {

	private static final long serialVersionUID = -8402510944659037798L;

	/* 댓글 */
	private Integer commentId;
	private Integer parentCommentId;
	private Integer commentRef;
	private Integer commentSeq;
	private String commentContent;
	private String commentRegistDatetime;
	private String commentUpdateDatetime;
	private Integer deleteYn;

	private String userName;
	private Integer boardId;
	private String userId;
	
	private int commentLevel; // 계층 깊이를 담을 필드

    // Getter와 Setter 추가
    public int getCommentLevel() {
        return commentLevel;
    }

    public void setCommentLevel(int commentLevel) {
        this.commentLevel = commentLevel;
    }

	public Integer getCommentId() {
		return commentId;
	}

	public void setCommentId(Integer commentId) {
		this.commentId = commentId;
	}

	public Integer getParentCommentId() {
		return parentCommentId;
	}

	public void setParentCommentId(Integer parentCommentId) {
		this.parentCommentId = parentCommentId;
	}

	public Integer getCommentRef() {
		return commentRef;
	}

	public void setCommentRef(Integer commentRef) {
		this.commentRef = commentRef;
	}

	public Integer getCommentSeq() {
		return commentSeq;
	}

	public void setCommentSeq(Integer commentSeq) {
		this.commentSeq = commentSeq;
	}

	public String getCommentContent() {
		return commentContent;
	}

	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
	}

	public String getCommentRegistDatetime() {
		return commentRegistDatetime;
	}

	public void setCommentRegistDatetime(String commentRegistDatetime) {
		this.commentRegistDatetime = commentRegistDatetime;
	}

	public String getCommentUpdateDatetime() {
		return commentUpdateDatetime;
	}

	public void setCommentUpdateDatetime(String commentUpdateDatetime) {
		this.commentUpdateDatetime = commentUpdateDatetime;
	}



	public Integer getDeleteYn() {
		return deleteYn;
	}

	public void setDeleteYn(Integer deleteYn) {
		this.deleteYn = deleteYn;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public Integer getBoardId() {
		return boardId;
	}

	public void setBoardId(Integer boardId) {
		this.boardId = boardId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}