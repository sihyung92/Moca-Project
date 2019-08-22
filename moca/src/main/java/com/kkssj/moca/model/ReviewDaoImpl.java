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


	//store ������ ���������� �ش� ī���� review�� ������
	@Override
	public List<ReviewVo> selectAll(int accountId, int storeId) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("ACCOUNTID", accountId);
		map.put("STOREID", storeId);
		
		return sqlSession.selectList("review.selectAll",map);
	}
	
	//���� �߰�
	@Override
	public int insertReview(ReviewVo reviewVo) {
		logger.debug(reviewVo.toString());
		int result = sqlSession.insert("review.insertReview", reviewVo);
		logger.debug("result:"+result);
		return result;
	}

	//��� �߰��� ���並 ������(�߰� ���� �����Ǵ� ������ �������� ����)
	@Override
	public ReviewVo selectAddedOne(int accountId) {
		return sqlSession.selectOne("review.selectAddedOne", accountId);
	}

	//���� ����
	@Override
	public int updateReview(ReviewVo reviewVo) {
		return sqlSession.update("review.updateReview", reviewVo);
	}
	

	//���� ����
	public int deleteReview(int review_id) throws SQLException {
		return sqlSession.delete("review.deleteReview",review_id);
	}

	//likeHate ���̺� row �߰�
	@Override
	public int insertLikeHate(int review_id, int accountId, int isLike) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		map.put("ISLIKE", isLike);
		
		return sqlSession.insert("review.insertLikeHate", map);
	}

	//likeHate ���̺� row ����
	@Override
	public int updateLikeHate(int review_id, int accountId, int isLike) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		map.put("ISLIKE", isLike);
		
		return sqlSession.update("review.updateLikeHate", map);
	}


	//likeHate ���̺� row ����
	@Override
	public int deleteLikeHate(int review_id, int accountId) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		
		return sqlSession.delete("review.deleteLikeHate", map);
	}

	//review ���̺� likeCount�� ����
	@Override
	public int updateLikeCount(int review_id, int likeCount) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("LIKECOUNT", likeCount);
		logger.debug("REVIEW_ID:"+review_id+ ", LIKECOUNT:"+likeCount);		
		return sqlSession.update("review.updateLikeCount", map);
	}

	//review ���̺� hateCount�� ����
	@Override
	public int updateHateCount(int review_id, int hateCount) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("HATECOUNT", hateCount);
		logger.debug("REVIEW_ID:"+review_id+ ", HATECOUNT:"+hateCount);		
		return sqlSession.update("review.updateHateCount", map);
	}

	//review ���̺� likeCount�� ��ȸ
	@Override
	public int selectLikeCount(int review_id) {
		int likeCount = sqlSession.selectOne("review.selectLikeCount", review_id);
		logger.debug("likeCount:"+likeCount);
		return likeCount;
	}

	//review ���̺� hateCount�� ��ȸ
	@Override
	public int selectHateCount(int review_id) {
		int hateCount = sqlSession.selectOne("review.selectHateCount", review_id);
		logger.debug("hateCount:"+hateCount);
		return hateCount;
	}


	//likeHate ���̺� isLike=1�� ���� ��ȸ
	@Override
	public int selectLikeHateLike(int reviewId) {
		try {
			return sqlSession.selectOne("review.selectLikeHateLike", reviewId);
		}catch (NullPointerException e) {
			//���ƿ䰡 ���� ���
			return 0;
		}
		
	}

	//likeHate ���̺� isLike=-1�� ���� ��ȸ
	@Override
	public int selectLikeHateHate(int reviewId) {
		try {
			return sqlSession.selectOne("review.selectLikeHateHate", reviewId);
		}catch (NullPointerException e) {
			//�Ⱦ�䰡 ���� ���
			return 0;
		}
	}


	//review ���̺��ִ� review_id�� ��ȸ
	@Override
	public List<ReviewVo> selectAllReviewId() {
		return sqlSession.selectList("review.selectAllReviewId");
	}
	
	//�ش� store�� �ִ� review�� ����(��, ���� ��) ��ȸ
	@Override
	public List<ReviewVo> selectAllReviewLevel(int storeId) {
		return sqlSession.selectList("review.selectAllReviewLevel", storeId);
	}
	
	//���� �̹��� ��������
	@Override
	public List<ImageVo> selectReviewImgListByStoreId(int storeId) {
		return sqlSession.selectList("review.selectReviewImgListByStoreId", storeId);
	}

}
