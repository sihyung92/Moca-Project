package com.kkssj.moca.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.kkssj.moca.model.StoreDao;
import com.kkssj.moca.model.entity.StoreVo;

@Service
public class MainServiceImpl implements MainService {
	@Inject
	StoreDao storeDao;
	Logger logger = LoggerFactory.getLogger(MainService.class);
	
	@Override
	public List<StoreVo> getCafesNearBy(Map<String, String> variables) {
		return storeDao.selectByDistance(variables);
	}
}
