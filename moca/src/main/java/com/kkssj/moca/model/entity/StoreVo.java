package com.kkssj.moca.model.entity;

public class StoreVo {
	private int storeId, reviewCount, isWifi, isPark;
	private String storeName, addressName , categoryDepth1, categoryDepth2, homepageUrl,tag, businessHour;
	private double tasteLev, priceLev,serviceLev, modeLev, convenientLev, totalLev;
	
	public StoreVo(int storeId, int reviewCount, int isWifi, int isPark, String storeName, String addressName,
			String categoryDepth1, String categoryDepth2, String homepageUrl, String tag, String businessHour,
			double tasteLev, double priceLev, double serviceLev, double modeLev, double convenientLev,
			double totalLev) {
		super();
		this.storeId = storeId;
		this.reviewCount = reviewCount;
		this.isWifi = isWifi;
		this.isPark = isPark;
		this.storeName = storeName;
		this.addressName = addressName;
		this.categoryDepth1 = categoryDepth1;
		this.categoryDepth2 = categoryDepth2;
		this.homepageUrl = homepageUrl;
		this.tag = tag;
		this.businessHour = businessHour;
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
	public String getStoreName() {
		return storeName;
	}
	public void setStoreName(String storeName) {
		this.storeName = storeName;
	}
	public String getAddressName() {
		return addressName;
	}
	public void setAddressName(String addressName) {
		this.addressName = addressName;
	}
	public String getCategoryDepth1() {
		return categoryDepth1;
	}
	public void setCategoryDepth1(String categoryDepth1) {
		this.categoryDepth1 = categoryDepth1;
	}
	public String getCategoryDepth2() {
		return categoryDepth2;
	}
	public void setCategoryDepth2(String categoryDepth2) {
		this.categoryDepth2 = categoryDepth2;
	}
	public String getHomepageUrl() {
		return homepageUrl;
	}
	public void setHomepageUrl(String homepageUrl) {
		this.homepageUrl = homepageUrl;
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
				+ isPark + ", storeName=" + storeName + ", addressName=" + addressName + ", categoryDepth1="
				+ categoryDepth1 + ", categoryDepth2=" + categoryDepth2 + ", homepageUrl=" + homepageUrl + ", tag="
				+ tag + ", businessHour=" + businessHour + ", tasteLev=" + tasteLev + ", priceLev=" + priceLev
				+ ", serviceLev=" + serviceLev + ", modeLev=" + modeLev + ", convenientLev=" + convenientLev
				+ ", totalLev=" + totalLev + "]";
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((addressName == null) ? 0 : addressName.hashCode());
		result = prime * result + ((businessHour == null) ? 0 : businessHour.hashCode());
		result = prime * result + ((categoryDepth1 == null) ? 0 : categoryDepth1.hashCode());
		result = prime * result + ((categoryDepth2 == null) ? 0 : categoryDepth2.hashCode());
		long temp;
		temp = Double.doubleToLongBits(convenientLev);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + ((homepageUrl == null) ? 0 : homepageUrl.hashCode());
		result = prime * result + isPark;
		result = prime * result + isWifi;
		temp = Double.doubleToLongBits(modeLev);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		temp = Double.doubleToLongBits(priceLev);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + reviewCount;
		temp = Double.doubleToLongBits(serviceLev);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + storeId;
		result = prime * result + ((storeName == null) ? 0 : storeName.hashCode());
		result = prime * result + ((tag == null) ? 0 : tag.hashCode());
		temp = Double.doubleToLongBits(tasteLev);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		temp = Double.doubleToLongBits(totalLev);
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
		if (addressName == null) {
			if (other.addressName != null)
				return false;
		} else if (!addressName.equals(other.addressName))
			return false;
		if (businessHour == null) {
			if (other.businessHour != null)
				return false;
		} else if (!businessHour.equals(other.businessHour))
			return false;
		if (categoryDepth1 == null) {
			if (other.categoryDepth1 != null)
				return false;
		} else if (!categoryDepth1.equals(other.categoryDepth1))
			return false;
		if (categoryDepth2 == null) {
			if (other.categoryDepth2 != null)
				return false;
		} else if (!categoryDepth2.equals(other.categoryDepth2))
			return false;
		if (Double.doubleToLongBits(convenientLev) != Double.doubleToLongBits(other.convenientLev))
			return false;
		if (homepageUrl == null) {
			if (other.homepageUrl != null)
				return false;
		} else if (!homepageUrl.equals(other.homepageUrl))
			return false;
		if (isPark != other.isPark)
			return false;
		if (isWifi != other.isWifi)
			return false;
		if (Double.doubleToLongBits(modeLev) != Double.doubleToLongBits(other.modeLev))
			return false;
		if (Double.doubleToLongBits(priceLev) != Double.doubleToLongBits(other.priceLev))
			return false;
		if (reviewCount != other.reviewCount)
			return false;
		if (Double.doubleToLongBits(serviceLev) != Double.doubleToLongBits(other.serviceLev))
			return false;
		if (storeId != other.storeId)
			return false;
		if (storeName == null) {
			if (other.storeName != null)
				return false;
		} else if (!storeName.equals(other.storeName))
			return false;
		if (tag == null) {
			if (other.tag != null)
				return false;
		} else if (!tag.equals(other.tag))
			return false;
		if (Double.doubleToLongBits(tasteLev) != Double.doubleToLongBits(other.tasteLev))
			return false;
		if (Double.doubleToLongBits(totalLev) != Double.doubleToLongBits(other.totalLev))
			return false;
		return true;
	}
}
