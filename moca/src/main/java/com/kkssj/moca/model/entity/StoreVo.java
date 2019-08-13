package com.kkssj.moca.model.entity;

import java.sql.Time;

public class StoreVo {
	private int store_Id, kakaoId, reviewCnt, wifi, parkingLot, viewCnt;
	private String name, category, url, tag, dayOff;
	private String address,roadAddress;
	private double xLocation, yLocation;
	private double tasteLevel, priceLevel,serviceLevel, moodLevel, convenienceLevel, averageLevel;
	private Time openTime,endTime;
	private String openTime2,endTime2;
	
	public StoreVo() {
		
	}
	
	public StoreVo(int store_Id, int kakaoId, String name,String category,String address,String roadAddress,double xLocation,
			 double yLocation, String url, String tag, int reviewCnt, int viewCnt,Time openTime, Time endTime,
			 int wifi, int parkingLot, String dayOff, double tasteLevel, double priceLevel, double serviceLevel, double moodLevel, double convenienceLevel)
	{
		super();
		this.store_Id = store_Id;
		this.kakaoId = kakaoId;
		this.reviewCnt = reviewCnt;
		this.wifi = wifi;
		this.parkingLot = parkingLot;
		this.viewCnt = viewCnt;
		this.name = name;
		this.category = category;
		this.url = url;
		this.tag = tag;
		this.dayOff = dayOff;
		this.address = address;
		this.roadAddress = roadAddress;
		this.xLocation = xLocation;
		this.yLocation = yLocation;
		this.tasteLevel = tasteLevel;
		this.priceLevel = priceLevel;
		this.serviceLevel = serviceLevel;
		this.moodLevel = moodLevel;
		this.convenienceLevel = convenienceLevel;
		this.openTime = openTime;
		this.endTime = endTime;
	}

	public int getStore_Id() {
		return store_Id;
	}

	public void setStore_Id(int store_Id) {
		this.store_Id = store_Id;
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

	public double getxLocation() {
		return xLocation;
	}

	public void setxLocation(double xLocation) {
		this.xLocation = xLocation;
	}

	public double getyLocation() {
		return yLocation;
	}

	public void setyLocation(double yLocation) {
		this.yLocation = yLocation;
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

	public void setMoodLevel(double modeLevel) {
		this.moodLevel = modeLevel;
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

	public Time getOpenTime() {
		return openTime;
	}

	public void setOpenTime(Time openTime) {
		this.openTime = openTime;
	}

	public Time getEndTime() {
		return endTime;
	}

	public void setEndTime(Time endTime) {
		this.endTime = endTime;
	}
	
	public int getKakaoId() {
		return kakaoId;
	}

	public void setKakaoId(int kakaoId) {
		this.kakaoId = kakaoId;
	}
	
	public String getDayOff() {
		return dayOff;
	}

	public void setDayOff(String dayOff) {
		this.dayOff = dayOff;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((address == null) ? 0 : address.hashCode());
		long temp;
		temp = Double.doubleToLongBits(averageLevel);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + ((category == null) ? 0 : category.hashCode());
		result = prime * result + ((dayOff == null) ? 0 : dayOff.hashCode());
		temp = Double.doubleToLongBits(convenienceLevel);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + kakaoId;
		temp = Double.doubleToLongBits(moodLevel);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + parkingLot;
		temp = Double.doubleToLongBits(priceLevel);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + reviewCnt;
		result = prime * result + ((roadAddress == null) ? 0 : roadAddress.hashCode());
		temp = Double.doubleToLongBits(serviceLevel);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + store_Id;
		result = prime * result + ((tag == null) ? 0 : tag.hashCode());
		temp = Double.doubleToLongBits(tasteLevel);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + ((url == null) ? 0 : url.hashCode());
		result = prime * result + viewCnt;
		result = prime * result + wifi;
		temp = Double.doubleToLongBits(xLocation);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		temp = Double.doubleToLongBits(yLocation);
		result = prime * result + (int) (temp ^ (temp >>> 32));
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
		StoreVo other = (StoreVo) obj;
		if (address == null) {
			if (other.address != null)
				return false;
		} else if (!address.equals(other.address))
			return false;
		if (Double.doubleToLongBits(averageLevel) != Double.doubleToLongBits(other.averageLevel))
			return false;
		if (category == null) {
			if (other.category != null)
				return false;
		} else if (!category.equals(other.category))
			return false;
		if (dayOff == null) {
			if (other.dayOff != null)
				return false;
		} else if (!dayOff.equals(other.dayOff))
			return false;
		if (Double.doubleToLongBits(convenienceLevel) != Double.doubleToLongBits(other.convenienceLevel))
			return false;
		if (kakaoId != other.kakaoId)
			return false;
		if (Double.doubleToLongBits(moodLevel) != Double.doubleToLongBits(other.moodLevel))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (parkingLot != other.parkingLot)
			return false;
		if (Double.doubleToLongBits(priceLevel) != Double.doubleToLongBits(other.priceLevel))
			return false;
		if (reviewCnt != other.reviewCnt)
			return false;
		if (roadAddress == null) {
			if (other.roadAddress != null)
				return false;
		} else if (!roadAddress.equals(other.roadAddress))
			return false;
		if (Double.doubleToLongBits(serviceLevel) != Double.doubleToLongBits(other.serviceLevel))
			return false;
		if (store_Id != other.store_Id)
			return false;
		if (tag == null) {
			if (other.tag != null)
				return false;
		} else if (!tag.equals(other.tag))
			return false;
		if (Double.doubleToLongBits(tasteLevel) != Double.doubleToLongBits(other.tasteLevel))
			return false;
		if (url == null) {
			if (other.url != null)
				return false;
		} else if (!url.equals(other.url))
			return false;
		if (viewCnt != other.viewCnt)
			return false;
		if (wifi != other.wifi)
			return false;
		if (Double.doubleToLongBits(xLocation) != Double.doubleToLongBits(other.xLocation))
			return false;
		if (Double.doubleToLongBits(yLocation) != Double.doubleToLongBits(other.yLocation))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "StoreVo [store_Id=" + store_Id + ", kakaoId=" + kakaoId + ", reviewCnt=" + reviewCnt + ", wifi=" + wifi
				+ ", parkingLot=" + parkingLot + ", viewCnt=" + viewCnt + ", name=" + name + ", category=" + category
				+ ", url=" + url + ", tag=" + tag + ", dayOff=" + dayOff + ", address=" + address + ", roadAddress="
				+ roadAddress + ", xLocation=" + xLocation + ", yLocation=" + yLocation + ", tasteLevel=" + tasteLevel
				+ ", priceLevel=" + priceLevel + ", serviceLevel=" + serviceLevel + ", moodLevel=" + moodLevel
				+ ", convenienceLevel=" + convenienceLevel + ", averageLevel=" + averageLevel + ", openTime=" + openTime
				+ ", endTime=" + endTime + "]";
	}
	
	
}
