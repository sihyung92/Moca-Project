package com.kkssj.moca.service;

import java.sql.SQLException;

import com.kkssj.moca.model.entity.StoreVo;

public interface StoreService {
	//상세정보 가져오기
	StoreVo getStore(int store_Id) throws SQLException;

	//store가 있는지 확인하고 add
	StoreVo addStore(StoreVo storeVo) throws SQLException;
	
	//store 상세정보 update
	int editStore(StoreVo storeVo) throws SQLException;
}
