package com.kkssj.moca.controller;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.service.AccountService;

@Controller
@SessionAttributes("login")
public class ResearchController {
	@Inject
	AccountService accountService;
	
	/*------------------------------------------------------------------------------------------------------*/
	
	@PostMapping(value = "/research")
	@ResponseBody
	public ResponseEntity researchInsert(@RequestBody AccountVo accountVo, Model model){
		AccountVo returnVo = accountService.researchInsert(stringFilter(accountVo));
		
		if(accountVo.getBarista()==0||accountVo.getGender()==0||accountVo.getBirthday()==null) {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}else if(returnVo==null) {
			//model.addAttribute("login",new AccountVo(0, 0, 0, 0, null, "\"NULL_VAL\"", null, null, null, 0, 0, null));
			
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}else {
			//세션 정보 업데이트
			model.addAttribute("login", returnVo);
			
			return new ResponseEntity<>(HttpStatus.OK);
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
