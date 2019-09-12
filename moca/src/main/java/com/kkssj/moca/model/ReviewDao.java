package com.kkssj.moca.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.kkssj.moca.model.entity.ImageVo;
import com.kkssj.moca.model.entity.ReviewVo;

public interface ReviewDao {

	List<ReviewVo> selectReviewByStoreId(int accountId, int storeId) throws SQLException;

	int insertLikeHate(int review_id, int accountId, int isLike) throws SQLException;
	
	int updateLikeHate(int review_id, int accountId, int isLike) throws SQLException;

	int deleteLikeHate(int review_id, int accountId) throws SQLException;

	int updateLikeCount(int review_id, int likeCount) throws SQLException;
	
	int updateHateCount(int review_id, int hateCount) throws SQLException;
	
	ReviewVo selectLikeHateCount(int review_id) throws SQLException;

	int selectLikeHateLike(int reviewId) throws SQLException;

	int selectLikeHateHate(int reviewId) throws SQLException;

	int insertReview(ReviewVo reviewVo) throws SQLException;

	ReviewVo selectAddedOne(int accountId) throws SQLException;

	int updateReview(ReviewVo reviewVo) throws SQLException;

	List<ReviewVo> selectAllReviewId() throws SQLException;

	List<ReviewVo> selectAllReviewLevel(int storeId) throws SQLException;
	
	int deleteReview(ReviewVo reviewVo) throws SQLException;

	int insertReviewImage(ImageVo imgaeVo) throws SQLException;

	int deleteReviewImage(ImageVo imageVo) throws SQLException;

	List<ImageVo> selectReviewImgListByReviewId(int review_id) throws SQLException;

	List<ImageVo> selectReviewImgListByStoreId(int storeId) throws SQLException;

	List<ReviewVo> selectRecentReviews() throws SQLException;

	List<ReviewVo> selectReviewListByAccountId(int accountId, int sessionId, int startNum) throws SQLException;

	List<ImageVo> selectReviewImgListByAccountId(int accountId) throws SQLException;

	List<ReviewVo> selectBestReviews() throws SQLException;
  
	int selectAccountIdOfReviewByReviewId(int review_id) throws SQLException;

	//리뷰 3개씩 불러오기
	List<ReviewVo> selectReviewLimit3ByStoreId(int accountId, int storeId, int startNum) throws SQLException;

	List<Map<String, Object>> selectTagsLimit3ByStoreId(int accountId, int storeId, int startNum) throws SQLException;

	int insertTags(Map<String, Object> tagMap) throws SQLException;

	int updateTags(Map<String, Object> tagMap) throws SQLException;

	List<Map<String, Object>> selectTagsLimit3ByAccountId(int targetAccountId, int startNum) throws SQLException;
	
	//평균점수 불러오기
	double selectAverageLevelByReviewId(int review_id) throws SQLException;

	List<Map<String, Integer>> selectTagListByStoreId(int store_id);
}
