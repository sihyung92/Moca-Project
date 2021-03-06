package com.kkssj.moca.model.entity;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class StoreVo {
	private int store_Id, kakaoId, reviewCnt, likeCnt, favoriteCnt, wifi, parkingLot, viewCnt, managerId;
	private String name, category, url, tag, dayOff, tel;
	private String address,roadAddress;
	private String xLocation, yLocation, distance;
	private String logoImg, storeImg1, storeImg2, storeImg3;
	private double tasteLevel, priceLevel,serviceLevel, moodLevel, convenienceLevel, averageLevel;
	private Date openTime,endTime;
	private String openTime2,endTime2;
	private int level1Cnt, level2Cnt, level3Cnt, level4Cnt, level5Cnt;
	
	//LIKEHATE table
	private int isLike, isFavorite, isManager;
	
	public StoreVo() {
	}

	public int getStore_Id() {
		return store_Id;
	}

	public void setStore_Id(int store_Id) {
		this.store_Id = store_Id;
	}

	public int getKakaoId() {
		return kakaoId;
	}

	public void setKakaoId(int kakaoId) {
		this.kakaoId = kakaoId;
	}

	public int getReviewCnt() {
		return reviewCnt;
	}

	public void setReviewCnt(int reviewCnt) {
		this.reviewCnt = reviewCnt;
	}

	public int getWifi() {
		return wifi;
	}

	public void setWifi(int wifi) {
		this.wifi = wifi;
	}

	public int getParkingLot() {
		return parkingLot;
	}

	public void setParkingLot(int parkingLot) {
		this.parkingLot = parkingLot;
	}

	public int getViewCnt() {
		return viewCnt;
	}

	public void setViewCnt(int viewCnt) {
		this.viewCnt = viewCnt;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getTag() {
		return tag;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}

	public String getDayOff() {
		return dayOff;
	}

	public void setDayOff(String dayOff) {
		this.dayOff = dayOff;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getRoadAddress() {
		return roadAddress;
	}

	public void setRoadAddress(String roadAddress) {
		this.roadAddress = roadAddress;
	}

	public String getxLocation() {
		return xLocation;
	}

	public void setxLocation(String xLocation) {
		this.xLocation = xLocation;
	}

	public String getyLocation() {
		return yLocation;
	}

	public void setyLocation(String yLocation) {
		this.yLocation = yLocation;
	}

	public String getDistance() {
		return distance;
	}

	public void setDistance(String distance) {
		this.distance = distance;
	}

	public String getLogoImg() {
		return logoImg;
	}

	public void setLogoImg(String logoImg) {
		this.logoImg = logoImg;
	}

	public String getStoreImg1() {
		return storeImg1;
	}

	public void setStoreImg1(String storeImg1) {
		this.storeImg1 = storeImg1;
	}

	public String getStoreImg2() {
		return storeImg2;
	}

	public void setStoreImg2(String storeImg2) {
		this.storeImg2 = storeImg2;
	}

	public String getStoreImg3() {
		return storeImg3;
	}

	public void setStoreImg3(String storeImg3) {
		this.storeImg3 = storeImg3;
	}

	public double getTasteLevel() {
		return tasteLevel;
	}

	public void setTasteLevel(double tasteLevel) {
		this.tasteLevel = tasteLevel;
	}

	public double getPriceLevel() {
		return priceLevel;
	}

	public void setPriceLevel(double priceLevel) {
		this.priceLevel = priceLevel;
	}

	public double getServiceLevel() {
		return serviceLevel;
	}

	public void setServiceLevel(double serviceLevel) {
		this.serviceLevel = serviceLevel;
	}

	public double getMoodLevel() {
		return moodLevel;
	}

	public void setMoodLevel(double moodLevel) {
		this.moodLevel = moodLevel;
	}

	public double getConvenienceLevel() {
		return convenienceLevel;
	}

	public void setConvenienceLevel(double convenienceLevel) {
		this.convenienceLevel = convenienceLevel;
	}

	public double getAverageLevel() {
		return averageLevel;
	}

	public void setAverageLevel(double averageLevel) {
		this.averageLevel = averageLevel;
	}

	public Date getOpenTime() {
		return openTime;
	}

	public void setOpenTime(Date openTime) {
		this.openTime = openTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public String getOpenTime2() {
		return openTime2;
	}

	public String getEndTime2() {
		return endTime2;
	}

	public void setOpenTime2(String openTime2) {
		if(!openTime2.equals("")) {
			DateFormat fommatter = new SimpleDateFormat("HH:mm");
			try {
				this.openTime = (Date) fommatter.parse(openTime2);
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		this.openTime2 = openTime2;
	}

	public void setEndTime2(String endTime2) {
		if(!endTime2.equals("")) {
			DateFormat fommatter = new SimpleDateFormat("HH:mm");
			try {
				this.endTime = (Date) fommatter.parse(endTime2);
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		this.endTime2 = endTime2;
	}
	
	public int getIsLike() {
		return isLike;
	}

	public void setIsLike(int isLike) {
		this.isLike = isLike;
	}

	public int getIsFavorite() {
		return isFavorite;
	}

	public void setIsFavorite(int isFavorite) {
		this.isFavorite = isFavorite;
	}

	public int getIsManager() {
		return isManager;
	}

	public void setIsManager(int isManager) {
		this.isManager = isManager;
	}

	public int getManagerId() {
		return managerId;
	}

	public void setManagerId(int managerId) {
		this.managerId = managerId;
	}

	public int getLikeCnt() {
		return likeCnt;
	}

	public void setLikeCnt(int likeCnt) {
		this.likeCnt = likeCnt;
	}

	public int getFavoriteCnt() {
		return favoriteCnt;
	}

	public void setFavoriteCnt(int favoriteCnt) {
		this.favoriteCnt = favoriteCnt;
	}

	public void calAllLevel(List<ReviewVo> list) {
		this.tasteLevel = 0;
		this.priceLevel = 0;
		this.serviceLevel = 0;
		this.moodLevel = 0;
		this.convenienceLevel = 0;
		
		for (int i = 0; i < list.size(); i++) {
			ReviewVo reviewVo = list.get(i);
			this.tasteLevel += reviewVo.getTasteLevel();
			this.priceLevel += reviewVo.getPriceLevel();
			this.serviceLevel += reviewVo.getServiceLevel();
			this.moodLevel += reviewVo.getMoodLevel();
			this.convenienceLevel += reviewVo.getConvenienceLevel();
		}
		
		this.averageLevel = this.tasteLevel+this.priceLevel+this.serviceLevel+this.moodLevel+this.convenienceLevel;
		
		this.tasteLevel = Math.round((this.tasteLevel*1.0/list.size())*10)/(10.0);
		this.priceLevel = Math.round((this.priceLevel*1.0/list.size())*10)/(10.0);
		this.serviceLevel = Math.round((this.serviceLevel*1.0/list.size())*10)/(10.0);
		this.moodLevel = Math.round((this.moodLevel*1.0/list.size())*10)/(10.0);
		this.convenienceLevel = Math.round((this.convenienceLevel*1.0/list.size())*10)/(10.0);
		this.averageLevel = Math.round((this.averageLevel*1.0/(list.size()*5))*10)/(10.0);
		
	}	
	
	public boolean infoEqual(Object obj) {
		StoreVo other = (StoreVo) obj;
		if (dayOff == null) {
			if (other.dayOff != null)
				return false;
		} else if (!dayOff.equals(other.dayOff))
			return false;

		if (parkingLot != other.parkingLot)
			return false;

		if (tel == null) {
			if (other.tel != null)
				return false;
		} else if (!tel.equals(other.tel))
			return false;
		if (url == null) {
			if (other.url != null)
				return false;
		} else if (!url.equals(other.url))
			return false;
		if (wifi != other.wifi)
			return false;
		return true;
	}	
	
	//kakao �˻� setter
	public void setAddress_name(String address_name) {
		address = address_name;
	}


	public void setCategory_name(String category_name) {
		category = category_name;
	}

	public void setId(int id) {
		kakaoId = id;
	}

	public void setPhone(String phone) {
		tel = phone;
	}

	public void setPlace_name(String place_name) {
		name = place_name;
	}

	public void setPlace_url(String place_url) {
		url = place_url;
	}

	public void setRoad_address_name(String road_address_name) {
		roadAddress = road_address_name;
	}

	public void setX(String x) {
		xLocation = x;
	}

	public void setY(String y) {
		yLocation = y;
	}


	//각각 점수에 따른 리뷰가 몇 개 있는 지
	public int getLevel1Cnt() {
		return level1Cnt;
	}

	public void setLevel1Cnt(int level1Cnt) {
		this.level1Cnt = level1Cnt;
	}

	public int getLevel2Cnt() {
		return level2Cnt;
	}

	public void setLevel2Cnt(int level2Cnt) {
		this.level2Cnt = level2Cnt;
	}

	public int getLevel3Cnt() {
		return level3Cnt;
	}

	public void setLevel3Cnt(int level3Cnt) {
		this.level3Cnt = level3Cnt;
	}

	public int getLevel4Cnt() {
		return level4Cnt;
	}

	public void setLevel4Cnt(int level4Cnt) {
		this.level4Cnt = level4Cnt;
	}

	public int getLevel5Cnt() {
		return level5Cnt;
	}

	public void setLevel5Cnt(int level5Cnt) {
		this.level5Cnt = level5Cnt;
	}

	@Override
	public String toString() {
		return "StoreVo [store_Id=" + store_Id + ", kakaoId=" + kakaoId + ", reviewCnt=" + reviewCnt + ", likeCnt="
				+ likeCnt + ", favoriteCnt=" + favoriteCnt + ", wifi=" + wifi + ", parkingLot=" + parkingLot
				+ ", viewCnt=" + viewCnt + ", managerId=" + managerId + ", name=" + name + ", category=" + category
				+ ", url=" + url + ", tag=" + tag + ", dayOff=" + dayOff + ", tel=" + tel + ", address=" + address
				+ ", roadAddress=" + roadAddress + ", xLocation=" + xLocation + ", yLocation=" + yLocation
				+ ", distance=" + distance + ", logoImg=" + logoImg + ", storeImg1=" + storeImg1 + ", storeImg2="
				+ storeImg2 + ", storeImg3=" + storeImg3 + ", tasteLevel=" + tasteLevel + ", priceLevel=" + priceLevel
				+ ", serviceLevel=" + serviceLevel + ", moodLevel=" + moodLevel + ", convenienceLevel="
				+ convenienceLevel + ", averageLevel=" + averageLevel + ", openTime=" + openTime + ", endTime="
				+ endTime + ", openTime2=" + openTime2 + ", endTime2=" + endTime2 + ", level1Cnt=" + level1Cnt
				+ ", level2Cnt=" + level2Cnt + ", level3Cnt=" + level3Cnt + ", level4Cnt=" + level4Cnt + ", level5Cnt="
				+ level5Cnt + ", isLike=" + isLike + ", isFavorite=" + isFavorite + ", isManager=" + isManager + "]";
	}

}

