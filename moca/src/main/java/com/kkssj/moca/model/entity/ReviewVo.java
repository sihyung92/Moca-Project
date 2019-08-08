package com.kkssj.moca.model.entity;

import java.sql.Date;

public class ReviewVo {
	private int reviewId, accountId, storeId;
	private int tasteLev, priceLev,serviceLev, modeLev, convenientLev;
	private int likeCount, hateCount;
	private String reviewContent;
	private Date writeDate;
	
	
	
	public ReviewVo(int reviewId, int accountId, int storeId, int tasteLev, int priceLev, int serviceLev, int modeLev,
			int convenientLev, int likeCount, int hateCount, String reviewContent, Date writeDate) {
		super();
		this.reviewId = reviewId;
		this.accountId = accountId;
		this.storeId = storeId;
		this.tasteLev = tasteLev;
		this.priceLev = priceLev;
		this.serviceLev = serviceLev;
		this.modeLev = modeLev;
		this.convenientLev = convenientLev;
		this.likeCount = likeCount;
		this.hateCount = hateCount;
		this.reviewContent = reviewContent;
		this.writeDate = writeDate;
	}
	public int getReviewId() {
		return reviewId;
	}
	public void setReviewId(int reviewId) {
		this.reviewId = reviewId;
	}
	public int getAccountId() {
		return accountId;
	}
	public void setAccountId(int accountId) {
		this.accountId = accountId;
	}
	public int getStoreId() {
		return storeId;
	}
	public void setStoreId(int storeId) {
		this.storeId = storeId;
	}
	public int getTasteLev() {
		return tasteLev;
	}
	public void setTasteLev(int tasteLev) {
		this.tasteLev = tasteLev;
	}
	public int getPriceLev() {
		return priceLev;
	}
	public void setPriceLev(int priceLev) {
		this.priceLev = priceLev;
	}
	public int getServiceLev() {
		return serviceLev;
	}
	public void setServiceLev(int serviceLev) {
		this.serviceLev = serviceLev;
	}
	public int getModeLev() {
		return modeLev;
	}
	public void setModeLev(int modeLev) {
		this.modeLev = modeLev;
	}
	public int getConvenientLev() {
		return convenientLev;
	}
	public void setConvenientLev(int convenientLev) {
		this.convenientLev = convenientLev;
	}
	public int getLikeCount() {
		return likeCount;
	}
	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}
	public int getHateCount() {
		return hateCount;
	}
	public void setHateCount(int hateCount) {
		this.hateCount = hateCount;
	}
	public String getReviewContent() {
		return reviewContent;
	}
	public void setReviewContent(String reviewContent) {
		this.reviewContent = reviewContent;
	}
	public Date getWriteDate() {
		return writeDate;
	}
	public void setWriteDate(Date writeDate) {
		this.writeDate = writeDate;
	}
	@Override
	public String toString() {
		return "ReviewVo [reviewId=" + reviewId + ", accountId=" + accountId + ", storeId=" + storeId + ", tasteLev="
				+ tasteLev + ", priceLev=" + priceLev + ", serviceLev=" + serviceLev + ", modeLev=" + modeLev
				+ ", convenientLev=" + convenientLev + ", likeCount=" + likeCount + ", hateCount=" + hateCount
				+ ", reviewContent=" + reviewContent + ", writeDate=" + writeDate + "]";
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + accountId;
		result = prime * result + convenientLev;
		result = prime * result + hateCount;
		result = prime * result + likeCount;
		result = prime * result + modeLev;
		result = prime * result + priceLev;
		result = prime * result + ((reviewContent == null) ? 0 : reviewContent.hashCode());
		result = prime * result + reviewId;
		result = prime * result + serviceLev;
		result = prime * result + storeId;
		result = prime * result + tasteLev;
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
		ReviewVo other = (ReviewVo) obj;
		if (accountId != other.accountId)
			return false;
		if (convenientLev != other.convenientLev)
			return false;
		if (hateCount != other.hateCount)
			return false;
		if (likeCount != other.likeCount)
			return false;
		if (modeLev != other.modeLev)
			return false;
		if (priceLev != other.priceLev)
			return false;
		if (reviewContent == null) {
			if (other.reviewContent != null)
				return false;
		} else if (!reviewContent.equals(other.reviewContent))
			return false;
		if (reviewId != other.reviewId)
			return false;
		if (serviceLev != other.serviceLev)
			return false;
		if (storeId != other.storeId)
			return false;
		if (tasteLev != other.tasteLev)
			return false;
		return true;
	}

}
