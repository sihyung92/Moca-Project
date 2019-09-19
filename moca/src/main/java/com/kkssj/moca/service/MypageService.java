package com.kkssj.moca.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.BadgeVo;
import com.kkssj.moca.model.entity.ReviewVo;

public interface MypageService{

	//해당 account의 follower목록 가져오기
	List<AccountVo> getFollowerList(int accountId);
	
	//해당 account의 following목록 가져오기
	List<AccountVo> getFollowingList(int accountId);
	
	//해당 account의 내가 쓴 리뷰 가져오기
	List<ReviewVo> getMyReviewListLimit(int myAccountId, int targetAccountId, int startNum);

	//해당 account의 follow신청
	int addFollow(int follower, int following);

	//해당 account의 follow신청취소
	int deleteFollow(int follower, int following);

	//해당 account의 정보 가져오기
	AccountVo getAccountInfo(int Account_id);	
	
	//가고싶은 카페 가져오기
	List<StoreVo> getFavoriteStoreList(int accountId);

	//좋아요한 카페 가져오기
	List<StoreVo> getLikeStoreList(int accountId);

	//해당 account의 회원정보 수정하기
	int editAccount(AccountVo editAccountVo, MultipartFile accountImage);
	
	//해당 account의 회원탈퇴(삭제)
	int deleteAccount(int accountId);

	//tag 이름 가져오기
	List<String> getTagNameList();

	//배지 리스트 가져오기
	List<BadgeVo> getBadgeList(int account_id);
	

}
