package com.kkssj.moca.model;

import java.sql.SQLException;

import com.kkssj.moca.model.entity.StoreVo;

public interface StoreDao {
	StoreVo selectOne(int store_Id) throws SQLException;
	
	StoreVo selectKakaoId(int kakaoId) throws SQLException;
	
	int insertOne(StoreVo storeVo) throws SQLException;

	int selectCnt(int kakaoId) throws SQLException;

}
