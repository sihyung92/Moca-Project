package com.kkssj.moca.model;

import java.sql.SQLException;
import java.util.List;

import com.kkssj.moca.model.entity.ImageVo;
import com.kkssj.moca.model.entity.ReviewVo;

public interface ReviewDao {

	List<ReviewVo> selectAll(int accountId, int storeId);

	int insertLikeHate(int review_id, int accountId, int isLike);
	
	int updateLikeHate(int review_id, int accountId, int isLike);

	int deleteLikeHate(int review_id, int accountId);

	int updateLikeCount(int review_id, int likeCount);
	
	int updateHateCount(int review_id, int hateCount);
	
	int selectLikeCount(int review_id);

	int selectHateCount(int review_id);

	int selectLikeHateLike(int reviewId);

	int selectLikeHateHate(int reviewId);

	int insertReview(ReviewVo reviewVo);

	ReviewVo selectAddedOne(int accountId);

	int updateReview(ReviewVo reviewVo);

	List<ReviewVo> selectAllReviewId();

	List<ReviewVo> selectAllReviewLevel(int storeId);
	
	int deleteReview(int review_id) throws SQLException;

	List<ImageVo> selectReviewImgListByStoreId(int storeId) throws SQLException;

	
}
