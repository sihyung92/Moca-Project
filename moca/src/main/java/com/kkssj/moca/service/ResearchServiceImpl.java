package com.kkssj.moca.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.kkssj.moca.model.AccountDao;
import com.kkssj.moca.model.ResearchDao;
import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.ResearchVo;

@Service
public class ResearchServiceImpl implements ResearchService {
private static final Logger logger = LoggerFactory.getLogger(ResearchServiceImpl.class);
	
	@Inject
	ResearchDao researchDao;

	@Inject
	AccountDao accountDao;
	
	@Override
	public boolean doResearch(ResearchVo research) {
		// TODO Auto-generated method stub
		try {
			researchDao.insertResearch(research);
			return true;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public List<AccountVo> searchByAnswer(Object[] answer) {
		// TODO Auto-generated method stub
		/*
		 * 	Object[] answ = {0,"5",2,"5"}; <=> {원하는 문항 인덱스 첫번째는 0, 3번째는 2 ,그리고 각 문항에 맞는 답안을 그다음 String으로 "5" "5" 를 넣은 배열을 넣어주면
		 * 
		 * 	List<AccountVo> list = researchService.SearchByAnswer(answ);
		 * 
		 *  AccountVo를 담고있는 List를 반환해준다.		 
		 *  
		 *  사용 가능한 예시? => 커피를 조금 쓰게 마시는 사람들이 내 친구들중에 누구인가? / 커피를 쓰게 마시면서 홍차를 좋아하는 사람은?
		 *  <추후 코드 개선할 예정?>
		 *  researchService.searchByAnswer(0,"1~2","and",1,"2~5","or",2,"3","or",4,"5","end");
		 */
		
		List list=null;
		try {
			list = researchDao.selectUsersByNumAndVal(answer);
			Iterator ite = list.iterator();
			int[] arr = new int[list.size()];
			for(int i=0;ite.hasNext();i++) {
				arr[i]=(Integer)ite.next();
			}
			return accountDao.selectByMultipleQuery(arr);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public ArrayList<String> SearchByAccountId(int account_id) {
		// TODO Auto-generated method stub
		return null;
	}
}