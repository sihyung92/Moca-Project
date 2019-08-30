package com.kkssj.moca.service;

import java.util.List;
import java.util.Map;

import com.kkssj.moca.model.entity.StoreVo;

public interface MainService {

	List<StoreVo> getHitStoresList(Map<String, String> variables);
	
	List<StoreVo> getBestStoresList();
	
	List<StoreVo> getTakeoutStoresList(Map<String, String> variables);

}
