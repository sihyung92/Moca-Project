package com.kkssj.moca.service;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.kkssj.moca.model.StoreDao;
import com.kkssj.moca.model.entity.StoreVo;

@Service
public class MainServiceImpl implements MainService{
	@Inject
	StoreDao storeDao;
	
	static Logger logger = LoggerFactory.getLogger(MainService.class);


	@Override
	public List<StoreVo> getHitStoresList() {
		logger.debug(storeDao.selectHitStoresList().toString());
		return storeDao.selectHitStoresList();
	}

}
