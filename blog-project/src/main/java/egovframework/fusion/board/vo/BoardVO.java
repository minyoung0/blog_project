/*********************************************************
 * 업 무 명 : 게시판 컨트롤러
 * 설 명 : 게시판을 조회하는 화면에서 사용 
 * 작 성 자 : 김민규
 * 작 성 일 : 2022.10.06
 * 관련테이블 : 
 * Copyright ⓒ fusionsoft.co.kr
 *
 *********************************************************/
package egovframework.fusion.board.vo;

import java.io.Serializable;

public class BoardVO implements Serializable {

	private static final long serialVersionUID = -8402510944659037798L;

	/* 게시판 */
	private Integer boardId;
	private Integer parentBoardId;
	private Integer boardRef;
	private Integer boardRefSeq;
	private String boardType;
	private Integer popupYn;
	private String boardTitle;
	private String boardContent;
	private String boardRegistDatetime;
	private String boardUpdateDatetime;
	private Integer viewcount;
	private String userId;

	private String userName;
	private String thumbNail;

	private int limit;
	private int startRow;
	private int boardLevel;
	
	private int menuId;
	private String menuName;
	
	private String scrapFromUserId;
	
	private String userAccessRight;
	
	
	
	

	public String getThumbNail() {
		return thumbNail;
	}

	public void setThumbNail(String thumbNail) {
		this.thumbNail = thumbNail;
	}

	public String getUserAccessRight() {
		return userAccessRight;
	}

	public void setUserAccessRight(String userAccessRight) {
		this.userAccessRight = userAccessRight;
	}

	public String getScrapFromUserId() {
		return scrapFromUserId;
	}

	public void setScrapFromUserId(String scrapFromUserId) {
		this.scrapFromUserId = scrapFromUserId;
	}

	public String getMenuName() {
		return menuName;
	}

	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}

	public int getMenuId() {
		return menuId;
	}

	public void setMenuId(int menuId) {
		this.menuId = menuId;
	}

	public int getBoardLevel() {
		return boardLevel;
	}

	public void setBoardLevel(int boardLevel) {
		this.boardLevel = boardLevel;
	}

	public int getStartRow() {
		return startRow;
	}

	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}

	public int getLimit() {
		return limit;
	}

	public void setLimit(int limit) {
		this.limit = limit;
	}

	public Integer getBoardId() {
		return boardId;
	}

	public void setBoardId(Integer boardId) {
		this.boardId = boardId;
	}

	public Integer getParentBoardId() {
		return parentBoardId;
	}

	public void setParentBoardId(Integer parentBoardId) {
		this.parentBoardId = parentBoardId;
	}

	public Integer getBoardRef() {
		return boardRef;
	}

	public void setBoardRef(Integer boardRef) {
		this.boardRef = boardRef;
	}

	public Integer getBoardRefSeq() {
		return boardRefSeq;
	}

	public void setBoardRefSeq(Integer boardRefSeq) {
		this.boardRefSeq = boardRefSeq;
	}

	public String getBoardType() {
		return boardType;
	}

	public void setBoardType(String boardType) {
		this.boardType = boardType;
	}

	public Integer getPopupYn() {
		return popupYn;
	}

	public void setPopupYn(Integer popupYn) {
		this.popupYn = popupYn;
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

	public String getBoardRegistDatetime() {
		return boardRegistDatetime;
	}

	public void setBoardRegistDatetime(String boardRegistDatetime) {
		this.boardRegistDatetime = boardRegistDatetime;
	}

	public String getBoardUpdateDatetime() {
		return boardUpdateDatetime;
	}

	public void setBoardUpdateDatetime(String boardUpdateDatetime) {
		this.boardUpdateDatetime = boardUpdateDatetime;
	}

	public Integer getViewcount() {
		return viewcount;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public void setViewcount(Integer viewcount) {
		this.viewcount = viewcount;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
