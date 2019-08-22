package com.kkssj.moca.service;

import com.kkssj.moca.model.entity.AccountVo;

public interface AccountService {
	boolean userLogin(AccountVo accountVo);	//kakao를 통해 처음 로그인시 DB를 저장하는 과정 (일종의 회원가입)
	/* 첫 접속시
	 *  DB에 플랫폼 kakao, 플랫폼ID 를 확인해서 return 값을 확인한다.
	 *  
	 *  return 값이 없는경우 (DB에 데이터가 없다는 의미)
	 *  해당 accountVo를 DB에 새 데이터로 저장한다.
	 *  
	 *  return 값이 있는경우 DB와 데이터를 대조해서 값이 같지 않다면
	 *  해당 accountVO를 DB에 새 데이터로 저장한다.
	 *  
	 *  대조했을 때 값이 같다면 true를 리턴한다.?
	 *  */
}
