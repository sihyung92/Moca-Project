package com.kkssj.moca.service;

import com.kkssj.moca.model.entity.AccountVo;

public interface AccountService {
	//kakao�κ��� ���� �����͸� VO ��üȭ�� �� DB�� �����ؼ� �����Ͱ� ���ٸ�(Ȥ�� �ٸ��ٸ�) ���� (select, insert, update?)
	AccountVo login(AccountVo accountVo);

	AccountVo researchInsert(AccountVo stringFilter);
}
