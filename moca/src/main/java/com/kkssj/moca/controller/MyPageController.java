package com.kkssj.moca.controller;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.service.MypageService;

@Controller
public class MyPageController {
	
	@Inject
	MypageService mypageService;
	
	private static final Logger logger = LoggerFactory.getLogger(MyPageController.class);

	@GetMapping(value = "/mypage/{accountId}")
	public String home(@PathVariable("accountId") int accountId, Model model) {
		AccountVo accountVo = new AccountVo();
		//세션
		accountVo.setAccount_id(1);
		
		
		AccountVo currentPageAccount = mypageService.getAccountInfo(accountId);
		model.addAttribute("currentPageAccount",currentPageAccount);
		logger.debug(currentPageAccount.toString());
		
		//세션의 id값과 path로 받아온 id값이 일치하는 지 확인
		if(accountId==1) {
			//isMine을 1로
			accountVo.setIsMine(1);
		}
		
		model.addAttribute("accountVo",accountVo);
		
		//해당 account 정보 가져오기 (그래프+배지 포함)
		//일단은 기본적인 정보만 가져오기
		model.addAttribute("");
		
		//해당 account의 내가 쓴 리뷰 가져오기
		model.addAttribute("reviewVoList", mypageService.getMyreviewList(accountId,accountVo.getAccount_id()));
		
		
		//follower목록 가져오기
		List<AccountVo> followingList = mypageService.getFollowingList(accountVo.getAccount_id());
		model.addAttribute("followingList",followingList);
		
		return "mypage";
	}
	
	//해당 account의 follow 추가
	@PostMapping(value="/follow/{accountId}")
	@ResponseBody
	public ResponseEntity addFollow(@PathVariable("accountId") int follower, @RequestParam("followId") int following){
		logger.debug(following+":"+follower);
		
		int result = mypageService.addFollow(follower,following);
		if(result==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		
	}
	
	//해당 account의 follow 삭제
	@DeleteMapping(value="/follow/{accountId}")
	@ResponseBody
	public ResponseEntity deleteFollow(@PathVariable("accountId") int follower, @RequestParam("followId") int following){
		logger.debug(following+":"+follower);
		
		int result = mypageService.deleteFollow(follower,following);
		if(result==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		
	}
	
	//해당 account의 follower 가져오기
	@GetMapping(value="/follower/{accountId}")
	@ResponseBody
	public ResponseEntity getFollower(@PathVariable("accountId") int accountId, HttpSession session){
		//세션의 id값과 path로 받아온 id값이 일치하는 지 확인
		if(accountId!=1) {
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		//follower목록 가져오기
		List<AccountVo> followerList = mypageService.getFollowerList(accountId);
		
		if(followerList!=null) {
			return new ResponseEntity<>(followerList, HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		
	}
	
	//해당 account의 following 가져오기
	@GetMapping(value="/following/{accountId}")
	@ResponseBody
	public ResponseEntity getFollowing(@PathVariable("accountId") int accountId){
		//세션의 id값과 path로 받아온 id값이 일치하는 지 확인
		if(accountId!=1) {
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		//following목록 가져오기
		List<AccountVo> followingList = mypageService.getFollowingList(accountId);
		
		if(followingList!=null) {
			return new ResponseEntity<>(followingList, HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	
		
	//해당 account의 회원정보 수정하기
	@PostMapping(value="/editAccount/{accountId}")
	@ResponseBody
	public ResponseEntity editAccount(@RequestParam("file") MultipartFile[] userImage, @PathVariable("accountId") int accountId, AccountVo accountVo) {
		//세션의 id값과 path로 받아온 id값이 일치하는 지 확인
		if(accountId==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.LOCKED);
	}
		
	//해당 account의 회원탈퇴(삭제)
	@DeleteMapping(value="/deleteAccount/{accountId}")
	@ResponseBody
	public	ResponseEntity deleteAccount(@PathVariable("accountId") int accountId) {
		//세션의 id값과 path로 받아온 id값이 일치하는 지 확인
		return null;
	}
}