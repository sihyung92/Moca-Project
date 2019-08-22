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
		
		//���� Ȥ�� dao�� �α��� ������ �ִ��� ������ ó���ؼ� ���� ����̸� �� vo��ü�� �����ؼ� ���ǿ��ٰ� �ٽ� ��?
		
		
		
		
		
		return new ResponseEntity<>(HttpStatus.OK);
//		if (isSuccess > 0) {
//			// ����
//			return new ResponseEntity<>(HttpStatus.OK);
//		} else {
//			// ����
//			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
//		}
	}
}
