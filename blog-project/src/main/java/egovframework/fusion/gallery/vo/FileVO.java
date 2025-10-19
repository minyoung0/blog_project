package egovframework.fusion.gallery.vo;

import java.io.Serializable;

public class FileVO implements Serializable {
	private static final long serialVersionUID = -8402510944659037798L;

	private String fileId;
	private int boardId;
	private String originalName;
	private String storedName;
	private String filePath;
	private String isThumbnail; // "1"이면 썸네일
	private String fileUpdateTime;
	private String fileDeleteYn;
	private String fileDowncount;

	public String getFileId() {
		return fileId;
	}

	public void setFileId(String fileId) {
		this.fileId = fileId;
	}


	public int getBoardId() {
		return boardId;
	}

	public void setBoardId(int boardId) {
		this.boardId = boardId;
	}

	public String getOriginalName() {
		return originalName;
	}

	public void setOriginalName(String originalName) {
		this.originalName = originalName;
	}

	public String getStoredName() {
		return storedName;
	}

	public void setStoredName(String storedName) {
		this.storedName = storedName;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getIsThumbnail() {
		return isThumbnail;
	}

	public void setIsThumbnail(String isThumbnail) {
		this.isThumbnail = isThumbnail;
	}

	public String getFileUpdateTime() {
		return fileUpdateTime;
	}

	public void setFileUpdateTime(String fileUpdateTime) {
		this.fileUpdateTime = fileUpdateTime;
	}

	public String getFileDeleteYn() {
		return fileDeleteYn;
	}

	public void setFileDeleteYn(String fileDeleteYn) {
		this.fileDeleteYn = fileDeleteYn;
	}

	public String getFileDowncount() {
		return fileDowncount;
	}

	public void setFileDowncount(String fileDowncount) {
		this.fileDowncount = fileDowncount;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
