package egovframework.fusion.main.vo;

import java.io.Serializable;
import java.util.Date;

public class SubCodeVO implements Serializable {
	private static final long serialVersionUID = -8402510944659037798L;

	private String mainCodeId;
	private int subCodeId;
	private String subCodeName;
	private String subCodeDescription;
	private String createAt;
	private String updateAt;
	private String createdBy;
	private String updatedBy;
	private int deleteYn;
	
	private String userId;
	
	private int seqSubCodeId;
	
	public int getSeqSubCodeId() {
		return seqSubCodeId;
	}
	public void setSeqSubCodeId(int seqSubCodeId) {
		this.seqSubCodeId = seqSubCodeId;
	}
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getDeleteYn() {
		return deleteYn;
	}
	public void setDeleteYn(int deleteYn) {
		this.deleteYn = deleteYn;
	}

	public String getMainCodeId() {
		return mainCodeId;
	}

	public void setMainCodeId(String mainCodeId) {
		this.mainCodeId = mainCodeId;
	}

	public int getSubCodeId() {
		return subCodeId;
	}

	public void setSubCodeId(int subCodeId) {
		this.subCodeId = subCodeId;
	}

	public String getSubCodeName() {
		return subCodeName;
	}

	public void setSubCodeName(String subCodeName) {
		this.subCodeName = subCodeName;
	}

	public String getSubCodeDescription() {
		return subCodeDescription;
	}

	public void setSubCodeDescription(String subCodeDescription) {
		this.subCodeDescription = subCodeDescription;
	}



	public String getCreateAt() {
		return createAt;
	}
	public void setCreateAt(String createAt) {
		this.createAt = createAt;
	}
	public String getUpdateAt() {
		return updateAt;
	}
	public void setUpdateAt(String updateAt) {
		this.updateAt = updateAt;
	}
	public String getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}

	public String getUpdatedBy() {
		return updatedBy;
	}

	public void setUpdatedBy(String updatedBy) {
		this.updatedBy = updatedBy;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
