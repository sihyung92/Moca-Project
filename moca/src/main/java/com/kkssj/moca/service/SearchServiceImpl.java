package com.kkssj.moca.service;

import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.kkssj.moca.model.StoreDao;
import com.kkssj.moca.model.entity.StoreVo;

@Service
public class SearchServiceImpl implements SearchService {
	@Inject
	StoreDao storeDao;
	
	@Override
	public List<StoreVo> getListByTag(Map<String, String> variables) {		
		//(할일)정렬해주기
		return storeDao.selectListByTag(variables);
	}

	@Override
	public StoreVo checkByKakaoId(int kakaoId) {		
		return storeDao.selectByKakaoId(kakaoId);
	}

	@Override
	public Properties getByRegion(String region) {
		return storeDao.selectByRegion(region);
	}

}
