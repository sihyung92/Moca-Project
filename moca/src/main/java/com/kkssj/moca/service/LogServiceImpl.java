package com.kkssj.moca.service;

import java.sql.SQLException;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.kkssj.moca.model.LogDao;
import com.kkssj.moca.model.StoreDao;
import com.kkssj.moca.model.entity.LogVo;

@Service
public class LogServiceImpl implements LogService {
	private static final Logger logger = LoggerFactory.getLogger(LogServiceImpl.class);
	
	@Inject
	LogDao logDao;
	
	@Inject
	StoreDao storeDao;

	@Override
	public boolean writeStoreIdKeyWordNone(HttpServletRequest req, String classification, int account_id) {
		// TODO Auto-generated method stub
		LogVo log = new LogVo(0, account_id, 0, classification, req.getRemoteAddr(), null, req.getLocale().getCountry()+"/"+req.getLocale().getDisplayCountry(), null);
		try {
			logDao.writeStoreIdKeyWordNone(log);
			return true;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean writeLogStore(HttpServletRequest req, String classification, int store_id, int account_id) {
		LogVo log;
		if(account_id==0) {
			log = new LogVo(0, 0, store_id, classification, req.getRemoteAddr(), null, req.getLocale().getCountry()+"/"+req.getLocale().getDisplayCountry(), null);			
		}else {
			log = new LogVo(0, account_id, store_id, classification, req.getRemoteAddr(), null, req.getLocale().getCountry()+"/"+req.getLocale().getDisplayCountry(), null);
		}
		try {
			logDao.insertLogStore(log);
			storeDao.updateViewcnt(store_id);
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

}
