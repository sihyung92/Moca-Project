package com.kkssj.moca.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.ui.Model;

import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.model.entity.StoreVo;

import java.sql.SQLException;

public interface StoreService {
	
	//������ ��������
	StoreVo getStore(int store_Id) throws SQLException;

	//store�� �ִ��� Ȯ���ϰ� add
	StoreVo addStore(StoreVo storeVo) throws SQLException;
	
	//store ������ update
	int editStore(StoreVo storeVo) throws SQLException;
	
	//���� ����Ʈ ��������
	List<ReviewVo> getReviewList(int accountId, int storeId);

	//���ƿ� �Ⱦ�� �߰��ϱ�
	int addLikeHate(int review_id, int accountId, int isLike);

	//���ƿ� �Ⱦ�� ����
	int editLikeHate(int review_id, int accountId, int isLike);

	//���ƿ� �Ⱦ�� ����
	int deleteLikeHate(int review_id, int accountId);
}
