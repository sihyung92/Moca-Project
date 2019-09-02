package com.kkssj.moca.model;


import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import com.kkssj.moca.model.entity.ImageVo;
import com.kkssj.moca.model.entity.StoreVo;

public interface StoreDao {
	StoreVo selectOne(int store_Id,int account_id) throws SQLException;
	
	StoreVo selectByKakaoId(int kakaoId);
	
	int insertOne(StoreVo storeVo) throws SQLException;

	int updateOne(StoreVo storeVo) throws SQLException;
	
	int insertStoreInfoHistory(int accountId, StoreVo storeVo) throws SQLException;

	int updateLevel(StoreVo storeVo) throws SQLException;

	Map<String, Object> selectStoreInfoHistory(int storeId) throws SQLException;

	Map<String, String> selectStoreImgList(int storeId) throws SQLException;

	List<ImageVo> selectStoreReviewImgList(Map<String, Integer> map) throws SQLException;

	List<StoreVo> selectListByTag(Map<String, String> variables);

	List<StoreVo> selectStoresNearBy(Map<String, String> variables);

	List<StoreVo> selectTrendStoresList(String tagName);
	
	List<StoreVo> selectHitStoresList(Map<String, String> variables);
	
	List<StoreVo> selectBestStoresList();
	
	List<StoreVo> selectTakeoutStoresList(Map<String, String> variables);

	int updateStoreImg(Map<String, Object> map);

	int updateStoreLogo(Map<String, Object> map);

	String selectCategoryByStoreId(int store_Id);
	
}
