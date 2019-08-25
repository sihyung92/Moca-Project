package com.kkssj.moca.model;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.kkssj.moca.model.entity.AccountVo;

@Repository
public class AccountDaoImpl implements AccountDao {

	@Inject
	SqlSession sqlSession;
	
	@Override
	public int insertUser(AccountVo accountVo) throws SQLException{
		// TODO Auto-generated method stub
		return sqlSession.insert("account.insertUser", accountVo);
	}

	@Override
	public AccountVo selectUser(String platformType, int platformId) throws SQLException{
		// TODO Auto-generated method stub
		return sqlSession.selectOne("account.selectUserByKakaoId", (Integer)platformId);
	}

	@Override
	public int updateUser(AccountVo accountVo) throws SQLException{
		// TODO Auto-generated method stub
		return sqlSession.update("account.updateUserByKakaoId", accountVo);
	}

	@Override
	public int deleteUser() throws SQLException{
		// TODO Auto-generated method stub
		return 0;
	}


}
