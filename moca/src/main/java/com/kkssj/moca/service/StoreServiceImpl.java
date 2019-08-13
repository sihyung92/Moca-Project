package com.kkssj.moca.service;

import java.sql.SQLException;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.kkssj.moca.model.StoreDao;
import com.kkssj.moca.model.entity.StoreVo;

@Service
public class StoreServiceImpl implements StoreService {
	@Inject
	StoreDao storeDao;

	@Override
	public StoreVo getStore(int store_Id) throws SQLException {
		return storeDao.selectOne(store_Id);
	}

	@Override
	public StoreVo addStore(StoreVo storeVo) throws SQLException {
		int cnt =  storeDao.selectCnt(storeVo.getKakaoId());
		System.out.println(storeVo.getKakaoId()+"store_id");
		System.out.println(storeVo.toString());
		System.out.println(cnt);
		if(cnt==0){
			storeDao.insertOne(storeVo);
		}
		storeVo = storeDao.selectKakaoId(storeVo.getKakaoId());
		
		return storeVo;
	}


}
