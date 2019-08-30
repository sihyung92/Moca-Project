package com.kkssj.moca.service;

import java.sql.SQLException;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.kkssj.moca.model.ReviewDao;
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
	public int editStore(int account_Id, StoreVo storeVo) {
		try {
			int result = storeDao.updateOne(storeVo);
			System.out.println("result : "+result);
			if(result>0) {
				int history = storeDao.insertStoreInfoHistory(account_Id, storeVo);
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
	public List<ReviewVo> getReviewList(int account_Id, int storeId) {
		try {
			return reviewDao.selectAll(account_Id, storeId);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
		
		
	}
	@Override
	public ReviewVo addReview(ReviewVo reviewVo) {
		//��� ���� ���
		reviewVo.calAverageLevel();
		try {
			//���������� �ԷµǾ�����
			if(reviewDao.insertReview(reviewVo) ==1) {
				//������ ���� ���� ����ȭ
				List<ReviewVo> list = reviewDao.selectAllReviewLevel(reviewVo.getStore_Id());
				StoreVo storeVo = new StoreVo();
				storeVo.setStore_Id(reviewVo.getStore_Id());
				storeVo.calAllLevel(list);
				logger.debug(storeVo.toString());
				storeDao.updateLevel(storeVo);
				
				
				// ��� �Է��� Vo�� �����´�. 
				return reviewDao.selectAddedOne(reviewVo.getAccount_Id());
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
			//��� ���� �ٽ� ���
			reviewVo.calAverageLevel();
			
			//������Ʈ �� ���� ���� ��ȯ
			return reviewDao.updateReview(reviewVo);
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
	}
	//���� ����
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
	public int addLikeHate(int review_id, int account_Id, int isLike) {
		try {
			reviewDao.insertLikeHate(review_id, account_Id, isLike );
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
	public int deleteLikeHate(int review_id, int account_Id, int isLike) {
		try {
			reviewDao.deleteLikeHate(review_id, account_Id);
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
	public int editLikeHate(int review_id, int account_Id, int isLike) {
		try {
			reviewDao.updateLikeHate(review_id, account_Id, isLike);
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
