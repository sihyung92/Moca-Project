package com.kkssj.moca.model;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

	public List selectUsersByNumAndVal(Object[] obj) throws SQLException{
		Map<String,String> map = new HashMap<String, String>();
		// int account_id,String value
		// 홀수번 obj[i] 는 넘버
		// 짝수번 obj[i+1] 는 해당 값
		String param = "";
		for (int i=0;i<obj.length;i=i+2) {
			param = param + "'%@"+(int)obj[i]+"_#"+(String)obj[i+1]+"!%' AND answer LIKE ";
		}
		param = param +"'%'";
		map.put("string", param);
		return sqlSession.selectList("com.kkssj.moca.model.ResearchDao.selectResearchByMultipleQuery", map);
	}
	

}
