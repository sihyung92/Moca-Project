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
import com.kkssj.moca.model.entity.ReviewVo;

@Repository
public class ReviewDaoImpl implements ReviewDao {
	private static final Logger logger = LoggerFactory.getLogger(ReviewDaoImpl.class);

	@Inject
	SqlSession sqlSession;
  
	//store 디테일 페이지에서 해당 카페의 review를 가져옴
	@Override
	public List<ReviewVo> selectReviewByStoreId(int accountId, int storeId) throws SQLException {
		Map<String, Integer> map = new HashMap<String, Integer>();
		logger.debug("storeId : "+storeId);
		map.put("ACCOUNT_ID", accountId);
		map.put("STORE_ID", storeId);
		
		return sqlSession.selectList("com.kkssj.moca.model.ReviewDao.selectReviewByStoreId",map);
	}
	
	//리뷰 추가
	@Override
	public int insertReview(ReviewVo reviewVo) throws SQLException {
		logger.debug(reviewVo.toString());
		int result = sqlSession.insert("com.kkssj.moca.model.ReviewDao.insertReview", reviewVo);
		logger.debug("result:"+result);
		return result;
	}

	//방금 추가한 리뷰를 가져옴(추가 이후 생성되는 정보를 가져오기 위해)
	@Override
	public ReviewVo selectAddedOne(int accountId) throws SQLException {
		return sqlSession.selectOne("com.kkssj.moca.model.ReviewDao.selectAddedOne", accountId);
	}


	//리뷰 수정
	@Override
	public int updateReview(ReviewVo reviewVo) throws SQLException{
		return sqlSession.update("com.kkssj.moca.model.ReviewDao.updateReview", reviewVo);
	}
	
	//리뷰 삭제
	public int deleteReview(ReviewVo reviewVo) throws SQLException {
		return sqlSession.delete("com.kkssj.moca.model.ReviewDao.deleteReview",reviewVo);
	}

