package com.kkssj.moca.service;

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
	public List<AccountVo> getFollower(int accountId) {
		return null;
	}

	@Override
	public List<AccountVo> getFollowing(int accountId) {
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
	

}
