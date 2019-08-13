package com.kkssj.moca.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.kkssj.moca.model.StoreDao;
import com.kkssj.moca.model.entity.StoreVo;

@Service
public class SearchServiceImpl implements SearchService {
	@Inject
	StoreDao storeDao;
	
	@Override
	public List<StoreVo> tagSearch(Map<String, String> variables) {		
		//(할일)정렬해주기
		return storeDao.selectByTag(variables);
	}

}
