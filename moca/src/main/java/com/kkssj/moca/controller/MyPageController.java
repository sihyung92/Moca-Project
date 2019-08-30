package com.kkssj.moca.controller;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.service.MypageService;

@Controller
public class MyPageController {
	
	@Inject
	MypageService mypageService;
	
	private static final Logger logger = LoggerFactory.getLogger(MyPageController.class);

	@GetMapping(value = "/mypage/{accountId}")
	public String home(@PathVariable("accountId") int accountId, Model model, HttpSession session){
		
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
		}else {
			logger.debug(accountVo.toString());
		}
		
		
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
	
	@GetMapping("/favoriteStores/{accountId}")
	public ResponseEntity getFavoriteStores(@PathVariable("accountId") int accountId, HttpSession session){
		
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		//나의 마이페이지가 아닌 경우
		if(accountVo.getAccount_id() != accountId) {
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		logger.debug(accountVo.toString());
		

		
		
		List<StoreVo> favoriteStoreList = mypageService.getFavoriteStoreList(accountId);
		
		if(favoriteStoreList!=null) {
			return new ResponseEntity<>(favoriteStoreList, HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	
	@GetMapping("/likeStores/{accountId}")
	public ResponseEntity getLikeStores(@PathVariable("accountId") int accountId, HttpSession session){
		
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		//나의 마이페이지가 아닌 경우
		if(accountVo.getAccount_id() != accountId) {
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		List<StoreVo> likeStoreList = mypageService.getLikeStoreList(accountId);
		
		if(likeStoreList!=null) {
			return new ResponseEntity<>(likeStoreList, HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}

	//해당 account의 follow 추가
	@PostMapping(value="/follow/{accountId}")
	@ResponseBody
	public ResponseEntity addFollow(@PathVariable("accountId") int following, HttpSession session){
		
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		//나의 마이페이지가 아닌 경우
		if(accountVo.getAccount_id() != following) {
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		int follower = accountVo.getAccount_id(); //세션 할당
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
	public ResponseEntity deleteFollow(@PathVariable("accountId") int following, HttpSession session){
		
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		//나의 마이페이지가 아닌 경우
		if(accountVo.getAccount_id() != following) {
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		int follower = accountVo.getAccount_id(); //세션 할당
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
		
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		//나의 마이페이지가 아닌 경우
		if(accountVo.getAccount_id() != accountId) {
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
	public ResponseEntity getFollowing(@PathVariable("accountId") int accountId, HttpSession session){
		
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		//나의 마이페이지가 아닌 경우
		if(accountVo.getAccount_id() != accountId) {
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		//following목록 가져오기
		List<AccountVo> followingList = mypageService.getFollowingList(accountId);
		
		if(followingList!=null) {
			return new ResponseEntity<>(followingList, HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	
		
	///해당 account의 회원정보 수정하기
	@PostMapping(value="/editAccount/{accountId}")
	@ResponseBody
	public ResponseEntity editAccount(@RequestParam("file") MultipartFile[] userImage, @PathVariable("accountId") int accountId, AccountVo editAccountVo, HttpSession session){
		
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		//나의 마이페이지가 아닌 경우
		if(accountVo.getAccount_id() != accountId) {
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		return null;
	}
		
	///해당 account의 회원탈퇴(삭제)
	@DeleteMapping(value="/deleteAccount/{accountId}")
	@ResponseBody
	public	ResponseEntity deleteAccount(@PathVariable("accountId") int accountId, HttpSession session){
		
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		//나의 마이페이지가 아닌 경우
		if(accountVo.getAccount_id() != accountId) {
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		return null;
	}
}