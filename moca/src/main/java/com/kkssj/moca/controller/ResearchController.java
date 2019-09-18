package com.kkssj.moca.controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.ResearchVo;
import com.kkssj.moca.service.AccountService;
import com.kkssj.moca.service.ResearchService;

@Controller
public class ResearchController {
	@Inject
	AccountService accountService;

	@Inject
	ResearchService researchService;
	/*------------------------------------------------------------------------------------------------------*/

	final int CNT = 30;
	final int CURRENT_VAL = 1; // 현재 정상적인 설문을 마친 사람의 값은 1이어야 한다.
	
	@RequestMapping(value = "/research", method = RequestMethod.GET)
	public void researchSelectiveInsert(HttpServletRequest req, HttpServletResponse res) {
		String referer_domain = req.getHeader("referer");
		HttpSession sess = req.getSession();
		AccountVo user = (AccountVo)sess.getAttribute("login");

		if(user.getIsResearch()!=CURRENT_VAL) {
			ArrayList<String> arrayList = new ArrayList<String>();
			try {
				int idx =0;
				for(int i=1;i<CNT;i++) { // 인덱스 i는 적당히 많은 숫자임 최댓값은 설문의 개수를 넘어서는 안된다.
					String question=(String)req.getParameter("SQ"+i);
					if(question!=null) {
						arrayList.add(question);
					}
				}
				String intoResearch="";
				for(int i=0;i<arrayList.size();i++) {
					intoResearch=intoResearch+"@"+i+"_#"+arrayList.get(i)+"!";
				}
				
							boolean check = researchService.doResearch(new ResearchVo(0,user.getAccount_id(),1,intoResearch));
				if(check) {
					sess.setAttribute("arrayList", null);
					for(int i=1;i<CNT;i++) {
						sess.setAttribute("ans"+i, null);
					}
					
					boolean chk = accountService.updateIsResearch(user);
					if(chk) {
						res.sendRedirect(referer_domain);
					}else {
						res.sendRedirect("/");
					}
				}else {
					res.sendRedirect("/");
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}else {
			sess.setAttribute("arrayList", null);
			for(int i=1;i<CNT;i++) {
				sess.setAttribute("ans"+i, null);
			}
			try {
				res.sendRedirect(referer_domain);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	@PostMapping(value = "/research")
	@ResponseBody
	public ResponseEntity researchEssentialInsert(@RequestBody AccountVo accountVo, HttpServletRequest req){
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
