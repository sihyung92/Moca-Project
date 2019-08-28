package com.kkssj.moca.service;

import java.sql.SQLException;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.kkssj.moca.model.AccountDao;
import com.kkssj.moca.model.entity.StoreVo;

@Service
public class MypageServiceImpl implements MypageService{
	@Inject
	AccountDao accountDao;	

	@Override
	public List<StoreVo> getFavoriteStoreList(int accountId) {
		try {
			return accountDao.selectFavoriteStoreList(accountId);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
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

}
