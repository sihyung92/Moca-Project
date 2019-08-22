package com.kkssj.moca.model;

import com.kkssj.moca.model.entity.AccountVo;

public interface AccountDao {
	//create
	int createUser();
	//read(get)
	AccountVo getUser(int account_Id);
	//update
	int updateUser();
	//delete
	int deleteUse();
}
