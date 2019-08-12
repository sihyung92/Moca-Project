package com.kkssj.moca.model.entity.kakaoAPI;

public class Documents {
	private String address_name;
	private String category_group_name;
	private String category_name;
	private String distance;
	private Long id;
	private String phone;
	private String place_name;
	private String place_url;
	private String road_address_name;
	private String x;
	
	public Documents() {
	};
	
	public Documents(String address_name, String category_group_name, String category_name, String distance, Long id,
			String phone, String place_name, String place_url, String road_address_name, String x, String y) {
		super();
		this.address_name = address_name;
		this.category_group_name = category_group_name;
		this.category_name = category_name;
		this.distance = distance;
		this.id = id;
		this.phone = phone;
		this.place_name = place_name;
		this.place_url = place_url;
		this.road_address_name = road_address_name;
		this.x = x;
		this.y = y;
	}
	@Override
	public String toString() {
		return "Documents [address_name=" + address_name + ", category_group_name=" + category_group_name
				+ ", category_name=" + category_name + ", distance=" + distance + ", id=" + id + ", phone=" + phone
				+ ", place_name=" + place_name + ", place_url=" + place_url + ", road_address_name=" + road_address_name
				+ ", x=" + x + ", y=" + y + "]";
	}
	public String getAddress_name() {
		return address_name;
	}
	public void setAddress_name(String address_name) {
		this.address_name = address_name;
	}
	public String getCategory_group_name() {
		return category_group_name;
	}
	public void setCategory_group_name(String category_group_name) {
		this.category_group_name = category_group_name;
	}
	public String getCategory_name() {
		return category_name;
	}
	public void setCategory_name(String category_name) {
		this.category_name = category_name;
	}
	public String getDistance() {
		return distance;
	}
	public void setDistance(String distance) {
		this.distance = distance;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getPlace_name() {
		return place_name;
	}
	public void setPlace_name(String place_name) {
		this.place_name = place_name;
	}
	public String getPlace_url() {
		return place_url;
	}
	public void setPlace_url(String place_url) {
		this.place_url = place_url;
	}
	public String getRoad_address_name() {
		return road_address_name;
	}
	public void setRoad_address_name(String road_address_name) {
		this.road_address_name = road_address_name;
	}
	public String getX() {
		return x;
	}
	public void setX(String x) {
		this.x = x;
	}
	public String getY() {
		return y;
	}
	public void setY(String y) {
		this.y = y;
	}
	private String y;
}
