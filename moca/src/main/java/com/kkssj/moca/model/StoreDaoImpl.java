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
	public List<StoreVo> selectListByTag(Map<String, Object> variables) {
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
		List<StoreVo> list = sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectStoresNearBy",variables);
		logger.debug("DAO: 근처 카페 요청 후");
		return list;
	}

	@Override
	public List<StoreVo> selectTrendStoresList(String tagName) {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectByReviewTag",tagName);
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
	public List<StoreVo> selectStoresListByTag(Map<String, String> variables) {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectStoresListByTag", variables);
	}
    
  @Override
	public int updateStoreImg(Map<String, Object> map) {	
		return sqlSession.update("com.kkssj.moca.model.StoreDao.updateStoreImg", map);
	}

	@Override
	public int updateStoreLogo(Map<String, Object> map) {
		return sqlSession.update("com.kkssj.moca.model.StoreDao.updateStoreLogo", map);
	}

	@Override
	public String selectCategoryByStoreId(int store_Id) {
		return sqlSession.selectOne("com.kkssj.moca.model.StoreDao.selectCategoryByStoreId", store_Id);
	}

	public int updateViewcnt(int store_id) throws SQLException {
		return sqlSession.update("com.kkssj.moca.model.StoreDao.updateViewcnt",store_id);
	}

	@Override
	public List<String> selectTagList() throws SQLException{
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectTagList");
	}
	
	@Override
	public List<StoreVo> selectStoresListByRating(Map<String, String> variables) {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectStoresListByRating", variables);
	}
	
	@Override
	public List<String> selectTagNames(){
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectTagNames");
	}

	@Override
	public int selectAlreadyReviewByKakaoId(int kakaoId) throws SQLException {
		return sqlSession.selectOne("com.kkssj.moca.model.StoreDao.selectAlreadyReviewByKakaoId",kakaoId);
	}

	@Override
	public int updateLevelCnt(int storeId, String levelCntColumn, int addCntNum) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("STORE_ID", storeId);
		map.put("LEVELCNTCOLUMN", levelCntColumn);
		map.put("ADDCNTNUM", addCntNum);
		return sqlSession.update("com.kkssj.moca.model.StoreDao.updateLevelCnt",map);
	}

	@Override
	public List<Integer> selectAllStoreId() {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectAllStoreId");
	}
	public List<StoreVo> selectAllLikeCntList() {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectAllLikeCntList");
	}
	@Override
	public int updateStoreLikeCnt(StoreVo storeVo) {
		return sqlSession.update("com.kkssj.moca.model.StoreDao.updateStoreLikeCnt", storeVo);
	}

	@Override
	public List<StoreVo> selectAllReviewCntList() {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectAllReviewCntList");
	}

	@Override
	public int updateStoreReviewCnt(StoreVo storeVo) {
		return sqlSession.update("com.kkssj.moca.model.StoreDao.updateStoreReviewCnt", storeVo);
	}

	@Override
	public List<StoreVo> selectAllFavoriteCntList() {
		return sqlSession.selectList("com.kkssj.moca.model.StoreDao.selectAllFavoriteCntList");
	}

	@Override
	public int updateStoreFavoriteCnt(StoreVo storeVo) {
		return sqlSession.update("com.kkssj.moca.model.StoreDao.updateStoreFavoriteCnt", storeVo);
	}

	@Override
	public int updateReviewCount(int store_id, int upDown) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("STORE_ID", store_id);
		map.put("upDown", upDown);
		return sqlSession.update("com.kkssj.moca.model.StoreDao.updateReviewCount", map);
	}

	@Override
	public int updateLikeCount(int storeId, int upDown) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("STORE_ID", storeId);
		map.put("upDown", upDown);
		return sqlSession.update("com.kkssj.moca.model.StoreDao.updateLikeCount", map);
	}

	@Override
	public int updateFavoriteCount(int storeId, int upDown) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("STORE_ID", storeId);
		map.put("upDown", upDown);
		return sqlSession.update("com.kkssj.moca.model.StoreDao.updateFavoriteCount", map);
	}

	@Override
	public int updateStoreTag(int store_id, String topTags) throws SQLException  {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("STORE_ID", store_id);
		map.put("TAG", topTags);
		return sqlSession.update("com.kkssj.moca.model.StoreDao.updateStoreTag", map);
	}

	@Override
	public int updateLevelCntAll(Integer store_id, int level1Cnt, int level2Cnt, int level3Cnt, int level4Cnt,
			int level5Cnt) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("STORE_ID", store_id);
		map.put("LEVEL1CNT", level1Cnt);
		map.put("LEVEL2CNT", level2Cnt);
		map.put("LEVEL3CNT", level3Cnt);
		map.put("LEVEL4CNT", level4Cnt);
		map.put("LEVEL5CNT", level5Cnt);
		return sqlSession.update("com.kkssj.moca.model.StoreDao.updateLevelCntAll", map);
	}
}