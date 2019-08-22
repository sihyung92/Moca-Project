package com.kkssj.moca.model.entity;

public class ImageVo {
	private String uu_id, path, originName, url;
	private int storeId, reviewId, views;
	
	public ImageVo() {
		
	}
	
	public String getUu_id() {
		return uu_id;
	}

	public void setUu_id(String uu_id) {
		this.uu_id = uu_id;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String getOriginName() {
		return originName;
	}

	public void setOriginName(String originName) {
		this.originName = originName;
	}

	public String getUrl() {
		return url;
	}
	
	public void setUrl(String url) {
		if(this.uu_id!=null) {
			this.url = "https://moca-pictures.s3.ap-northeast-2.amazonaws.com/"+this.path+this.uu_id+"_"+this.originName;			
		}else {
			this.url = url;
		}
	}

	public int getStoreId() {
		return storeId;
	}

	public void setStoreId(int storeId) {
		this.storeId = storeId;
	}

	public int getReviewId() {
		return reviewId;
	}

	public void setReviewId(int reviewId) {
		this.reviewId = reviewId;
	}

	public int getViews() {
		return views;
	}

	public void setViews(int views) {
		this.views = views;
	}

	@Override
	public String toString() {
		return "ImageVo [uu_id=" + uu_id + ", path=" + path + ", originName=" + originName + ", url=" + url
				+ ", storeId=" + storeId + ", reviewId=" + reviewId + ", views=" + views + "]";
	}
	
	
}
