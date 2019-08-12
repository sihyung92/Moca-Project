package com.kkssj.moca.model.entity.kakaoAPI;

import java.util.Arrays;

public class KakaoCafeVo {
	private Documents[] documents;
	private Meta meta;
	public KakaoCafeVo() {
	}
	public Documents[] getDocuments() {
		return documents;
	}
	public void setDocuments(Documents[] documents) {
		this.documents = documents;
	}
	public Meta getMeta() {
		return meta;
	}
	public void setMeta(Meta meta) {
		this.meta = meta;
	}
	@Override
	public String toString() {
		return "KakaoCafeVo [document=" + Arrays.toString(documents) + ", meta=" + meta + "]";
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + Arrays.hashCode(documents);
		result = prime * result + ((meta == null) ? 0 : meta.hashCode());
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
		KakaoCafeVo other = (KakaoCafeVo) obj;
		if (!Arrays.equals(documents, other.documents))
			return false;
		if (meta == null) {
			if (other.meta != null)
				return false;
		} else if (!meta.equals(other.meta))
			return false;
		return true;
	}
}
