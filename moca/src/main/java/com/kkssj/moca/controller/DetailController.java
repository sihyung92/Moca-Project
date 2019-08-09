package com.kkssj.moca.controller;

import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class DetailController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	//처음 상세페이지로 접속 (디비 넣기)
	@PostMapping("/store")
	public String pdetail(Locale locale, Model model) {
		logger.info("Welcome storeDetail!");
		
		return "store_detail";
	}
	
	//리다이렉트로 상세페이지로
	@GetMapping("/store")
	public String detail(Locale locale, Model model) {
		logger.info("Welcome storeDetail!");
		
		return "store_detail";
	}
	
}
