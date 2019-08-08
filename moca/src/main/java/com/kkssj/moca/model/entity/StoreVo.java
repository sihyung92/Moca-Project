package com.kkssj.moca.model.entity;

public class StoreVo {
	private int storeId, reviewCount, isWifi, isPark, viewCount;
	private String storeName, categoryName, storeUrl, tag, businessHour;
	private String addressName,roadAddressName, xLoc, yLoc;
	private double tasteLev, priceLev,serviceLev, modeLev, convenientLev, totalLev;
	public StoreVo(int storeId, int reviewCount, int isWifi, int isPark, int viewCount, String storeName,
			String categoryName, String storeUrl, String tag, String businessHour, String addressName,
			String roadAddressName, String xLoc, String yLoc, double tasteLev, double priceLev, double serviceLev,
			double modeLev, double convenientLev, double totalLev) {
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
		this.xLoc = xLoc;
		this.yLoc = yLoc;
		this.tasteLev = tasteLev;
		this.priceLev = priceLev;
		this.serviceLev = serviceLev;
		this.modeLev = modeLev;
		this.convenientLev = convenientLev;
		this.totalLev = totalLev;
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
	public String getxLoc() {
		return xLoc;
	}
	public void setxLoc(String xLoc) {
		this.xLoc = xLoc;
	}
	public String getyLoc() {
		return yLoc;
	}
	public void setyLoc(String yLoc) {
		this.yLoc = yLoc;
	}
	public double getTasteLev() {
		return tasteLev;
	}
	public void setTasteLev(double tasteLev) {
		this.tasteLev = tasteLev;
	}
	public double getPriceLev() {
		return priceLev;
	}
	public void setPriceLev(double priceLev) {
		this.priceLev = priceLev;
	}
	public double getServiceLev() {
		return serviceLev;
	}
	public void setServiceLev(double serviceLev) {
		this.serviceLev = serviceLev;
	}
	public double getModeLev() {
		return modeLev;
	}
	public void setModeLev(double modeLev) {
		this.modeLev = modeLev;
	}
	public double getConvenientLev() {
		return convenientLev;
	}
	public void setConvenientLev(double convenientLev) {
		this.convenientLev = convenientLev;
	}
	public double getTotalLev() {
		return totalLev;
	}
	public void setTotalLev(double totalLev) {
		this.totalLev = totalLev;
	}
	@Override
	public String toString() {
		return "StoreVo [storeId=" + storeId + ", reviewCount=" + reviewCount + ", isWifi=" + isWifi + ", isPark="
				+ isPark + ", viewCount=" + viewCount + ", storeName=" + storeName + ", categoryName=" + categoryName
				+ ", storeUrl=" + storeUrl + ", tag=" + tag + ", businessHour=" + businessHour + ", addressName="
				+ addressName + ", roadAddressName=" + roadAddressName + ", xLoc=" + xLoc + ", yLoc=" + yLoc
				+ ", tasteLev=" + tasteLev + ", priceLev=" + priceLev + ", serviceLev=" + serviceLev + ", modeLev="
				+ modeLev + ", convenientLev=" + convenientLev + ", totalLev=" + totalLev + "]";
	}

	
}
