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
	
	@GetMapping(value = "/naverLogin")
	public String loginPage() {
		
		return "naverLogin";
	}
	
	@PostMapping(value = "/login/{accountId}")
	@ResponseBody
	public ResponseEntity login(@PathVariable("accountId") int accountId, @RequestBody AccountVo accountVo, Model model){
		AccountVo returnVo = accountService.login(stringFilter(accountVo));
		
		if(returnVo==null) {
			//로그아웃 시점
			
			model.addAttribute("login","NULL_VAL");
			
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}else {
			//로그인 시점
			model.addAttribute("login", returnVo);
			
			return new ResponseEntity<>(HttpStatus.OK);
		}
	}
	
	@PostMapping(value = "/session")
	@ResponseBody
	public AccountVo session(Model model) {
		if(model.asMap().get("login")==null) {
			return new AccountVo(0, 0, 0, 0, null, "NON-CONNECTED", null, null, null, 0, 0, null);
		}else if((model.asMap().get("login").toString()).equals("NULL_VAL")) {
			return new AccountVo(0, 0, 0, 0, null, "NON-CONNECTED", null, null, null, 0, 0, null);
		}else {
			AccountVo accVo = (AccountVo)model.asMap().get("login");
			return accVo;
		}
		
	}
	
	@PostMapping(value = "logout")
	@ResponseBody
	public ResponseEntity logout(Model model) {

		if(model.asMap().get("login")==null) {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}else if((model.asMap().get("login").toString()!="NULL_VAL")) {
			
			model.addAttribute("login","NULL_VAL");
			
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}
	
	//단순 문자열 컨트롤 로직용 함수
	public AccountVo stringFilter(AccountVo vo) {
		if("kakao".equals(vo.getPlatformType())) {
			AccountVo answer = new AccountVo(vo.getAccount_id(),vo.getFollowCount(),vo.getReviewCount(),vo.getPlatformId(),
					cut(vo.getNickname()),cut(vo.getPlatformType()),cut(vo.getProfileImage()),cut(vo.getThumbnailImage()),
					cut(vo.getEmail()),vo.getGender(),vo.getBarista(),vo.getBirthday());
			return answer;
		}else {
			return vo;
		}
	}
	public String cut(String string) {
		String rt=string;
		if(string==null) {
			return null;
		}else if(string.charAt(0)=='"'&&string.charAt(string.length()-1)=='"') {
			rt=string.substring(1, string.length()-1);
		}
		return rt;
	}
}
