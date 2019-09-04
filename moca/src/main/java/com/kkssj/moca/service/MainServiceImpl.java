package com.kkssj.moca.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.kkssj.moca.model.ReviewDao;
import com.kkssj.moca.model.StoreDao;
import com.kkssj.moca.model.entity.ImageVo;
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
	public List<StoreVo> getTakeoutStoresList(Map<String, String> variables) {
		return storeDao.selectTakeoutStoresList(variables);
	}

	@Override
	public List<StoreVo> getBestStoresList() {
		
		return storeDao.selectBestStoresList();
	}
	
	@Override
	public List<ReviewVo> getRecentReviews() throws SQLException {
		List<ReviewVo> list = reviewDao.selectRecentReviews();
		//review ImageList 받아오기
		ArrayList<ImageVo> reviewImgList;
		for(ReviewVo reviewVo:list) {
			//reviewVo에 imageVo의 URL정보 주입
			reviewImgList = (ArrayList<ImageVo>)reviewDao.selectReviewImgListByReviewId(reviewVo.getReview_id());
			for(int i=0; i<reviewImgList.size(); i++) {
				reviewImgList.get(i).setUrl();
			}
			reviewVo.setImageList(reviewImgList);
	   	}
		return list;
	}
	
	@Override
	public List<ReviewVo> getBestReviews() throws SQLException {
		List<ReviewVo> list = reviewDao.selectBestReviews();
		//review ImageList 받아오기
		 ArrayList<ImageVo> reviewImgList;
		for(ReviewVo reviewVo:list) {
			//reviewVo에 imageVo의 URL정보 주입
			reviewImgList = (ArrayList<ImageVo>)reviewDao.selectReviewImgListByReviewId(reviewVo.getReview_id());
			for(int i=0; i<reviewImgList.size(); i++) {
				reviewImgList.get(i).setUrl();
			}
			reviewVo.setImageList(reviewImgList);
    	}
		return list;
	}
	 
	@Override	
	public List<StoreVo> getFollowersStoresList(int id) {
		return storeDao.selectFollowersStoresList(id);
	}

	@Override
	public List<StoreVo> getGoodMoodStoresList(Map<String, String> variables) {
		List<StoreVo> alist = new ArrayList<StoreVo>();
		alist = storeDao.selectGoodMoodStoresList(variables);
		if(variables!=null && alist.size()<5) {
			variables.put("trial", "2");
			alist = storeDao.selectGoodMoodStoresList(variables);
		}
		if(variables!=null && alist.size()<5) {
			variables.put("x", null);
			variables.put("y", null); 
			alist = storeDao.selectGoodMoodStoresList(variables);
		}
		return alist;
	}

	@Override
	public List<StoreVo> getGoodTasteStoresList(Map<String, String> variables) {
		List<StoreVo> alist = new ArrayList<StoreVo>();
		alist = storeDao.selectGoodTasteStoresList(variables);
		if(variables!=null && alist.size()<5) {
			variables.put("trial", "2");
			alist = storeDao.selectGoodTasteStoresList(variables);
		}
		if(variables!=null && alist.size()<5) {
			variables.put("x", null);
			variables.put("y", null); 
			alist = storeDao.selectGoodTasteStoresList(variables);
		}
		return alist;
	}

	@Override
	public List<StoreVo> getGoodPriceStoresList(Map<String, String> variables) {
		List<StoreVo> alist = new ArrayList<StoreVo>();
		alist = storeDao.selectGoodPriceStoresList(variables);
		if(variables!=null && alist.size()<5) {
			variables.put("trial", "2");
			alist = storeDao.selectGoodPriceStoresList(variables);
		}
		if(variables!=null && alist.size()<5) {
			variables.put("x", null);
			variables.put("y", null); 
			alist = storeDao.selectGoodPriceStoresList(variables);
		}
		return alist;
	}

	@Override
	public List<StoreVo> getTagStoresList(Map<String, String> variables) {
		List<StoreVo> alist = new ArrayList<StoreVo>();
		alist = storeDao.selectTagStoresList(variables);
		if(variables!=null && alist.size()<5) {
			variables.put("trial", "2");
			alist = storeDao.selectGoodPriceStoresList(variables);
		}
		if(variables!=null && alist.size()<5) {
			variables.put("x", null);
			variables.put("y", null); 
			alist = storeDao.selectGoodPriceStoresList(variables);
		}
		return alist;
	}
}
