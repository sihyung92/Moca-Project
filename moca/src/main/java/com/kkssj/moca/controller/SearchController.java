package com.kkssj.moca.controller;

import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	public String search(String keyword, String x, String y, String filter, Model model) throws MalformedURLException {		
	////�˻� �ɼ� ����Ʈ �� �� �Ķ���� ó��	
		List<StoreVo> cafeInfoList= new ArrayList<StoreVo>();
		int page=1;
		//��ġ���� �������� �ʴ� �������� ���� ��, ����Ʈ ��ġ�� ��Ʈķ�� ���� ����! :p
		if(x.equals("") || y.equals("")) {
			y = "37.4995011";
			x = "127.0291403";
		}
		keyword = keyword.trim();
		//�˻�� ���� ��
		if(keyword.equals("") || keyword.equals("#")) {
			model.addAttribute("err", "�˻�� �ٽ� �Է����ּ���(#�˻��� ���� �߰�)1");
			return "search";
		}
////�±� �˻�
		//�±� �˻����� Ű���� �˻����� Ȯ��
		if(keyword.contains("#")){
			//#�±װ� ������
			if(keyword.indexOf('#')!=keyword.lastIndexOf('#')) {
			model.addAttribute("err", "�˻�� �ٽ� �Է����ּ���(#�˻��� ���� �߰�)2");
			return "search";
			//#�±װ� �� ���̰�, ������ ���� ��
			}else if(!keyword.substring(keyword.indexOf("#")+1).equals("")){				
				keyword=keyword.substring(keyword.indexOf("#")+1).trim();
				Map<String, String> variables = new HashMap<String, String>();
				variables.put("keyword", keyword);
				variables.put("x", x);
				variables.put("y", y);
				variables.put("filter", filter);
				logger.debug("DAO���� ���� filter: "+filter);
				model.addAttribute("alist",storeService.getListByTag(variables));			
				model.addAttribute("keyword", "#"+keyword);
				model.addAttribute("filter", filter);
				return "search";
			}			
		}
			

		//(�ؾ��� ��) ���� ���� ó��

////Ű���� �˻�: #�±׵ڿ� ������ ���ų�, Ű���� �˻�
		//Ű���� ����
		String query=keyword.replace("#", "").trim();
		
		//īī�� URL
		String url="https://dapi.kakao.com/v2/local/search/keyword.json?category_group_code=CE7&sort=distance&x={x}&y={y}&query={query}&page={page}";
		
		//HttpEntity�� header ���� �Ʊ�
		HttpHeaders headers = new HttpHeaders();		//MultiValueMap<String, String> �����-
		headers.add("Authorization", "KakaoAK 1e233a4652123a4998f1e91bf40b38ba");
		HttpEntity entity = new HttpEntity(headers);
		
		//īī�� API ������� & JSON ������ ����
		RestTemplate restTemplate = new RestTemplate();
//		HttpEntity<MultiValueMap> requestEntity =new HttpEntity(map, headers);		//POST�� �ν��ϴ� ��
		ResponseEntity<KakaoCafeVo> response = restTemplate.exchange(url, HttpMethod.GET, entity, KakaoCafeVo.class, x, y, query, page);	//Object �Ķ���ʹ� URL�� ������� �ν�
		
		StoreVo[] cafeInfo = response.getBody().getDocuments();
		Meta APIInfo = response.getBody().getMeta();
		for(StoreVo d : cafeInfo)
		cafeInfoList.add(d);
		
		//'is_end'�� false�̸�, ������������ ���û
		while(!APIInfo.isIs_end()) {
			response = restTemplate.exchange(url, HttpMethod.GET, entity, KakaoCafeVo.class, x, y, query, ++page);
			cafeInfo = response.getBody().getDocuments();
			APIInfo = response.getBody().getMeta();
			for(StoreVo d : cafeInfo) 
				cafeInfoList.add(d);
		}		
		
		//īī�� ��� ������ mocaDB���� ����
		StoreVo temp=null;
		for(StoreVo d: cafeInfoList) {
			if((temp=storeService.checkByKakaoId(d.getKakaoId()))!=null) {
				d.setStore_Id(temp.getStore_Id());
				d.setTag(temp.getTag());
				d.setReviewCnt(temp.getReviewCnt());
				d.setViewCnt(temp.getViewCnt());
				d.setAverageLevel(temp.getAverageLevel());
				logger.debug(d.getKakaoId()+"�� ����: "+d.getAverageLevel());
			}else{
				d.setStore_Id(0);
			}
		}
		
		model.addAttribute("alist", cafeInfoList);
		model.addAttribute("keyword", query);
		model.addAttribute("filter", filter);
		return "search";
	}
	
	
	@RequestMapping(value="store", method=RequestMethod.POST)
	public String detail(@ModelAttribute("bean") StoreVo bean) {			
		logger.debug(bean.getAddress());		
		return"detail";
	}
	
}

