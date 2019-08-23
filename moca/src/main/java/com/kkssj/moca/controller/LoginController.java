package com.kkssj.moca.controller;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.service.AccountService;

@Controller
@SessionAttributes("login")
public class LoginController {

	@Inject
	AccountService accountService;
	
	/*------------------------------------------------------------------------------------------------------*/
	
	@GetMapping(value = "/login")
	public String loginPage() {
		
		return "login";
	}
	
	@PostMapping(value = "/login/{accountId}")
	@ResponseBody
	public ResponseEntity login(@PathVariable("accountId") int accountId, @RequestBody AccountVo accountVo, Model model){
		
		//서비스 혹은 dao로 로그인 정보가 있는지 없는지 처리해서 없는 사람이면 새 vo객체로 선언해서 세션에다가 다시 넣?
		
		AccountVo returnVo = null;
		returnVo = accountService.login(accountVo);
		
		
		
//		if(returnVo==null) {
//			return null;
//		}else {
//			return returnVo;
//		}
		if(returnVo==null) {
			model.addAttribute("login",null);
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}else {
			model.addAttribute("login", returnVo);
			return new ResponseEntity<>(HttpStatus.OK);
		}
	}
}
