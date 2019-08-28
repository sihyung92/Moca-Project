package com.kkssj.moca.service;

import java.sql.SQLException;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.kkssj.moca.model.AccountDao;
import com.kkssj.moca.model.entity.AccountVo;

@Service
public class AccountServiceImpl implements AccountService {
	private static final Logger logger = LoggerFactory.getLogger(AccountServiceImpl.class);
	
	@Inject
	AccountDao accountDao;
	
	/*-----------------------------------------------------------------------------*/
	
	@Override
	public AccountVo login(AccountVo accountVo) {
		// TODO Auto-generated method stub
		
		try {
			AccountVo compareVo =accountDao.selectUser(accountVo.getPlatformType(), accountVo.getPlatformId());
			if(compareVo==null) {
				accountDao.insertUser(accountVo);
				compareVo =accountDao.selectUser(accountVo.getPlatformType(), accountVo.getPlatformId());
				return compareVo;
			}else if(compareVo.hashCode()!=accountVo.hashCode()){
				accountDao.updateUser(accountVo.getPlatformType(), accountVo);
				
				compareVo =accountDao.selectUser(accountVo.getPlatformType(), accountVo.getPlatformId());
				return compareVo;
			}else {
				return compareVo;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}


}
