package com.kkssj.moca.controller;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

@ControllerAdvice("com.kkssj.moca")//com.kkssj.moca 패키지로 시작하는 컨트롤러에서 예외가 발생하는 순간 ExceptionHandler가 작동
public class MocaExceptionHandler {

	@ExceptionHandler(com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException.class)
	public ModelAndView handleNotFoundException(Exception e) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("exception", e);
		mav.setViewName("/err/err404");
		
		return mav;
	}
	
	@ExceptionHandler(org.springframework.web.method.annotation.MethodArgumentTypeMismatchException.class)
	public ModelAndView NotFoundException(Exception e) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("exception", e);
		mav.setViewName("/err/err404");
		return mav;
	}
}
