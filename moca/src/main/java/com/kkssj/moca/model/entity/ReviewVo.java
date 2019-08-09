package com.kkssj.moca.model.entity;

import java.sql.Date;

public class ReviewVo {
	private int reviewId, accountId, storeId;
	private int tasteLevel, priceLevel,serviceLevel, modeLevel, convenientLevel;
	private double averageLevel;
	private int likeCount, hateCount;
	private String reviewContent;
	private Date writeDate;
	
	public ReviewVo(int reviewId, int accountId, int storeId, int tasteLevel, int priceLevel, int serviceLevel,
			int modeLevel, int convenientLevel, double averageLevel, int likeCount, int hateCount, String reviewContent,
			Date writeDate) {
		super();
		this.reviewId = reviewId;
		this.accountId = accountId;
		this.storeId = storeId;
		this.tasteLevel = tasteLevel;
		this.priceLevel = priceLevel;
		this.serviceLevel = serviceLevel;
		this.modeLevel = modeLevel;
		this.convenientLevel = convenientLevel;
		this.averageLevel = averageLevel;
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
	public int getTasteLevel() {
		return tasteLevel;
	}
	public void setTasteLevel(int tasteLevel) {
		this.tasteLevel = tasteLevel;
	}
	public int getPriceLevel() {
		return priceLevel;
	}
	public void setPriceLevel(int priceLevel) {
		this.priceLevel = priceLevel;
	}
	public int getServiceLevel() {
		return serviceLevel;
	}
	public void setServiceLevel(int serviceLevel) {
		this.serviceLevel = serviceLevel;
	}
	public int getModeLevel() {
		return modeLevel;
	}
	public void setModeLevel(int modeLevel) {
		this.modeLevel = modeLevel;
	}
	public int getConvenientLevel() {
		return convenientLevel;
	}
	public void setConvenientLevel(int convenientLevel) {
		this.convenientLevel = convenientLevel;
	}
	public double getAverageLevel() {
		return averageLevel;
	}
	public void setAverageLevel(double averageLevel) {
		this.averageLevel = averageLevel;
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
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + accountId;
		long temp;
		temp = Double.doubleToLongBits(averageLevel);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + convenientLevel;
		result = prime * result + hateCount;
		result = prime * result + likeCount;
		result = prime * result + modeLevel;
		result = prime * result + priceLevel;
		result = prime * result + ((reviewContent == null) ? 0 : reviewContent.hashCode());
		result = prime * result + reviewId;
		result = prime * result + serviceLevel;
		result = prime * result + storeId;
		result = prime * result + tasteLevel;
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
		if (Double.doubleToLongBits(averageLevel) != Double.doubleToLongBits(other.averageLevel))
			return false;
		if (convenientLevel != other.convenientLevel)
			return false;
		if (hateCount != other.hateCount)
			return false;
		if (likeCount != other.likeCount)
			return false;
		if (modeLevel != other.modeLevel)
			return false;
		if (priceLevel != other.priceLevel)
			return false;
		if (reviewContent == null) {
			if (other.reviewContent != null)
				return false;
		} else if (!reviewContent.equals(other.reviewContent))
			return false;
		if (reviewId != other.reviewId)
			return false;
		if (serviceLevel != other.serviceLevel)
			return false;
		if (storeId != other.storeId)
			return false;
		if (tasteLevel != other.tasteLevel)
			return false;
		return true;
	}
	
	
	@Override
	public String toString() {
		return "ReviewVo [reviewId=" + reviewId + ", accountId=" + accountId + ", storeId=" + storeId + ", tasteLevel="
				+ tasteLevel + ", priceLevel=" + priceLevel + ", serviceLevel=" + serviceLevel + ", modeLevel="
				+ modeLevel + ", convenientLevel=" + convenientLevel + ", averageLevel=" + averageLevel + ", likeCount="
				+ likeCount + ", hateCount=" + hateCount + ", reviewContent=" + reviewContent + ", writeDate="
				+ writeDate + "]";
	}
}
