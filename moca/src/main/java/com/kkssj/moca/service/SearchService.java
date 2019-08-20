package com.kkssj.moca.service;

import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.kkssj.moca.model.entity.StoreVo;

public interface SearchService {

	List<StoreVo> getListByTag(Map<String, String> variables);
	Properties getByRegion(String region);
	StoreVo getMoreData(StoreVo currentVo);
	List<StoreVo> getListFromKakaoAPI(String keyword, String region, String x, String y);
	List<StoreVo> sort(List<StoreVo> alist, String filter);
}