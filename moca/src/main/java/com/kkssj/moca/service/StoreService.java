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
	
	//������ ��������
	StoreVo getStore(int store_Id);

	//store�� �ִ��� Ȯ���ϰ� add
	StoreVo addStore(StoreVo storeVo);
	
	//store ������ update
	int editStore(int accountId, StoreVo storeVo);

	//storeInfoHistory ��������
	String getStoreInfoHistory(int storeId);
	
	
	///////////////////////
	//review
	
	//���� ����Ʈ ��������
	List<ReviewVo> getReviewList(int accountId, int storeId);
	
	//���� �߰�
	ReviewVo addReview(ReviewVo reviewVo, MultipartFile[] files);

	//���� ����
	int editReview(ReviewVo reviewVo);
	
	//���� ����
	int deleteReview(ReviewVo reviewVo);
	
	
	///////////////////////
	//likeHate

	//���ƿ� �Ⱦ�� �߰��ϱ�
	int addLikeHate(int review_id, int accountId, int isLike);

	//���ƿ� �Ⱦ�� ����
	int editLikeHate(int review_id, int accountId, int isLike);

	//���ƿ� �Ⱦ�� ����
	int deleteLikeHate(int review_id, int accountId, int isLike);

	//review�� ���ƿ� �Ⱦ�� ī��Ʈ�� likehate ���̺��� ���� ����ȭ
	int syncReviewLikeHate();
	
	//store�� ��ǥ�̹�����
	List<ImageVo> getStoreImgList(int storeId);

	//���� �̹��� ����
	int deleteReviewImage(ImageVo imageVo);

}
