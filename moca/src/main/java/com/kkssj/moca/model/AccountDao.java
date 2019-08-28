package com.kkssj.moca.model;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.StoreVo;

public interface AccountDao {
	//create
	int insertUser(AccountVo accountVo) throws SQLException;
	//read(get)
	AccountVo selectUser(String platformType, int platformId) throws SQLException;
	//update
	int updateUser(AccountVo accountVo) throws SQLException;
	//delete
	int deleteUser() throws SQLException;
	
	List<StoreVo> selectFavoriteStoreList(int account_id) throws SQLException;
	
	List<StoreVo> selectLikeStoreList(int account_id) throws SQLException;
	
	int insertLikeStore(int storeId, int account_id) throws SQLException;
	
	int deleteLikeStore(int storeId, int account_id) throws SQLException;
	
	int insertFavoriteStore(int storeId, int account_id) throws SQLException;
	
	int deleteFavoriteStore(int storeId, int account_id) throws SQLException;
}