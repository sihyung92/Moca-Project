package com.kkssj.moca.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
		Map<String, String> variables = new HashMap<String, String>();
		variables.put("x", (String)session.getAttribute("x"));
		variables.put("y", (String)session.getAttribute("y"));
		//추천 문구 목록
		List<String> listNames = new ArrayList<String>();
		//각 추천 stores들을 출력순으로 삽입할 리스트
		List<List<StoreVo>> storesList = new ArrayList<List<StoreVo>>();
		
		//근처 카페 추천
		listNames.add("근처 카페 추천");
		storesList.add(mainService.getStoresNearBy(variables));
		
		//Hit Stores추천
		listNames.add("지금 뜨는 카페");
		storesList.add(mainService.getHitStoresList(variables));
		
		//Best Stores추천
		listNames.add("한주간 베스트 카페");
		storesList.add(mainService.getBestStoresList());
		
		//Trend Stores
		listNames.add("흑당흑당 카페카페(미구현)");
		storesList.add(mainService.getTrendStoresList("예쁜"));
		 
		//TakeOut Stores
		listNames.add("주변의 테이크아웃 전문점");
		storesList.add(mainService.getTakeoutStoresList(variables));
		
		//Follower's pick Stores
		//int id=((AccountVo)session.getAttribute("login")).getAccount_id();
		int id = 48;
		listNames.add("팔로워가 추천하는 카페");
		storesList.add(mainService.getFollowersStoresList(id));
		
		//금주의 인기리뷰
		model.addAttribute("bestReviews",mainService.getBestReviews());
		//최신 리뷰 
		model.addAttribute("recentReviews",mainService.getRecentReviews());
		
		model.addAttribute("listNames",listNames);
		model.addAttribute("storesList",storesList);
		return "main";
	}

	@RequestMapping(value="/geolocation", method = RequestMethod.GET)
	public String getGeolocation() {
		return "geolocation";
	}
}