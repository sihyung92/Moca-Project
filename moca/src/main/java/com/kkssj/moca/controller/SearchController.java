package com.kkssj.moca.controller;

import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.client.RestTemplate;

import com.kkssj.moca.model.entity.kakaoAPI.Documents;
import com.kkssj.moca.model.entity.kakaoAPI.KakaoCafeVo;
import com.kkssj.moca.model.entity.kakaoAPI.Meta;
import com.kkssj.moca.service.SearchService;

@Controller
public class SearchController {
	@Inject
	SearchService storeService;
	
	private static final Logger logger = LoggerFactory.getLogger(SearchController.class);
	
	@RequestMapping(value = "/search", method = RequestMethod.GET)
	public String search(String keyword, String x, String y, Model model) throws MalformedURLException {
	////검색 옵션 디폴트 값 및 파라미터 처리	
		List<Documents> cafeInfoList= new ArrayList<>();
		int page=1;
		//위치정보 제공하지 않는 브라우저로 접근 시, 디폴트 위치는 비트캠프 강남 센터! :p
		if(x.equals("") || y.equals("")) {
			y = "37.4995011";
			x = "127.0291403";
		}
		keyword = keyword.trim();
		//검색어가 없을 때
		if(keyword.equals("") || keyword.equals("#")) {
			model.addAttribute("alist", "검색어를 다시 입력해주세요(#검색어 예시 추가)1");
			return "search";
		}
////태그 검색
		//태그 검색인지 키워드 검색인지 확인
		if(keyword.contains("#")){
			//#태그가 여러개
			if(keyword.indexOf('#')!=keyword.lastIndexOf('#')) {
			model.addAttribute("alist", "검색어를 다시 입력해주세요(#검색어 예시 추가)2");
			return "search";
			//#태그가 한 개이고, 내용이 있을 때
			}else if(!keyword.substring(keyword.indexOf("#")+1).equals("")){				
				keyword=keyword.substring(keyword.indexOf("#")+1).trim();
				Map<String, String> variables = new HashMap<String, String>();
				variables.put("keyword", keyword);
				variables.put("x", x);
				variables.put("y", y);
				model.addAttribute("alist",storeService.tagSearch(variables));				
				return "search";
			}			
		}
			

		//(해야할 일) 정렬 기준 처리

////키워드 검색: #태그뒤에 내용이 없거나, 키워드 검색
		//키워드 추출
		String query=keyword.replace("#", "").trim();
		
		//카카오 URL
		String url="https://dapi.kakao.com/v2/local/search/keyword.json?category_group_code=CE7&sort=distance&x={x}&y={y}&query={query}&page={page}";
		
		//HttpEntity에 header 정보 싣기
		HttpHeaders headers = new HttpHeaders();		//MultiValueMap<String, String> 상속중-
		headers.add("Authorization", "KakaoAK 1e233a4652123a4998f1e91bf40b38ba");
		HttpEntity entity = new HttpEntity(headers);
		
		//카카오 API 동기통신 & JSON 데이터 리턴
		RestTemplate restTemplate = new RestTemplate();
//		HttpEntity<MultiValueMap> requestEntity =new HttpEntity(map, headers);		//POST로 인식하는 듯
		ResponseEntity<KakaoCafeVo> response = restTemplate.exchange(url, HttpMethod.GET, entity, KakaoCafeVo.class, x, y, query, page);	//Object 파라미터는 URL에 순서대로 인식

		Documents[] cafeInfo = response.getBody().getDocuments();
		Meta APIInfo = response.getBody().getMeta();
		for(Documents d : cafeInfo)
		cafeInfoList.add(d);
		
		//'is_end'가 false이면, 다음페이지를 재요청
		while(!APIInfo.isIs_end()) {
			response = restTemplate.exchange(url, HttpMethod.GET, entity, KakaoCafeVo.class, x, y, query, ++page);
			cafeInfo = response.getBody().getDocuments();
			APIInfo = response.getBody().getMeta();
			for(Documents d : cafeInfo)
				cafeInfoList.add(d);
		}
		
		logger.debug(response.toString());
		logger.debug("cafeInfoList: " + cafeInfoList.toString());
		model.addAttribute("alist", cafeInfoList);

		return "search";
	}
	
}

