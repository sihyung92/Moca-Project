package com.kkssj.moca.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.kkssj.moca.model.AccountDao;
import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.util.S3Util;
import com.kkssj.moca.util.UploadFileUtils;
import com.kkssj.moca.model.ReviewDao;
import com.kkssj.moca.model.StoreDao;
import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.BadgeVo;
import com.kkssj.moca.model.entity.ImageVo;
import com.kkssj.moca.model.entity.ReviewVo;

@Service
public class MypageServiceImpl implements MypageService{
	
	private static final Logger logger = LoggerFactory.getLogger(MypageServiceImpl.class);
	
	int[] followBadgeLevel = new int[] {0,10,30,50,100}; 
	String[] followBadgeUrl = new String[] {"", "/resources/imgs/badge/followBadge1.png", "/resources/imgs/badge/followBadge2.png", "/resources/imgs/badge/followBadge3.png", "/resources/imgs/badge/followBadge4.png", "/resources/imgs/badge/followBadge5.png"};
	
	@Inject
	AccountDao accountDao;	
	
	@Inject
	ReviewDao reviewDao;
	
	@Inject
	StoreDao storeDao;
	
	

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
	public List<ReviewVo> getMyReviewListLimit(int myAccountId, int targetAccountId, int startNum) {
		List<ReviewVo> reviewList = new ArrayList<ReviewVo>();
		List<ImageVo> reviewImageList = new ArrayList<ImageVo>();
		
		List<Map<String, Object>> tagsMapList = new ArrayList<Map<String,Object>>();
		
		try {
			reviewList = reviewDao.selectReviewListByAccountId(targetAccountId,myAccountId,startNum);
			tagsMapList = reviewDao.selectTagsLimit3ByAccountId(targetAccountId, startNum);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		
		for(int i=0; i<reviewList.size(); i++) {
			try {
				//set 리뷰 이미지 리스트
				reviewImageList = reviewDao.selectReviewImgListByReviewId(reviewList.get(i).getReview_id());
				for(int j=0; j<reviewImageList.size(); j++) {
					reviewImageList.get(j).setUrl();
				}
				reviewList.get(i).setImageList(reviewImageList);
				
				//tag list에서 tag값만 내용만 사용
				tagsMapList.get(i).remove("REVIEW_ID");
				tagsMapList.get(i).remove("STORE_ID");
				
				//set 리뷰 태그 
				reviewList.get(i).setTagMap(tagsMapList.get(i)); ///에러
			} catch (SQLException e) {
				e.printStackTrace();
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
			int result = accountDao.insertFollow(follower,following);
			if(follower!=following) {
				//팔로우 받은사람 포인트 up
//				accountDao.updateAccountExp(following, 7);
//				accountDao.insertExpLog(following, "팔로우받음", 7);
				
				//각각의 팔로워, 팔로잉 count 증가
//				accountDao.updateFollowCount(following);	//팔로잉인 사람의 팔로워가 증가
//				accountDao.updateFollowingCount(follower);	//팔로워인 사람의 팔로잉이 증가
				
				//포인트가 레벨업 할만큼 쌓였는지 검사
				AccountVo accountVo = accountDao.selectByaccountId(following);
				accountVo.setMaxExp();
				if(accountVo.getExp() >= accountVo.getMaxExp()) {
					accountDao.updateAccountlevel(following);
				}
				
				badgeManage(following , "following");
			}
			
			return result;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	private void badgeManage(int followingAccount, String callWhere) throws SQLException {
		int level = 0;
		if(callWhere.equals("following")) {// 리뷰를 작성했을때
			int followCount = accountDao.selectFollowCountByFollowing(followingAccount);
			
			for (int i = 0; i < followBadgeLevel.length; i++) {
				if(followBadgeLevel[i] == followCount) {
					level = i;
				}
			}
			
			if(level != 0) {
				accountDao.insertBadge(followingAccount, "팔로우" , level, followBadgeUrl[level]);
			}
		}
		
	}

	@Override
	public int deleteFollow(int follower, int following) {
		try {
			int result = accountDao.deleteFollow(follower,following);
			if(follower!=following) {
				//팔로우 취소된 사람 포인트 down
				//accountDao.updateAccountExp(following, -7);
				//accountDao.insertExpLog(following, "팔로우취소됨", -7);
				
				//각각의 팔로워, 팔로잉 count 감소
				//accountDao.updateFollowCount(following);
				//accountDao.updateFollowingCount(follower);
				
				//취소된 포인트로 레벨 down을 해야하는지
				AccountVo accountVo = accountDao.selectByaccountId(following);
				accountVo.setMinExp();
				if(accountVo.getExp() < accountVo.getMinExp()) {
					accountDao.updateAccountlevelDown(following);
				}
			}
			
			return result;
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
				if(OldImgUrlVo.getProfileImage()!=null) {
					if(!OldImgUrlVo.getProfileImage().contains("kakaocdn")) {	
						if(OldImgUrlVo.getProfileImage().length() !=0) {
							DelimageVo.setDelImageVo(OldImgUrlVo.getProfileImage());
							//s3에서 이미지 삭제 (카카오톡 url이 아닐때)
							s3.fileDelete(DelimageVo.getPath()+"/"+DelimageVo.getFileName());
							s3.fileDelete(DelimageVo.getPath()+"/"+DelimageVo.getThumbnailFileName());		
						}				
					}
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

	@Override
	public List<String> getTagNameList() {
		List<String> tagNameList = null;
		try {
			tagNameList = storeDao.selectTagList();
			//review_id, store_id 제거
			tagNameList.remove(0);
			tagNameList.remove(0);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

		return tagNameList;
	}

	@Override
	public List<BadgeVo> getBadgeList(int account_id) {
		try {
			return accountDao.selectBadgeList(account_id);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}



}
