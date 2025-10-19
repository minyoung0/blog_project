package egovframework.fusion.main.vo;

import java.io.Serializable;
import java.util.Date;


public class MenuLogVO implements Serializable {

	private static final long serialVersionUID = -8402510944659037798L;

	private int accessId;
	private Date accessDate;
	private int menuId;
	private String userId;
	
	private String MONTH;
	private String ACCESSCOUNT;
	
	
	public String getMONTH() {
		return MONTH;
	}
	public void setMONTH(String mONTH) {
		MONTH = mONTH;
	}
	public String getACCESSCOUNT() {
		return ACCESSCOUNT;
	}
	public void setACCESSCOUNT(String aCCESSCOUNT) {
		ACCESSCOUNT = aCCESSCOUNT;
	}
	public int getAccessId() {
		return accessId;
	}
	public void setAccessId(int accessId) {
		this.accessId = accessId;
	}
	public Date getAccessDate() {
		return accessDate;
	}
	public void setAccessDate(Date accessDate) {
		this.accessDate = accessDate;
	}
	public int getMenuId() {
		return menuId;
	}
	public void setMenuId(int menuId) {
		this.menuId = menuId;
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