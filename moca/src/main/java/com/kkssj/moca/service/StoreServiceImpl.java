package com.kkssj.moca.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.kkssj.moca.model.ReviewDao;
import com.kkssj.moca.model.ReviewDaoImpl;
import com.kkssj.moca.model.StoreDao;
import com.kkssj.moca.model.entity.ImageVo;
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
	public StoreVo getStore(int store_Id){
		try {
			return storeDao.selectOne(store_Id);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	@Override
	public StoreVo addStore(StoreVo storeVo){
		
		try {
			storeDao.insertOne(storeVo);
			storeVo = storeDao.selectByKakaoId(storeVo.getKakaoId());
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return storeVo;
	}
	@Override
	public int editStore(int accountId, StoreVo storeVo){
		
		int result = -1;
		try {
			result = storeDao.updateOne(storeVo);
			System.out.println("result : "+result);
			if(result>0) {
				int history = storeDao.insertStoreInfoHistory(accountId, storeVo);
				System.out.println("history : "+history);
				
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	@Override
	public String getStoreInfoHistory(int storeId) {
		Map<String, Object> map = null;
		try {
			map = storeDao.selectStoreInfoHistory(storeId);
			if(map!=null) {				
				String updateInfoNickname = (String) map.get("nickname");
				Timestamp renewalDate = (Timestamp) map.get("renewaldate");
				SimpleDateFormat format= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				
				return updateInfoNickname +"���� " + format.format(renewalDate) +"�� ���������� �����Ͽ����ϴ�";
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@Override
	public List<ImageVo> getStoreImgList(int storeId) {
		//store���̺� �ִ� storeImg1,2,3 ��������
		List<ImageVo> result = new ArrayList<ImageVo>();
		int limit = 0;
		try {
			Map<String,String> storeImgUrlList = storeDao.selectStoreImgList(storeId);
			//�����ͼ� null�� Ȥ�� ���� ���� ����
			if(storeImgUrlList!=null) {
				System.out.println(storeImgUrlList.size());
				System.out.println(storeImgUrlList.toString());
				limit = 10 - storeImgUrlList.size();
			}else {
				limit = 10;
			}
			//10���߿� ������ ������ŭ �������� reviewImg
			Map<String,Integer> map = new HashMap<String, Integer>();
			map.put("LIMIT", limit);
			map.put("STORE_ID", storeId);
			
			result = storeDao.selectStoreReviewImgList(map);
			for(int i=0; i<result.size(); i++) {
				result.get(i).setUrl(result.get(i).getUrl());
			}
			if(storeImgUrlList!=null) {
				for(int i=0; i<storeImgUrlList.size(); i++) {
					ImageVo imageVo = new ImageVo();
					imageVo.setPath("store");				
					imageVo.setUrl(storeImgUrlList.get("storeImg"+(i+1)));				
					result.add(imageVo);
				}
			}
			Collections.reverse(result);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	////////////////////////////////
	//review
	
	@Override
	public List<ReviewVo> getReviewList(int accountId, int storeId) {
		
		List<ReviewVo> reviewList = new ArrayList<ReviewVo>();
		reviewList = reviewDao.selectAll(accountId, storeId);
		
		List<ImageVo> reviewImageList = new ArrayList<ImageVo>();
		try {
			reviewImageList = reviewDao.selectReviewImgListByStoreId(storeId);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		System.out.println("reviewImageList size : "+reviewImageList);
		System.out.println("reviewList size : "+reviewList);
		
		for(int i=0; i<reviewImageList.size(); i++) {
			reviewImageList.get(i).setUrl(reviewImageList.get(i).getUrl());
		}
		
		int imageListIndex = 0;
		for (int i = 0; i < reviewList.size(); i++) {
			reviewList.get(i).setImageList(new ArrayList());
			for (int j = imageListIndex; j < reviewImageList.size(); j++) {
				if(reviewList.get(i).getReview_id()==reviewImageList.get(j).getReviewId()) {
					reviewList.get(i).getImageList().add(reviewImageList.get(j));
					imageListIndex++;
				}else {
					break;
				}
			}
		}
		
		return reviewList;
		
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
			try {
				storeDao.updateLevel(storeVo);
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			
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
	public int deleteReview(int review_id){
		try {
			return reviewDao.deleteReview(review_id);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return -1;
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
