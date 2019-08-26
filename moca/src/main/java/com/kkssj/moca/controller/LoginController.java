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
@SessionAttributes({"login","token"})
public class LoginController {
	
	@Inject
	AccountService accountService;
	
	/*------------------------------------------------------------------------------------------------------*/
	
	@GetMapping(value = "/naverLogin")
	public String loginPage() {
		
		return "naverLogin";
	}
	
	@PostMapping(value = "/login/{accountId}")
	@ResponseBody
	public ResponseEntity login(@PathVariable("accountId") int accountId, @RequestBody AccountVo accountVo, Model model){
		AccountVo returnVo = accountService.login(accountVo);
		
		if(returnVo==null) {
			model.addAttribute("login","NULL_VAL");
			model.addAttribute("token","NULL_VAL");
			
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}else {
			model.addAttribute("login", returnVo);
			model.addAttribute("token",accountVo.getToken());
			
			return new ResponseEntity<>(HttpStatus.OK);
		}
	}
	
	@PostMapping(value = "/session")
	@ResponseBody
	public AccountVo session(Model model) {
		if(model.asMap().get("login")==null) {
			return new AccountVo(0, 0, 0, 0, null, "NON-CONNECTED", null, null, null, null);
		}else if((String)model.asMap().get("login").toString()=="NULL_VAL") {
			return new AccountVo(0, 0, 0, 0, null, "NON-CONNECTED", null, null, null, null);
		}else {
			AccountVo accVo = (AccountVo)model.asMap().get("login");
			return accVo;
		}
		
	}
	
	@PostMapping(value = "logout")
	@ResponseBody
	public ResponseEntity logout(Model model) {

		if((model.asMap().get("login").toString()!="NULL_VAL")&&((String)model.asMap().get("token")!="NULL_VAL")) {
			
			model.addAttribute("login","NULL_VAL");
			model.addAttribute("token","NULL_VAL");
			
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}
}
