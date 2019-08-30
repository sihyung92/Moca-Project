package com.kkssj.moca.service;

import java.sql.SQLException;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.kkssj.moca.model.LogDao;
import com.kkssj.moca.model.entity.LogVo;

@Service
public class LogServiceImpl implements LogService {
	private static final Logger logger = LoggerFactory.getLogger(LogServiceImpl.class);
	
	@Inject
	LogDao logDao;

	@Override
	public boolean writeStoreIdKeyWordNone(HttpServletRequest req, String classification, int account_id) {
		// TODO Auto-generated method stub
		LogVo log = new LogVo(0, account_id, null, classification, req.getRemoteAddr(), null, req.getLocale().getCountry()+"/"+req.getLocale().getDisplayCountry(), null);
		try {
			logDao.writeStoreIdKeyWordNone(log);
			return true;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}
	
	//그냥 로그 서비스 가져다가 서비스.write(HttpServletRequest,로그구분,키워드,어카운트아이디,스토어아이디) 하면 로그 작성 됩니다.
		
}
