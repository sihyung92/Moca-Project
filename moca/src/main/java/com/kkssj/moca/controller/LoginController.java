package com.kkssj.moca.controller;

import javax.inject.Inject;

import org.springframework.http.HttpRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.HttpRequestHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.request.RequestScope;
import org.springframework.web.context.request.SessionScope;
import org.springframework.web.servlet.View;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.service.AccountService;

@Controller
@SessionAttributes({"login","token"})
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
		
		//���� Ȥ�� dao�� �α��� ������ �ִ��� ������ ó���ؼ� ���� ����̸� �� vo��ü�� �����ؼ� ���ǿ��ٰ� �ٽ� ��?
		
		
		AccountVo returnVo = accountService.login(accountVo);
		
		if(returnVo==null) {
			model.addAttribute("login",null);
			model.addAttribute("token",null);
			
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}else {
			model.addAttribute("login", returnVo);
			model.addAttribute("token",accountVo.getToken());
			
			return new ResponseEntity<>(HttpStatus.OK);
		}
	}
	
	@PostMapping(value = "/session")
	@ResponseBody
	public String session(Model model) {
		String token = (String) model.asMap().get("token");
		System.out.println("���� ���� ��ū ���?"+token);
		return token;
	}
	
	
	@PostMapping(value = "/logout")
	@ResponseBody
	public ResponseEntity logout(Model model) {
		if((model.asMap().get("login")!=null)&&(model.asMap().get("token")!=null)) {
			model.addAttribute("login",null);
			model.addAttribute("token",null);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	
	
}
