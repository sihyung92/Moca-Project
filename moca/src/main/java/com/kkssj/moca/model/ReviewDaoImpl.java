package com.kkssj.moca.model;

import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;

public class ReviewDaoImpl implements ReviewDao {
	public static void main(String[] args) throws Exception {
		SqlSessionTemplate sqlSession;
		SqlSessionFactoryBean fac = new SqlSessionFactoryBean();
		sqlSession = (SqlSessionTemplate) fac.getObject();
	}
}
