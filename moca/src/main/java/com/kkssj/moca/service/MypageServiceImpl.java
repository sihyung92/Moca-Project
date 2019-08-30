package com.kkssj.moca.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.kkssj.moca.model.AccountDao;
import com.kkssj.moca.model.entity.StoreVo;
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
	public int editAccount(int accountId) {
		return 0;
	}

	@Override
	public int deleteAccount(int accountId) {
		return 0;
	}

	@Override
	public int addFollow(int follower, int following) {
		try {
			return accountDao.insertFollow(follower,following);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public int deleteFollow(int follower, int following) {
		try {
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

}
