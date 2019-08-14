package com.kkssj.moca.service;

import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.kkssj.moca.model.entity.StoreVo;

public interface SearchService {

	List<StoreVo> getListByTag(Map<String, String> variables);
	StoreVo checkByKakaoId(int kakaoId);
	Properties getByRegion(String region);
}
