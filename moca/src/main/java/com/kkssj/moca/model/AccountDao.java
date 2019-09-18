package com.kkssj.moca.model;

import java.sql.SQLException;
import java.util.List;
import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.BadgeVo;
import com.kkssj.moca.model.entity.StoreVo;

public interface AccountDao {
	//create
	int insertUser(AccountVo accountVo) throws SQLException;
	//read(get)
	AccountVo selectUser(String platformType, int platformId) throws SQLException;
	//
	AccountVo selectUserByAccountId(int account_id) throws SQLException;
	//update
	int updateUser(String platformType, AccountVo accountVo) throws SQLException;
	int updateUserForIsResearch(AccountVo accountVo) throws SQLException;
	//delete
	int deleteUser() throws SQLException;
	
	//가고 싶은 카페 리스트 가져오기
	List<StoreVo> selectFavoriteStoreList(int account_id) throws SQLException;
	
	//좋아요한 카페 리스트 가져오기
	List<StoreVo> selectLikeStoreList(int account_id) throws SQLException;
	
	//카페 좋아요 누르기
	int insertLikeStore(int storeId, int account_id) throws SQLException;
	
	//카페 좋아요 취소
	int deleteLikeStore(int storeId, int account_id) throws SQLException;
	
	//가고싶은 카페 추가
	int insertFavoriteStore(int storeId, int account_id) throws SQLException;
	
	//가고싶은 카페 취소
	int deleteFavoriteStore(int storeId, int account_id) throws SQLException;
	
	//해당 account의 follower 가져오기
	List<AccountVo> selectFollowerList(int accountId) throws SQLException;
	
	//해당 account의 following목록 가져오기
	List<AccountVo> selectFollowingList(int accountId) throws SQLException;
	
	//해당 account의 following목록 추가하기
	int insertFollow(int follower, int following) throws SQLException;
	
	//해당account의 following 삭제
	int deleteFollow(int follower, int following) throws SQLException;
	
	//해당 account의 정보 불러오기
	AccountVo selectByaccountId(int account_id) throws SQLException;
	
	//해당 account의 정보 수정
	int updateAccount(AccountVo editAccountVo) throws SQLException;
	
	//해당 account의 image 불러오기
	AccountVo selectProfileImageByaccountId(int account_id) throws SQLException;
	
	//해당 account 삭제
	int deleteAccount(int accountId) throws SQLException;
	
	//해당 account의 exp 누적
	int updateAccountExp(int accountId, int exp) throws SQLException;
	
	//해당 account의 exp 누적 활동 기록
	int insertExpLog(int accountId, String classification, int exp) throws SQLException;
	
	//해당 account의 level up
	int updateAccountlevel(int accountId) throws SQLException;
	
	//해당 account의 level down
	int updateAccountlevelDown(int accountId) throws SQLException;
	
	//해당 account의 exp log 조회
	int selectExpLogByAccountId(int accountId, String classification) throws SQLException;
	
	//해당 acoount의 reviewcount 증감
	int updateReviewCount(int account_id, int cnt) throws SQLException;
	
	//해당 acoount의 AttendanceCount 증가
	int updateAttendanceCount(int account_id) throws SQLException;
	
	//해당 acoount의 FollowCount 증감
	int updateFollowCount(int account_id, int cnt) throws SQLException;
	
	//해당 acoount의 FollowingCount 증감
	int updateFollowingCount(int account_id, int cnt) throws SQLException;
	
	//배지 추가
	int insertBadge(int account_id, String classification, int level, String badgeUrl) throws SQLException;
	
	//자신의 follow수 조회
	int selectFollowCountByFollowing(int followingAccount) throws SQLException;
	
	//자신의 출석수 조회
	int selectAttendanceCountByAccountId(int account_id) throws SQLException;
	
	//배지 리스트 조회
	List<BadgeVo> selectBadgeList(int account_id) throws SQLException;
	

}