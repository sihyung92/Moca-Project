package com.kkssj.moca.service;

import java.sql.Date;
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

	@Override
	public AccountVo researchInsert(AccountVo accountVo) {
		// TODO Auto-generated method stub
		int account_id = accountVo.getAccount_id();
		int gender = accountVo.getGender();
		int barista = accountVo.getBarista();
		Date birthday = accountVo.getBirthday();
		
		try {
			AccountVo vo1 = accountDao.selectUserByAccountId(account_id);
			System.out.println(vo1.toString());
			if(vo1.getBarista()==0) {
				vo1.setBarista(barista);
			}
			if(vo1.getGender()==0) {
				vo1.setGender(gender);
			}
			if(vo1.getBirthday()==null) {
				vo1.setBirthday(birthday);
			}
			System.out.println(vo1.toString());
			int cnt=accountDao.updateUser(vo1.getPlatformType(), vo1);
			if(cnt==1) {
				return vo1;
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
		return null;
	}


}
