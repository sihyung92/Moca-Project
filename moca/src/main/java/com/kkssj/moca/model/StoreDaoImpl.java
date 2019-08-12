package com.kkssj.moca.model;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.kkssj.moca.model.entity.ReviewVo;

@Repository
public class StoreDaoImpl implements StoreDao{
	
	@Inject
	SqlSession sqlSession;



	
	
}
