package com.kkssj.moca.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.model.entity.StoreVo;

import java.sql.SQLException;

public interface StoreService {
	
	///////////////////////
	//store
	
	//상세정보 가져오기
	StoreVo getStore(int store_Id) throws SQLException;

	//store가 있는지 확인하고 add
	StoreVo addStore(StoreVo storeVo) throws SQLException;
	
	//store 상세정보 update
	int editStore(int accountId, StoreVo storeVo) throws SQLException;
	
	
	///////////////////////
	//review
	
	//리뷰 리스트 가져오기
	List<ReviewVo> getReviewList(int accountId, int storeId);
	
	//리뷰 추가
	ReviewVo addReview(ReviewVo reviewVo, MultipartFile[] files);

	//리뷰 수정
	int editReview(ReviewVo reviewVo);
	
	//리뷰 제거
	int deleteReview(int review_id) throws SQLException;
	
	
	///////////////////////
	//likeHate

	//좋아요 싫어요 추가하기
	int addLikeHate(int review_id, int accountId, int isLike);

	//좋아요 싫어요 수정
	int editLikeHate(int review_id, int accountId, int isLike);

	//좋아요 싫어요 제거
	int deleteLikeHate(int review_id, int accountId, int isLike);

	//review의 좋아요 싫어요 카운트를 likehate 테이블의 값과 동기화
	int syncReviewLikeHate();

}
