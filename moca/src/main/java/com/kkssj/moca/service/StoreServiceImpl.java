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
		reviewDao.insertLikeHate(review_id, accountId, isLike );
		if(isLike ==1) {
			return reviewDao.updateLikeCount(review_id, reviewDao.selectLikeCount(review_id)+1) ;
		}else { 
			return reviewDao.updateHateCount(review_id, reviewDao.selectHateCount(review_id)+1) ;
		}
	}
	@Override
	public int deleteLikeHate(int review_id, int accountId, int isLike) {
		reviewDao.deleteLikeHate(review_id, accountId);
		if(isLike ==1) {
			return reviewDao.updateLikeCount(review_id, reviewDao.selectLikeCount(review_id)-1) ;
		}else { 
			return reviewDao.updateHateCount(review_id, reviewDao.selectHateCount(review_id)-1) ;
		}

	}
	@Override
	public int editLikeHate(int review_id, int accountId, int isLike) {
		reviewDao.updateLikeHate(review_id, accountId, isLike);
		reviewDao.updateLikeCount(review_id, reviewDao.selectLikeCount(review_id)+isLike) ;
		reviewDao.updateHateCount(review_id, reviewDao.selectHateCount(review_id)-isLike) ;
		return 1;
	}

	

	@Override
	public int syncReviewLikeHate() {
		List<ReviewVo> list = reviewDao.selectAllReview();
		int review_id;
		for (int i = 0; i < list.size(); i++) {
			review_id = list.get(i).getReview_id();
			reviewDao.updateLikeCount(review_id, reviewDao.selectLikeHateLike(review_id));
			reviewDao.updateHateCount(review_id, reviewDao.selectLikeHateHate(review_id));
		}
		
		
		return 1;
	}

	@Override
	public ReviewVo addReview(ReviewVo reviewVo) {
		//평균 점수 계산
		reviewVo.calAverageLevel();
		
		//정상적으로 입력되었을때
		if(reviewDao.insertReview(reviewVo) ==1) {
			//상점에 대한 평점 동기화
			List<ReviewVo> list = reviewDao.selectStoreAllReview(reviewVo.getStoreId());
			StoreVo storeVo = new StoreVo();
			storeVo.setStore_Id(reviewVo.getStoreId());
			storeVo.calAllLevel(list);
			storeDao.updateLevel(storeVo);
			
			
			// 방금 입력한 Vo를 가져온다. 
			return reviewDao.selectAddedOne(reviewVo.getAccountId());
		}
		return null;
	}

	@Override
	public int editReview(ReviewVo reviewVo) {
		
		//평균 점수 다시 계산
		reviewVo.calAverageLevel();
		
		//업데이트 된 행의 수를 반환
		return reviewDao.updateReview(reviewVo);
		
	}


}
