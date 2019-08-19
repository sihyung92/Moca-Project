package com.kkssj.moca.model.entity.kakaoAPI;

public class Meta {
	private boolean is_end;
	private int pageable_count;
	private SameName same_name;
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

	public SameName getSame_name() {
		return same_name;
	}

	public void setSame_name(SameName same_name) {
		this.same_name = same_name;
	}

	public int getTotal_count() {
		return total_count;
	}

	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}

	@Override
	public String toString() {
		return "Meta [is_end=" + is_end + ", pageable_count=" + pageable_count + ", same_name=" + same_name.toString()
				+ ", total_count=" + total_count + "]";
	}
	
	
}
