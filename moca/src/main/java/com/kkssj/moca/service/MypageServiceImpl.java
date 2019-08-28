package com.kkssj.moca.service;

import java.sql.SQLException;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.kkssj.moca.model.AccountDao;
import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.ReviewVo;

@Service
public class MypageServiceImpl implements MypageService{
	@Inject
	AccountDao accountDao;

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
	public List<AccountVo> getFollowingList(int accountId) {
		try {
			return accountDao.selectFollowingList(accountId);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<ReviewVo> getMyreview(int accountId) {
		return null;
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
	

}
