package com.maknaez.model;

public class AlertDTO {
	private int alertIdx;
	private long memberIdx;
	private String content;
	private int isRead;
	private String regDate;
	private int dataIdx;

	public int getAlertIdx() {
		return alertIdx;
	}

	public void setAlertIdx(int alertIdx) {
		this.alertIdx = alertIdx;
	}

	public long getMemberIdx() {
		return memberIdx;
	}

	public void setMemberIdx(long memberIdx) {
		this.memberIdx = memberIdx;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public int getIsRead() {
		return isRead;
	}

	public void setIsRead(int isRead) {
		this.isRead = isRead;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public int getDataIdx() {
		return dataIdx;
	}

	public void setDataIdx(int dataIdx) {
		this.dataIdx = dataIdx;
	}
}