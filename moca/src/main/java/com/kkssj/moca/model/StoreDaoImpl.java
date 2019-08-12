package com.kkssj.moca.model;

import java.sql.SQLException;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.kkssj.moca.model.entity.StoreVo;

@Repository
public class StoreDaoImpl implements StoreDao {
	@Inject
	SqlSession sqlsession;

	@Override
	public StoreVo selectOne(int store_Id) throws SQLException {
		return sqlsession.selectOne("store.selectOne", store_Id);
	}

	@Override
	public int insertOne(StoreVo storeVo) throws SQLException {
		return sqlsession.insert("store.insertOne", storeVo);
	}

	@Override
	public StoreVo selectKakaoId(int kakaoId) throws SQLException {
		return sqlsession.selectOne("store.selectKakaoId", kakaoId);
	}

	@Override
	public int selectCnt(int kakaoId) throws SQLException {
		return sqlsession.selectOne("store.selectCnt", kakaoId);
	}

}
