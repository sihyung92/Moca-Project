package com.kkssj.moca.service;

import com.kkssj.moca.model.entity.AccountVo;

public interface AccountService {
	boolean userLogin(AccountVo accountVo);	//kakao�� ���� ó�� �α��ν� DB�� �����ϴ� ���� (������ ȸ������)
	/* ù ���ӽ�
	 *  DB�� �÷��� kakao, �÷���ID �� Ȯ���ؼ� return ���� Ȯ���Ѵ�.
	 *  
	 *  return ���� ���°�� (DB�� �����Ͱ� ���ٴ� �ǹ�)
	 *  �ش� accountVo�� DB�� �� �����ͷ� �����Ѵ�.
	 *  
	 *  return ���� �ִ°�� DB�� �����͸� �����ؼ� ���� ���� �ʴٸ�
	 *  �ش� accountVO�� DB�� �� �����ͷ� �����Ѵ�.
	 *  
	 *  �������� �� ���� ���ٸ� true�� �����Ѵ�.?
	 *  */
}
