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
	
	//store의 viewcnt 증가
	int updateViewcnt(int store_id) throws SQLException;

	List<String> selectTagList() throws SQLException;
	
	List<StoreVo> selectFollowersStoresList(int id);	
	
	List<StoreVo> selectStoresListByRating(Map<String, String> variables);	

	List<StoreVo> selectStoresListByTag(Map<String, String> variables);
	
	List<String> selectTagNames();
	
	int selectAlreadyReviewByKakaoId(int kakaoId) throws SQLException;

	int updateLevelCnt(int storeId, String levelCntColumn, int addCntNum) throws SQLException;

	List<StoreVo> selectAllLikeCntList();

	int updateStoreLikeCnt(StoreVo storeVo);

	List<StoreVo> selectAllReviewCntList();

	int updateStoreReviewCnt(StoreVo storeVo);

	List<StoreVo> selectAllFavoriteCntList();

	int updateStoreFavoriteCnt(StoreVo storeVo);

	int updateReviewCount(int store_id, int upDown) throws SQLException;

	int updateLikeCount(int storeId, int upDown) throws SQLException;

	int updateFavoriteCount(int storeId, int upDown) throws SQLException;

	int updateStoreTag(int store_id, String topTags) throws SQLException;
	
	List<Integer> selectAllStoreId();
	
}
