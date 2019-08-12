package com.kkssj.moca.service;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.kkssj.moca.model.ReviewDao;
import com.kkssj.moca.model.StoreDao;
import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.model.entity.StoreVo;

@Service
public class StoreServiceImpl implements StoreService{
//	@Inject
//	StoreDao storeDao;
	
	@Inject
	ReviewDao reviewDao;

	@Override
	public List<ReviewVo> getReviewList(int accountId, int storeId) {
		return reviewDao.selectAll(accountId, storeId);
	}

	@Override
	public void getStore(Model model, int accountId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void addStore(StoreVo storeVo) {
		// TODO Auto-generated method stub
		
	}
	
	

}
