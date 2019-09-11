package com.kkssj.moca.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.kkssj.moca.model.entity.ImageVo;
import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.model.entity.StoreVo;

import java.sql.SQLException;

public interface StoreService {
	
	///////////////////////
	//store
	//상세정보 가져오기
	StoreVo getStore(int store_Id, int account_id);

	//store가 있는지 확인하고 add
	StoreVo addStore(StoreVo storeVo);
	
	//store 상세정보 update
	int editStore(int accountId, StoreVo storeVo);

	//storeInfoHistory 가져오기
	String getStoreInfoHistory(int storeId);
	
	
	///////////////////////
	//review
	//리뷰 리스트 n개씩 가져오기
	List<ReviewVo> getReviewListLimit(int myAccountId, int targetStoreId, int startNum);
	
	//리뷰 추가
	ReviewVo addReview(ReviewVo reviewVo, MultipartFile[] files);

	//리뷰 수정
	ReviewVo editReview(ReviewVo reviewVo, MultipartFile[] newFiles, String delThumbnails);
	
	//리뷰 제거
	int deleteReview(ReviewVo reviewVo);
	
	
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
	
	//store의 대표이미지들
	List<ImageVo> getStoreImgList(int storeId);

	//리뷰 이미지 삭제
	int deleteReviewImage(ImageVo imageVo);

	//카페 좋아요 추가
	int addLikeStore(int storeId, int account_id);

	//카페 좋아요 취소
	int deleteLikeStore(int storeId, int account_id);

	//가고싶은 카페 추가
	int addFavoriteStore(int storeId, int account_id);

	//가고싶은 카페 제거
	int deleteFavoriteStore(int storeId, int account_id);

	//카페 대표 이미지 수정
	int editStoreImg(int store_id, MultipartFile[] newFiles, String[] oldStoreImgArr, String[] delStoreImgArr);

	//카페 로고 수정
	int editStoreLogo(int store_Id, MultipartFile newFiles, String delStoreLogo);

	List<String> getTagNameList();

<<<<<<< HEAD
	//store countLevel 맞추기(동기화)
	int syncStoreLevel();
=======
	int syncStoresLikeCnt();

	int syncStoresReviewCnt();

	int syncStoresFavoriteCnt();
>>>>>>> 7cdbd310b6dbe760020fa4c3f8ad241f56ca8dc1
}