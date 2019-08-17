package com.kkssj.moca.model.entity;

import java.sql.Date;

public class ReviewVo {
	//REVIEW table
	private int review_id, accountId, storeId;
	private String reviewContent, pictureUrls;
	private Date writeDate;
	private int tasteLevel, priceLevel,serviceLevel, moodLevel, convenienceLevel;
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
	
	

	public ReviewVo(int review_id, int accountId, int storeId, String reviewContent, String pictureUrls, Date writeDate,
			int tasteLevel, int priceLevel, int serviceLevel, int moodLevel, int convenienceLevel, double averageLevel,
			int likeCount, int hateCount, int isLike, String nickName, int followCount, int reviewCount, int isMine) {
		super();
		this.review_id = review_id;
		this.accountId = accountId;
		this.storeId = storeId;
		this.reviewContent = reviewContent;
		this.pictureUrls = pictureUrls;
		this.writeDate = writeDate;
		this.tasteLevel = tasteLevel;
		this.priceLevel = priceLevel;
		this.serviceLevel = serviceLevel;
		this.moodLevel = moodLevel;
		this.convenienceLevel = convenienceLevel;
		this.averageLevel = averageLevel;
		this.likeCount = likeCount;
		this.hateCount = hateCount;
		this.isLike = isLike;
		this.nickName = nickName;
		this.followCount = followCount;
		this.reviewCount = reviewCount;
		this.isMine = isMine;
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

	public String getPictureUrls() {
		return pictureUrls;
	}

	public void setPictureUrls(String pictureUrls) {
		this.pictureUrls = pictureUrls;
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

	public int getMoodLevel() {
		return moodLevel;
	}

	public void setMoodLevel(int moodLevel) {
		this.moodLevel = moodLevel;
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

	public int getIsMine() {
		return isMine;
	}

	public void setIsMine(int isMine) {
		this.isMine = isMine;
	}


	@Override
	public String toString() {
		return "ReviewVo [review_id=" + review_id + ", accountId=" + accountId + ", storeId=" + storeId
				+ ", reviewContent=" + reviewContent + ", pictureUrls=" + pictureUrls + ", writeDate=" + writeDate
				+ ", tasteLevel=" + tasteLevel + ", priceLevel=" + priceLevel + ", serviceLevel=" + serviceLevel
				+ ", moodLevel=" + moodLevel + ", convenienceLevel=" + convenienceLevel + ", averageLevel="
				+ averageLevel + ", likeCount=" + likeCount + ", hateCount=" + hateCount + ", isLike=" + isLike
				+ ", nickName=" + nickName + ", followCount=" + followCount + ", reviewCount=" + reviewCount
				+ ", isMine=" + isMine + "]";
	}

	//5가지 level을 가지고 소숫점 1자리까지 평점 계산
	public void calAverageLevel() {
		this.averageLevel = Math.round(((this.tasteLevel + this.priceLevel + this.serviceLevel + this.moodLevel + this.convenienceLevel)/5.0)*10)/10.0;
	}
}
