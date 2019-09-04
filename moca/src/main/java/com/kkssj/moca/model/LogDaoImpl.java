package com.kkssj.moca.model;

import java.sql.SQLException;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.kkssj.moca.model.entity.LogVo;

@Repository
public class LogDaoImpl implements LogDao{
	@Inject
	SqlSession sqlSession;

	@Override
	public int write(LogVo logVo) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int writeStoreIdNone(LogVo logVo) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int writeKeyWordNone(LogVo logVo) throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int writeStoreIdKeyWordNone(LogVo logVo) throws SQLException{
		// TODO Auto-generated method stub
		return sqlSession.insert("com.kkssj.moca.model.logDao.insertLogStoreIdKeyWordNone", logVo);
	}

	@Override
	public int insertLogStore(LogVo logVo) throws SQLException {
		return sqlSession.insert("com.kkssj.moca.model.logDao.insertLogStore", logVo);
	}
	


}
