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
		
		return sqlSession.selectList("com.kkssj.moca.model.ReviewDao.selectAll",map);
	}
	
	//���� �߰�
	@Override
	public int insertReview(ReviewVo reviewVo) throws SQLException {
		logger.debug(reviewVo.toString());
		int result = sqlSession.insert("com.kkssj.moca.model.ReviewDao.insertReview", reviewVo);
		logger.debug("result:"+result);
		return result;
	}

	//��� �߰��� ���並 ������(�߰� ���� �����Ǵ� ������ �������� ����)
	@Override
	public ReviewVo selectAddedOne(int accountId) throws SQLException {
		return sqlSession.selectOne("com.kkssj.moca.model.ReviewDao.selectAddedOne", accountId);
	}

	//���� ����
	@Override
	public int updateReview(ReviewVo reviewVo) throws SQLException{
		return sqlSession.update("com.kkssj.moca.model.ReviewDao.updateReview", reviewVo);
	}
	

	//���� ����
	public int deleteReview(int review_id) throws SQLException {
		return sqlSession.delete("com.kkssj.moca.model.ReviewDao.deleteReview",review_id);
	}

	//likeHate ���̺� row �߰�
	@Override
	public int insertLikeHate(int review_id, int accountId, int isLike) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		map.put("ISLIKE", isLike);
		
		return sqlSession.insert("com.kkssj.moca.model.ReviewDao.insertLikeHate", map);
	}

	//likeHate ���̺� row ����
	@Override
	public int updateLikeHate(int review_id, int accountId, int isLike) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		map.put("ISLIKE", isLike);
		
		return sqlSession.update("com.kkssj.moca.model.ReviewDao.updateLikeHate", map);
	}


	//likeHate ���̺� row ����
	@Override
	public int deleteLikeHate(int review_id, int accountId) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("ACCOUNT_ID", accountId);
		
		return sqlSession.delete("com.kkssj.moca.model.ReviewDao.deleteLikeHate", map);
	}

	//review ���̺� likeCount�� ����
	@Override
	public int updateLikeCount(int review_id, int likeCount) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("LIKECOUNT", likeCount);
		logger.debug("REVIEW_ID:"+review_id+ ", LIKECOUNT:"+likeCount);		
		return sqlSession.update("com.kkssj.moca.model.ReviewDao.updateLikeCount", map);
	}

	//review ���̺� hateCount�� ����
	@Override
	public int updateHateCount(int review_id, int hateCount) throws SQLException{
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("REVIEW_ID", review_id);
		map.put("HATECOUNT", hateCount);
		logger.debug("REVIEW_ID:"+review_id+ ", HATECOUNT:"+hateCount);		
		return sqlSession.update("com.kkssj.moca.model.ReviewDao.updateHateCount", map);
	}

	//review ���̺� likeCount, hateCount�� ��ȸ
	@Override
	public ReviewVo selectLikeHateCount(int review_id) throws SQLException{
		ReviewVo reviewVo = sqlSession.selectOne("com.kkssj.moca.model.ReviewDao.selectLikeHateCount", review_id);
		logger.debug("likeCount:"+reviewVo.getLikeCount());
		return reviewVo;
	}


	//likeHate ���̺� isLike=1�� ���� ��ȸ
	@Override
	public int selectLikeHateLike(int reviewId) throws SQLException{
		try {
			return sqlSession.selectOne("com.kkssj.moca.model.ReviewDao.selectLikeHateLike", reviewId);
		}catch (NullPointerException e) {
			//���ƿ䰡 ���� ���
			return 0;
		}
		
	}

	//likeHate ���̺� isLike=-1�� ���� ��ȸ
	@Override
	public int selectLikeHateHate(int reviewId) {
		try {
			return sqlSession.selectOne("com.kkssj.moca.model.ReviewDao.selectLikeHateHate", reviewId);
		}catch (NullPointerException e) {
			//�Ⱦ�䰡 ���� ���
			return 0;
		}
	}


	//review ���̺��ִ� review_id�� ��ȸ
	@Override
	public List<ReviewVo> selectAllReviewId() throws SQLException{
		return sqlSession.selectList("com.kkssj.moca.model.ReviewDao.selectAllReviewId");
	}
	
	//�ش� store�� �ִ� review�� ����(��, ���� ��) ��ȸ
	@Override
	public List<ReviewVo> selectAllReviewLevel(int storeId) throws SQLException{
		return sqlSession.selectList("com.kkssj.moca.model.ReviewDao.selectAllReviewLevel", storeId);
	}

}
