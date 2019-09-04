package com.kkssj.moca.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
	private Map<String, String> variables = new HashMap<String, String>();		//DB 처리용: 전달할 변수 목룍	
	private List<String> tagNames;
	private Map<String, String> rating = new HashMap<String, String>();
	
	@RequestMapping(value="/geolocation", method = RequestMethod.GET)
	public String getGeolocation() {
		return "geolocation";
	}
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
		if((String)session.getAttribute("x")!="" && (String)session.getAttribute("y")!="") {
			variables.put("x", (String)session.getAttribute("x"));
			variables.put("y", (String)session.getAttribute("y"));	
		}else {
			variables=null;
		}
		
		//뷰 처리용: 전달할 추천 리스트 이름 목록
		List<String> listNames = new ArrayList<String>();
		//뷰 처리용: 각 추천 리스트를 담은 리스트
		List<List<StoreVo>> storesList = new ArrayList<List<StoreVo>>();
		//DB 처리용: DB에서 리턴 받은 추천 카페 StoreVo 임시 저장용 리스트
		List<StoreVo> alist = new ArrayList<StoreVo>();

		//세션에서 id 받아오기
		int id=0;
		if(session.getAttribute("login")!=null) {
			id=((AccountVo)session.getAttribute("login")).getAccount_id();
		}
		
		//TAGS테이블에서 태그 종류 받아오기
		tagNames = mainService.getTagNames();
		tagNames.remove(0);
		tagNames.remove(0); 		
		
		//별점 추천 기준 저장
		rating.put("TASTELEVEL", "맛있는 카페");
		rating.put("PRICELEVEL", "가격이 착한 카페");
		rating.put("MOODLEVEL", "분위기 좋은 카페");

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
	
	//추천 정보 추가로 받기
	@RequestMapping("/getmorepicks")
	public String getMorePicks(HttpSession session,HttpServletResponse response, Model model) {
		//뷰 처리용: 전달할 추천 리스트 이름 목록
		List<String> listNames = new ArrayList<String>(); 
		//뷰 처리용: 각 추천 리스트를 담은 리스트
		List<List<StoreVo>> storesList = new ArrayList<List<StoreVo>>();
		//DB 처리용: DB에서 리턴 받은 추천 카페 StoreVo 임시 저장용 리스트
		List<StoreVo> alist = new ArrayList<StoreVo>();		
		logger.debug("추가 추천!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1");
		
		if(tagNames.size()==0) {
			response.setStatus(418); //I'M_A_TEAPOT
		}
		
		if(!rating.isEmpty()) {		//별점 추천(맛있는, 분위기 좋은, 가격이 착한)
			Set<String> ratingNames = rating.keySet();
			Iterator<String> ite = ratingNames.iterator();
			
			while(ite.hasNext()) {
				String ratingName = ite.next();
				variables.put("ratingName", ratingName);
				alist=mainService.getStoresListByRating(variables);		
				if(alist.size()>4) {
					listNames.add(rating.get(ratingName));
					storesList.add(alist); 							
				}
			}
			rating.clear();
		}else {		//태그 추천(ex: #예쁜, #혼자가기좋은)
			int end=10;
			if(tagNames.size()<10) end = tagNames.size();			
			for(int i=0; i<end; i++) {
				String tag = tagNames.get(0); 
				tagNames.remove(0);
				variables.put("tag", tag);
				alist=mainService.getStoresListByTag(variables);		
				if(alist.size()>4) {
					listNames.add("#"+tag);
					storesList.add(alist); 
				}
			}
		}			
		
		model.addAttribute("listNames",listNames);
		model.addAttribute("storesList",storesList);
		return "converter"; 
	}
	
	//boardController혹은bbsController 이동예정~!
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