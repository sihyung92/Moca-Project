package com.kkssj.moca.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
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
	public List<StoreVo> getStoresListByTag(Map<String, String> variables) {
		List<StoreVo> alist = new ArrayList<StoreVo>();
		Map<String, String> localVariables=new HashMap<String, String>();
		alist = storeDao.selectStoresListByTag(variables);
		if(variables!=null && alist.size()<5) {
			localVariables.put("x", variables.get("x"));
			localVariables.put("y", variables.get("y"));
			localVariables.put("tag", variables.get("tag"));
			localVariables.put("extendedSearch", "true");
			alist = storeDao.selectStoresListByTag(localVariables); 
		}
		if(variables!=null && alist.size()<5) {
			localVariables.put("x", null);
			localVariables.put("y", null);
			alist = storeDao.selectStoresListByTag(localVariables);
		}
		return alist;
	}

	@Override
	public List<StoreVo> getStoresListByRating(Map<String, String> variables) {
		List<StoreVo> alist = new ArrayList<StoreVo>();
		Map<String, String> localVariables=new HashMap<String, String>();
		alist = storeDao.selectStoresListByRating(variables);
		if(variables!=null && alist.size()<5) {
			localVariables.put("x", variables.get("x"));
			localVariables.put("y", variables.get("y"));
			localVariables.put("ratingName", variables.get("ratingName"));
			localVariables.put("extendedSearch", "true");
			alist = storeDao.selectStoresListByRating(localVariables);
		}
		if(variables!=null && alist.size()<5) {
			localVariables.put("x", null);
			localVariables.put("y", null);
			alist = storeDao.selectStoresListByRating(localVariables);
		}
		return alist;
	}
	
	@Override
	public List<String> getTagNames() {
		return storeDao.selectTagNames();
	}
}
