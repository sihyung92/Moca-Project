package com.kkssj.moca.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.service.MainService;

@Controller
public class MainController {
	@Inject
	MainService mainService;
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);	
	
	@RequestMapping(value="/geolocation", method = RequestMethod.GET)
	public String getGeolocation() {
		return "geolocation";
	}
	//DB 처리용: 전달할 변수 목룍
	private Map<String, String> variables = new HashMap<String, String>();
	//뷰 처리용: 전달할 추천 리스트 이름 목록
	private List<String> listNames = new ArrayList<String>();
	//뷰 처리용: 각 추천 리스트를 담은 리스트
	private List<List<StoreVo>> storesList = new ArrayList<List<StoreVo>>();
	//DB 처리용: DB에서 리턴 받은 추천 카페 StoreVo 임시 저장용 리스트
	private List<StoreVo> alist = new ArrayList<StoreVo>();
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(HttpSession session, HttpServletRequest request, HttpServletResponse response, String x, String y, Model model) {
		//세션에 위치 정보 x, y값 저장 (geolocation 페이지에서 x, y좌표를 받아서 돌아온 경우)
		//geolocation 페이지에서 x, y좌표 받기 실패한 경우 -> x, y = "";으로 넘어옴
		if(x!=null && y!=null) { 
			session.setAttribute("x", x);
			session.setAttribute("y", y);
		//geolocation페이지에서 위치 정보 받아 오기 (메인 페이지 첫 접근 시)
		}else if(session.getAttribute("x") == null|| session.getAttribute("y") == null) {
			return "geolocation";
		}
	
		//세션에서 x, y 좌표 받아 쿼리용 변수 생성		
		if((String)session.getAttribute("x")!="" && (String)session.getAttribute("y")!="") {
			variables.put("x", (String)session.getAttribute("x"));
			variables.put("y", (String)session.getAttribute("y"));	
		}else {
			variables=null;
		}
		
		//뷰 처리용: 전달할 추천 리스트 이름 목록
		listNames = new ArrayList<String>();
		//뷰 처리용: 각 추천 리스트를 담은 리스트
		storesList = new ArrayList<List<StoreVo>>();
		//DB 처리용: DB에서 리턴 받은 추천 카페 StoreVo 임시 저장용 리스트
		alist = new ArrayList<StoreVo>();

		//세션에서 id 받아오기
		int id=0;
		if(session.getAttribute("login")!=null) {
			id=((AccountVo)session.getAttribute("login")).getAccount_id();
		}
		
		
		if(variables!=null) {
			alist = mainService.getStoresNearBy(variables);		//근처 카페 추천
			if(alist.size()>4) {
				listNames.add("근처 카페 추천");
				storesList.add(alist);
			}
		}
		
		alist = mainService.getHitStoresList(variables);	//Hit Stores추천
		if(alist.size()>4) {
			listNames.add("지금 뜨는 카페");
			storesList.add(alist);
		}
		
		alist = mainService.getBestStoresList();		//Best Stores추천
		if(alist.size()>4) {			
			listNames.add("한주간 베스트 카페");
			storesList.add(alist);
		} 
		
		alist = mainService.getTrendStoresList("예쁜");		//Trend Stores
		if(alist.size()>4) {			
			listNames.add("흑당흑당 카페카페(미구현)");
			storesList.add(alist);
		}
		
		if(variables!=null) {
			alist = mainService.getTakeoutStoresList(variables);		//TakeOut Stores
			if(alist.size()>4) {			
				listNames.add("주변의 테이크아웃 전문점");
				storesList.add(alist);
			}
		}		
		 
		if(id>0) {
			alist = mainService.getFollowersStoresList(id);		//Follower's pick Stores
			if(alist.size()>4) {			
				listNames.add("팔로워가 추천하는 카페");
				storesList.add(alist); 
			} 
		}		
		
		//금주의 인기리뷰
		model.addAttribute("bestReviews",mainService.getBestReviews());
		//최신 리뷰 
		model.addAttribute("recentReviews",mainService.getRecentReviews());
		
		model.addAttribute("listNames",listNames);
		model.addAttribute("storesList",storesList);
		return "main";
	}
	
	@RequestMapping("/getmorepicks/1")
	public String getMorePicks1(HttpSession session, Model model, String idx) {
		//뷰 처리용: 전달할 추천 리스트 이름 목록
		listNames = new ArrayList<String>();
		//뷰 처리용: 각 추천 리스트를 담은 리스트
		storesList = new ArrayList<List<StoreVo>>();
		//DB 처리용: DB에서 리턴 받은 추천 카페 StoreVo 임시 저장용 리스트
		alist = new ArrayList<StoreVo>();
		
		logger.debug("데이터 요청 11111111111111111111111111111111111111111111111111111");
		
		alist=mainService.getGoodMoodStoresList(variables);		//분위기 좋은 카페 리턴
		if(alist.size()>4) {
			listNames.add("분위기 좋은 카페");
			storesList.add(alist); 
		}
		 
		alist=mainService.getGoodTasteStoresList(variables);		//맛있는 카페 리턴
		if(alist.size()>4) {
			listNames.add("맛있는 카페");
			storesList.add(alist); 
		}
		
		alist=mainService.getGoodPriceStoresList(variables);		//가격이 착한 카페 리턴
		if(alist.size()>4) {
			listNames.add("가격이 착한 카페");
			storesList.add(alist); 
		}
	
		model.addAttribute("listNames",listNames);
		model.addAttribute("storesList",storesList);
		return "converter";
	}
	
	@RequestMapping("/getmorepicks/2")
	public String getMorePicks2(HttpSession session, Model model) {
		//뷰 처리용: 전달할 추천 리스트 이름 목록
		listNames = new ArrayList<String>();
		//뷰 처리용: 각 추천 리스트를 담은 리스트
		storesList = new ArrayList<List<StoreVo>>();
		//DB 처리용: DB에서 리턴 받은 추천 카페 StoreVo 임시 저장용 리스트
		alist = new ArrayList<StoreVo>();
		
		logger.debug("데이터 요청 222222222222222222222222222222222222222222222222222222");
		
		alist=mainService.getTagStoresList(variables);		//분위기 좋은 카페 리턴
		if(alist.size()>4) {
			listNames.add("#혼자가기 좋은 카페");
			storesList.add(alist); 
		}
		 
		alist=mainService.getGoodTasteStoresList(variables);		//맛있는 카페 리턴
		if(alist.size()>4) {
			listNames.add("맛있는 카페");
			storesList.add(alist); 
		}
		
		alist=mainService.getGoodPriceStoresList(variables);		//가격이 착한 카페 리턴
		if(alist.size()>4) {
			listNames.add("가격이 착한 카페");
			storesList.add(alist); 
		}
	
		model.addAttribute("listNames",listNames);
		model.addAttribute("storesList",storesList);
		return "converter";
	}

	@RequestMapping("/getmorepicks/3")
	public String getMorePicks3(HttpSession session, Model model) {
		//뷰 처리용: 전달할 추천 리스트 이름 목록
		listNames = new ArrayList<String>();
		//뷰 처리용: 각 추천 리스트를 담은 리스트
		storesList = new ArrayList<List<StoreVo>>();
		//DB 처리용: DB에서 리턴 받은 추천 카페 StoreVo 임시 저장용 리스트
		alist = new ArrayList<StoreVo>();
		
		logger.debug("데이터 요청 333333333333333333333333333333333333333333333333333");
		
		alist=mainService.getGoodMoodStoresList(variables);		//분위기 좋은 카페 리턴
		if(alist.size()>4) {
			listNames.add("분위기 좋은 카페");
			storesList.add(alist); 
		}
		 
		alist=mainService.getGoodTasteStoresList(variables);		//맛있는 카페 리턴
		if(alist.size()>4) {
			listNames.add("맛있는 카페");
			storesList.add(alist); 
		}
		
		alist=mainService.getGoodPriceStoresList(variables);		//가격이 착한 카페 리턴
		if(alist.size()>4) {
			listNames.add("가격이 착한 카페");
			storesList.add(alist); 
		}
	
		model.addAttribute("listNames",listNames);
		model.addAttribute("storesList",storesList);
		return "converter";
	}
	@RequestMapping("/getmorepicks/4")
	public String getMorePicks4(HttpSession session, Model model) {
		//뷰 처리용: 전달할 추천 리스트 이름 목록
		listNames = new ArrayList<String>();
		//뷰 처리용: 각 추천 리스트를 담은 리스트
		storesList = new ArrayList<List<StoreVo>>();
		//DB 처리용: DB에서 리턴 받은 추천 카페 StoreVo 임시 저장용 리스트
		alist = new ArrayList<StoreVo>();
		
		logger.debug("데이터 요청 44444444444444444444444444444444444444444444444444444");
		
		alist=mainService.getGoodMoodStoresList(variables);		//분위기 좋은 카페 리턴
		if(alist.size()>4) {
			listNames.add("분위기 좋은 카페");
			storesList.add(alist); 
		}
		 
		alist=mainService.getGoodTasteStoresList(variables);		//맛있는 카페 리턴
		if(alist.size()>4) {
			listNames.add("맛있는 카페");
			storesList.add(alist); 
		}
		
		alist=mainService.getGoodPriceStoresList(variables);		//가격이 착한 카페 리턴
		if(alist.size()>4) {
			listNames.add("가격이 착한 카페");
			storesList.add(alist); 
		}
	
		model.addAttribute("listNames",listNames);
		model.addAttribute("storesList",storesList);
		return "converter";
	}
	@RequestMapping("/getmorepicks/5")
	public String getMorePicks5(HttpSession session, Model model) {
		//뷰 처리용: 전달할 추천 리스트 이름 목록
		listNames = new ArrayList<String>();
		//뷰 처리용: 각 추천 리스트를 담은 리스트
		storesList = new ArrayList<List<StoreVo>>();
		//DB 처리용: DB에서 리턴 받은 추천 카페 StoreVo 임시 저장용 리스트
		alist = new ArrayList<StoreVo>();
		
		logger.debug("데이터 요청 55555555555555555555555555555555555555555555555555");
		
		alist=mainService.getGoodMoodStoresList(variables);		//분위기 좋은 카페 리턴
		if(alist.size()>4) {
			listNames.add("분위기 좋은 카페");
			storesList.add(alist); 
		}
		 
		alist=mainService.getGoodTasteStoresList(variables);		//맛있는 카페 리턴
		if(alist.size()>4) {
			listNames.add("맛있는 카페");
			storesList.add(alist); 
		}
		
		alist=mainService.getGoodPriceStoresList(variables);		//가격이 착한 카페 리턴
		if(alist.size()>4) {
			listNames.add("가격이 착한 카페");
			storesList.add(alist); 
		}
	
		model.addAttribute("listNames",listNames);
		model.addAttribute("storesList",storesList);
		return "converter";
	}
	
	
}