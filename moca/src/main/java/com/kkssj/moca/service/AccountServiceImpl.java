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
		System.out.println(accountVo.toString());
		
		try {
			AccountVo compareVo =accountDao.selectUser(accountVo.getPlatformType(), accountVo.getPlatformId());
			
			if(compareVo==null) {	//�α��ν� īī���κ��� ���� JSON => VO �� ��ȸ�� ���� ���ٸ�
				accountDao.insertUser(accountVo);	//������ JSON => VO�� DB�� �Է��Ѵ�.
				
				compareVo =accountDao.selectUser(accountVo.getPlatformType(), accountVo.getPlatformId());	//�Էµ� ������ ���� ��ȸ�ؿ´�.
				
				return compareVo;
			}else if(compareVo.hashCode()!=accountVo.hashCode()){	//HashCode�� ���Ѵ� / �����Ͱ� �ֱ�� �ѵ� email�̳� ���� ������ ���� �ٸ��� ���� �ٸ��ٸ� JSON => VO�� �����Ѵ�. ���� �� �۵� �ȵɵ�.
				accountDao.updateUser(accountVo);
				
				compareVo =accountDao.selectUser(accountVo.getPlatformType(), accountVo.getPlatformId());	//����� ������ ���� ��ȸ�ؿ´�.
				
				return compareVo;
			}else {	//DB�� �����͵� ������ ���� �ٸ��� ���� ��� �ٽ� �� DB�� VO(compareVo)�� �������ش�(�̶��� account_id�� ����� ������ VO�� �޾ƿ�)
				
				return compareVo;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}


}
