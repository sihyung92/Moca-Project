package com.kkssj.moca.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.kkssj.moca.model.ReviewDao;
import com.kkssj.moca.model.entity.ImageVo;
import com.kkssj.moca.model.entity.ReviewVo;

@Service
public class BoardServiceImpl implements BoardService {
	@Inject
	ReviewDao reviewDao;

	@Override
	public List<ReviewVo> getReviewList(String type) throws SQLException {
		List<ReviewVo> list=null;
		//parameter로 받아온 type이 recent라면 최신리뷰, best라면 주간리뷰
		switch (type) {
		case "recent":
			list = reviewDao.selectRecentReviews();
			break;
		case "best":
			list = reviewDao.selectBestReviews();
			break;
		default:
			break;
		}
		
		//리뷰vo에 imageVo의 URL를 주입
		if(list!=null) {
			ArrayList<ImageVo> reviewImgList;
			for(ReviewVo reviewVo:list) {
				reviewImgList = (ArrayList<ImageVo>)reviewDao.selectReviewImgListByReviewId(reviewVo.getReview_id());
				for(int i=0; i<reviewImgList.size(); i++) {
					reviewImgList.get(i).setUrl();
				}
				reviewVo.setImageList(reviewImgList);
	    	}
		}
		return list;
	}
}
