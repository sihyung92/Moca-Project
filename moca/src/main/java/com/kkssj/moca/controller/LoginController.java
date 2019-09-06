package com.kkssj.moca.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
import com.kkssj.moca.model.entity.ResearchQuestionVo;
import com.kkssj.moca.service.AccountService;
import com.kkssj.moca.service.LogService;
import com.kkssj.moca.service.ResearchQuestionService;
import com.kkssj.moca.service.ResearchService;

@Controller
public class LoginController {//@SessionAtrribute?인가 삭제함
	
	@Inject
	AccountService accountService;
	
	@Inject
	LogService logService;
	
	@Inject
	ResearchQuestionService researchQuestionService;
	
	@Inject
	ResearchService researchService;
	/*------------------------------------------------------------------------------------------------------*/
	
	@GetMapping(value = "/naverLogin")
	public String loginPage() {
		
		return "naverLogin";
	}
	
	@PostMapping(value = "/login/{account_id}")
	@ResponseBody
	public ResponseEntity login(@PathVariable("account_id") int account_id, @RequestBody AccountVo accountVo, HttpServletRequest req){
		AccountVo returnVo = accountService.login(stringFilter(accountVo));
		try {
			if(returnVo.getIsResearch()==0) {
				HttpSession ses=req.getSession();
				
				researchQuestionService.getList(ses);
				ArrayList array = (ArrayList)ses.getAttribute("alist");// 설문 리스트를 받아다가 세션에 설정함
				for(int i=0;i<array.size();i++) {
					ResearchQuestionVo rqVo = (ResearchQuestionVo)array.get(i);
					if((rqVo).getAnswer()!=null) {
						String answer=((ResearchQuestionVo)(array).get(rqVo.getQuestion_id()-1)).getAnswer();
						
						char[] ques = answer.toCharArray();
						List<String> al = new ArrayList<String>();
						String ans="";
						
						for(int j=1;j<ques.length+1;j++){ // 설문에 문항 / 답안 인식 부호들을 처리하는 과정
							if(ques[j-1]=='$'){
								continue;
							}else if(ques[j-1]=='_'){
								al.add(ans);
								ans="";
							}else if(ques[j-1]=='!') {
								al.add(ans);
								ans="";
								continue;
							}else {
								ans=ans+ques[j-1];
							}
						}
						ses.setAttribute("ans"+rqVo.getQuestion_id(), al);
					}
				}
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
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
					cut(vo.getEmail()),vo.getGender(),vo.getBarista(),vo.getBirthday(),vo.getIsResearch());
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
