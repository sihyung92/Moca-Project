package com.kkssj.moca.model;

import java.util.List;

import com.kkssj.moca.model.entity.ReviewVo;

public interface ReviewDao {

	List<ReviewVo> selectAll(int accountId, int storeId);
}
