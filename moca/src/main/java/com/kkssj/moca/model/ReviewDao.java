package com.kkssj.moca.model;

import java.sql.SQLException;
import java.util.List;

import com.kkssj.moca.model.entity.ImageVo;
import com.kkssj.moca.model.entity.ReviewVo;

public interface ReviewDao {

	List<ReviewVo> selectAll(int accountId, int storeId) throws SQLException;

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

	List<ReviewVo> selectRecentReviews();

	List<ReviewVo> selectReviewListByAccountId(int accountId, int sessionId) throws SQLException;

	List<ImageVo> selectReviewImgListByAccountId(int accountId) throws SQLException;

	int selectAccountIdOfReviewByReviewId(int review_id) throws SQLException;
}
