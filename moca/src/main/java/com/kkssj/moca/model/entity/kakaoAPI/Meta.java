package com.kkssj.moca.model.entity.kakaoAPI;

public class Meta {
	private boolean is_end;
	private int pageable_count;
	private String sname_name;
	private int total_count;
	
	public Meta() {
	}
	
	public boolean isIs_end() {
		return is_end;
	}
	public void setIs_end(boolean is_end) {
		this.is_end = is_end;
	}
	public int getPageable_count() {
		return pageable_count;
	}
	public void setPageable_count(int pageable_count) {
		this.pageable_count = pageable_count;
	}
	public String getSname_name() {
		return sname_name;
	}
	public void setSname_name(String sname_name) {
		this.sname_name = sname_name;
	}
	public int getTotal_count() {
		return total_count;
	}
	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + (is_end ? 1231 : 1237);
		result = prime * result + pageable_count;
		result = prime * result + ((sname_name == null) ? 0 : sname_name.hashCode());
		result = prime * result + total_count;
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
		Meta other = (Meta) obj;
		if (is_end != other.is_end)
			return false;
		if (pageable_count != other.pageable_count)
			return false;
		if (sname_name == null) {
			if (other.sname_name != null)
				return false;
		} else if (!sname_name.equals(other.sname_name))
			return false;
		if (total_count != other.total_count)
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "Meta [is_end=" + is_end + ", pageable_count=" + pageable_count + ", sname_name=" + sname_name
				+ ", total_count=" + total_count + "]";
	}
}
