package com.kkssj.moca.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.service.AccountService;
import com.kkssj.moca.service.LogService;

@Controller
public class LoginController {//@SessionAtrribute?인가 삭제함
	
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
	public ResponseEntity login(@PathVariable("account_id") int account_id, @RequestBody AccountVo accountVo, HttpServletRequest req){
		AccountVo returnVo = accountService.login(stringFilter(accountVo));
		
		HttpSession sess = req.getSession();
		
		if(returnVo==null) {
			sess.setAttribute("login",null);
			
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}else {
			sess.setAttribute("login", returnVo);
			logService.writeStoreIdKeyWordNone(req, "로그인", returnVo.getAccount_id());
			return new ResponseEntity<>(HttpStatus.OK);
		}
	}
		
	@PostMapping(value = "logout")
	@ResponseBody
	public ResponseEntity logout(Model model, HttpServletRequest req) {
		HttpSession sess = req.getSession();
		AccountVo check = ((AccountVo)(sess.getAttribute("login")));
		
		//if(model.asMap().get("login")==null) {
		if(check==null) {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}else if(check.getPlatformType()!=null) {
			int account_id=check.getAccount_id();
			
			sess.setAttribute("login",null);
			logService.writeStoreIdKeyWordNone(req, "로그아웃", account_id);
			return new ResponseEntity<>(HttpStatus.OK);
		}else {

			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}
	
	public AccountVo stringFilter(AccountVo vo) {
		if("kakao".equals(vo.getPlatformType())) {
			AccountVo answer = new AccountVo(vo.getAccount_id(),vo.getFollowCount(),vo.getReviewCount(),vo.getPlatformId(),
					0,0,0,cut(vo.getNickname()),cut(vo.getPlatformType()),cut(vo.getProfileImage()),cut(vo.getThumbnailImage()),
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
