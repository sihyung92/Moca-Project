package com.kkssj.moca.model;

import java.sql.SQLException;
import java.util.List;

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
	
	//해당 account의 follower 가져오기
	List<AccountVo> selectFollowerList(int accountId) throws SQLException;
	
	//해당 account의 following목록 가져오기
	List<AccountVo> selectFollowingList(int accountId) throws SQLException;
	
	//해당 account의 내가 쓴 리뷰 가져오기
	
	//해당 account의 following목록 추가하기
	int insertFollow(int follower, int following) throws SQLException;
	
	//해당account의 following 삭제
	int deleteFollow(int follower, int following) throws SQLException;
	
	//해당 account의 정보 불러오기
	AccountVo selectByaccountId(int account_id) throws SQLException;
}