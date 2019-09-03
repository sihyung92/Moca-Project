package com.kkssj.moca.service;

import java.sql.SQLException;
import java.util.List;

import com.kkssj.moca.model.entity.ReviewVo;

public interface BoardService {
	List<ReviewVo> getReviewList(String type) throws SQLException;
}
