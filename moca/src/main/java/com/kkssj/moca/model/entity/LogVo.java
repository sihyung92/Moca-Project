package com.kkssj.moca.model.entity;

import java.sql.Timestamp;

public class LogVo {//���� �ۼ�
	
	long seq;
	int account_id, store_id;
	String classification,ip, keyword, access_location;
	Timestamp logtime;
	public LogVo() {
	
	};
	public LogVo(long seq, int account_id, int store_id, String classification, String ip, String keyword,
			String access_location, Timestamp logtime) {
		super();
		this.seq = seq;
		this.account_id = account_id;
		this.store_id = store_id;
		this.classification = classification;
		this.ip = ip;
		this.keyword = keyword;
		this.access_location = access_location;
		this.logtime = logtime;
	}
	public long getSeq() {
		return seq;
	}
	public void setSeq(long seq) {
		this.seq = seq;
	}
	public int getAccount_id() {
		return account_id;
	}
	public void setAccount_id(int account_id) {
		this.account_id = account_id;
	}
	public int getStore_id() {
		return store_id;
	}
	public void setStore_id(int store_id) {
		this.store_id = store_id;
	}
	public String getClassification() {
		return classification;
	}
	public void setClassification(String classification) {
		this.classification = classification;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getAccess_location() {
		return access_location;
	}
	public void setAccess_location(String access_location) {
		this.access_location = access_location;
	}
	public Timestamp getLogtime() {
		return logtime;
	}
	public void setLogtime(Timestamp logtime) {
		this.logtime = logtime;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((access_location == null) ? 0 : access_location.hashCode());
		result = prime * result + account_id;
		result = prime * result + ((classification == null) ? 0 : classification.hashCode());
		result = prime * result + ((ip == null) ? 0 : ip.hashCode());
		result = prime * result + ((keyword == null) ? 0 : keyword.hashCode());
		result = prime * result + ((logtime == null) ? 0 : logtime.hashCode());
		result = prime * result + (int) (seq ^ (seq >>> 32));
		result = prime * result + store_id;
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		LogVo other = (LogVo) obj;
		if (access_location == null) {
			if (other.access_location != null)
				return false;
		} else if (!access_location.equals(other.access_location))
			return false;
		if (account_id != other.account_id)
			return false;
		if (classification == null) {
			if (other.classification != null)
				return false;
		} else if (!classification.equals(other.classification))
			return false;
		if (ip == null) {
			if (other.ip != null)
				return false;
		} else if (!ip.equals(other.ip))
			return false;
		if (keyword == null) {
			if (other.keyword != null)
				return false;
		} else if (!keyword.equals(other.keyword))
			return false;
		if (logtime == null) {
			if (other.logtime != null)
				return false;
		} else if (!logtime.equals(other.logtime))
			return false;
		if (seq != other.seq)
			return false;
		if (store_id != other.store_id)
			return false;
		return true;
	}
	
}
