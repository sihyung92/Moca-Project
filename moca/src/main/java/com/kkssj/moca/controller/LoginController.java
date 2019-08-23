package com.kkssj.moca.controller;

import javax.inject.Inject;

import org.apache.ibatis.executor.ReuseExecutor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.service.AccountService;

@Controller
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
	public AccountVo login(@PathVariable("accountId") int accountId, @RequestBody AccountVo accountVo){
		
		//���� Ȥ�� dao�� �α��� ������ �ִ��� ������ ó���ؼ� ���� ����̸� �� vo��ü�� �����ؼ� ���ǿ��ٰ� �ٽ� ��?
		
		AccountVo returnVo = null;
		returnVo = accountService.login(accountVo);
		
		if(returnVo==null) {
			return null;
		}else {
			return returnVo;
		}
	}
}
