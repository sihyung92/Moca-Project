package com.kkssj.moca.service;

import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.springframework.ui.Model;

import com.kkssj.moca.model.entity.StoreVo;

public interface SearchService {

	List<StoreVo> getListByTag(Map<String, String> variables);
	StoreVo getMoreData(StoreVo currentVo);
	List<StoreVo> getListFromKakaoAPI(String keyword, String[] region, String x, String y, Model model);
	List<StoreVo> sort(List<StoreVo> alist, String filter);
}
