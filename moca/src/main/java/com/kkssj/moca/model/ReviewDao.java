package com.kkssj.moca.model;

import java.util.List;

import com.kkssj.moca.model.entity.ReviewVo;

public interface ReviewDao {

	List<ReviewVo> selectAll(int accountId, int storeId);

	int insertLikeHateOne(int review_id, int accountId, int isLike);
	
	int updateLikeHateOne(int review_id, int accountId, int isLike);

	int deleteLikeHateOne(int review_id, int accountId);

	int updateLikeCount(int review_id, int likeCount);
	
	int updateHateCount(int review_id, int hateCount);
	
	int selectLikeCount(int review_id);

	int selectHateCount(int review_id);

	
	

	
}
