package com.kkssj.moca.service;

import java.util.List;
import java.util.Map;

import com.kkssj.moca.model.entity.StoreVo;

public interface SearchService {

	List<StoreVo> tagSearch(Map<String, String> variables);
	
}
