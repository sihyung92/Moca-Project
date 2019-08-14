package com.kkssj.moca.service;

import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.kkssj.moca.model.ReviewDao;
import com.kkssj.moca.model.StoreDao;
import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.model.entity.StoreVo;

@Service
public class StoreServiceImpl implements StoreService{

	@Inject
	ReviewDao reviewDao;
	
	@Inject
	StoreDao storeDao;

	@Override
	public StoreVo getStore(int store_Id) throws SQLException {
		return storeDao.selectOne(store_Id);
	}

	@Override
	public StoreVo addStore(StoreVo storeVo) throws SQLException {
		
		storeDao.insertOne(storeVo);
		storeVo = storeDao.selectByKakaoId(storeVo.getKakaoId());
		
		return storeVo;
	}

	@Override
	public int editStore(StoreVo storeVo) throws SQLException {
		return storeDao.updateOne(storeVo);
	}
	

	@Override
	public List<ReviewVo> getReviewList(int accountId, int storeId) {
		return reviewDao.selectAll(accountId, storeId);
	}

	@Override
	public int addLikeHate(int review_id, int accountId, int isLike) {
		if(reviewDao.insertLikeHateOne(review_id, accountId, isLike ) ==1) {
			return reviewDao.updateLikeCount(review_id, reviewDao.selectLikeCount(review_id)+isLike) ;
		}
		return -1;
	}

	@Override
	public int editLikeHate(int review_id, int accountId, int isLike) {
		if(reviewDao.updateLikeHateOne(review_id, accountId, isLike) ==1) {
			return reviewDao.updateLikeCount(review_id, reviewDao.selectLikeCount(review_id)+isLike) ;
		}
		return -1;
	}

	@Override
	public int deleteLikeHate(int review_id, int accountId) {
		return reviewDao.deleteLikeHateOne(review_id, accountId);
	}


}
