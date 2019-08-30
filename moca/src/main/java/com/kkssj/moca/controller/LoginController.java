package com.kkssj.moca.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

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
import com.kkssj.moca.service.LogService;

@Controller
@SessionAttributes("login")
public class LoginController {
	
	@Inject
	AccountService accountService;
	
	@Inject
	LogService logService;
	/*------------------------------------------------------------------------------------------------------*/
	
	@GetMapping(value = "/naverLogin")
	public String loginPage() {
		
		return "naverLogin";
	}
	
	@PostMapping(value = "/login/{account_id}")
	@ResponseBody
	public ResponseEntity login(@PathVariable("account_id") int account_id, @RequestBody AccountVo accountVo, Model model, HttpServletRequest req){
		AccountVo returnVo = accountService.login(stringFilter(accountVo));
		
		if(returnVo==null) {
			//로그아웃 시점
			
			model.addAttribute("login",new AccountVo(0, 0, 0, 0, null, "\"NULL_VAL\"", null, null, null, 0, 0, null));
			
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}else {
			//로그인 시점
			model.addAttribute("login", returnVo);
			logService.writeStoreIdKeyWordNone(req, "로그인", returnVo.getAccount_id());
			return new ResponseEntity<>(HttpStatus.OK);
		}
	}
		
	@PostMapping(value = "logout")
	@ResponseBody
	public ResponseEntity logout(Model model, HttpServletRequest req) {

		AccountVo check = ((AccountVo)(model.asMap().get("login")));
		
		//if(model.asMap().get("login")==null) {
		if(check==null) {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}else if(check.getPlatformType()!="NULL_VAL") {
			int account_id=check.getAccount_id();
			
			model.addAttribute("login",new AccountVo(0, 0, 0, 0, null, "NULL_VAL", null, null, null, 0, 0, null));
			logService.writeStoreIdKeyWordNone(req, "로그아웃", account_id);
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
