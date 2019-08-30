package com.kkssj.moca.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AccountController {

	@GetMapping(value = "research")
	public String research() {
		
		return "research";
	}
	@GetMapping(value = "mypage")
	public String mypage() {
		
		return "mypage";
	}
}
