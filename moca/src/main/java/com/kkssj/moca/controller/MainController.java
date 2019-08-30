package com.kkssj.moca.controller;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.service.MainService;

@Controller
public class MainController {
	@Inject
	MainService mainService;
	
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(HttpSession session, HttpServletRequest request, HttpServletResponse response, String x, String y, Model model) {
		session.invalidate();		//개발 단계 테스트용 라인
		session=request.getSession();	//개발 단계 테스트용 라인
		if(x!=null && y!=null) {
			session.setAttribute("x", x);
			session.setAttribute("y", y);
		}else if(session.getAttribute("x") == null|| session.getAttribute("y") == null) {
			return "geolocation";
		}
	//	List<String> listNames = new ArrayList<String>();
	//	List<List<StoreVo>> storesList = new ArrayList<List<StoreVo>>();
		Map<String, String> variables = new HashMap<String, String>();
		variables.put("x", x );
		variables.put("y", y);
		//Hit Stores 추천 
		logger.debug((mainService.getHitStoresList(variables)).toString());
		model.addAttribute("hitStores", mainService.getHitStoresList(variables));		
		//Best Stores 추천 
	//	model.addAttribute("bestStores", mainService.getBestStoresList());
		//TakeOut Stores 추천
	//	model.addAttribute("takeOutStores", mainService.getTakeoutStoresList(variables));
		return "main";
	} 

	@RequestMapping(value="/geolocation", method = RequestMethod.GET)
	public String getGeolocation() {
		return "geolocation";
	}
	
}