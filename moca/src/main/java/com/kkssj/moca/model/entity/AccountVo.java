package com.kkssj.moca.model.entity;

import java.util.ArrayList;
import java.util.List;

public class AccountVo {
	int account_id, followCount, reviewCount, platformId ;
	String nickname, platformType, profileImage, thumbnailImage;
	ArrayList<StoreVo> favoriteStoreList, likeStoreList;
	
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
	
	public List<StoreVo> getFavoriteStoreList() {
		return favoriteStoreList;
	}

	public void setFavoriteStoreList(ArrayList<StoreVo> favoriteStoreList) {
		this.favoriteStoreList = favoriteStoreList;
	}

	public List<StoreVo> getLikeStoreList() {
		return likeStoreList;
	}

	public void setLikeStoreList(ArrayList<StoreVo> list) {
		this.likeStoreList = list;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((email == null) ? 0 : email.hashCode());
		result = prime * result + ((nickname == null) ? 0 : nickname.hashCode());
		result = prime * result + platformId;
		result = prime * result + ((platformType == null) ? 0 : platformType.hashCode());
		result = prime * result + ((profileImage == null) ? 0 : profileImage.hashCode());
		result = prime * result + ((thumbnailImage == null) ? 0 : thumbnailImage.hashCode());
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
		AccountVo other = (AccountVo) obj;
		if (email == null) {
			if (other.email != null)
				return false;
		} else if (!email.equals(other.email))
			return false;
		if (nickname == null) {
			if (other.nickname != null)
				return false;
		} else if (!nickname.equals(other.nickname))
			return false;
		if (platformId != other.platformId)
			return false;
		if (platformType == null) {
			if (other.platformType != null)
				return false;
		} else if (!platformType.equals(other.platformType))
			return false;
		if (profileImage == null) {
			if (other.profileImage != null)
				return false;
		} else if (!profileImage.equals(other.profileImage))
			return false;
		if (thumbnailImage == null) {
			if (other.thumbnailImage != null)
				return false;
		} else if (!thumbnailImage.equals(other.thumbnailImage))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "AccountVo [account_id=" + account_id + ", followCount=" + followCount + ", reviewCount=" + reviewCount
				+ ", platformId=" + platformId + ", nickname=" + nickname + ", platformType=" + platformType
				+ ", profileImage=" + profileImage + ", thumbnailImage=" + thumbnailImage + ", email=" + email + "]";
	}

}
