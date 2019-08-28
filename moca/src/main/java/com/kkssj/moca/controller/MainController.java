package com.kkssj.moca.controller;

import java.util.List;

import javax.inject.Inject;

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

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model) {		
		model.addAttribute("hitStores", mainService.getHitStoresList());
		return "main";
	}
	
//	@ResponseBody
//	@RequestMapping("/hits")
//	public List<StoreVo> getHits() {
//		return mainService.getHitStoresList();
//	}	
}