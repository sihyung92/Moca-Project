package com.kkssj.moca.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.kkssj.moca.controller.HomeController;
import com.kkssj.moca.model.entity.ReviewVo;

@Repository
public class ReviewDaoImpl implements ReviewDao {
	private static final Logger logger = LoggerFactory.getLogger(ReviewDaoImpl.class);

	@Inject
	SqlSession sqlSession;


	@Override
	public List<ReviewVo> selectAll(int accountId, int storeId) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("ACCOUNTID", accountId);
		map.put("STOREID", storeId);
		
//		return sqlSession.selectList("review.selectAll",map);
		
		List<ReviewVo> list = sqlSession.selectList("review.selectAll",map);
		for (int i = 0; i < list.size(); i++) {
			System.out.println(list.get(i).getReview_id() + "," +list.get(i).getIsLike());
//			logger.debug(list.get(i).toString());
		}
		
		return list;
	}


	@Override
	public int insertLikeHate(int review_id, int accountId, int isLike) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		map.put("ISLIKE", isLike);
		
		return sqlSession.insert("review.insertLikeHate", map);
		
//		int a = sqlSession.insert("review.insertLikeHateOne", map);
//		System.out.println("result = "+a);
//		
//		return a;
	}


	@Override
	public int updateLikeHate(int review_id, int accountId, int isLike) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		map.put("ISLIKE", isLike);
		
		return sqlSession.update("review.updateLikeHate", map);
		
//		int a = sqlSession.insert("review.updateLikeHateOne", map);
//		System.out.println("result = "+a);
//		
//		return a;
	}


	@Override
	public int deleteLikeHate(int review_id, int accountId) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		
		return sqlSession.delete("review.deleteLikeHate", map);
		
//		int a = sqlSession.insert("review.deleteLikeHateOne", map);
//		System.out.println("result = "+a);
//		
//		return a;
	}


	@Override
	public int updateLikeCount(int review_id, int likeCount) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("LIKECOUNT", likeCount);
		int result = sqlSession.update("review.updateLikeCount", map);
		logger.debug("result:"+result);
		return result;
	}


	@Override
	public int updateHateCount(int review_id, int hateCount) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("HATECOUNT", hateCount);
		int result = sqlSession.update("review.updateHateCount", map);
		logger.debug("result:"+result);
		return result;
	}


	@Override
	public int selectLikeCount(int review_id) {
		int likeCount = sqlSession.selectOne("review.selectLikeCount", review_id);
		logger.debug("likeCount:"+likeCount);
		return likeCount;
	}


	@Override
	public int selectHateCount(int review_id) {
		int hateCount = sqlSession.selectOne("review.selectHateCount", review_id);
		logger.debug("hateCount:"+hateCount);
		return hateCount;
	}


	@Override
	public int selectLikeHateLike(int reviewId) {
		int likeHateLike = sqlSession.selectOne("review.selectLikeHateLike", reviewId);
		logger.debug("likeHateLike:"+likeHateLike);
		return likeHateLike;
	}


	@Override
	public int selectLikeHateHate(int reviewId) {
		int likeHateHate = sqlSession.selectOne("review.selectLikeHateHate", reviewId);
		logger.debug("likeHateLike:"+likeHateHate);
		return likeHateHate;
	}


	@Override
	public int insertReview(ReviewVo reviewVo) {
		logger.debug(reviewVo.toString());
		int result = sqlSession.insert("review.insertReview", reviewVo);
		logger.debug("result:"+result);
		return result;
	}


	@Override
	public ReviewVo selectAddedOne(int accountId) {
		return sqlSession.selectOne("review.selectAddedOne", accountId);
	}

}
