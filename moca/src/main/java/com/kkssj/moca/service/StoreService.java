package com.kkssj.moca.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.ui.Model;

import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.model.entity.StoreVo;

public interface StoreService {

	List<ReviewVo> getReviewList(int accountId, int storeId);

	void getStore(Model model, int accountId);

	void addStore(StoreVo storeVo);

	
}
