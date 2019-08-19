package com.kkssj.moca.controller;

import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.client.RestTemplate;

import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.model.entity.kakaoAPI.KakaoCafeVo;
import com.kkssj.moca.model.entity.kakaoAPI.Meta;
import com.kkssj.moca.service.SearchService;

@Controller
public class SearchController {
	@Inject
	SearchService storeService;
	
	private static final Logger logger = LoggerFactory.getLogger(SearchController.class);
	
	@RequestMapping(value = "/search", method = RequestMethod.GET)
	public String search(String keyword, String x, String y, String filter, String region, Model model) throws MalformedURLException {

	////검색 옵션 디폴트 값 및 파라미터 처리	
		int page=1;
		//위치정보 제공하지 않는 브라우저로 접근 시, 디폴트 위치는 비트캠프 강남 센터! :p
		//region을 찍었을 때는, 해당 region의 x,y좌표로 검색! x는 경도, y는 위도
		if(region!=null&&!region.equals("")) {
			Properties regionLatLng = storeService.getByRegion(region);
			y = (String) regionLatLng.get("xLocation");
			x = (String) regionLatLng.get("yLocation");
		}else if(x.equals("") || y.equals("")) {
			y = "37.4995011";
			x = "127.0291403";
		}
		keyword = keyword.trim();
		//검색어가 없을 때
		if(keyword.equals("") || keyword.equals("#")) {
			model.addAttribute("err", "검색어를 다시 입력해주세요(#검색어 예시 추가)1");
			return "search";
		}
////태그 검색
		//태그 검색인지 키워드 검색인지 확인
		if(keyword.contains("#")){
			//#태그가 여러개
			if(keyword.indexOf('#')!=keyword.lastIndexOf('#')) {
			model.addAttribute("err", "검색어를 다시 입력해주세요(#검색어 예시 추가)2");
			return "search";
			//#태그가 한 개이고, 내용이 있을 때
			}else if(!keyword.substring(keyword.indexOf("#")+1).equals("")){				
				keyword=keyword.substring(keyword.indexOf("#")+1).trim();
				Map<String, String> variables = new HashMap<String, String>();
				variables.put("keyword", keyword);
				variables.put("x", x);
				variables.put("y", y);
				variables.put("filter", filter);
        if(region!=null&&!region.equals("")) {
					variables.put("region",region);
				}
				model.addAttribute("alist",storeService.getListByTag(variables));			
				model.addAttribute("keyword", "#"+keyword);
				model.addAttribute("filter", filter);
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
		
		List<StoreVo> cafeInfoList= new ArrayList<StoreVo>();
		StoreVo[] cafeInfo = response.getBody().getDocuments();
		Meta APIInfo = response.getBody().getMeta();
		for(StoreVo d : cafeInfo) {
			//지역 필터가 적용중이고, 검색해서 나온 위치가 지역필터와 맞지 않다면(거리상 더 가깝지만 해당 지역이 아니라면)
			if(region!=null&&!region.equals("")&&!d.getAddress().contains(region))
				continue;
			cafeInfoList.add(d);
		}
		//'is_end'가 false이면, 다음페이지를 재요청
		while(!APIInfo.isIs_end()) {
			response = restTemplate.exchange(url, HttpMethod.GET, entity, KakaoCafeVo.class, x, y, query, ++page);
			cafeInfo = response.getBody().getDocuments();
			APIInfo = response.getBody().getMeta();
      
			for(StoreVo d : cafeInfo) {
				//지역 필터가 적용중이고, 검색해서 나온 위치가 지역필터와 맞지 않다면(거리상 더 가깝지만 해당 지역이 아니라면)
				if(region!=null&&!region.equals("")&&!d.getAddress().contains(region))
					continue;
				cafeInfoList.add(d);
			}
		}

		
//카카오 결과 mocaDB확인 및 후처리(데이터 추가, 필터)		

		//카카오API 결과 mocaDB에서 확인
		List<StoreVo> cafesInMoca= new ArrayList<StoreVo>();		//mocaDB에 있는 데이터의 필터 처리를 위한 List
		for(int i=0; i<cafeInfoList.size(); i++) {
			StoreVo currentVo = cafeInfoList.get(i);
			StoreVo temp=storeService.checkByKakaoId(currentVo.getKakaoId());
			//필요한 값 추가 저장(Store_Id, Tag, ReviewCnt, ViewCnt, AverageLevel)
			if(temp!=null) {				
				currentVo.setStore_Id(temp.getStore_Id());
				currentVo.setTag(temp.getTag());
				currentVo.setReviewCnt(temp.getReviewCnt());
				currentVo.setViewCnt(temp.getViewCnt());
				currentVo.setAverageLevel(temp.getAverageLevel());
				//유저가 선택한 정렬 필터가 거리순이 아닌 경우에만 새로운 List에 StoreVo객체 추출(카카오 정렬 디폴트=거리순)
				if(!filter.equals("distance")) {
					cafesInMoca.add(currentVo);		
				}
			}
		}		
			
		//카카오API 결과 List에서 정렬해야하는 객체 제거
		cafeInfoList.removeAll(cafesInMoca);	//유저가 선택한 정렬 필터가 거리순인 경우 영향받지 않음
		
		//필터 오름차순 처리(유저가 선택한 필터가 거리순인 경우 추가 정렬 없이 그대로 List 리턴)
		if(!filter.equals("distance")) {
			Collections.sort(cafesInMoca, new Comparator<StoreVo>() {
				
				@Override
				public int compare(StoreVo o1, StoreVo o2) {
					//정렬 기준: 평점순
					if(filter.equals("averageLevel")) {	
						if(o1.getAverageLevel()>o2.getAverageLevel()) return 1;
						else if(o1.getAverageLevel()<o2.getAverageLevel()) return -1;
						else return 0;
					//정렬 기준: 리뷰수순
					}else if(filter.equals("reviewCnt")) {
						if(o1.getReviewCnt()>o2.getReviewCnt()) return 1;
						else if(o1.getReviewCnt()>o2.getReviewCnt()) return -1;
						else return 0;
					//정렬 기준: 조회수순
					}else if(filter.equals("viewCnt")){
						if(o1.getViewCnt()>o2.getViewCnt()) return 1;
						else if(o1.getViewCnt()<o2.getViewCnt()) return -1;
						else return 0;
					}	
					return 0;
				}});
		}
		
		//오름차순 처리된 mocaDB데이터 내림차순으로 카카오API 결과 List와 병합
		for(StoreVo d : cafesInMoca) cafeInfoList.add(0, d);
		
		//모델 전달
		model.addAttribute("alist", cafeInfoList);
		model.addAttribute("keyword", query);
		model.addAttribute("filter", filter);		
		
		return "search";
	}
	
	
	@RequestMapping(value="store", method=RequestMethod.POST)
	public String detail(@ModelAttribute("bean") StoreVo bean) {			
		logger.debug(bean.getAddress());		
		return "detail";
	}
	
}

