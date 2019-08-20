package com.kkssj.moca.model;

import java.sql.SQLException;

import com.kkssj.moca.model.entity.StoreVo;

public interface StoreDao {
	StoreVo selectOne(int store_Id) throws SQLException;
	
	StoreVo selectByKakaoId(int kakaoId) throws SQLException;
	
	int insertOne(StoreVo storeVo) throws SQLException;

	int updateOne(StoreVo storeVo) throws SQLException;
	
	int insertStoreInfoHistory(int accountId, StoreVo storeVo) throws SQLException;

	int updateLevel(StoreVo storeVo) throws SQLException;

}
