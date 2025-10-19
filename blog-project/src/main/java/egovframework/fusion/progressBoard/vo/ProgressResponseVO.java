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

public class ProgressResponseVO implements Serializable {

	private static final long serialVersionUID = -8402510944659037798L;

	private int responseId;
	private int boardId;
	private String adminId;
	private int responseCode;
	private String responseContent;
	private String responseCreateAt;
	private String responseUpdateAt;
	private String subCodeName;
	
	
	
	
	public String getSubCodeName() {
		return subCodeName;
	}
	public void setSubCodeName(String subCodeName) {
		this.subCodeName = subCodeName;
	}
	public int getResponseId() {
		return responseId;
	}
	public void setResponseId(int responseId) {
		this.responseId = responseId;
	}
	public int getBoardId() {
		return boardId;
	}
	public void setBoardId(int boardId) {
		this.boardId = boardId;
	}
	public String getAdminId() {
		return adminId;
	}
	public void setAdminId(String adminId) {
		this.adminId = adminId;
	}
	public int getResponseCode() {
		return responseCode;
	}
	public void setResponseCode(int responseCode) {
		this.responseCode = responseCode;
	}
	public String getResponseContent() {
		return responseContent;
	}
	public void setResponseContent(String responseContent) {
		this.responseContent = responseContent;
	}
	public String getResponseCreateAt() {
		return responseCreateAt;
	}
	public void setResponseCreateAt(String responseCreateAt) {
		this.responseCreateAt = responseCreateAt;
	}
	public String getResponseUpdateAt() {
		return responseUpdateAt;
	}
	public void setResponseUpdateAt(String responseUpdateAt) {
		this.responseUpdateAt = responseUpdateAt;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
	


}
