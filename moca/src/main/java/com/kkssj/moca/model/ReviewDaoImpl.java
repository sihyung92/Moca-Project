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

import com.kkssj.moca.controller.TestController;
import com.kkssj.moca.model.entity.ImageVo;
import com.kkssj.moca.model.entity.ReviewVo;

@Repository
public class ReviewDaoImpl implements ReviewDao {
	private static final Logger logger = LoggerFactory.getLogger(ReviewDaoImpl.class);

	@Inject
	SqlSession sqlSession;


	//store ������ ���������� �ش� ī���� review�� ������
	@Override
	public List<ReviewVo> selectAll(int accountId, int storeId) throws SQLException {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("ACCOUNTID", accountId);
		map.put("STOREID", storeId);
		
		return sqlSession.selectList("review.selectAll",map);
	}
	
	//���� �߰�
	@Override
	public int insertReview(ReviewVo reviewVo) throws SQLException {
		logger.debug(reviewVo.toString());
		int result = sqlSession.insert("review.insertReview", reviewVo);
		logger.debug("result:"+result);
		return result;
	}

	//��� �߰��� ���並 ������(�߰� ���� �����Ǵ� ������ �������� ����)
	@Override
	public ReviewVo selectAddedOne(int accountId) throws SQLException {
		return sqlSession.selectOne("review.selectAddedOne", accountId);
	}

	//���� ����
	@Override
	public int updateReview(ReviewVo reviewVo) throws SQLException{
		return sqlSession.update("review.updateReview", reviewVo);
	}
	

	//���� ����
	public int deleteReview(ReviewVo reviewVo) throws SQLException {
		return sqlSession.delete("review.deleteReview",reviewVo);
	}

	//likeHate ���̺� row �߰�
	@Override
	public int insertLikeHate(int review_id, int accountId, int isLike) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		map.put("ISLIKE", isLike);
		
		return sqlSession.insert("review.insertLikeHate", map);
	}

	//likeHate ���̺� row ����
	@Override
	public int updateLikeHate(int review_id, int accountId, int isLike) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		map.put("ISLIKE", isLike);
		
		return sqlSession.update("review.updateLikeHate", map);
	}


	//likeHate ���̺� row ����
	@Override
	public int deleteLikeHate(int review_id, int accountId) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		
		return sqlSession.delete("review.deleteLikeHate", map);
	}

	//review ���̺� likeCount�� ����
	@Override
	public int updateLikeCount(int review_id, int likeCount) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("LIKECOUNT", likeCount);
		logger.debug("REVIEW_ID:"+review_id+ ", LIKECOUNT:"+likeCount);		
		return sqlSession.update("review.updateLikeCount", map);
	}

	//review ���̺� hateCount�� ����
	@Override
	public int updateHateCount(int review_id, int hateCount) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("HATECOUNT", hateCount);
		logger.debug("REVIEW_ID:"+review_id+ ", HATECOUNT:"+hateCount);		
		return sqlSession.update("review.updateHateCount", map);
	}

	//review ���̺� likeCount, hateCount�� ��ȸ
	@Override
	public ReviewVo selectLikeHateCount(int review_id) throws SQLException{
		ReviewVo reviewVo = sqlSession.selectOne("review.selectLikeHateCount", review_id);
		logger.debug("likeCount:"+reviewVo.getLikeCount());
		return reviewVo;
	}


	//likeHate ���̺� isLike=1�� ���� ��ȸ
	@Override
	public int selectLikeHateLike(int reviewId) throws SQLException{
		try {
			return sqlSession.selectOne("review.selectLikeHateLike", reviewId);
		}catch (NullPointerException e) {
			//���ƿ䰡 ���� ���
			return 0;
		}
		
	}

	//likeHate ���̺� isLike=-1�� ���� ��ȸ
	@Override
	public int selectLikeHateHate(int reviewId) throws SQLException {
		try {
			return sqlSession.selectOne("review.selectLikeHateHate", reviewId);
		}catch (NullPointerException e) {
			//�Ⱦ�䰡 ���� ���
			return 0;
		}
	}
	
	
	//���� �̹��� ���
	@Override
	public int insertReviewImage(ImageVo imgaeVo) throws SQLException {
		return sqlSession.insert("review.insertReviewImage", imgaeVo);
	}


	//review ���̺��ִ� review_id�� ��ȸ
	@Override
	public List<ReviewVo> selectAllReviewId() throws SQLException{
		return sqlSession.selectList("review.selectAllReviewId");
	}
	
	//�ش� store�� �ִ� review�� ����(��, ���� ��) ��ȸ
	@Override
	public List<ReviewVo> selectAllReviewLevel(int storeId) throws SQLException{
		return sqlSession.selectList("review.selectAllReviewLevel", storeId);
	}
	
	//���� �̹��� ��������
	@Override
	public List<ImageVo> selectReviewImgListByStoreId(int storeId) {
		return sqlSession.selectList("review.selectReviewImgListByStoreId", storeId);
	}

	//���� �̹��� ����
	@Override
	public int deleteReviewImage(ImageVo imageVo) throws SQLException {
		return sqlSession.delete("review.deleteReviewImage", imageVo);
	}

	@Override
	public List<ImageVo> selectReviewImgListByReviewId(int reviewId) throws SQLException {
		return sqlSession.selectList("review.selectReviewImgListByReviewId", reviewId);
	}

	@Override
	public List<ReviewVo> selectRecentReviews() {
		return sqlSession.selectList("selectRecentReviews");
	}

}
