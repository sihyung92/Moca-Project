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
				if(accountVo.getProfileImage().equals("https://ssl.pstatic.net/static/pwe/address/img_profile.png")) {
					accountVo.setProfileImage("");
					accountVo.setThumbnailImage("");
				}
				accountDao.insertUser(accountVo);	//새로이 JSON => VO를 DB에 입력한다.
				
				compareVo =accountDao.selectUser(accountVo.getPlatformType(), accountVo.getPlatformId());	//입력된 값으로 새로 조회해온다.
				return compareVo;
			}else {	//DB에 데이터도 있으며 값도 다르지 않은 경우 다시 이 DB속 VO(compareVo)를 리턴해준다(이때는 account_id가 제대로 설정된 VO로 받아옴)
				
				//오늘날짜로 "로그인"이 하나도 없을 경우만
				if(accountDao.selectExpLogByAccountId(compareVo.getAccount_id(), "로그인")==0) {
					//로그인 exp 증가
					accountDao.updateAccountExp(compareVo.getAccount_id(), 2);
					accountDao.insertExpLog(compareVo.getAccount_id(), "로그인", 2);
					accountDao.updateAttendanceCount(compareVo.getAccount_id());
					
					//포인트가 레벨업 할만큼 쌓였는지 검사
					AccountVo accountVoForExp = accountDao.selectByaccountId(compareVo.getAccount_id());
					accountVoForExp.setMaxExp();
					if(accountVoForExp.getExp() >= accountVoForExp.getMaxExp()) {
						accountDao.updateAccountlevel(accountVoForExp.getAccount_id());
					}
				}
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
				//"설문조사" 하나도 없을 경우만
				if(accountDao.selectExpLogByAccountId(account_id, "설문조사")==0) {
					//설문조사 exp 증가
					accountDao.updateAccountExp(account_id, 30);
					accountDao.insertExpLog(account_id, "설문조사", 30);
					
					//포인트가 레벨업 할만큼 쌓였는지 검사
					AccountVo accountVoForExp = accountDao.selectByaccountId(account_id);
					accountVo.setMaxExp();
					if(accountVoForExp.getExp() >= accountVoForExp.getMaxExp()) {
						accountDao.updateAccountlevel(account_id);
					}
				}
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
