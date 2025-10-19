package egovframework.fusion.gallery.vo;

import java.io.Serializable;

public class LikeVO implements Serializable {

	private static final long serialVersionUID = -8402510944659037798L;

	//좋아요
	
	private int likeId;
	private int likeYn;
	private int boardId;
	private String userId;
	private boolean liked;
	
	
	
	public boolean isLiked() {
		return liked;
	}
	public void setLiked(boolean liked) {
		this.liked = liked;
	}
	public int getLikeId() {
		return likeId;
	}
	public void setLikeId(int likeId) {
		this.likeId = likeId;
	}
	public int getLikeYn() {
		return likeYn;
	}
	public void setLikeYn(int likeYn) {
		this.likeYn = likeYn;
	}
	public int getBoardId() {
		return boardId;
	}
	public void setBoardId(int boardId) {
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