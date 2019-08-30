package com.kkssj.moca.model.entity;

import java.util.ArrayList;
import java.util.List;

public class AccountVo {

	int account_id, followCount, reviewCount, platformId, accountLevel, isMine, exp;
	String nickname, platformType, profileImage, thumbnailImage, accountEmail;
	
	/*email 추가*/
	String email;
	
	public AccountVo() {
	}

	public AccountVo(int account_id, int followCount, int reviewCount, int platformId, String nickname,
			String platformType, String profileImage, String thumbnailImage, String email) {
		super();
		this.account_id = account_id;
		this.followCount = followCount;
		this.reviewCount = reviewCount;
		this.platformId = platformId;
		this.nickname = nickname;
		this.platformType = platformType;
		this.profileImage = profileImage;
		this.thumbnailImage = thumbnailImage;
		
		this.email = email;
	}


	public int getAccount_id() {
		return account_id;
	}


	public void setAccount_id(int account_id) {
		this.account_id = account_id;
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


	public int getPlatformId() {
		return platformId;
	}


	public void setPlatformId(int platformId) {
		this.platformId = platformId;
	}


	public String getNickname() {
		return nickname;
	}


	public void setNickname(String nickname) {
		this.nickname = nickname;
	}


	public String getPlatformType() {
		return platformType;
	}


	public void setPlatformType(String platformType) {
		this.platformType = platformType;
	}


	public String getProfileImage() {
		return profileImage;
	}


	public void setProfileImage(String profileImage) {
		this.profileImage = profileImage;
	}


	public String getThumbnailImage() {
		return thumbnailImage;
	}


	public void setThumbnailImage(String thumbnailImage) {
		this.thumbnailImage = thumbnailImage;
	}


	public String getEmail() {
		return email;
	}


	public void setEmail(String email) {
		this.email = email;
	}

	public int getAccountLevel() {
		return accountLevel;
	}

	public void setAccountLevel(int accountLevel) {
		this.accountLevel = accountLevel;
	}

	public int getIsMine() {
		return isMine;
	}

	public void setIsMine(int isMine) {
		this.isMine = isMine;
	}

	public int getExp() {
		return exp;
	}

	public void setExp(int exp) {
		this.exp = exp;
	}

	public String getAccountEmail() {
		return accountEmail;
	}

	public void setAccountEmail(String accountEmail) {
		this.accountEmail = accountEmail;
	}


	@Override
	public String toString() {
		return "AccountVo [account_id=" + account_id + ", followCount=" + followCount + ", reviewCount=" + reviewCount
				+ ", platformId=" + platformId + ", nickname=" + nickname + ", platformType=" + platformType
				+ ", profileImage=" + profileImage + ", thumbnailImage=" + thumbnailImage + ", email=" + email + "]";
	}

}
