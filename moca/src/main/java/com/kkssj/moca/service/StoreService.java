package com.kkssj.moca.service;

import java.sql.SQLException;

import com.kkssj.moca.model.entity.StoreVo;

public interface StoreService {
	//������ ��������
	StoreVo getStore(int store_Id) throws SQLException;

	//store�� �ִ��� Ȯ���ϰ� add
	StoreVo addStore(StoreVo storeVo) throws SQLException;
	
	//store ������ update
	int editStore(StoreVo storeVo) throws SQLException;
}
