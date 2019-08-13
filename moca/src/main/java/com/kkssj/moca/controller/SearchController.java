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
	////�˻� �ɼ� ����Ʈ �� �� �Ķ���� ó��	
		List<Documents> cafeInfoList= new ArrayList<>();
		int page=1;
		//��ġ���� �������� �ʴ� �������� ���� ��, ����Ʈ ��ġ�� ��Ʈķ�� ���� ����! :p
		if(x.equals("") || y.equals("")) {
			y = "37.4995011";
			x = "127.0291403";
		}
		keyword = keyword.trim();
		//�˻�� ���� ��
		if(keyword.equals("") || keyword.equals("#")) {
			model.addAttribute("alist", "�˻�� �ٽ� �Է����ּ���(#�˻��� ���� �߰�)1");
			return "search";
		}
////�±� �˻�
		//�±� �˻����� Ű���� �˻����� Ȯ��
		if(keyword.contains("#")){
			//#�±װ� ������
			if(keyword.indexOf('#')!=keyword.lastIndexOf('#')) {
			model.addAttribute("alist", "�˻�� �ٽ� �Է����ּ���(#�˻��� ���� �߰�)2");
			return "search";
			//#�±װ� �� ���̰�, ������ ���� ��
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

		Documents[] cafeInfo = response.getBody().getDocuments();
		Meta APIInfo = response.getBody().getMeta();
		for(Documents d : cafeInfo)
		cafeInfoList.add(d);
		
		//'is_end'�� false�̸�, ������������ ���û
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

