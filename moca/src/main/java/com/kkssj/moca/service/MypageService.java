package com.kkssj.moca.service;

import java.util.List;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.ReviewVo;

public interface MypageService{

	//해당 account의 follower목록 가져오기
	List<AccountVo> getFollowerList(int accountId);
	
	//해당 account의 following목록 가져오기
	List<AccountVo> getFollowingList(int accountId);
	
	//해당 account의 내가 쓴 리뷰 가져오기
	List<ReviewVo> getMyreviewList(int accountId, int sessionId);
	
	//해당 account의 회원정보 수정하기
	int editAccount(int accountId);
	
	//해당 account의 회원탈퇴(삭제)
	int deleteAccount(int accountId);

	//해당 account의 follow신청
	int addFollow(int follower, int following);

	//해당 account의 follow신청취소
	int deleteFollow(int follower, int following);

	//해당 account의 정보 가져오기
	AccountVo getAccountInfo(int Account_id);	
	
}
