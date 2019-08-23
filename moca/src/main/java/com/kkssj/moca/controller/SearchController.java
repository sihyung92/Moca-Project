package com.kkssj.moca.controller;

import java.net.MalformedURLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.service.SearchService;

@Controller
public class SearchController {
	@Inject
	SearchService searchService;	
	private static final Logger logger = LoggerFactory.getLogger(SearchController.class);
	
	@RequestMapping(value = "/stores", method = RequestMethod.GET)
	public String search(String keyword, String x, String y, String filter, String[] region, Model model) throws MalformedURLException {
	//0. URL을 통한 비정상 적인 접근 처리
		if(keyword==null || x==null || y==null || filter==null || x.equals("") || y.equals("") || filter.equals("")) {
			model.addAttribute("filter", "distance");
			model.addAttribute("keyword", "");
			model.addAttribute("msg_badRequest", "엥 뭐하셨어요...? 이러지 마시구, 다시 검색해주세요.");
			model.addAttribute("msg_keywordEx", "예시) 키워드 검색: 비트카페<br/>태그 검색: #분위기 좋은");
			return "stores_search";
		}
		model.addAttribute("filter", filter);		
	//0. 비정상 적인 검색어 처리
		keyword = keyword.trim();		
		if(keyword.equals("") || keyword.equals("#")) {					//검색어가 없으면, 에러메시지와 함께 뷰페이지 리턴
			model.addAttribute("msg_wrongKeyword", "검색어가 없네요.... :'(");
			model.addAttribute("msg_keywordEx", "예시)	키워드 검색: 비트카페<br/>태그 검색: #분위기 좋은");
			return "stores_search";
		}
		
	//1. 태그 검색(#검색)		
		if(keyword.contains("#")){										//태그 검색 & 키워드 검색 판별
			//여러개의 태그(#)-> 에러메시지와 함께 뷰페이지로 리턴
			if(keyword.indexOf('#')!=keyword.lastIndexOf('#')) {
			model.addAttribute("msg_wrongKeyword", "검색어를 다시 입력해주세요!");
			model.addAttribute("msg_keywordEx", "예시) 키워드 검색: 비트카페<br/>태그 검색: #분위기 좋은");
			return "stores_search";			
			//한 개의 태그(#)
			}else if(!keyword.substring(keyword.indexOf("#")+1).equals("")){		//태그 앞에만 내용이 있으면 키워드 검색으로 처리
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
		alist = searchService.getListFromKakaoAPI(keyword, region, x, y, model); 
		
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
		return "stores_search";
	}
	
}

