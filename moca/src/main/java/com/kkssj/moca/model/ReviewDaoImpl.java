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

import com.kkssj.moca.controller.HomeController;
import com.kkssj.moca.model.entity.ImageVo;
import com.kkssj.moca.model.entity.ReviewVo;

@Repository
public class ReviewDaoImpl implements ReviewDao {
	private static final Logger logger = LoggerFactory.getLogger(ReviewDaoImpl.class);

	@Inject
	SqlSession sqlSession;


	//store 디테일 페이지에서 해당 카페의 review를 가져옴
	@Override
	public List<ReviewVo> selectAll(int accountId, int storeId) throws SQLException {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("ACCOUNTID", accountId);
		map.put("STOREID", storeId);
		
		return sqlSession.selectList("review.selectAll",map);
	}
	
	//리뷰 추가
	@Override
	public int insertReview(ReviewVo reviewVo) throws SQLException {
		logger.debug(reviewVo.toString());
		int result = sqlSession.insert("review.insertReview", reviewVo);
		logger.debug("result:"+result);
		return result;
	}

	//방금 추가한 리뷰를 가져옴(추가 이후 생성되는 정보를 가져오기 위해)
	@Override
	public ReviewVo selectAddedOne(int accountId) throws SQLException {
		return sqlSession.selectOne("review.selectAddedOne", accountId);
	}

	//리뷰 수정
	@Override
	public int updateReview(ReviewVo reviewVo) throws SQLException{
		return sqlSession.update("review.updateReview", reviewVo);
	}
	

	//리뷰 삭제
	public int deleteReview(ReviewVo reviewVo) throws SQLException {
		return sqlSession.delete("review.deleteReview",reviewVo);
	}

	//likeHate 테이블에 row 추가
	@Override
	public int insertLikeHate(int review_id, int accountId, int isLike) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		map.put("ISLIKE", isLike);
		
		return sqlSession.insert("review.insertLikeHate", map);
	}

	//likeHate 테이블에 row 수정
	@Override
	public int updateLikeHate(int review_id, int accountId, int isLike) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		map.put("ISLIKE", isLike);
		
		return sqlSession.update("review.updateLikeHate", map);
	}


	//likeHate 테이블에 row 삭제
	@Override
	public int deleteLikeHate(int review_id, int accountId) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		
		return sqlSession.delete("review.deleteLikeHate", map);
	}

	//review 테이블에 likeCount값 수정
	@Override
	public int updateLikeCount(int review_id, int likeCount) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("LIKECOUNT", likeCount);
		logger.debug("REVIEW_ID:"+review_id+ ", LIKECOUNT:"+likeCount);		
		return sqlSession.update("review.updateLikeCount", map);
	}

	//review 테이블에 hateCount값 수정
	@Override
	public int updateHateCount(int review_id, int hateCount) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("HATECOUNT", hateCount);
		logger.debug("REVIEW_ID:"+review_id+ ", HATECOUNT:"+hateCount);		
		return sqlSession.update("review.updateHateCount", map);
	}

	//review 테이블에 likeCount, hateCount값 조회
	@Override
	public ReviewVo selectLikeHateCount(int review_id) throws SQLException{
		ReviewVo reviewVo = sqlSession.selectOne("review.selectLikeHateCount", review_id);
		logger.debug("likeCount:"+reviewVo.getLikeCount());
		return reviewVo;
	}


	//likeHate 테이블에 isLike=1인 개수 조회
	@Override
	public int selectLikeHateLike(int reviewId) throws SQLException{
		try {
			return sqlSession.selectOne("review.selectLikeHateLike", reviewId);
		}catch (NullPointerException e) {
			//좋아요가 없는 경우
			return 0;
		}
		
	}

	//likeHate 테이블에 isLike=-1인 개수 조회
	@Override
	public int selectLikeHateHate(int reviewId) throws SQLException {
		try {
			return sqlSession.selectOne("review.selectLikeHateHate", reviewId);
		}catch (NullPointerException e) {
			//싫어요가 없는 경우
			return 0;
		}
	}
	
	
	//리뷰 이미지 등록
	@Override
	public int insertReviewImage(ImageVo imgaeVo) throws SQLException {
		return sqlSession.insert("review.insertReviewImage", imgaeVo);
	}


	//review 테이블에있는 review_id값 조회
	@Override
	public List<ReviewVo> selectAllReviewId() throws SQLException{
		return sqlSession.selectList("review.selectAllReviewId");
	}
	
	//해당 store에 있는 review의 점수(맛, 가격 등) 조회
	@Override
	public List<ReviewVo> selectAllReviewLevel(int storeId) throws SQLException{
		return sqlSession.selectList("review.selectAllReviewLevel", storeId);
	}
	
	//리뷰 이미지 가져오기
	@Override
	public List<ImageVo> selectReviewImgListByStoreId(int storeId) {
		return sqlSession.selectList("review.selectReviewImgListByStoreId", storeId);
	}

	//리뷰 이미지 제거
	@Override
	public int deleteReviewImage(ImageVo imageVo) throws SQLException {
		return sqlSession.delete("review.deleteReviewImage", imageVo);
	}

	@Override
	public List<ImageVo> selectReviewImgListByReviewId(int reviewId) throws SQLException {
		return sqlSession.selectList("review.selectReviewImgListByReviewId", reviewId);
	}

	

}
