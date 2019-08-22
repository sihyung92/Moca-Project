package com.kkssj.moca.model.entity;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class StoreVo {
	private int store_Id, kakaoId, reviewCnt, wifi, parkingLot, viewCnt;
	private String name, category, url, tag, dayOff, tel;
	private String address,roadAddress;
	private String xLocation, yLocation, distance;
	private String logoImg, reviewImg;
	private double tasteLevel, priceLevel,serviceLevel, moodLevel, convenienceLevel, averageLevel;
	private Date openTime,endTime;
	private String openTime2,endTime2;
	
	public StoreVo() {
		
	}
	
	public StoreVo(int store_Id, int kakaoId, String name,String category,String address,String roadAddress,String xLocation,
			 String yLocation, String url, String tag, int reviewCnt, int viewCnt,Date openTime, Date endTime,
			 int wifi, int parkingLot, String dayOff, String tel, 
			 double tasteLevel, double priceLevel, double serviceLevel, double moodLevel, double convenienceLevel, double averageLevel,
			 String logoImg, String reviewImg){
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
		this.tel = tel;
		this.address = address;
		this.roadAddress = roadAddress;
		this.xLocation = xLocation;
		this.yLocation = yLocation;
		this.tasteLevel = tasteLevel;
		this.priceLevel = priceLevel;
		this.serviceLevel = serviceLevel;
		this.moodLevel = moodLevel;
		this.convenienceLevel = convenienceLevel;
		this.averageLevel = averageLevel;
		this.openTime = openTime;
		this.endTime = endTime;
		this.setLogoImg(logoImg);
		this.setReviewImg(reviewImg);
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

	public void setOpenTime2(String openTime2) {
		DateFormat fommatter = new SimpleDateFormat("HH:mm");
		try {
			this.openTime = (Date) fommatter.parse(openTime2);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		this.openTime2 = openTime2;
	}

	public void setEndTime2(String endTime2) {
		DateFormat fommatter = new SimpleDateFormat("HH:mm");
		try {
			this.endTime = (Date) fommatter.parse(endTime2);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		this.endTime2 = endTime2;
	}
	
	public String getLogoImg() {
		return logoImg;
	}

	public void setLogoImg(String logoImg) {
		this.logoImg = logoImg;
	}

	public String getReviewImg() {
		return reviewImg;
	}

	public void setReviewImg(String reviewImg) {
		this.reviewImg = reviewImg;
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
		temp = Double.doubleToLongBits(convenienceLevel);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + ((dayOff == null) ? 0 : dayOff.hashCode());
		result = prime * result + ((distance == null) ? 0 : distance.hashCode());
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
		result = prime * result + ((tel == null) ? 0 : tel.hashCode());
		result = prime * result + ((url == null) ? 0 : url.hashCode());
		result = prime * result + viewCnt;
		result = prime * result + wifi;
		result = prime * result + ((xLocation == null) ? 0 : xLocation.hashCode());
		result = prime * result + ((yLocation == null) ? 0 : yLocation.hashCode());
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
		if (Double.doubleToLongBits(convenienceLevel) != Double.doubleToLongBits(other.convenienceLevel))
			return false;
		if (dayOff == null) {
			if (other.dayOff != null)
				return false;
		} else if (!dayOff.equals(other.dayOff))
			return false;
		if (distance == null) {
			if (other.distance != null)
				return false;
		} else if (!distance.equals(other.distance))
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
		if (viewCnt != other.viewCnt)
			return false;
		if (wifi != other.wifi)
			return false;
		if (xLocation == null) {
			if (other.xLocation != null)
				return false;
		} else if (!xLocation.equals(other.xLocation))
			return false;
		if (yLocation == null) {
			if (other.yLocation != null)
				return false;
		} else if (!yLocation.equals(other.yLocation))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "StoreVo [store_Id=" + store_Id + ", kakaoId=" + kakaoId + ", reviewCnt=" + reviewCnt + ", wifi=" + wifi
				+ ", parkingLot=" + parkingLot + ", viewCnt=" + viewCnt + ", name=" + name + ", category=" + category
				+ ", url=" + url + ", tag=" + tag + ", dayOff=" + dayOff + ", tel=" + tel + ", address=" + address
				+ ", roadAddress=" + roadAddress + ", xLocation=" + xLocation + ", yLocation=" + yLocation
				+ ", distance=" + distance + ", logoImg=" + logoImg + ", reviewImg=" + reviewImg + ", tasteLevel="
				+ tasteLevel + ", priceLevel=" + priceLevel + ", serviceLevel=" + serviceLevel + ", moodLevel="
				+ moodLevel + ", convenienceLevel=" + convenienceLevel + ", averageLevel=" + averageLevel
				+ ", openTime=" + openTime + ", endTime=" + endTime + ", openTime2=" + openTime2 + ", endTime2="
				+ endTime2 + "]";
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
	
}
