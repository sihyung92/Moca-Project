package com.kkssj.moca.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.kkssj.moca.controller.HomeController;
import com.kkssj.moca.model.entity.ReviewVo;

@Repository
public class ReviewDaoImpl implements ReviewDao {
	private static final Logger logger = LoggerFactory.getLogger(ReviewDaoImpl.class);

	@Inject
	SqlSession sqlSession;


	@Override
	public List<ReviewVo> selectAll(int accountId, int storeId) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("account_id", accountId);
		map.put("storeId", storeId);
		
		List<ReviewVo> list = sqlSession.selectList("review.selectAll",map);
		for (int i = 0; i < list.size(); i++) {
			System.out.println(list.get(i).toString());
		}
		
		return list;
	}

}
