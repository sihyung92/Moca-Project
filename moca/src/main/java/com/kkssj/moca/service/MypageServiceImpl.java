package com.kkssj.moca.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.kkssj.moca.model.AccountDao;
import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.util.S3Util;
import com.kkssj.moca.util.UploadFileUtils;
import com.kkssj.moca.model.ReviewDao;
import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.ImageVo;
import com.kkssj.moca.model.entity.ReviewVo;

@Service
public class MypageServiceImpl implements MypageService{
	@Inject
	AccountDao accountDao;	
	
	@Inject
	ReviewDao reviewDao;

	@Override
	public List<StoreVo> getFavoriteStoreList(int accountId) {
		try {
			return accountDao.selectFavoriteStoreList(accountId);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	

	@Override
	public List<AccountVo> getFollowerList(int accountId) {
		try {
			return accountDao.selectFollowerList(accountId);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<StoreVo> getLikeStoreList(int accountId) {
		try {
			return accountDao.selectLikeStoreList(accountId);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return null;
	}
	public List<AccountVo> getFollowingList(int accountId) {
		try {
			return accountDao.selectFollowingList(accountId);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<ReviewVo> getMyreviewList(int accountId, int sessionId) {
		List<ReviewVo> reviewList = new ArrayList<ReviewVo>();
		List<ImageVo> reviewImageList = new ArrayList<ImageVo>();
		try {
			reviewList = reviewDao.selectReviewListByAccountId(accountId,sessionId);
			reviewImageList = reviewDao.selectReviewImgListByAccountId(accountId);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		System.out.println("reviewImageList size : "+reviewImageList);
		System.out.println("reviewList size : "+reviewList);
		
		for(int i=0; i<reviewImageList.size(); i++) {
			reviewImageList.get(i).setUrl("");
		}
		
		int imageListIndex = 0;
		for (int i = 0; i < reviewList.size(); i++) {
			reviewList.get(i).setImageList(new ArrayList());
			for (int j = imageListIndex; j < reviewImageList.size(); j++) {
				if(reviewList.get(i).getReview_id()==reviewImageList.get(j).getReview_id()) {
					reviewList.get(i).getImageList().add(reviewImageList.get(j));
					imageListIndex++;
				}
			}
		}
		return reviewList;
		
	}

	@Override
	public int deleteAccount(int accountId) {
		try {
			return accountDao.deleteAccount(accountId);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public int addFollow(int follower, int following) {
		try {
			if(follower!=following) {
				//팔로우 받은사람 포인트 up
				accountDao.updateAccountExp(following, 7);
				accountDao.insertExpLog(following, "팔로우받음", 7);
				
				//포인트가 레벨업 할만큼 쌓였는지 검사
				AccountVo accountVo = accountDao.selectByaccountId(following);
				accountVo.setMaxExp();
				if(accountVo.getExp() >= accountVo.getMaxExp()) {
					accountDao.updateAccountlevel(following);
				}
			}
			
			return accountDao.insertFollow(follower,following);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public int deleteFollow(int follower, int following) {
		try {
			
			if(follower!=following) {
				//팔로우 취소된 사람 포인트 down
				accountDao.updateAccountExp(following, -7);
				accountDao.insertExpLog(following, "팔로우취소됨", -7);
				
				//취소된 포인트로 레벨 down을 해야하는지
				AccountVo accountVo = accountDao.selectByaccountId(following);
				accountVo.setMinExp();
				if(accountVo.getExp() < accountVo.getMinExp()) {
					accountDao.updateAccountlevelDown(following);
				}
			}
			
			return accountDao.deleteFollow(follower,following);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public AccountVo getAccountInfo(int Account_id) {
		try {
			return accountDao.selectByaccountId(Account_id);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}



	@Override
	public int editAccount(AccountVo editAccountVo, MultipartFile accountImage) {
		S3Util s3 = new S3Util();
    	
		try {
			if(accountImage!=null) {
				//삭제할 image
				ImageVo DelimageVo = new ImageVo();
				
				//db에서 원래 있던 이미지 url select로 받아오기
				AccountVo OldImgUrlVo = accountDao.selectProfileImageByaccountId(editAccountVo.getAccount_id());
				if(!OldImgUrlVo.getProfileImage().contains("kakaocdn")) {					
					DelimageVo.setDelImageVo(OldImgUrlVo.getProfileImage());
					
					//s3에서 이미지 삭제 (카카오톡 url이 아닐때)
					s3.fileDelete(DelimageVo.getPath()+"/"+DelimageVo.getFileName());
					s3.fileDelete(DelimageVo.getPath()+"/"+DelimageVo.getThumbnailFileName());
				}
				
				//추가할 image
				ImageVo AddimageVo = new ImageVo();
				
				//s3에 이미지 추가 & 썸네일 이미지 추가
				AddimageVo = UploadFileUtils.uploadFile("account", accountImage.getOriginalFilename(), accountImage.getBytes());
				AddimageVo.setUrl();
				AddimageVo.setAccount_id(editAccountVo.getAccount_id());
				
				//이미지 추가(update)
				System.out.println(AddimageVo.getUrl()+":"+AddimageVo.getThumbnailUrl());
				editAccountVo.setProfileImage(AddimageVo.getUrl());
				editAccountVo.setThumbnailImage(AddimageVo.getThumbnailUrl());
			}
			
			//updateAccount
			return accountDao.updateAccount(editAccountVo);
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
    	
		return 0;
	}

}
