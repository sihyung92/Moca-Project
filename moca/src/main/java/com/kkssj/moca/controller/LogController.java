package com.kkssj.moca.controller;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;

import com.kkssj.moca.service.LogService;

@Controller
public class LogController {

	@Inject
	LogService logService;
	
	//Ajax를 통해서 통신이 있는경우 LogController 쓰면 되려나? $ 각자 컨트롤러에서 로그 찍으려면 각 컨트롤러 내부에서 LogService Inject 해서 쓰면 될듯
}
