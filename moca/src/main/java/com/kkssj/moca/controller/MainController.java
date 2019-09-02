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

import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.service.MainService;

@Controller
public class MainController {
	@Inject
	MainService mainService;
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);
	
	@ResponseBody
	@RequestMapping(value = "/near", method = RequestMethod.GET)
	public List<StoreVo> getNearStores(Model model, String x, String y) {
		Map<String, String> variables = new HashMap<String, String>();
		variables.put("x", x);
		variables.put("y", y);
		List<StoreVo> list = mainService.getStoresNearBy(variables);
		return list;
	}
	
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(HttpSession session, HttpServletRequest request, HttpServletResponse response, String x, String y, Model model) {
		//session.invalidate();		//개발 단계 테스트용 라인
		session=request.getSession();	//개발 단계 테스트용 라인
		if(x!=null && y!=null) {
			session.setAttribute("x", x);
			session.setAttribute("y", y);
		}else if(session.getAttribute("x") == null|| session.getAttribute("y") == null) {
			return "geolocation";
		}
		Map<String, String> variables = new HashMap<String, String>();
		variables.put("x", x );
		variables.put("y", y);
		
		//추천 문구 목록
		List<String> listNames = new ArrayList<String>();
		//각 추천 stores들을 출력순으로 삽입할 리스트
		List<List<StoreVo>> storesList = new ArrayList<List<StoreVo>>();
		
		//Hit Stores추천, index : 0
		listNames.add("지금 뜨는 카페");
		storesList.add(mainService.getHitStoresList(variables));
		
		//Best Stores추천, index : 1
		listNames.add("한주간 베스트 카페");
		storesList.add(mainService.getBestStoresList());
		
		//Trend Stores, index : 2
		listNames.add("흑당흑당 카페카페(미구현)");
		storesList.add(mainService.getTrendStoresList("예쁜"));
		
		//takeOut Stores, index : 3
		listNames.add("주변의 테이크아웃 전문점");
		storesList.add(mainService.getTakeoutStoresList(variables));
		
//		//Hit Stores 추천 
//		model.addAttribute("hitStores", mainService.getHitStoresList(variables));		
//		//Best Stores 추천 
//		model.addAttribute("bestStores", mainService.getBestStoresList());
//		//흑당커피:)
//		model.addAttribute("trendStores", mainService.getTrendStoresList("예쁜"));
//		//최신 리뷰
		model.addAttribute("recentReviews",mainService.getRecentReviews());
//		//TakeOut Stores 추천
//		model.addAttribute("takeOutStores", mainService.getTakeoutStoresList(variables));
		
		model.addAttribute("listNames",listNames);
		model.addAttribute("storesList",storesList);
		return "main2";
	}

	@RequestMapping(value="/geolocation", method = RequestMethod.GET)
	public String getGeolocation() {
		return "geolocation";
	}
}