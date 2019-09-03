package com.kkssj.moca.model;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

@Repository
public class ResearchDaoImpl implements ResearchDao {
	private static final Logger logger = LoggerFactory.getLogger(ResearchDaoImpl.class);

	@Inject
	SqlSession sqlSession;
}
