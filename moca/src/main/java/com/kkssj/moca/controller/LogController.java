package com.kkssj.moca.controller;

import javax.inject.Inject;
import org.springframework.stereotype.Controller;
import com.kkssj.moca.service.LogService;

@Controller
public class LogController {

	@Inject
	LogService logService;
	
}
