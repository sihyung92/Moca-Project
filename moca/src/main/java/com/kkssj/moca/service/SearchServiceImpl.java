package com.kkssj.moca.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.client.RestTemplate;

import com.kkssj.moca.model.LogDao;
import com.kkssj.moca.model.StoreDao;
import com.kkssj.moca.model.entity.LogVo;
import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.model.entity.kakaoAPI.KakaoCafeVo;
import com.kkssj.moca.model.entity.kakaoAPI.Meta;

@Service
public class SearchServiceImpl implements SearchService {
	@Inject
	StoreDao storeDao;
	@Inject
	LogDao logDao;
	
	Logger logger = LoggerFactory.getLogger(SearchService.class);
	
	@Override
	public List<StoreVo> getListByTag(Map<String, String> variables) {		
		return storeDao.selectListByTag(variables);
	}	

	@Override
	public StoreVo getMoreData(StoreVo currentVo) {	
	//alist(카카오 검색 결과)의 가게Vo와 mocaDB 연계(데이터 추가)
		StoreVo tempVo = storeDao.selectByKakaoId(currentVo.getKakaoId());
		//currentVo의 가게가 mocaDB에 있을 시, 객체에 데이터 추가(Store_Id, Tag, ReviewCnt, ViewCnt, AverageLevel)
		if(tempVo!=null) {				
			currentVo.setStore_Id(tempVo.getStore_Id());
			currentVo.setTag(tempVo.getTag());
			currentVo.setReviewCnt(tempVo.getReviewCnt());
			currentVo.setViewCnt(tempVo.getViewCnt());
			currentVo.setTasteLevel(tempVo.getTasteLevel());
			currentVo.setConvenienceLevel(tempVo.getConvenienceLevel());
			currentVo.setMoodLevel(tempVo.getMoodLevel());
			currentVo.setServiceLevel(tempVo.getServiceLevel());
			currentVo.setPriceLevel(tempVo.getPriceLevel());
			currentVo.setAverageLevel(tempVo.getAverageLevel());
			currentVo.setLogoImg(tempVo.getLogoImg());			
		}		
		return currentVo;
	}

	@Override
	public List<StoreVo> getListFromKakaoAPI(String keyword, String[] region, String x, String y, String rect, Model model) {
		//(카카오 검색) 키워드 검색 파라미터 세팅
		List<StoreVo> alist = new ArrayList<StoreVo>();
		int page=1;		
		//키워드 추출
		String query=null;
		//sort 기준 변경1 : 지역 필터 검색
		String sort="distance";
		if(region!=null) {
			logger.debug("지역 필터 들어옴!");
			sort="accuracy";
			if(keyword.contains(region[1])){
				query=keyword;		//광진스타벅스
			}else {
				query=region[0]+" "+region[1]+" "+keyword;
			}			
		}else {
			query=keyword;
		}
		//sort 기준 변경2 : 지도 내 재검색
		if(rect!=null) {
			sort="accuracy";
		}
		
		logger.debug("카카오 검색 키워드: "+query);
		
//카카오 API 접속 정보 세팅
		//URL  category_group_code=CE7&		
		String url="https://dapi.kakao.com/v2/local/search/keyword.json?category_group_code=CE7&sort={sort}&x={x}&y={y}&query={query}&page={page}";
		//HttpEntity에 header 정보 싣기
		HttpHeaders headers = new HttpHeaders();		//MultiValueMap<String, String> 상속중-
		headers.add("Authorization", "KakaoAK 1e233a4652123a4998f1e91bf40b38ba");
		HttpEntity entity = new HttpEntity(headers);		
		//동기 통신용 RestTemplate
		RestTemplate restTemplate = new RestTemplate();
//		HttpEntity<MultiValueMap> requestEntity =new HttpEntity(map, headers);		//POST로 인식하는 듯
		
//카카오 API 동기 통신 & 데이터 받기
		//지도 내 재검색 기능
		url+="&rect="+rect;
		//JSON 데이터 Vo객체로 파싱
		ResponseEntity<KakaoCafeVo> response = restTemplate.exchange(url, HttpMethod.GET, entity, KakaoCafeVo.class, sort, x, y, query, page);	//Object 파라미터는 URL에 순서대로 인식	
		
		//카카오 API 검색 결과 alist에 추가
		StoreVo[] kakaoStores = response.getBody().getDocuments();
		Meta kakaoInfo = response.getBody().getMeta();
		
		//지역 검색 여부 판단
		if(!kakaoInfo.getSame_name().getSelected_region().equals("")) {
			sort="accuracy";
			model.addAttribute("msg_changedFilter", "지역 기반 검색 시, 정확도 순으로 정렬됩니다.");
			response = restTemplate.exchange(url, HttpMethod.GET, entity, KakaoCafeVo.class, sort, x, y, query, page);
			kakaoStores = response.getBody().getDocuments();
			kakaoInfo = response.getBody().getMeta();
		}	
		
		for(StoreVo s : kakaoStores) {			
			alist.add(s);
		}		
		
		//카카오 API 다음 페이지 요청(Meta객체의 is_end=false인 경우) & 검색 결과 alist에 추가
		while(!kakaoInfo.isIs_end()) {
			response = restTemplate.exchange(url, HttpMethod.GET, entity, KakaoCafeVo.class, sort, x, y, query, ++page);
			kakaoStores = response.getBody().getDocuments();
			kakaoInfo = response.getBody().getMeta();			
			for(StoreVo s : kakaoStores) {
				alist.add(s);
			}
		}		
		return alist;
	}
	
	@Override
	public List<StoreVo> sort(List<StoreVo> alist, String filter){
		List<StoreVo> mocaStores= new ArrayList<StoreVo>();			//alist 정렬을 위한 List(mocaDB의 평점/조회수/리뷰수 기준)
		//정렬을 위해 mocaDB에 있는 alist의 가게를 mocaStores에 추출
		for(StoreVo s : alist) {
			if(s.getStore_Id()!=0) {
				mocaStores.add(s);		//정렬용 List에 Vo객체 저장
			}
		}
		alist.removeAll(mocaStores);			//alist에서 mocaStores의 가게 객체 제거
		//필터 기준에 따라 mocaStores 오름 차순 정렬
		Collections.sort(mocaStores, new Comparator<StoreVo>() {				
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
					else if(o1.getReviewCnt()<o2.getReviewCnt()) return -1;
					else return 0;
				//정렬 기준: 조회수순
				}else if(filter.equals("viewCnt")){
					if(o1.getViewCnt()>o2.getViewCnt()) return 1;
					else if(o1.getViewCnt()<o2.getViewCnt()) return -1;
					else return 0;
				}	
				return 0;
			}});	
		//오름차순 처리된 mocaStores를 내림차순으로 alist와 병합
		for(StoreVo s : mocaStores) alist.add(0, s);
		return alist;
	}

	@Override
	public int addKeywordLog(LogVo logVo) {
		return logDao.insertKeywordLog(logVo);	
	}	
	
}
