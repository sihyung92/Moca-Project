package com.kkssj.moca.model;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.BadgeVo;
import com.kkssj.moca.model.entity.StoreVo;

@Repository
public class AccountDaoImpl implements AccountDao {
	private static final Logger logger = LoggerFactory.getLogger(AccountDaoImpl.class);

	@Inject
	SqlSession sqlSession;
	
	@Override
	public int insertUser(AccountVo accountVo) throws SQLException{
		// TODO Auto-generated method stub
		return sqlSession.insert("com.kkssj.moca.model.AccountDao.insertUser", accountVo);
	}

	@Override
	public AccountVo selectUser(String platformType, int platformId) throws SQLException{
		// TODO Auto-generated method stub
		return sqlSession.selectOne("com.kkssj.moca.model.AccountDao.selectUserBy"+platformType+"Id", (Integer)platformId);
	}
	
	@Override
	public AccountVo selectUserByAccountId(int account_id) throws SQLException {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("com.kkssj.moca.model.AccountDao.selectByaccountId", (Integer)account_id);
	}

	@Override
	public int updateUser(String platformType, AccountVo accountVo) throws SQLException{
		// TODO Auto-generated method stub
		return sqlSession.update("com.kkssj.moca.model.AccountDao.updateUserBy"+platformType+"Id", accountVo);
	}

	@Override
	public int updateUserForIsResearch(AccountVo accountVo) throws SQLException{
		// TODO Auto-generated method stub
		return sqlSession.update("com.kkssj.moca.model.AccountDao.updateUserForIsResearch", accountVo);
	}
	
	@Override
	public int deleteUser() throws SQLException{
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<StoreVo> selectFavoriteStoreList(int account_id) {
		return sqlSession.selectList("com.kkssj.moca.model.AccountDao.selectFavoriteStoreList", account_id);
	}

	@Override
	public List<StoreVo> selectLikeStoreList(int account_id) {
		return sqlSession.selectList("com.kkssj.moca.model.AccountDao.selectLikeStoreList", account_id);
	}

	@Override
	public int insertLikeStore(int storeId, int account_id) throws SQLException {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("STORE_ID", storeId);
		map.put("ACCOUNT_ID", account_id);
		return sqlSession.insert("com.kkssj.moca.model.AccountDao.insertLikeStore", map);
	}

	@Override
	public int deleteLikeStore(int storeId, int account_id) throws SQLException {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("STORE_ID", storeId);
		map.put("ACCOUNT_ID", account_id);
		return sqlSession.insert("com.kkssj.moca.model.AccountDao.deleteLikeStore", map);
	}

	@Override
	public int insertFavoriteStore(int storeId, int account_id) throws SQLException {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("STORE_ID", storeId);
		map.put("ACCOUNT_ID", account_id);	
		return sqlSession.insert("com.kkssj.moca.model.AccountDao.insertFavoriteStore", map);
	}

	@Override
	public int deleteFavoriteStore(int storeId, int account_id) throws SQLException {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("STORE_ID", storeId);
		map.put("ACCOUNT_ID", account_id);
		return sqlSession.insert("com.kkssj.moca.model.AccountDao.deleteFavoriteStore", map);
	}
	
	@Override
	public List<AccountVo> selectFollowerList(int account_id) throws SQLException {
		return sqlSession.selectList("com.kkssj.moca.model.AccountDao.selectFollowerList",account_id);
	}

	@Override
	public List<AccountVo> selectFollowingList(int account_id) throws SQLException {
		return sqlSession.selectList("com.kkssj.moca.model.AccountDao.selectFollowingList",account_id);
	}

	@Override
	public int insertFollow(int follower, int following) throws SQLException {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("follower", follower);
		map.put("following", following);
		return sqlSession.insert("com.kkssj.moca.model.AccountDao.insertFollow",map);
	}

	@Override
	public int deleteFollow(int follower, int following) throws SQLException {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("follower", follower);
		map.put("following", following);
		return sqlSession.insert("com.kkssj.moca.model.AccountDao.deleteFollow",map);
	}

	@Override
	public AccountVo selectByaccountId(int account_id) throws SQLException {
		return sqlSession.selectOne("com.kkssj.moca.model.AccountDao.selectByaccountId",account_id);
	}

	@Override
	public int updateAccount(AccountVo editAccountVo) throws SQLException {
		return sqlSession.update("com.kkssj.moca.model.AccountDao.updateAccount",editAccountVo);
	}

	@Override
	public AccountVo selectProfileImageByaccountId(int account_id) {
		return sqlSession.selectOne("com.kkssj.moca.model.AccountDao.selectProfileImageByaccountId",account_id);
	}

	@Override
	public int deleteAccount(int accountId) throws SQLException {
		return sqlSession.delete("com.kkssj.moca.model.AccountDao.deleteAccount",accountId);
	}

	@Override
	public int updateAccountExp(int accountId, int exp) throws SQLException {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("ACCOUNT_ID", accountId);
		map.put("EXP", exp);
		return sqlSession.update("com.kkssj.moca.model.AccountDao.updateAccountExp",map);
	}

	@Override
	public int insertExpLog(int accountId, String classification, int exp) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ACCOUNT_ID", accountId);
		map.put("CLASSIFICATION", classification);
		map.put("EXP", exp);
		return sqlSession.insert("com.kkssj.moca.model.AccountDao.insertExpLog",map);
	}

