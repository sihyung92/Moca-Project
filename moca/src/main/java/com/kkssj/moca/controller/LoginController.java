package com.kkssj.moca.controller;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.service.StoreService;

@Controller
public class LoginController {

	@Inject
	StoreService storeService;
	
	@GetMapping(value = "/login")
	public String loginPage() {
		
		return "login";
	}
	
//	public AccountVo setSession() {
//		
//	}
//	
	@PostMapping(value = "/login/{accountId}")
	public ResponseEntity loginSuccess(@PathVariable("accountId") int accountId, @RequestBody AccountVo accountVo){
		
		System.out.println("accountid:	"+accountId);
		System.out.println("accountVo;	"+accountVo.toString());
		
		//서비스 혹은 dao로 로그인 정보가 있는지 없는지 처리해서 없는 사람이면 새 vo객체로 선언해서 세션에다가 다시 넣?
		
		
		
		
		
		return new ResponseEntity<>(HttpStatus.OK);
//		if (isSuccess > 0) {
//			// 성공
//			return new ResponseEntity<>(HttpStatus.OK);
//		} else {
//			// 실패
//			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
//		}
	}
}
