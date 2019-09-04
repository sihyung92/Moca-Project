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
			if(compareVo==null) {	//로그인시 카카오로부터 받은 JSON => VO 로 조회한 값이 없다면
				accountDao.insertUser(accountVo);	//새로이 JSON => VO를 DB에 입력한다.
				
				compareVo =accountDao.selectUser(accountVo.getPlatformType(), accountVo.getPlatformId());	//입력된 값으로 새로 조회해온다.
				
				return compareVo;
			}else if(compareVo.hashCode()!=accountVo.hashCode()){	//HashCode로 비교한다 / 데이터가 있기는 한데 email이나 변동 가능한 값이 다른지 비교후 다르다면 JSON => VO로 수정한다. 현재 는 작동 안될듯.
				accountDao.updateUser(accountVo.getPlatformType(),accountVo);
				compareVo =accountDao.selectUser(accountVo.getPlatformType(), accountVo.getPlatformId());	//변경된 값으로 새로 조회해온다.
				return compareVo;
			}else {	//DB에 데이터도 있으며 값도 다르지 않은 경우 다시 이 DB속 VO(compareVo)를 리턴해준다(이때는 account_id가 제대로 설정된 VO로 받아옴)
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
			if(vo1.getBarista()==0) {
				vo1.setBarista(barista);
			}
			if(vo1.getGender()==0) {
				vo1.setGender(gender);
			}
			if(vo1.getBirthday()==null) {
				vo1.setBirthday(birthday);
			}
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

	@Override
	public boolean updateIsResearch(AccountVo accountVo) {
		// TODO Auto-generated method stub
		try {
			accountVo.setIsResearch(1);
			accountDao.updateUserForIsResearch(accountVo);
			return true;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}
}