	//likeHate 테이블에 row 추가
	@Override
	public int insertLikeHate(int review_id, int accountId, int isLike) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		map.put("ISLIKE", isLike);
		logger.debug(review_id+", "+accountId +", "+isLike );
		return sqlSession.insert("com.kkssj.moca.model.ReviewDao.insertLikeHate", map);
	}

	//likeHate 테이블에 row 수정
	@Override
	public int updateLikeHate(int review_id, int accountId, int isLike) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		map.put("ISLIKE", isLike);
		logger.debug(review_id+", "+accountId +", "+isLike );
		return sqlSession.update("com.kkssj.moca.model.ReviewDao.updateLikeHate", map);
	}



	//likeHate 테이블에 row 삭제
	@Override
	public int deleteLikeHate(int review_id, int accountId) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		logger.debug(review_id+", "+accountId );
		return sqlSession.delete("com.kkssj.moca.model.ReviewDao.deleteLikeHate", map);
	}

	//review 테이블에 likeCount값 수정
	@Override
	public int updateLikeCount(int review_id) throws SQLException{
		return sqlSession.update("com.kkssj.moca.model.ReviewDao.updateLikeCount", review_id);
	}

	//review 테이블에 hateCount값 수정
	@Override
	public int updateHateCount(int review_id) throws SQLException{		
		return sqlSession.update("com.kkssj.moca.model.ReviewDao.updateHateCount", review_id);
	}

	//review 테이블에 likeCount, hateCount값 조회
	@Override
	public ReviewVo selectLikeHateCount(int review_id) throws SQLException{
		ReviewVo reviewVo = sqlSession.selectOne("com.kkssj.moca.model.ReviewDao.selectLikeHateCount", review_id);
		logger.debug("likeCount:"+reviewVo.getLikeCount());
		return reviewVo;
	}

	//likeHate 테이블에 isLike=1인 개수 조회
	@Override
	public int selectLikeHateLike(int reviewId) throws SQLException{
		try {
			return sqlSession.selectOne("com.kkssj.moca.model.ReviewDao.selectLikeHateLike", reviewId);
		}catch (NullPointerException e) {
			//좋아요가 없는 경우
			return 0;
		}
		
	}

	//likeHate 테이블에 isLike=-1인 개수 조회
	@Override
	public int selectLikeHateHate(int reviewId) throws SQLException {
		try {
			return sqlSession.selectOne("com.kkssj.moca.model.ReviewDao.selectLikeHateHate", reviewId);
		}catch (NullPointerException e) {
			//싫어요가 없는 경우
			return 0;
		}
	}
	
	//리뷰 이미지 등록
	@Override
	public int insertReviewImage(ImageVo imgaeVo) throws SQLException {
		return sqlSession.insert("com.kkssj.moca.model.ReviewDao.insertReviewImage", imgaeVo);
	}

	//review 테이블에있는 review_id값 조회
	@Override
	public List<ReviewVo> selectAllReviewId() throws SQLException{
		return sqlSession.selectList("com.kkssj.moca.model.ReviewDao.selectAllReviewId");
	}
	
	//해당 store에 있는 review의 점수(맛, 가격 등) 조회
	@Override
	public List<ReviewVo> selectAllReviewLevel(int storeId) throws SQLException{
		return sqlSession.selectList("com.kkssj.moca.model.ReviewDao.selectAllReviewLevel", storeId);
	}

	//리뷰 이미지 가져오기
	@Override
	public List<ImageVo> selectReviewImgListByStoreId(int storeId) throws SQLException{
		return sqlSession.selectList("com.kkssj.moca.model.ReviewDao.selectReviewImgListByStoreId", storeId);
	}

	//리뷰 이미지 제거
	@Override
	public int deleteReviewImage(ImageVo imageVo) throws SQLException {
		return sqlSession.delete("com.kkssj.moca.model.ReviewDao.deleteReviewImage", imageVo);
	}

	@Override
	public List<ImageVo> selectReviewImgListByReviewId(int reviewId) throws SQLException {
		return sqlSession.selectList("com.kkssj.moca.model.ReviewDao.selectReviewImgListByReviewId", reviewId);
	}

	//accountId로 review 가져오기
	@Override
	public List<ReviewVo> selectReviewListByAccountId(int accountId,int sessionId, int startNum) throws SQLException {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("ACCOUNT_ID", accountId);
		map.put("SESSION_ID", sessionId);
		map.put("STARTNUM", startNum);
		map.put("ENDNUM", 3);
		return sqlSession.selectList("com.kkssj.moca.model.ReviewDao.selectReviewListByAccountId", map);
	}

	//accountId로 reviewImg 가져오기
	@Override
	public List<ImageVo> selectReviewImgListByAccountId(int accountId) throws SQLException {
		return sqlSession.selectList("com.kkssj.moca.model.ReviewDao.selectReviewImgListByAccountId", accountId);
	}

	@Override
	public List<ReviewVo> selectRecentReviews() throws SQLException{
		return sqlSession.selectList("selectRecentReviews");
	}

	@Override
	public List<ReviewVo> selectBestReviews() throws SQLException{
		return sqlSession.selectList("selectBestReviews");
	}
	
	//리뷰아이디로 리뷰 글쓴이가 누구인지 가져오기
	@Override
	public int selectAccountIdOfReviewByReviewId(int review_id) throws SQLException {
		return sqlSession.selectOne("com.kkssj.moca.model.ReviewDao.selectAccountIdOfReviewByReviewId",review_id);
	}
	
	//리뷰 3개씩 가져오기
	@Override
	public List<ReviewVo> selectReviewLimit3ByStoreId(int accountId, int storeId, int startNum) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("ACCOUNT_ID", accountId);
		map.put("STORE_ID", storeId);
		map.put("STARTNUM", startNum);
		map.put("ENDNUM", 3);
		return sqlSession.selectList("com.kkssj.moca.model.ReviewDao.selectReviewLimit3ByStoreId",map);
	}

	@Override
	public List<Map<String, Object>> selectTagsLimit3ByStoreId(int myAccountId, int targetStoreId, int startNum) throws SQLException {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("ACCOUNT_ID", myAccountId);
		map.put("STORE_ID", targetStoreId);
		map.put("STARTNUM", startNum);
		map.put("ENDNUM", 3);
		return sqlSession.selectList("com.kkssj.moca.model.ReviewDao.selectTagsLimit3ByStoreId",map);
	}

	@Override
	public int insertTags(Map<String, Object> tagMap) throws SQLException{
		return sqlSession.insert("com.kkssj.moca.model.ReviewDao.insertTags", tagMap);
	}

	@Override
	public int updateTags(Map<String, Object> tagMap) throws SQLException{
		return sqlSession.update("com.kkssj.moca.model.ReviewDao.updateTags", tagMap);
	}

	@Override
	public List<Map<String, Object>> selectTagsLimit3ByAccountId(int targetAccountId, int startNum)
			throws SQLException {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("ACCOUNT_ID", targetAccountId);
		map.put("STARTNUM", startNum);
		map.put("ENDNUM", 3);
		return sqlSession.selectList("com.kkssj.moca.model.ReviewDao.selectTagsLimit3ByAccountId",map);
	}
	
	public double selectAverageLevelByReviewId(int review_id) throws SQLException {
		double result = sqlSession.selectOne("com.kkssj.moca.model.ReviewDao.selectAverageLevelByReviewId",review_id); 
		return result;

	}

	@Override
	public List<Map<String, Integer>> selectTagListByStoreId(int store_id) {
		return sqlSession.selectList("com.kkssj.moca.model.ReviewDao.selectTagListByStoreId", store_id);
	}

	@Override
	public List<Double> selectReviewAverageLevelByStoreId(Integer store_id) {
		return sqlSession.selectList("com.kkssj.moca.model.ReviewDao.selectReviewAverageLevelByStoreId",store_id);
	}

	@Override
	public int updateReviewImageViews(String uu_id) {
		return sqlSession.update("com.kkssj.moca.model.ReviewDao.updateReviewImageViews", uu_id);
	}

	@Override
	public int selectReviewCountByAccountId(int account_id) throws SQLException {
		return sqlSession.selectOne("com.kkssj.moca.model.ReviewDao.selectReviewCountByAccountId", account_id);
	}

	@Override
	public int selectLikeHateCountByAccountId(int account_id) throws SQLException {
		return sqlSession.selectOne("com.kkssj.moca.model.ReviewDao.selectLikeHateCountByAccountId", account_id);
	}
}
