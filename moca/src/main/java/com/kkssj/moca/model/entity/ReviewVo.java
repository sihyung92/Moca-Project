package com.kkssj.moca.model.entity;

import java.sql.Date;

public class ReviewVo {
	//REVIEW table
	private int review_id, accountId, storeId;
	private String reviewContent;
	private Date writeDate;
	private int tasteLevel, priceLevel,serviceLevel, modeLevel, convenienceLevel;
	private double averageLevel;
	private int likeCount, hateCount;
	
	//LIKEHATE table
	private int isLike;
	
	//ACCOUNT table
	private String nickName;
	private int followCount, reviewCount;
	
	//내가 쓴 댓글인지 (table엔 없음)
	private int isMine;
	
	public ReviewVo() {
	}
	
	

	public ReviewVo(int review_id, int accountId, int storeId, String reviewContent, Date writeDate, int tasteLevel,
			int priceLevel, int serviceLevel, int modeLevel, int convenienceLevel, double averageLevel, int likeCount,
			int hateCount, int isLike, String nickName, int followCount, int reviewCount) {
		super();
		this.review_id = review_id;
		this.accountId = accountId;
		this.storeId = storeId;
		this.reviewContent = reviewContent;
		this.writeDate = writeDate;
		this.tasteLevel = tasteLevel;
		this.priceLevel = priceLevel;
		this.serviceLevel = serviceLevel;
		this.modeLevel = modeLevel;
		this.convenienceLevel = convenienceLevel;
		this.averageLevel = averageLevel;
		this.likeCount = likeCount;
		this.hateCount = hateCount;
		this.isLike = isLike;
		this.nickName = nickName;
		this.followCount = followCount;
		this.reviewCount = reviewCount;
	}



	public int getReview_id() {
		return review_id;
	}

	public void setReview_id(int review_id) {
		this.review_id = review_id;
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

	public int getConvenienceLevel() {
		return convenienceLevel;
	}

	public void setConvenienceLevel(int convenienceLevel) {
		this.convenienceLevel = convenienceLevel;
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

	public int getIsLike() {
		return isLike;
	}

	public void setIsLike(int isLike) {
		this.isLike = isLike;
	}

	public String getNickName() {
		return nickName;
	}

	public void setNickName(String nickName) {
		this.nickName = nickName;
	}

	public int getFollowCount() {
		return followCount;
	}

	public void setFollowCount(int followCount) {
		this.followCount = followCount;
	}

	public int getReviewCount() {
		return reviewCount;
	}

	public void setReviewCount(int reviewCount) {
		this.reviewCount = reviewCount;
	}



	@Override
	public String toString() {
		return "ReviewVo [review_id=" + review_id + ", accountId=" + accountId + ", storeId=" + storeId
				+ ", reviewContent=" + reviewContent + ", writeDate=" + writeDate + ", tasteLevel=" + tasteLevel
				+ ", priceLevel=" + priceLevel + ", serviceLevel=" + serviceLevel + ", modeLevel=" + modeLevel
				+ ", convenienceLevel=" + convenienceLevel + ", averageLevel=" + averageLevel + ", likeCount="
				+ likeCount + ", hateCount=" + hateCount + ", isLike=" + isLike + ", nickName=" + nickName
				+ ", followCount=" + followCount + ", reviewCount=" + reviewCount + "]";
	}

}
