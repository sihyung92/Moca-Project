package com.kkssj.moca.controller;

import java.sql.SQLException;
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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.service.BoardService;
import com.kkssj.moca.service.MainService;

@Controller
public class MainController {
	@Inject
	MainService mainService;
	@Inject 
	BoardService boardService;
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);	
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(HttpSession session, HttpServletRequest request, HttpServletResponse response, String x, String y, Model model) throws SQLException {
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
		if((String)session.getAttribute("x")!="" && (String)session.getAttribute("y")!="") {
			variables.put("x", (String)session.getAttribute("x"));
			variables.put("y", (String)session.getAttribute("y"));	
		}else {
			variables=null;
		}

		//세션에서 id 받아오기
		int id=0;
		if(session.getAttribute("login")!=null) {
			id=((AccountVo)session.getAttribute("login")).getAccount_id();
		}
		
		//추천 문구 목록
		List<String> listNames = new ArrayList<String>();
		//각 추천 stores들을 출력순으로 삽입할 리스트
		List<List<StoreVo>> storesList = new ArrayList<List<StoreVo>>();
		//
		List<StoreVo> alist = new ArrayList<StoreVo>();
		
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

	@RequestMapping(value="/geolocation", method = RequestMethod.GET)
	public String getGeolocation() {
		return "geolocation";
	}
	
	@RequestMapping(value="/reviewboard/{type}", method = RequestMethod.GET)
	public String reviewBoard(Model model, @PathVariable String type) throws SQLException {
		//type이 "recent"면 최근리뷰, "best"면 주간 인기리뷰 
		List<ReviewVo> alist = null;
		if(type!=null)
		alist = boardService.getReviewList(type);
		
		//view에서의 검색결과(recent, best)
		model.addAttribute("type", type);
		model.addAttribute("alist", alist);
		return "reviewboard";
	}
	
}