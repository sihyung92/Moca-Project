package com.kkssj.moca.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.service.MainService;

@Controller
public class MainController {
	@Inject
	MainService mainService;
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);
	
	@ResponseBody
	@RequestMapping(value = "/near", method = RequestMethod.GET)
	public List<StoreVo> getNearStores(Model model, String x, String y) {
		Map<String, String> variables = new HashMap<String, String>();
		variables.put("x", x);
		variables.put("y", y);
		List<StoreVo> list = mainService.getStoresNearBy(variables);
		return list;
	}
	
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(HttpSession session, HttpServletResponse response, String x, String y, Model model) {
		if(x!=null && y!=null) {
			session.setAttribute("x", x);
			session.setAttribute("y", y);
		}else if(session.getAttribute("x") == null|| session.getAttribute("y") == null) {
			return "geolocation";
		}
		
		model.addAttribute("hitStores", mainService.getHitStoresList());
		model.addAttribute("trendStores", mainService.getTrendStoresList("예쁜"));
		model.addAttribute("recentReviews",mainService.getRecentReviews());
		return "main";
	}

	@RequestMapping(value="/geolocation", method = RequestMethod.GET)
	public String getGeolocation() {
		return "geolocation";
	}
}