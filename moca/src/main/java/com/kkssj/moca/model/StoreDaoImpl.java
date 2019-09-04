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

import com.kkssj.moca.model.entity.ImageVo;
import com.kkssj.moca.model.entity.StoreVo;

@Repository
public class StoreDaoImpl implements StoreDao {
	@Inject
	SqlSession sqlSession;
	
	private static final Logger logger = LoggerFactory.getLogger(StoreDao.class);
	
	@Override
	public List<StoreVo> selectListByTag(Map<String, String> variables) {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectByTag", variables);
	}

	@Override
	public StoreVo selectByKakaoId(int kakaoId) {
		return sqlSession.selectOne("com.kkssj.moca.model.StoreDao.selectByKakaoId", kakaoId);
	}

	@Override
	public StoreVo selectOne(int store_Id,int account_id) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("STORE_ID", store_Id);
		map.put("ACCOUNT_ID", account_id);
		
		return sqlSession.selectOne("com.kkssj.moca.model.StoreDao.selectOne", map);
	}

	@Override
	public int insertOne(StoreVo storeVo) throws SQLException {
		return sqlSession.insert("com.kkssj.moca.model.StoreDao.insertOne", storeVo);
	}
	
	@Override
	public int updateOne(StoreVo storeVo) throws SQLException {
//		if(storeVo.infoEqual(sqlSession.selectOne("store.selectOne", storeVo.getStore_Id()))) {	
//			return -1;
//		}
		return sqlSession.update("com.kkssj.moca.model.StoreDao.updateOne", storeVo);
	}

	@Override
	public int insertStoreInfoHistory(int accountId, StoreVo storeVo) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		//store_id,url,opentime,endtime,wifi,parkinglot,dayoff,tel
		map.put("ACCOUNT_ID", accountId);
		map.put("STORE_ID", storeVo.getStore_Id());
		map.put("URL", storeVo.getUrl());
		map.put("OPENTIME", storeVo.getOpenTime());
		map.put("ENDTIME", storeVo.getEndTime());
		map.put("WIFI", storeVo.getWifi());
		map.put("PARKINGLOT", storeVo.getParkingLot());
		map.put("DAYOFF", storeVo.getDayOff());
		map.put("TEL", storeVo.getTel());
		int result = sqlSession.insert("com.kkssj.moca.model.StoreDao.insertStoreInfoHistory", map);
		return result;
	}

	@Override
	public int updateLevel(StoreVo storeVo) throws SQLException {
		return sqlSession.update("com.kkssj.moca.model.StoreDao.updateLevel", storeVo);
	}

	@Override
	public Map<String, Object> selectStoreInfoHistory(int storeId) throws SQLException {
		return sqlSession.selectOne("com.kkssj.moca.model.StoreDao.selectStoreInfoHistory", storeId);
	}

	@Override
	public Map<String, String> selectStoreImgList(int storeId) throws SQLException{
		return sqlSession.selectOne("com.kkssj.moca.model.StoreDao.selectStoreImgList", storeId);
	}

	@Override
	public List<ImageVo> selectStoreReviewImgList(Map<String, Integer> map) {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectStoreReviewImgList", map);
	}

	@Override
	public List<StoreVo> selectStoresNearBy(Map<String, String> variables) {
		List<StoreVo> list = sqlSession.selectList("selectStoresNearBy",variables);
		logger.debug("DAO: 근처 카페 요청 후");
		return list;
	}

	@Override
	public List<StoreVo> selectTrendStoresList(String tagName) {
		return sqlSession.selectList("selectByReviewTag",tagName);
	}
	
	public List<StoreVo> selectHitStoresList(Map<String, String> variables) {	
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectHitStoresList", variables);
	}

	@Override
	public List<StoreVo> selectBestStoresList() {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectBestStoresList");
	}

	@Override
	public List<StoreVo> selectTakeoutStoresList(Map<String, String> variables) {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectTakeoutStoresList", variables);
	}

	@Override
	public List<StoreVo> selectFollowersStoresList(int id) {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectFollowersStoresList", id);
	}

	@Override
	public List<StoreVo> selectGoodMoodStoresList(Map<String, String> variables) {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectGoodMoodStoresList", variables);
	}

	@Override
	public List<StoreVo> selectGoodTasteStoresList(Map<String, String> variables) {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectGoodTasteStoresList", variables);
	}

	@Override
	public List<StoreVo> selectGoodPriceStoresList(Map<String, String> variables) {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectGoodPriceStoresList", variables);
	}

	@Override
	public List<StoreVo> selectTagStoresList(Map<String, String> variables) {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectTagStoresList", variables);
	} 
}