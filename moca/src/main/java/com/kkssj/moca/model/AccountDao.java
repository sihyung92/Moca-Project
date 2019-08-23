package com.kkssj.moca.model;

import java.sql.SQLException;

import com.kkssj.moca.model.entity.AccountVo;

public interface AccountDao {
	//create
	int insertUser(AccountVo accountVo) throws SQLException;
	//read(get)
	AccountVo selectUser(String platformType, int platformId) throws SQLException;
	//update
	int updateUser(AccountVo accountVo) throws SQLException;
	//delete
	int deleteUser() throws SQLException;
}