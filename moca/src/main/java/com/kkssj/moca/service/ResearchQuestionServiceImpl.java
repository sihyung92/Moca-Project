package com.kkssj.moca.service;

import java.sql.SQLException;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.kkssj.moca.model.ResearchQuestionDao;

@Service
public class ResearchQuestionServiceImpl implements ResearchQuestionService {
private static final Logger logger = LoggerFactory.getLogger(ResearchQuestionServiceImpl.class);
	
	@Inject
	ResearchQuestionDao researchQuestionDao;

	@Override
	public void getList(HttpSession sess) throws SQLException {
		// TODO Auto-generated method stub
		sess.setAttribute("alist",researchQuestionDao.list());
	}
}
