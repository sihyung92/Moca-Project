package com.kkssj.moca.model.entity;

import java.sql.Date;
import java.util.Arrays;

public class AccountVo {
	
	//등급별 maxExp
	int maxExps[] = {0,30,100,300,1000,3000,6000,10000};

	private int account_id, followCount, reviewCount, platformId, accountLevel, isMine, exp, maxExp, minExp;
	private String nickname, platformType, profileImage, thumbnailImage, levelName;
	
	/*email 추가*/
	private String email;
	
	int gender, barista;
	Date birthday;
	
	public int getGender() {
		return gender;
	}

	public void setGender(int gender) {
		this.gender = gender;
	}

	public int getBarista() {
		return barista;
	}

	public void setBarista(int barista) {
		this.barista = barista;
	}

	public Date getBirthday() {
		return birthday;
	}

	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}

	public AccountVo() {
	}
	
public AccountVo(int account_id, int followCount, int reviewCount, int platformId, int accountLevel, int isMine,
			int exp, String nickname, String platformType, String profileImage, String thumbnailImage, String email,
			int gender, int barista, Date birthday) {
		super();
		this.account_id = account_id;
		this.followCount = followCount;
		this.reviewCount = reviewCount;
		this.platformId = platformId;
		this.accountLevel = accountLevel;
		this.isMine = isMine;
		this.exp = exp;
		this.nickname = nickname;
		this.platformType = platformType;
		this.profileImage = profileImage;
		this.thumbnailImage = thumbnailImage;
		this.email = email;
		this.gender = gender;
		this.barista = barista;
		this.birthday = birthday;
	}

//	public AccountVo(int account_id, int followCount, int reviewCount, int platformId, String nickname,
//			String platformType, String profileImage, String thumbnailImage, String email) {
//		super();
//		this.account_id = account_id;
//		this.followCount = followCount;
//		this.reviewCount = reviewCount;
//		this.platformId = platformId;
//		this.nickname = nickname;
//		this.platformType = platformType;
//		this.profileImage = profileImage;
//		this.thumbnailImage = thumbnailImage;
//		this.email = email;
//	}


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

	//level에 따른 maxExp구하기
	public int getMaxExp() {
		return this.maxExp;
	}

	public void setMaxExp() {
		this.maxExp=maxExps[this.accountLevel];
		System.out.println("maxExp"+this.maxExp);
	}

	public String getLevelName() {
		return this.levelName;
	}
	
	public void setLevelName(int level) {
		String levelName = null;
		switch (level) {
		case 1:
			levelName = "라이트";
			break;
		case 2:
			levelName = "시나몬";
			break;
		case 3:
			levelName = "미디움";
			break;
		case 4:
			levelName = "하이";
			break;
		case 5:
			levelName = "시티";
			break;
		case 6:
			levelName = "롱시티";
			break;
		case 7:
			levelName = "프렌치";
			break;
		case 8:
			levelName = "이탈리안";
			break;
		}
		this.levelName = levelName;
	}
	
	public int getMinExp() {
		return this.minExp;
	}

	public void setMinExp() {
		this.minExp=maxExps[this.accountLevel-1];
		System.out.println("minExp"+this.minExp);
	}
	

	@Override
	public String toString() {
		return "AccountVo [maxExps=" + Arrays.toString(maxExps) + ", account_id=" + account_id + ", followCount="
				+ followCount + ", reviewCount=" + reviewCount + ", platformId=" + platformId + ", accountLevel="
				+ accountLevel + ", isMine=" + isMine + ", exp=" + exp + ", maxExp=" + maxExp + ", minExp=" + minExp
				+ ", nickname=" + nickname + ", platformType=" + platformType + ", profileImage=" + profileImage
				+ ", thumbnailImage=" + thumbnailImage + ", levelName=" + levelName + ", email=" + email + ", gender="
				+ gender + ", barista=" + barista + ", birthday=" + birthday + "]";
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
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

}

