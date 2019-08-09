package com.kkssj.moca.model.entity;

public class StoreVo {
	private int storeId, reviewCount, isWifi, isPark, viewCount;
	private String storeName, categoryName, storeUrl, tag, businessHour;
	private String addressName,roadAddressName, xLocation, yLocation;
	private double tasteLevel, priceLevel,serviceLevel, modeLevel, convenientLevel, averageLevel;
	
	
	public StoreVo(int storeId, int reviewCount, int isWifi, int isPark, int viewCount, String storeName,
			String categoryName, String storeUrl, String tag, String businessHour, String addressName,
			String roadAddressName, String xLocation, String yLocation, double tasteLevel, double priceLevel,
			double serviceLevel, double modeLevel, double convenientLevel, double averageLevel) {
		super();
		this.storeId = storeId;
		this.reviewCount = reviewCount;
		this.isWifi = isWifi;
		this.isPark = isPark;
		this.viewCount = viewCount;
		this.storeName = storeName;
		this.categoryName = categoryName;
		this.storeUrl = storeUrl;
		this.tag = tag;
		this.businessHour = businessHour;
		this.addressName = addressName;
		this.roadAddressName = roadAddressName;
		this.xLocation = xLocation;
		this.yLocation = yLocation;
		this.tasteLevel = tasteLevel;
		this.priceLevel = priceLevel;
		this.serviceLevel = serviceLevel;
		this.modeLevel = modeLevel;
		this.convenientLevel = convenientLevel;
		this.averageLevel = averageLevel;
	}
	
	
	public int getStoreId() {
		return storeId;
	}
	public void setStoreId(int storeId) {
		this.storeId = storeId;
	}
	public int getReviewCount() {
		return reviewCount;
	}
	public void setReviewCount(int reviewCount) {
		this.reviewCount = reviewCount;
	}
	public int getIsWifi() {
		return isWifi;
	}
	public void setIsWifi(int isWifi) {
		this.isWifi = isWifi;
	}
	public int getIsPark() {
		return isPark;
	}
	public void setIsPark(int isPark) {
		this.isPark = isPark;
	}
	public int getViewCount() {
		return viewCount;
	}
	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}
	public String getStoreName() {
		return storeName;
	}
	public void setStoreName(String storeName) {
		this.storeName = storeName;
	}
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public String getStoreUrl() {
		return storeUrl;
	}
	public void setStoreUrl(String storeUrl) {
		this.storeUrl = storeUrl;
	}
	public String getTag() {
		return tag;
	}
	public void setTag(String tag) {
		this.tag = tag;
	}
	public String getBusinessHour() {
		return businessHour;
	}
	public void setBusinessHour(String businessHour) {
		this.businessHour = businessHour;
	}
	public String getAddressName() {
		return addressName;
	}
	public void setAddressName(String addressName) {
		this.addressName = addressName;
	}
	public String getRoadAddressName() {
		return roadAddressName;
	}
	public void setRoadAddressName(String roadAddressName) {
		this.roadAddressName = roadAddressName;
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
	public double getModeLevel() {
		return modeLevel;
	}
	public void setModeLevel(double modeLevel) {
		this.modeLevel = modeLevel;
	}
	public double getConvenientLevel() {
		return convenientLevel;
	}
	public void setConvenientLevel(double convenientLevel) {
		this.convenientLevel = convenientLevel;
	}
	public double getAverageLevel() {
		return averageLevel;
	}
	public void setAverageLevel(double averageLevel) {
		this.averageLevel = averageLevel;
	}
	
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((addressName == null) ? 0 : addressName.hashCode());
		long temp;
		temp = Double.doubleToLongBits(averageLevel);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + ((businessHour == null) ? 0 : businessHour.hashCode());
		result = prime * result + ((categoryName == null) ? 0 : categoryName.hashCode());
		temp = Double.doubleToLongBits(convenientLevel);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + isPark;
		result = prime * result + isWifi;
		temp = Double.doubleToLongBits(modeLevel);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		temp = Double.doubleToLongBits(priceLevel);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + reviewCount;
		result = prime * result + ((roadAddressName == null) ? 0 : roadAddressName.hashCode());
		temp = Double.doubleToLongBits(serviceLevel);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + storeId;
		result = prime * result + ((storeName == null) ? 0 : storeName.hashCode());
		result = prime * result + ((storeUrl == null) ? 0 : storeUrl.hashCode());
		result = prime * result + ((tag == null) ? 0 : tag.hashCode());
		temp = Double.doubleToLongBits(tasteLevel);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + viewCount;
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
		if (addressName == null) {
			if (other.addressName != null)
				return false;
		} else if (!addressName.equals(other.addressName))
			return false;
		if (Double.doubleToLongBits(averageLevel) != Double.doubleToLongBits(other.averageLevel))
			return false;
		if (businessHour == null) {
			if (other.businessHour != null)
				return false;
		} else if (!businessHour.equals(other.businessHour))
			return false;
		if (categoryName == null) {
			if (other.categoryName != null)
				return false;
		} else if (!categoryName.equals(other.categoryName))
			return false;
		if (Double.doubleToLongBits(convenientLevel) != Double.doubleToLongBits(other.convenientLevel))
			return false;
		if (isPark != other.isPark)
			return false;
		if (isWifi != other.isWifi)
			return false;
		if (Double.doubleToLongBits(modeLevel) != Double.doubleToLongBits(other.modeLevel))
			return false;
		if (Double.doubleToLongBits(priceLevel) != Double.doubleToLongBits(other.priceLevel))
			return false;
		if (reviewCount != other.reviewCount)
			return false;
		if (roadAddressName == null) {
			if (other.roadAddressName != null)
				return false;
		} else if (!roadAddressName.equals(other.roadAddressName))
			return false;
		if (Double.doubleToLongBits(serviceLevel) != Double.doubleToLongBits(other.serviceLevel))
			return false;
		if (storeId != other.storeId)
			return false;
		if (storeName == null) {
			if (other.storeName != null)
				return false;
		} else if (!storeName.equals(other.storeName))
			return false;
		if (storeUrl == null) {
			if (other.storeUrl != null)
				return false;
		} else if (!storeUrl.equals(other.storeUrl))
			return false;
		if (tag == null) {
			if (other.tag != null)
				return false;
		} else if (!tag.equals(other.tag))
			return false;
		if (Double.doubleToLongBits(tasteLevel) != Double.doubleToLongBits(other.tasteLevel))
			return false;
		if (viewCount != other.viewCount)
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
		return "StoreVo [storeId=" + storeId + ", reviewCount=" + reviewCount + ", isWifi=" + isWifi + ", isPark="
				+ isPark + ", viewCount=" + viewCount + ", storeName=" + storeName + ", categoryName=" + categoryName
				+ ", storeUrl=" + storeUrl + ", tag=" + tag + ", businessHour=" + businessHour + ", addressName="
				+ addressName + ", roadAddressName=" + roadAddressName + ", xLocation=" + xLocation + ", yLocation="
				+ yLocation + ", tasteLevel=" + tasteLevel + ", priceLevel=" + priceLevel + ", serviceLevel="
				+ serviceLevel + ", modeLevel=" + modeLevel + ", convenientLevel=" + convenientLevel + ", averageLevel="
				+ averageLevel + "]";
	}
}
