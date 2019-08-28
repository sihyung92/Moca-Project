package com.kkssj.moca.controller;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.service.MypageService;

@Controller
public class MyPageController {
	
	@Inject
	MypageService mypageService;
	
	private static final Logger logger = LoggerFactory.getLogger(MyPageController.class);

	@GetMapping(value = "/mypage/{accountId}")
	public String home() {
		//해당 account 정보 가져오기 (그래프+배지 포함)
		
		//해당 account의 내가 쓴 리뷰 가져오기
		
		
		return "mypage";
	}
	
	//해당 account의 follower 가져오기
	@GetMapping(value="/follower/{accountId}")
	@ResponseBody
	public ResponseEntity getFollower(@PathVariable("accountId") int accountId){
		//세션의 id값과 path로 받아온 id값이 일치하는 지 확인
		//if() {}
		logger.debug("getFollower 들어옴");
		
		//follower목록 가져오기
		List<AccountVo> followerList = mypageService.getFollower(accountId);
		
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
		
		
		return null;
	}
	
		
	//해당 account의 회원정보 수정하기
	@PutMapping(value="/editAccount/{accountId}")
	@ResponseBody
	public ResponseEntity editAccount(@PathVariable("accountId") int accountId, AccountVo accountVo) {
		//세션의 id값과 path로 받아온 id값이 일치하는 지 확인
		return null;
	}
		
	//해당 account의 회원탈퇴(삭제)
	@DeleteMapping(value="/deleteAccount/{accountId}")
	@ResponseBody
	public	ResponseEntity deleteAccount(@PathVariable("accountId") int accountId) {
		//세션의 id값과 path로 받아온 id값이 일치하는 지 확인
		return null;
	}
}