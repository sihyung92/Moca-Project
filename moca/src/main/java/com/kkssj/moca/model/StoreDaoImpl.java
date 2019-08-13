package com.kkssj.moca.model;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.kkssj.moca.controller.SearchController;
import com.kkssj.moca.model.entity.StoreVo;

@Repository
public class StoreDaoImpl implements StoreDao {
	@Inject
	SqlSession sqlSession;
	
	private static final Logger logger = LoggerFactory.getLogger(SearchController.class);
	
	@Override
	public List<StoreVo> selectByTag(Map<String, String> variables) {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectByTag", variables);
	}

}
