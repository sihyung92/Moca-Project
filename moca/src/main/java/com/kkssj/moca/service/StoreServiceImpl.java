package com.kkssj.moca.service;

import java.util.ArrayList;
import java.util.List;

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
	

	@Override
	public List<ReviewVo> getReviewList(int accountId, int storeId) {
		return reviewDao.selectAll(accountId, storeId);
	}

	@Override
	public void getStore(Model model, int accountId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void addStore(StoreVo storeVo) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public int addLikeHate(int review_id, int accountId, int isLike) {
		if(reviewDao.insertLikeHateOne(review_id, accountId, isLike ) ==1) {
			if(isLike ==1) {
				if(reviewDao.updateLikeCount(review_id, reviewDao.selectLikeCount(review_id)+1)==1) {
					return 1;
				}
			}else if(isLike==-1) {
				if(reviewDao.updateHateCount(review_id, reviewDao.selectHateCount(review_id)-1)==1) {
					return 1;
				}
			}
		}
		return -1;
	}

	@Override
	public int editLikeHate(int review_id, int accountId, int isLike) {
		return reviewDao.updateLikeHateOne(review_id, accountId, isLike);
	}

	@Override
	public int deleteLikeHate(int review_id, int accountId) {
		return reviewDao.deleteLikeHateOne(review_id, accountId);
	}

	

}
