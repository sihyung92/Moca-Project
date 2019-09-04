package com.kkssj.moca.model;

import java.sql.SQLException;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.kkssj.moca.model.entity.ResearchVo;

@Repository
public class ResearchDaoImpl implements ResearchDao {
	private static final Logger logger = LoggerFactory.getLogger(ResearchDaoImpl.class);

	@Inject
	SqlSession sqlSession;

	@Override
	public int insertResearch(ResearchVo research) throws SQLException {
		// TODO Auto-generated method stub
		return sqlSession.insert("com.kkssj.moca.model.ResearchDao.insertResearch",research);
	}



}