	@Override
	public int updateAccountlevel(int accountId) throws SQLException {
		return sqlSession.update("com.kkssj.moca.model.AccountDao.updateAccountlevel",accountId);
	}

	@Override
	public int updateAccountlevelDown(int accountId) throws SQLException {
		return sqlSession.update("com.kkssj.moca.model.AccountDao.updateAccountlevelDown",accountId);
	}

	@Override
	public int selectExpLogByAccountId(int accountId, String classification) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ACCOUNT_ID", accountId);
		map.put("CLASSIFICATION", classification);
		return sqlSession.selectOne("com.kkssj.moca.model.AccountDao.selectExpLogByAccountId",map);
	}

	@Override
	public int updateReviewCount(int account_id) throws SQLException {
		return sqlSession.update("com.kkssj.moca.model.AccountDao.updateReviewCount",account_id);
	}

	@Override
	public int updateAttendanceCount(int account_id) throws SQLException {
		return sqlSession.update("com.kkssj.moca.model.AccountDao.updateAttendanceCount",account_id);
	}

	@Override
	public int updateFollowCount(int account_id) throws SQLException {
		return sqlSession.update("com.kkssj.moca.model.AccountDao.updateFollowCount",account_id);
	}

	@Override
	public int updateFollowingCount(int account_id) throws SQLException {
		return sqlSession.update("com.kkssj.moca.model.AccountDao.updateFollowingCount",account_id);
	}

	@Override
	public int insertBadge(int account_id, String classification, int level, String badgeUrl) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ACCOUNT_ID", account_id);
		map.put("CLASSIFICATION", classification);
		map.put("BADGELEVEL", level);
		map.put("BADGEURL", badgeUrl);
		return sqlSession.insert("com.kkssj.moca.model.AccountDao.insertBadge", map);
	}

	@Override
	public int selectFollowCountByFollowing(int followingAccount) throws SQLException {
		return sqlSession.selectOne("com.kkssj.moca.model.AccountDao.selectFollowCountByFollowing", followingAccount);
	}

	@Override
	public int selectAttendanceCountByAccountId(int account_id) {
		return sqlSession.selectOne("com.kkssj.moca.model.AccountDao.selectAttendanceCountByAccountId", account_id);
	}

	@Override
	public List<BadgeVo> selectBadgeList(int account_id) throws SQLException {
		return sqlSession.selectList("com.kkssj.moca.model.AccountDao.selectBadgeList", account_id);
	}
}
