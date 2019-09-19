package com.kkssj.moca.model.entity;

import java.io.File;

public class ImageVo {
	private String uu_id, path, originName, url, thumbnailUrl, fileName, thumbnailFileName;
	private int store_id, review_id, views, account_id;
	
	
	
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

	public int getStore_id() {
		return store_id;
	}

	public void setStore_id(int store_id) {
		this.store_id = store_id;
	}

	public int getReview_id() {
		return review_id;
	}

	public void setReview_id(int review_id) {
		this.review_id = review_id;
	}

	public int getAccount_id() {
		return account_id;
	}

	public void setAccount_id(int account_id) {
		this.account_id = account_id;
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
				this.url = "https://team-moca.s3.ap-northeast-2.amazonaws.com/"+this.uu_id+"_"+this.originName;	
				this.thumbnailUrl = "https://team-moca.s3.ap-northeast-2.amazonaws.com/"+this.uu_id+"_thumbnail_"+this.originName;
			}else {
				this.url = "https://team-moca.s3.ap-northeast-2.amazonaws.com/"+this.path+"/"+this.uu_id+"_"+this.originName;	
				this.thumbnailUrl = "https://team-moca.s3.ap-northeast-2.amazonaws.com/"+this.path+"/"+this.uu_id+"_thumbnail_"+this.originName;
			}
				
		}else {
			this.url = url;
		}
		
	}
	
	public void setUrl() {
		if(this.path.equals("")) {
			this.url = "https://team-moca.s3.ap-northeast-2.amazonaws.com/"+this.uu_id+"_"+this.originName;
			this.thumbnailUrl = "https://team-moca.s3.ap-northeast-2.amazonaws.com/"+this.uu_id+"_thumbnail_"+this.originName;
		}else {
			this.url = "https://team-moca.s3.ap-northeast-2.amazonaws.com/"+this.path+"/"+this.uu_id+"_"+this.originName;
			this.thumbnailUrl = "https://team-moca.s3.ap-northeast-2.amazonaws.com/"+this.path+"/"+this.uu_id+"_thumbnail_"+this.originName;
		}
		
	}

	public int getViews() {
		return views;
	}

	public void setViews(int views) {
		this.views = views;
	}
	

	public String getFileName() {
		return fileName;
	}

	public void setFileName() {
		this.fileName = this.uu_id+"_"+this.originName;
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
				+ ", thumbnailUrl=" + thumbnailUrl + ", fileName=" + fileName + ", thumbnailFileName="
				+ thumbnailFileName + ", store_id=" + store_id + ", review_id=" + review_id + ", views=" + views
				+ ", account_id=" + account_id + "]";
	}

	public void setDelImageVo(String url) {
		String pathUu_idOriginName = url.split(".com/")[1];
		String path = pathUu_idOriginName.substring(0,pathUu_idOriginName.lastIndexOf("/"));
		String uu_idOriginName = pathUu_idOriginName.substring(pathUu_idOriginName.lastIndexOf("/")+1);
		setPath(path);
		setUu_id(uu_idOriginName.split("_")[0]);
		if(uu_idOriginName.contains("thumbnail")) {
			setOriginName(uu_idOriginName.split("_thumbnail_")[1]);		
		}else {
			//UUID의 길이 36, 언더바(_)의 길이 1 해서 37 이후로 잡음
			setOriginName(uu_idOriginName.substring(37));
		}
		
		setFileName();
		setThumbnailFileName();
		setUrl();
		System.out.println(this.toString());
		
	}
	public void setImageVo(String url) {
		setDelImageVo(url);
	}

	public void setUu_idPathOriginNameByUrl() {
		this.fileName = this.url.split(".com/")[1];
		String uu_idFileName = this.fileName.split("/")[this.fileName.split("/").length-1];
		this.uu_id = uu_idFileName.split("_")[0];
		
	}

	
	
}
