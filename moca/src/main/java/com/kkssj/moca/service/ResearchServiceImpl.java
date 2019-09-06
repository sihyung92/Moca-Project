package com.kkssj.moca.service;

import java.sql.SQLException;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.kkssj.moca.model.ResearchDao;
import com.kkssj.moca.model.entity.ResearchVo;

@Service
public class ResearchServiceImpl implements ResearchService {
private static final Logger logger = LoggerFactory.getLogger(ResearchServiceImpl.class);
	
	@Inject
	ResearchDao researchDao;

	@Override
	public boolean doResearch(ResearchVo research) {
		// TODO Auto-generated method stub
		try {
			researchDao.insertResearch(research);
			return true;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}
}
