package com.kkssj.moca.service;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.kkssj.moca.model.AccountDao;
import com.kkssj.moca.model.ReviewDao;
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
	
	@Inject
	AccountDao accountDao;
	
	
	//////////////////////////////
	//Store

	@Override
	public StoreVo getStore(int store_Id, int account_id){
		try {
			return storeDao.selectOne(store_Id, account_id);
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
				if(reviewList.get(i).getReview_id()==reviewImageList.get(j).getReview_id()) {
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
				reviewVo = reviewDao.selectAddedOne(reviewVo.getAccount_id());
				
				//S3에 파일 업로드
				MultipartFile file;
		    	for (int i = 0; i < files.length; i++) {

		    		file = files[i];
		    			
		    		logger.debug("originalName: " + file.getOriginalFilename());
		    		logger.debug("size : " +  file.getSize());
		    		logger.debug("contentType : " + file.getContentType());
		            
		            
		            if((file.getSize() != 0) && file.getContentType().contains("image")) {
		            	ImageVo imgaeVo = UploadFileUtils.uploadFile(uploadPath, file.getOriginalFilename(), file.getBytes());
		            	imgaeVo.setReview_id(reviewVo.getReview_id());
		            	imgaeVo.setStore_id(reviewVo.getStore_id());
		            	imgaeVo.setAccount_id(reviewVo.getAccount_id());
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
				List<ReviewVo> list = reviewDao.selectAllReviewLevel(reviewVo.getStore_id());
				StoreVo storeVo = new StoreVo();
				storeVo.setStore_Id(reviewVo.getStore_id());
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
	public int editStoreLogo(int store_Id, MultipartFile newFile, String delStoreLogo) {
		String uploadPath = "logo";
		S3Util s3 = new S3Util();
		
		//삭제된 이미지 s3에서 파일 삭제
		if(!delStoreLogo.equals("")) {
			
			//프랜차이즈인 경우 or 서버 내부의 기본 이미지인 경우 이미지 삭제하지 않
			String category = storeDao.selectCategoryByStoreId(store_Id);
			logger.debug("delStoreLogo : "+delStoreLogo +", category" +category +",!category.contains(\"프랜차이즈\") " +!category.contains("프랜차이즈"));
			if (!category.contains("프랜차이즈") && !delStoreLogo.contains("/moca/resources/")) {
				String pathUu_idOriginName = delStoreLogo.split(".com/")[1];
				String [] pathUu_idOriginName2 = pathUu_idOriginName.split("_");
				s3.fileDelete(pathUu_idOriginName);	
				s3.fileDelete(pathUu_idOriginName2[0]+"_thumbnail_"+pathUu_idOriginName2[1]);
			}
			

		}
		
		
		logger.debug("originalName: " + newFile.getOriginalFilename());
		logger.debug("size : " +  newFile.getSize());
		logger.debug("contentType : " + newFile.getContentType());
        
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("STORE_ID", store_Id);
		ImageVo imgaeVo = null;
        if((newFile.getSize() != 0) && newFile.getContentType().contains("image")) {
        	
			try {
				imgaeVo = UploadFileUtils.uploadFile(uploadPath, newFile.getOriginalFilename(), newFile.getBytes());
				
		    	map.put("LOGOIMG", imgaeVo.getUrl());
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}            	
        }else {
        	map.put("LOGOIMG", null);
        }

		//storeVo내용으로 DB 내용 수정    		
		return storeDao.updateStoreLogo(map);
	}
	
	@Override
	public int editStoreImg(int store_id, MultipartFile[] newFiles, String[] oldStoreImgArr,
			String[] delStoreImgArr) {
		String uploadPath = "store";
		S3Util s3 = new S3Util();
		String[] newStoreImgArr = new String[newFiles.length];
		
		
		//삭제된 이미지 s3에서 파일 삭제
		for (int i = 0; i < delStoreImgArr.length; i++) {
			if(!delStoreImgArr[i].equals("")) {
				String pathUu_idOriginName = delStoreImgArr[i].split(".com/")[1];
				s3.fileDelete(pathUu_idOriginName);				
			}
		}
		
		//s3에서 파일 추가
		//S3에 파일 업로드
		MultipartFile file;
    	for (int i = 0; i < newFiles.length; i++) {

    		file = newFiles[i];
    			
    		logger.debug("originalName: " + file.getOriginalFilename());
    		logger.debug("size : " +  file.getSize());
    		logger.debug("contentType : " + file.getContentType());
            
            
            if((file.getSize() != 0) && file.getContentType().contains("image")) {
            	ImageVo imgaeVo;
				try {
					imgaeVo = UploadFileUtils.uploadFile(uploadPath, file.getOriginalFilename(), file.getBytes());
					newStoreImgArr[i] = imgaeVo.getUrl();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}            	
            }
		}
    	
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("STORE_ID", store_id);
    	for(int i=0; i<oldStoreImgArr.length; i++) {
    		map.put("STOREIMG"+(i+1), oldStoreImgArr[i]);
    		logger.debug("oldStoreImg STOREIMG"+(i+1)+(String)map.get("STOREIMG"+(i+1)));
    	}
    	for(int i=oldStoreImgArr.length; i< oldStoreImgArr.length+newStoreImgArr.length; i++) {
    		map.put("STOREIMG"+(i+1), newStoreImgArr[i-oldStoreImgArr.length]);
    		logger.debug("newStoreImg STOREIMG"+(i+1)+(String)map.get("STOREIMG"+(i+1)));
    	}

		//storeVo내용으로 DB 내용 수정    		
		return storeDao.updateStoreImg(map);		
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
					imageVo.setStore_id(reviewVo.getStore_id());
					imageVo.setReview_id(reviewVo.getReview_id());
					imageVo.setAccount_id(reviewVo.getAccount_id());
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
	            	imgaeVo.setReview_id(reviewVo.getReview_id());
	            	imgaeVo.setStore_id(reviewVo.getStore_id());
	            	imgaeVo.setAccount_id(reviewVo.getAccount_id());
	            	
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
				List<ReviewVo> list = reviewDao.selectAllReviewLevel(reviewVo.getStore_id());
				StoreVo storeVo = new StoreVo();
				storeVo.setStore_Id(reviewVo.getStore_id());
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
	@Override
	public int addLikeStore(int storeId, int account_id) {
		try {
			return accountDao.insertLikeStore(storeId,account_id);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
	}
	@Override
	public int deleteLikeStore(int storeId, int account_id) {
		try {
			return accountDao.deleteLikeStore(storeId,account_id);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
	}
	@Override
	public int addFavoriteStore(int storeId, int account_id) {
		try {
			return accountDao.insertFavoriteStore(storeId,account_id);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
		}
	@Override
	public int deleteFavoriteStore(int storeId, int account_id) {
		try {
			return accountDao.deleteFavoriteStore(storeId,account_id);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
	}
	


}