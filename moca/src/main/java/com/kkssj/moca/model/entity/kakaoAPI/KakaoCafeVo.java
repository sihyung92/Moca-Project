package com.kkssj.moca.model.entity.kakaoAPI;

import java.util.Arrays;

import com.kkssj.moca.model.entity.StoreVo;

public class KakaoCafeVo {
	private StoreVo[] documents;
	private Meta meta;
	public KakaoCafeVo() {
	}
	public StoreVo[] getDocuments() {
		return documents;
	}
	public void setDocuments(StoreVo[] documents) {
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
		return "KakaoCafeVo [documents=" + Arrays.toString(documents) + ", meta=" + meta + "]";
	}
	
	
}
