package egovframework.fusion.gallery.vo;

import java.io.Serializable;
import java.util.List;

public class GalleryVO implements Serializable {

	private static final long serialVersionUID = -8402510944659037798L;

//	게시판
	private int boardId;
	private String boardTitle;
	private String boardContent;
	private String boardRegistDatetime;
	private String viewCount;
	private String userName;
	private String likeCount;
	private String userId;
	private String thumbnailPath;
	private String tagName;

//게시판 타입 (ex: 글, 동물갤러리, 식물갤러리, 연예인 갤러리 ...)
	private String typeId;
	/*
	 * private List<FileVO> files; private List<TagVO> tags; private List<LikeVO>
	 * lies;
	 */
//페이징
	private int limit;
	private int startRow;
	private int boardLevel;
	
	private String searchType;
	private String keyword;
	private int menuId;
	private int boardTypeId;
	private String menuName;
	
	
	
	

	public String getMenuName() {
		return menuName;
	}

	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}

	public int getBoardTypeId() {
		return boardTypeId;
	}

	public void setBoardTypeId(int boardTypeId) {
		this.boardTypeId = boardTypeId;
	}

	public int getMenuId() {
		return menuId;
	}

	public void setMenuId(int menuId) {
		this.menuId = menuId;
	}

	// 태그 및 파일
	private List<String> tags; // 태그 리스트

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public int getBoardId() {
		return boardId;
	}

	public void setBoardId(int boardId) {
		this.boardId = boardId;
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

	public String getViewCount() {
		return viewCount;
	}

	public void setViewCount(String viewCount) {
		this.viewCount = viewCount;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getTypeId() {
		return typeId;
	}

	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}

	/*
	 * public String getTypeName() { return typeName; }
	 * 
	 * public void setTypeName(String typeName) { this.typeName = typeName; }
	 */
	public String getLikeCount() {
		return likeCount;
	}

	public void setLikeCount(String likeCount) {
		this.likeCount = likeCount;
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

	public int getBoardLevel() {
		return boardLevel;
	}

	public void setBoardLevel(int boardLevel) {
		this.boardLevel = boardLevel;
	}

	public String getThumbnailPath() {
		return thumbnailPath;
	}

	public void setThumbnailPath(String thumbnailPath) {
		this.thumbnailPath = thumbnailPath;
	}

	public List<String> getTags() {
		return tags;
	}

	public void setTags(List<String> tags) {
		this.tags = tags;
	}


	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}
	

}