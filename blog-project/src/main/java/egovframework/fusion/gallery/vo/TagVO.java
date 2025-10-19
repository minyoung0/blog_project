package egovframework.fusion.gallery.vo;

import java.io.Serializable;

public class TagVO implements Serializable {
	private static final long serialVersionUID = -8402510944659037798L;

	// 태그
	private String tagId;
	private String tagName;
	private String tagDeleteYn;
	private int boardId;

	public String getTagId() {
		return tagId;
	}

	public void setTagId(String tagId) {
		this.tagId = tagId;
	}

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}

	public String getTagDeleteYn() {
		return tagDeleteYn;
	}

	public void setTagDeleteYn(String tagDeleteYn) {
		this.tagDeleteYn = tagDeleteYn;
	}

	public int getBoardId() {
		return boardId;
	}

	public void setBoardId(int boardId) {
		this.boardId = boardId;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}