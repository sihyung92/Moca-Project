package com.kkssj.moca.model.entity;

import java.io.File;

public class ImageVo {
	private String uu_id, path, originName, url, thumbnailUrl, fieName, thumbnailFileName;
	private int storeId, reviewId, views, accountId;
	
	public ImageVo() {
		
	}

	public ImageVo(String uu_id, String path, String originName) {
		super();
		this.uu_id = uu_id;
		this.path = path;
		this.originName = originName;
		this.setUrl();
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
			if(this.path.equals("")) {
				this.url = "https://moca-pictures.s3.ap-northeast-2.amazonaws.com/"+this.uu_id+"_"+this.originName;	
				this.thumbnailUrl = "https://moca-pictures.s3.ap-northeast-2.amazonaws.com/"+this.uu_id+"_thumbnail_"+this.originName;
			}else {
				this.url = "https://moca-pictures.s3.ap-northeast-2.amazonaws.com/"+this.path+"/"+this.uu_id+"_"+this.originName;	
				this.thumbnailUrl = "https://moca-pictures.s3.ap-northeast-2.amazonaws.com/"+this.path+"/"+this.uu_id+"_thumbnail_"+this.originName;
			}
				
		}else {
			this.url = url;
		}
		
	}
	public void setUrl() {
		if(this.path.equals("")) {
			this.url = "https://moca-pictures.s3.ap-northeast-2.amazonaws.com/"+this.uu_id+"_"+this.originName;
			this.thumbnailUrl = "https://moca-pictures.s3.ap-northeast-2.amazonaws.com/"+this.uu_id+"_thumbnail_"+this.originName;
		}else {
			this.url = "https://moca-pictures.s3.ap-northeast-2.amazonaws.com/"+this.path+"/"+this.uu_id+"_"+this.originName;
			this.thumbnailUrl = "https://moca-pictures.s3.ap-northeast-2.amazonaws.com/"+this.path+"/"+this.uu_id+"_thumbnail_"+this.originName;
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
	
	public int getAccountId() {
		return accountId;
	}

	public void setAccountId(int accountId) {
		this.accountId = accountId;
	}
	
	


	public String getFieName() {
		return fieName;
	}

	public void setFieName() {
		this.fieName = this.uu_id+"_"+this.originName;
	}

	public String getThumbnailFileName() {
		return thumbnailFileName;
	}

	public void setThumbnailFileName() {
		this.thumbnailFileName = this.uu_id+"_thumbnail_"+this.originName;
	}
	
	
	

	public String getThumbnailUrl() {
		return thumbnailUrl;
	}

	public void setThumbnailUrl(String thumbnailUrl) {
		this.thumbnailUrl = thumbnailUrl;
	}

	@Override
	public String toString() {
		return "ImageVo [uu_id=" + uu_id + ", path=" + path + ", originName=" + originName + ", url=" + url
				+ ", thumbnailUrl=" + thumbnailUrl + ", storeId=" + storeId + ", reviewId=" + reviewId + ", views="
				+ views + ", accountId=" + accountId + "]";

	}
	
	
}
