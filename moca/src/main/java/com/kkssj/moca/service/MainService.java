package com.kkssj.moca.service;

import java.util.List;
import java.util.Map;

import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.model.entity.StoreVo;

public interface MainService {
	List<StoreVo> getStoresNearBy(Map<String, String> variables);

	List<StoreVo> getTrendStoresList(String tagName);

	List<ReviewVo> getRecentReviews();
	
	List<StoreVo> getHitStoresList(Map<String, String> variables);
	
	List<StoreVo> getBestStoresList();
	
	List<StoreVo> getTakeoutStoresList(Map<String, String> variables);

	List<ReviewVo> getBestReviews();
	
	List<StoreVo> getFollowersStoresList(int id);
	
	List<StoreVo> getGoodMoodStoresList(Map<String, String> variables);

	List<StoreVo> getGoodTasteStoresList(Map<String, String> variables);

	List<StoreVo> getGoodPriceStoresList(Map<String, String> variables);

	List<StoreVo> getTagStoresList(Map<String, String> variables);
}
