package egovframework.fusion.main.vo;

import java.io.Serializable;
import java.util.Date;

public class MenuVO implements Serializable {

	private static final long serialVersionUID = -8402510944659037798L;

	private Integer menuId;
	private String menuName;
	private String menuUrl;
	private Date menuCreateAt;
	private Integer menuRef;
	private String menuAccessRight;
	private int deleteYn;
	private int boardtypeId;
	private String userId;
	private String boardtypeName;

	private int limit;
	private int startRow;
	private int boardLevel;
	
	

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

	public int getBoardLevel() {
		return boardLevel;
	}

	public void setBoardLevel(int boardLevel) {
		this.boardLevel = boardLevel;
	}

	public String getBoardtypeName() {
		return boardtypeName;
	}

	public void setBoardtypeName(String boardtypeName) {
		this.boardtypeName = boardtypeName;
	}

	public Integer getMenuId() {
		return menuId;
	}

	public void setMenuId(Integer menuId) {
		this.menuId = menuId;
	}

	public String getMenuName() {
		return menuName;
	}

	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}

	public String getMenuUrl() {
		return menuUrl;
	}

	public void setMenuUrl(String menuUrl) {
		this.menuUrl = menuUrl;
	}

	public Date getMenuCreateAt() {
		return menuCreateAt;
	}

	public void setMenuCreateAt(Date menuCreateAt) {
		this.menuCreateAt = menuCreateAt;
	}

	public Integer getMenuRef() {
		return menuRef;
	}

	public void setMenuRef(Integer menuRef) {
		this.menuRef = menuRef;
	}

	public String getMenuAccessRight() {
		return menuAccessRight;
	}

	public void setMenuAccessRight(String menuAccessRight) {
		this.menuAccessRight = menuAccessRight;
	}

	public int getDeleteYn() {
		return deleteYn;
	}

	public void setDeleteYn(int deleteYn) {
		this.deleteYn = deleteYn;
	}

	public int getBoardtypeId() {
		return boardtypeId;
	}

	public void setBoardtypeId(int boardtypeId) {
		this.boardtypeId = boardtypeId;
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