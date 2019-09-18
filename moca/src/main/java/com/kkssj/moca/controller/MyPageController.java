package com.kkssj.moca.controller; 

import java.io.InputStream;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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

import com.kkssj.moca.model.AccountDao;
import com.kkssj.moca.model.entity.AccountVo;
import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.model.entity.StoreVo;
import com.kkssj.moca.service.MypageService;

@Controller
public class MyPageController {
	
	@Inject
	MypageService mypageService;
	
	private static final Logger logger = LoggerFactory.getLogger(MyPageController.class);

	@GetMapping(value = "/mypage")
	public String myHome(HttpSession session, HttpServletResponse response, Model model){
		
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			model.addAttribute("accountId", 0);
			///어디로 보낼지는 회의를 거쳐서
			response.setStatus(423);
			return "mypage";
		}

		logger.debug(accountVo.toString());
		
		return "redirect:/mypage/"+accountVo.getAccount_id();
	}
	
	@GetMapping(value = "/mypage/{accountId}")
	public String home(@PathVariable("accountId") int accountId, Model model, HttpSession session, HttpServletResponse response){
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		AccountVo currentPageAccount = mypageService.getAccountInfo(accountId);
		//탈퇴한 회원이거나 DB에 없는 회원번호를 호출했을 때
		if(currentPageAccount==null) {
			//오류페이지로(현재는 메인페이지로 이동)
			return "redirect:/err/err404.jsp";
		}
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
		}else {
			logger.debug(accountVo.toString());
		}
		
		AccountVo currentPageAccount1 = mypageService.getAccountInfo(accountId);
		//탈퇴한 회원이거나 DB에 없는 회원번호를 호출했을 때
		if(currentPageAccount1==null) {
			//오류페이지로(현재는 메인페이지로 이동)
			return "redirect:/";
		}
		
		currentPageAccount1.setLevelName(currentPageAccount1.getAccountLevel());
		model.addAttribute("currentPageAccount",currentPageAccount1);
		logger.debug(currentPageAccount1.toString());
		
		//세션의 id값과 path로 받아온 id값이 일치하는 지 확인
		if(accountId==accountVo.getAccount_id()) {
			//isMine을 1로
			accountVo.setIsMine(1);
			accountVo.setExp(currentPageAccount1.getExp());
			accountVo.setAccountLevel(currentPageAccount1.getAccountLevel());
			accountVo.setMaxExp();
			accountVo.setMinExp();
			logger.debug(accountVo.toString());
		}else {
			accountVo.setIsMine(0);
		}
		
		List<String> tagNameList = mypageService.getTagNameList();
		
		model.addAttribute("accountVo",accountVo);
		
		//해당 account 정보 가져오기 (그래프+배지 포함)
		//일단은 기본적인 정보만 가져오기
		model.addAttribute("");
		
		//해당 account의 내가 쓴 리뷰 가져오기
		model.addAttribute("reviewVoList", mypageService.getMyReviewListLimit(accountVo.getAccount_id(), accountId, 0));
		
		//tag 가져오기
		model.addAttribute("tagNameList", tagNameList);
		
		
		//follower목록 가져오기
		List<AccountVo> followingList = mypageService.getFollowingList(accountVo.getAccount_id());
		model.addAttribute("followingList",followingList);
		
		return "mypage";
	}
	
	@GetMapping("/mypage/reviewMore/{accountId}")
	public ResponseEntity getReviewMore(@PathVariable("accountId") int accountId, @RequestParam("startNum") int startNum, HttpSession session){
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
		}else {
			logger.debug(accountVo.toString());
		}
		
		//해당 account의 내가 쓴 리뷰 가져오기
		List<ReviewVo> MyreviewList = mypageService.getMyReviewListLimit(accountVo.getAccount_id(), accountId, startNum);
		return new ResponseEntity<>(MyreviewList, HttpStatus.OK);
	}
	
	
	@GetMapping("/favoriteStores/{accountId}")
	public ResponseEntity getFavoriteStores(@PathVariable("accountId") int accountId, HttpSession session){
		
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		logger.debug(accountVo.toString());
		//나의 마이페이지가 아닌 경우
		if(accountVo.getAccount_id() != accountId) {
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		

		
		
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
		logger.debug(accountVo.toString());
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
			logger.debug("비회원인 경우");
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		int result=-1;
		//나의 마이페이지가 아닌 경우
		if(accountVo.getAccount_id() != following) {
			logger.debug("나의 마이페이지가 아닌 경우");
			int follower = accountVo.getAccount_id(); //세션 할당
			logger.debug(following+":"+follower);
			
			result = mypageService.addFollow(follower,following);
		}
		
		
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
		
		int result=-1;
		
		//나의 마이페이지가 아닌 경우
		if(accountVo.getAccount_id() != following) {
			int follower = accountVo.getAccount_id(); //세션 할당
			logger.debug(following+":"+follower);
			
			result = mypageService.deleteFollow(follower,following);
		}
		
		
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
	public ResponseEntity editAccount(@RequestParam("userImage") MultipartFile[] userImage, @PathVariable("accountId") int accountId, AccountVo editAccountVo, HttpSession session){
		
		AccountVo accountVo = (AccountVo) session.getAttribute("login");
		logger.debug(editAccountVo.toString());
		
		//비회원인 경우
		if(accountVo ==null) {
			accountVo = new AccountVo();
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		//나의 마이페이지가 아닌 경우
		if(accountVo.getAccount_id() != accountId) {
			return new ResponseEntity<>(HttpStatus.LOCKED);
		}
		
		int result = mypageService.editAccount(editAccountVo,userImage[0]);
		
		
		if(result==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
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
		
//		accountVo.setAccount_id(49);
		
		int result = mypageService.deleteAccount(accountVo.getAccount_id());
		
		if(result==1) {
			session.setAttribute("login", null);
			return new ResponseEntity<>(HttpStatus.OK);
		}
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	
}