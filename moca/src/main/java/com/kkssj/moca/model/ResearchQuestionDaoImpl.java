package com.kkssj.moca.model;

import java.sql.SQLException;
import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.kkssj.moca.model.entity.ResearchQuestionVo;

@Repository
public class ResearchQuestionDaoImpl implements ResearchQuestionDao {
	private static final Logger logger = LoggerFactory.getLogger(ResearchQuestionDaoImpl.class);

	@Inject
	SqlSession sqlSession;

	@Override
	public List<ResearchQuestionVo> list() throws SQLException {
		// TODO Auto-generated method stub
		return sqlSession.selectList("com.kkssj.moca.model.ResearchQuestionDao.selectAll");
	}

	@Override
	public int add() throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int update() throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int delete() throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}
}
