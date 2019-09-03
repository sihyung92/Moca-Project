package com.kkssj.moca.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.service.AccountService;

@Controller
public class ResearchController {
	@Inject
	AccountService accountService;
	
	/*------------------------------------------------------------------------------------------------------*/
	
	@PostMapping(value = "/research")
	@ResponseBody
	public ResponseEntity researchInsert(@RequestBody AccountVo accountVo, HttpServletRequest req){
		AccountVo returnVo = accountService.researchInsert(stringFilter(accountVo));
		
		if(accountVo.getBarista()==0||accountVo.getGender()==0||accountVo.getBirthday()==null) {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}else if(returnVo==null) {
			
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}else {
			req.getSession().setAttribute("login", returnVo);
			
			return new ResponseEntity<>(HttpStatus.OK);
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
