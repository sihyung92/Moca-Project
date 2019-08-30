package com.kkssj.moca.service;

import com.kkssj.moca.model.entity.AccountVo;

public interface AccountService {
	//kakao로부터 받은 데이터를 VO 객체화한 후 DB와 대조해서 데이터가 없다면(혹은 다르다면) 재등록 (select, insert, update?)
	AccountVo login(AccountVo accountVo);

	AccountVo researchInsert(AccountVo stringFilter);
}
