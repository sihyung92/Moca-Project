package com.kkssj.moca.model;

import static org.junit.Assert.*;

import java.sql.SQLException;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(value = {"file:src/main/webapp/WEB-INF/spring/root-context.xml"})
public class AccountDaoTest {
	@Inject
	javax.sql.DataSource dataSource;
	
	@Inject
	SqlSession sqlSession;
	
	@Inject
	SqlSessionFactory sqlSessionFactory;
	
	
 
	@Test
	public void test() throws SQLException {
		assertNotNull(dataSource);
		assertNotNull(sqlSession);
		assertNotNull(sqlSessionFactory);
		System.out.println(sqlSessionFactory.openSession().getConnection().toString());
		System.out.println(sqlSession.getConnection().toString());
	}

}
