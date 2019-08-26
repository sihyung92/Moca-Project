package com.kkssj.moca.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.services.s3.internal.S3AbortableInputStream;
import com.kkssj.moca.model.ReviewDao;
import com.kkssj.moca.model.ReviewDaoImpl;
import com.kkssj.moca.model.StoreDao;
import com.kkssj.moca.model.entity.ImageVo;
import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.util.S3Util;
import com.kkssj.moca.util.UploadFileUtils;

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
				
				return updateInfoNickname +"님이 " + format.format(renewalDate) +"에 마지막으로 수정하였습니다";
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@Override
	public List<ImageVo> getStoreImgList(int storeId) {
		//store테이블에 있는 storeImg1,2,3 가져오기
		List<ImageVo> result = new ArrayList<ImageVo>();
		int limit = 0;
		try {
			Map<String,String> storeImgUrlMap = storeDao.selectStoreImgList(storeId);
			//가져와서 null값 혹은 빈값인 개수 세기
			if(storeImgUrlMap!=null) {
				System.out.println(storeImgUrlMap.size());
				System.out.println(storeImgUrlMap.toString());
				limit = 10 - storeImgUrlMap.size();
			}else {
				limit = 10;
			}
			//10개중에 나머지 개수만큼 가져오기 reviewImg
			Map<String,Integer> map = new HashMap<String, Integer>();
			map.put("LIMIT", limit);
			map.put("STORE_ID", storeId);
			
			result = storeDao.selectStoreReviewImgList(map);
			for(int i=0; i<result.size(); i++) {
				//카트리지 기법
				result.get(i).setUrl();
			}
			if(storeImgUrlMap!=null) {
				for(int i=0; i<storeImgUrlMap.size(); i++) {
					ImageVo imageVo = new ImageVo();
					imageVo.setPath("store");				
					imageVo.setUrl(storeImgUrlMap.get("storeImg"+(i+1)));				
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
		List<ImageVo> reviewImageList = new ArrayList<ImageVo>();
		try {
			reviewList = reviewDao.selectAll(accountId, storeId);
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
	public ReviewVo addReview(ReviewVo reviewVo, MultipartFile[] files) {
		///
		String uploadPath = "review";
		
		//평균 점수 계산
		reviewVo.calAverageLevel();
		try {
			//정상적으로 입력되었을때
			if(reviewDao.insertReview(reviewVo) ==1) {
				reviewVo = reviewDao.selectAddedOne(reviewVo.getAccountId());
				
				//S3에 파일 업로드
				MultipartFile file;
		    	for (int i = 0; i < files.length; i++) {

		    		file = files[i];
		    			
		    		logger.debug("originalName: " + file.getOriginalFilename());
		    		logger.debug("size : " +  file.getSize());
		    		logger.debug("contentType : " + file.getContentType());
		            
		            
		            if((file.getSize() != 0) && file.getContentType().contains("image")) {
		            	ImageVo imgaeVo = UploadFileUtils.uploadFile(uploadPath, file.getOriginalFilename(), file.getBytes());
		            	imgaeVo.setReviewId(reviewVo.getReview_id());
		            	imgaeVo.setStoreId(reviewVo.getStoreId());
		            	imgaeVo.setAccountId(reviewVo.getAccountId());
		            	reviewDao.insertReviewImage(imgaeVo);
		            }

				}
		    	//select로 가져와서 imgvo 넣기
		    	ArrayList<ImageVo> ReviewImgList = (ArrayList<ImageVo>) reviewDao.selectReviewImgListByReviewId(reviewVo.getReview_id());
		    	for(int i=0; i<ReviewImgList.size(); i++) {
		    		ReviewImgList.get(i).setUrl();
		    	}
		    	reviewVo.setImageList(ReviewImgList);
		    	
				
				//상점에 대한 평점 동기화
				List<ReviewVo> list = reviewDao.selectAllReviewLevel(reviewVo.getStoreId());
				StoreVo storeVo = new StoreVo();
				storeVo.setStore_Id(reviewVo.getStoreId());
				storeVo.calAllLevel(list);
				logger.debug("평점 동기화 된 StoreVo : "+storeVo.toString());
				storeDao.updateLevel(storeVo);
				
				
				// 방금 입력한 reviewVo를 리턴  
				return reviewVo;
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();

		}
		return null;
	}
	
	@Override
	public ReviewVo editReview(ReviewVo reviewVo, MultipartFile[] newFiles, String delThumbnails) {
		try {
			String uploadPath = "review";
			S3Util s3 = new S3Util();
			
			System.out.println(delThumbnails.isEmpty());
			if((delThumbnails.isEmpty())==false) {
				//delThumnail split ,
				String[] delThumbnailArray = delThumbnails.split(",");
				List<ImageVo> delImageVoList = new ArrayList<ImageVo>();
				
				//set url
				for(int i=0; i<delThumbnailArray.length; i++) {
					ImageVo imageVo = new ImageVo();
					imageVo.setDelImageVo(delThumbnailArray[i]);
					imageVo.setStoreId(reviewVo.getStoreId());
					imageVo.setReviewId(reviewVo.getReview_id());
					imageVo.setAccountId(reviewVo.getAccountId());
					logger.debug(imageVo.toString());
					delImageVoList.add(imageVo);
					//db에서 삭제
					reviewDao.deleteReviewImage(imageVo);
				}
				
				//aws thumnail도 삭제, 원본이미지도 삭제
				for (int i = 0; i < delImageVoList.size(); i++) {
					ImageVo imageVo = delImageVoList.get(i);
					logger.debug(imageVo.toString());
					imageVo.setFileName();
					imageVo.setThumbnailFileName();
					s3.fileDelete(imageVo.getPath()+"/"+imageVo.getFileName());
					s3.fileDelete(imageVo.getPath()+"/"+imageVo.getThumbnailFileName());
				}
			}
			
			//S3에 파일 업로드
			MultipartFile file;
	    	for (int i = 0; i < newFiles.length; i++) {

	    		file = newFiles[i];
	    			
	    		logger.debug("originalName: " + file.getOriginalFilename());
	    		logger.debug("size : " +  file.getSize());
	    		logger.debug("contentType : " + file.getContentType());
	            
	            
	            if((file.getSize() != 0) && file.getContentType().contains("image")) {
	            	ImageVo imgaeVo = UploadFileUtils.uploadFile(uploadPath, file.getOriginalFilename(), file.getBytes());
	            	imgaeVo.setReviewId(reviewVo.getReview_id());
	            	imgaeVo.setStoreId(reviewVo.getStoreId());
	            	imgaeVo.setAccountId(reviewVo.getAccountId());
	            	
	            	//db에 이미지 추가
	            	reviewDao.insertReviewImage(imgaeVo);
	            }
			}
	    	
	    	//select로 가져와서 imgvo 넣기
	    	ArrayList<ImageVo> ReviewImgList = (ArrayList<ImageVo>) reviewDao.selectReviewImgListByReviewId(reviewVo.getReview_id());
	    	for(int i=0; i<ReviewImgList.size(); i++) {
	    		ReviewImgList.get(i).setUrl();
	    	}
	    	reviewVo.setImageList(ReviewImgList);
			
			//평균 점수 다시 계산
			reviewVo.calAverageLevel();
						
			//업데이트 된 행의 수를 반환
			int result = reviewDao.updateReview(reviewVo);
			
			//상점에 대한 평점 동기화
			if(result>0) {
				List<ReviewVo> list = reviewDao.selectAllReviewLevel(reviewVo.getStoreId());
				StoreVo storeVo = new StoreVo();
				storeVo.setStore_Id(reviewVo.getStoreId());
				storeVo.calAllLevel(list);
				logger.debug("평점 동기화 된 StoreVo : "+storeVo.toString());
				storeDao.updateLevel(storeVo);				
			}
			
			return reviewVo;
			
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	//리뷰 삭제
	@Override
	public int deleteReview(ReviewVo reviewVo){
		S3Util s3 = new S3Util();
		try {
			//DB에 있는 imageVo list 조회
			List<ImageVo> imageVoList = reviewDao.selectReviewImgListByReviewId(reviewVo.getReview_id());
			logger.debug("imageList size = " + imageVoList.size());
			
			//review테이블에 있는 row삭제
			//해당 review_id에 해당하는 reviewImage테이블에 있는 row도  같이 삭제(cascade)
			int result = reviewDao.deleteReview(reviewVo);
			logger.debug("delete result = "+ result);

	
			//반복
			//imageVo로 s3에 저장된 파일명 생성 > 삭제
			for (int i = 0; i < imageVoList.size(); i++) {
				ImageVo imageVo = imageVoList.get(i);
				logger.debug(imageVo.toString());
				imageVo.setFileName();
				imageVo.setThumbnailFileName();
				s3.fileDelete(imageVo.getPath()+"/"+imageVo.getFileName());
				s3.fileDelete(imageVo.getPath()+"/"+imageVo.getThumbnailFileName());
			}
	
			
			//정상일 경우 return 1
			return 1;
			
		} catch (SQLException e) {
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
				reviewDao.updateLikeCount(review_id, reviewDao.selectLikeHateLike(review_id));
				reviewDao.updateHateCount(review_id, reviewDao.selectLikeHateHate(review_id));
			}
			
			return 1;
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return -1;
	}
	@Override
	public int deleteReviewImage(ImageVo imageVo) {
		try {
			return reviewDao.deleteReviewImage(imageVo);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return -1;
	}

}