/*********************************************************
 * 업 무 명 : 게시판 컨트롤러
 * 설 명 : 게시판을 조회하는 화면에서 사용 
 * 작 성 자 : 김민규
 * 작 성 일 : 2022.10.06
 * 관련테이블 : 
 * Copyright ⓒ fusionsoft.co.kr
 *
 *********************************************************/
package egovframework.fusion.progressBoard.vo;

import java.io.Serializable;

public class ProgressBoardVO implements Serializable {

	private static final long serialVersionUID = -8402510944659037798L;

	private int boardId;
	private int parentBoardId;
	private int boardRef;
	private String boardTitle;
	private String boardContent;
	private String userId;
	private String adminId;
	private String boardCreateAt;
	private String boardUpdateAt;
	private int progressCode;
	private int boardDeleteYn;
	private String subCodeName;
	
	private int limit;
	private int startRow;
	private int menuId;
	private String userAccess;
	private int maxRef;
	
		
	
	public int getMaxRef() {
		return maxRef;
	}
	public void setMaxRef(int maxRef) {
		this.maxRef = maxRef;
	}
	public String getUserAccess() {
		return userAccess;
	}
	public void setUserAccess(String userAccess) {
		this.userAccess = userAccess;
	}
	public int getMenuId() {
		return menuId;
	}
	public void setMenuId(int menuId) {
		this.menuId = menuId;
	}
	public int getLimit() {
		return limit;
	}
	public void setLimit(int limit) {
		this.limit = limit;
	}
	public int getStartRow() {
		return startRow;
	}
	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}
	public String getSubCodeName() {
		return subCodeName;
	}
	public void setSubCodeName(String subCodeName) {
		this.subCodeName = subCodeName;
	}
	public int getBoardId() {
		return boardId;
	}
	public void setBoardId(int boardId) {
		this.boardId = boardId;
	}
	public int getParentBoardId() {
		return parentBoardId;
	}
	public void setParentBoardId(int parentBoardId) {
		this.parentBoardId = parentBoardId;
	}
	public int getBoardRef() {
		return boardRef;
	}
	public void setBoardRef(int boardRef) {
		this.boardRef = boardRef;
	}
	public String getBoardTitle() {
		return boardTitle;
	}
	public void setBoardTitle(String boardTitle) {
		this.boardTitle = boardTitle;
	}
	public String getBoardContent() {
		return boardContent;
	}
	public void setBoardContent(String boardContent) {
		this.boardContent = boardContent;
	}

	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getAdminId() {
		return adminId;
	}
	public void setAdminId(String adminId) {
		this.adminId = adminId;
	}
	public String getBoardCreateAt() {
		return boardCreateAt;
	}
	public void setBoardCreateAt(String boardCreateAt) {
		this.boardCreateAt = boardCreateAt;
	}
	public String getBoardUpdateAt() {
		return boardUpdateAt;
	}
	public void setBoardUpdateAt(String boardUpdateAt) {
		this.boardUpdateAt = boardUpdateAt;
	}
	public int getProgressCode() {
		return progressCode;
	}
	public void setProgressCode(int progressCode) {
		this.progressCode = progressCode;
	}
	public int getBoardDeleteYn() {
		return boardDeleteYn;
	}
	public void setBoardDeleteYn(int boardDeleteYn) {
		this.boardDeleteYn = boardDeleteYn;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	

}
