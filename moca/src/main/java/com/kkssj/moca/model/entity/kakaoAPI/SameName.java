package com.kkssj.moca.model.entity.kakaoAPI;

import java.util.Arrays;

public class SameName {

	private String[] region;
	private String keyword, selected_region;
	public String[] getRegion() {
		return region;
	}
	public void setRegion(String[] region) {
		this.region = region;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getSelected_region() {
		return selected_region;
	}
	public void setSelected_region(String selected_region) {
		this.selected_region = selected_region;
	}
	@Override
	public String toString() {
		return "SameName [region=" + Arrays.toString(region) + ", keyword=" + keyword + ", selected_region="
				+ selected_region + "]";
	}

	
	
}
