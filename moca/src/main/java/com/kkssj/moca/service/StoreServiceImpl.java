package com.kkssj.moca.service;

import java.util.ArrayList;
import java.util.List;
import java.io.IOException;
import java.sql.SQLException;

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
	public ReviewVo addReview(ReviewVo reviewVo, MultipartFile[] files) {
		///
		String uploadPath = "";
		String uploadedFileName = "";
		
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
				imageVo.setFieName();
				imageVo.setThumbnailFileName();
				s3.fileDelete(imageVo.getFieName());
				s3.fileDelete(imageVo.getThumbnailFileName());
			}
	
			
			//정상일 경우 return 1
			return 1;
			
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
	@Override
	public int deleteReviewImage(ImageVo imageVo) {
		try {
			return reviewDao.deleteReviewImage(imageVo);
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
	}


	


}
