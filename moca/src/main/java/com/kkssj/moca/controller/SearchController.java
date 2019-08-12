package com.kkssj.moca.controller;

import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

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

@Controller
public class SearchController {

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
		//�˻�� ���� ��
		if(keyword.trim().equals("")) {
			model.addAttribute("alist", "�˻�� �ٽ� �Է����ּ���");
			return "search";
		}
		
		//(�ؾ��� ��) Ű���忡�� ���� ���ڿ� / �±� ���ڿ� �и��ؼ� ó��
		//(�ؾ��� ��) ���� ���� ó��
		
		//�˻��� ����
		String query=keyword;		
		
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
		//(�ؾ��� ��)3���������� ������ ��û�ϱ� �߰�
		//(�ؾ��� ��)���̽� ������ ó�� �� �� �������� �����ϱ�
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
		
		logger.debug(cafeInfoList.toString());
		model.addAttribute("alist", cafeInfoList);

		return "search";
	}
	
}
