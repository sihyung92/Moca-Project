package com.kkssj.moca.controller;

import java.net.MalformedURLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.LogVo;
import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.service.SearchService;

@Controller
public class SearchController {
	@Inject
	SearchService searchService;	
	private static final Logger logger = LoggerFactory.getLogger(SearchController.class);
	
	@RequestMapping("/re-search")
	@ResponseBody
	public List<StoreVo> searchOnTheMap(String filter, String rect, String keyword, Model model){
		logger.debug("filter: "+filter+"keyword: "+keyword);
		//카카오 맵 범위 내 재검색
		List<StoreVo> alist = searchService.getListFromKakaoAPI(keyword, null, "", "", rect, model);	//x, y, region 정보 불필요
		//mocaDB 열람 및 데이터 업데이트
		for(StoreVo s: alist) s = searchService.getMoreData(s);
		//정렬 처리
		if(!filter.equals("distance")) 	alist = searchService.sort(alist, filter); 		//카카오 정렬 디폴트 = 거리순(정렬 처리 불필요)
		return alist;		
	}
	
	@RequestMapping(value = "/stores", method = RequestMethod.GET)
	public String search(HttpSession session, HttpServletRequest request, String lng, String lat, String keyword, String filter, String[] region, Model model) throws MalformedURLException {
		long enterTime=System.currentTimeMillis();
		//세션에 위치 정보 x, y값 저장 (geolocation 페이지에서 x, y좌표를 받아서 돌아온 경우)
		//geolocation 페이지에서 x, y좌표 받기 실패한 경우 -> x, y = "";으로 넘어옴
		if(lng!=null && lat!=null) { 
			session.setAttribute("x", lng);
			session.setAttribute("y", lat);
		//geolocation페이지에서 위치 정보 받아 오기 (메인 페이지 첫 접근 시)
		}else if(session.getAttribute("x") == null|| session.getAttribute("y") == null) {
			return "geolocation";
		}		
		//세션에서 현재 위치 x,y 값 받아오기
		String x = (String)session.getAttribute("x");
		String y = (String)session.getAttribute("y");
		
		//0. URL을 통한 비정상 적인 접근 처리
		if(keyword==null || filter==null ||  filter.equals("")) {
			model.addAttribute("filter", "distance");
			model.addAttribute("keyword", "");
			model.addAttribute("msg_badRequest", "엥 뭐하셨어요...? 이러지 마시구, 다시 검색해주세요.");
			model.addAttribute("msg_keywordEx", "예시) 키워드 검색: 비트카페<br/>태그 검색: #분위기 좋은");
			return "stores_search";
		}
		model.addAttribute("filter", filter);	
		
		//키워드 검색 로그 남기기
		int id=0;
		if(session.getAttribute("login")!=null) {
			id =((AccountVo)session.getAttribute("login")).getAccount_id();
		}		
		searchService.addKeywordLog(new LogVo(id, request.getRemoteAddr(), keyword, "업데이트해야되"));

	//1. 태그 검색(#검색)		
		if(keyword.contains("#")){										//태그 검색 & 키워드 검색 판별
			if(!keyword.substring(keyword.indexOf("#")+1).equals("")){		//태그 앞에만 내용이 있으면 키워드 검색으로 처리
				keyword=keyword.substring(keyword.indexOf("#")+1).trim();
				keyword=keyword.replace(" ", "");
				Map<String, String> variables = new HashMap<String, String>();
				variables.put("keyword", keyword);
				variables.put("x", x);
				variables.put("y", y);
				variables.put("filter", filter);
				if(region!=null) variables.put("region",region[0]+" "+region[1]);
				model.addAttribute("keyword", "#"+keyword);
				model.addAttribute("alist",searchService.getListByTag(variables));				
				return "stores_search";
			}			
		}

	//2. 키워드 검색: 키워드 검색, #기호 앞에만 내용이 있는 경우
		keyword=keyword.replace("#", "").trim();
		//카카오 API 검색 & Selected_Region값 저장
		List<StoreVo> alist=null;
		alist = searchService.getListFromKakaoAPI(keyword, region, x, y, null, model); 
		
		//mocaDB 열람 및 데이터 업데이트
		for(StoreVo s: alist) s = searchService.getMoreData(s);
		//정렬 처리
		if(!filter.equals("distance")) 	alist = searchService.sort(alist, filter); 		//카카오 정렬 디폴트 = 거리순(정렬 처리 불필요)
		if(keyword.startsWith("'") && keyword.endsWith("'")) {
			keyword=keyword.substring(1, keyword.length()-1);
		}
		model.addAttribute("keyword", keyword);
		model.addAttribute("alist", alist);
		logger.debug("카카오 검색 총 갯수: "+(alist.size()));
		
		//키워드 검색시간
		long afterTime=System.currentTimeMillis();
		logger.debug("search controller에서 키워드 검색에 걸린 시간은 : "+String.valueOf((afterTime-enterTime)/1000D)+"초");
		return "stores_search";
	}
	
}

