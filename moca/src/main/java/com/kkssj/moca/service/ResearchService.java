package com.kkssj.moca.service;

import java.util.ArrayList;
import java.util.List;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.ResearchVo;

public interface ResearchService {
	boolean doResearch(ResearchVo research);
	ArrayList<String> SearchByAccountId(int account_id);//id에 해당하는 사람이 선택한 점수(답변들을) 반환
	List<AccountVo> searchByAnswer(Object[] answer);//{"1","1","2","4","5","2"} => 1번에 1을 고르고 2번에 4를 고르고 5번에 2를 고른 사람들을 반환
}
