package com.kkssj.moca.service;

import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.kkssj.moca.model.ReviewDao;
import com.kkssj.moca.model.ReviewDaoImpl;
import com.kkssj.moca.model.StoreDao;
import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.model.entity.StoreVo;

@Service
public class StoreServiceImpl implements StoreService{
	private static final Logger logger = LoggerFactory.getLogger(StoreServiceImpl.class);

	@Inject
	ReviewDao reviewDao;
	
	@Inject
	StoreDao storeDao;
	
	//////////////////////////////
	//Store

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
	public int editStore(int accountId, StoreVo storeVo) throws SQLException {
		
		int result = storeDao.updateOne(storeVo);
		System.out.println("result : "+result);
		if(result>0) {
			int history = storeDao.insertStoreInfoHistory(accountId, storeVo);
			System.out.println("history : "+history);
		}
		return result;
	}
	
	////////////////////////////////
	//review
	
	@Override
	public List<ReviewVo> getReviewList(int accountId, int storeId) {
		return reviewDao.selectAll(accountId, storeId);
	}
	@Override
	public ReviewVo addReview(ReviewVo reviewVo) {
		//��� ���� ���
		reviewVo.calAverageLevel();
		
		//���������� �ԷµǾ�����
		if(reviewDao.insertReview(reviewVo) ==1) {
			//������ ���� ���� ����ȭ
			List<ReviewVo> list = reviewDao.selectAllReviewLevel(reviewVo.getStoreId());
			StoreVo storeVo = new StoreVo();
			storeVo.setStore_Id(reviewVo.getStoreId());
			storeVo.calAllLevel(list);
			logger.debug(storeVo.toString());
			storeDao.updateLevel(storeVo);
			
			
			// ��� �Է��� Vo�� �����´�. 
			return reviewDao.selectAddedOne(reviewVo.getAccountId());
		}
		return null;
	}

	@Override
	public int editReview(ReviewVo reviewVo) {
		
		//��� ���� �ٽ� ���
		reviewVo.calAverageLevel();
		
		//������Ʈ �� ���� ���� ��ȯ
		return reviewDao.updateReview(reviewVo);
	}
	//���� ����
	@Override
	public int deleteReview(int review_id) throws SQLException {
		return reviewDao.deleteReview(review_id);
	}
	
	
	///////////////////////////////
	//likeHate
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
		List<ReviewVo> list = reviewDao.selectAllReviewId();
		int review_id;
		for (int i = 0; i < list.size(); i++) {
			review_id = list.get(i).getReview_id();
//			logger.debug("review_id="+review_id+", likeCount="+reviewDao.selectLikeHateLike(review_id)+", hateCount="+reviewDao.selectLikeHateHate(review_id));
			reviewDao.updateLikeCount(review_id, reviewDao.selectLikeHateLike(review_id));
			reviewDao.updateHateCount(review_id, reviewDao.selectLikeHateHate(review_id));
		}
		
		
		return 1;
	}


	


}
