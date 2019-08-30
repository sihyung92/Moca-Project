package com.kkssj.moca.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.kkssj.moca.model.ReviewDao;
import com.kkssj.moca.model.StoreDao;
import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.model.entity.StoreVo;

@Service
public class MainServiceImpl implements MainService{
	@Inject
	StoreDao storeDao;
	@Inject
	ReviewDao reviewDao;
	static Logger logger = LoggerFactory.getLogger(MainService.class);

	@Override
	public List<StoreVo> getHitStoresList(Map<String, String> variables) {
		/*
		 * List<StoreVo> list = storeDao.selectHitStoresList();
		 * //list.get(1).setStoreImg1("null"); logger.debug(list.get(1).getStoreImg1());
		 */
		return storeDao.selectHitStoresList(variables);
	}
		
	@Override
	public List<StoreVo> getStoresNearBy(Map<String, String> variables) {
		return storeDao.selectStoresNearBy(variables);
	}

	@Override
	public List<StoreVo> getTrendStoresList(String tagName) {
		return storeDao.selectTrendStoresList(tagName);
	}

	@Override
	public List<ReviewVo> getRecentReviews() {
		return reviewDao.selectRecentReviews();
	}

	@Override
	public List<StoreVo> getBestStoresList() {
		return storeDao.selectBestStoresList();
	}

	@Override
	public List<StoreVo> getTakeoutStoresList(Map<String, String> variables) {
		return storeDao.selectTakeoutStoresList(variables);
	}
}