package com.kkssj.moca.model;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.kkssj.moca.model.entity.AccountVo;
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
	public List<AccountVo> selectByMultipleQuery(int[] account_id) throws SQLException {
		// TODO Auto-generated method stub
		String preString ="'%' AND( ACCOUNT_ID = ";
		String foreString =")";
		
		String string ="";
		for (int i=0;i<account_id.length;i++) {
			string = string + account_id[i];
			if(i!=account_id.length-1) {
				string = string +" OR ACCOUNT_id = ";
			}
		}
		string = preString + string + foreString;
		
		return sqlSession.selectList("com.kkssj.moca.model.AccountDao.selectByMultipleQuery", string);
	}
}
