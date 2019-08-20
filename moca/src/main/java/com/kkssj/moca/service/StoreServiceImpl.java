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
	public StoreVo getStore(int store_Id) {
		try {
			return storeDao.selectOne(store_Id);
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	@Override
	public StoreVo addStore(StoreVo storeVo) {
		try {
			storeDao.insertOne(storeVo);
			storeVo = storeDao.selectByKakaoId(storeVo.getKakaoId());
			
			return storeVo;
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
		
	}
	@Override
	public int editStore(int accountId, StoreVo storeVo) {
		try {
			int result = storeDao.updateOne(storeVo);
			System.out.println("result : "+result);
			if(result>0) {
				int history = storeDao.insertStoreInfoHistory(accountId, storeVo);
				System.out.println("history : "+history);
			}
			return result;
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
		
	}
	
	////////////////////////////////
	//review
	
	@Override
	public List<ReviewVo> getReviewList(int accountId, int storeId) {
		try {
			return reviewDao.selectAll(accountId, storeId);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
		
		
	}
	@Override
	public ReviewVo addReview(ReviewVo reviewVo) {
		//평균 점수 계산
		reviewVo.calAverageLevel();
		try {
			//정상적으로 입력되었을때
			if(reviewDao.insertReview(reviewVo) ==1) {
				//상점에 대한 평점 동기화
				List<ReviewVo> list = reviewDao.selectAllReviewLevel(reviewVo.getStoreId());
				StoreVo storeVo = new StoreVo();
				storeVo.setStore_Id(reviewVo.getStoreId());
				storeVo.calAllLevel(list);
				logger.debug(storeVo.toString());
				storeDao.updateLevel(storeVo);
				
				
				// 방금 입력한 Vo를 가져온다. 
				return reviewDao.selectAddedOne(reviewVo.getAccountId());
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public int editReview(ReviewVo reviewVo) {
		try {
			//평균 점수 다시 계산
			reviewVo.calAverageLevel();
			
			//업데이트 된 행의 수를 반환
			return reviewDao.updateReview(reviewVo);
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
	}
	//리뷰 삭제
	@Override
	public int deleteReview(int review_id) throws SQLException {
		try {
			return reviewDao.deleteReview(review_id);
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
	}
	
	
	///////////////////////////////
	//likeHate
	@Override
	public int addLikeHate(int review_id, int accountId, int isLike) {
		try {
			reviewDao.insertLikeHate(review_id, accountId, isLike );
			ReviewVo reviewVo = reviewDao.selectLikeHateCount(review_id);
			if(isLike ==1) {
				return reviewDao.updateLikeCount(review_id, reviewVo.getLikeCount()+1) ;
			}else { 
				return reviewDao.updateHateCount(review_id, reviewVo.getHateCount()+1) ;
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
		
	}
	@Override
	public int deleteLikeHate(int review_id, int accountId, int isLike) {
		try {
			reviewDao.deleteLikeHate(review_id, accountId);
			ReviewVo reviewVo = reviewDao.selectLikeHateCount(review_id);
			if(isLike ==1) {
				return reviewDao.updateLikeCount(review_id, reviewVo.getLikeCount()-1) ;
			}else { 
				return reviewDao.updateHateCount(review_id, reviewVo.getHateCount()-1) ;
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;

	}
	@Override
	public int editLikeHate(int review_id, int accountId, int isLike) {
		try {
			reviewDao.updateLikeHate(review_id, accountId, isLike);
			ReviewVo reviewVo = reviewDao.selectLikeHateCount(review_id);
			reviewDao.updateLikeCount(review_id, reviewVo.getLikeCount()+isLike) ;
			reviewDao.updateHateCount(review_id, reviewVo.getHateCount()-isLike) ;
			return 1;
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
	}
	@Override
	public int syncReviewLikeHate() {
		try {
			List<ReviewVo> list = reviewDao.selectAllReviewId();
			int review_id;
			for (int i = 0; i < list.size(); i++) {
				review_id = list.get(i).getReview_id();
//			logger.debug("review_id="+review_id+", likeCount="+reviewDao.selectLikeHateLike(review_id)+", hateCount="+reviewDao.selectLikeHateHate(review_id));
				reviewDao.updateLikeCount(review_id, reviewDao.selectLikeHateLike(review_id));
				reviewDao.updateHateCount(review_id, reviewDao.selectLikeHateHate(review_id));
			}
			
			
			return 1;
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
	}


	


}
