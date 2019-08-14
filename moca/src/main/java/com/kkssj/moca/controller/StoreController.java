package com.kkssj.moca.controller;


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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.kkssj.moca.model.entity.ReviewVo;
import com.kkssj.moca.service.StoreService;

@Controller
public class StoreController {
	private static final Logger logger = LoggerFactory.getLogger(StoreController.class);

	@Inject
	StoreService storeService;
	
	
 	//처음 상세페이지로 접속
//	@PostMapping("/store")


 	//리다이렉트로 상세페이지로
	@GetMapping("/store/{storeId}")
	public String getStore(@PathVariable("storeId") int storeId, Model model) {
		logger.info("Welcome storeDetail!");
		
		//계정 정보를 받아오고
		int accountId =1;
		
		
		model.addAttribute("reviewVoList", storeService.getReviewList(accountId, storeId));

 		return "store_detail";
	}
	
	//좋아요싫어요 추가
	@PostMapping("/likeHates/{review_id}")
	public ResponseEntity addLikeHate(@PathVariable("review_id") int review_id, @RequestParam int isLike) {
		
		//계정 정보를 받아오고
		int accountId =1;
		
		logger.debug("accountId :" + accountId);
		logger.debug("review_id :" + review_id);
		logger.debug("isLike :" + isLike);
		
		
		if(storeService.addLikeHate(review_id, accountId, isLike) ==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		
	}
	
	//좋아요싫어요 수정
	//서버에 server.xml에 Connector 태그에 parseBodyMethods
	//<Connector connectionTimeout="20000" port="8080" protocol="HTTP/1.1" redirectPort="8443" parseBodyMethods="POST,PUT,DELETE"/> 추가
	@PutMapping("/likeHates/{review_id}")
	public ResponseEntity editLikeHate(@PathVariable("review_id") int review_id, @RequestParam int isLike) {
		
		
		//계정 정보를 받아오고
		int accountId =1;
		
		logger.debug("accountId :" + accountId);
		logger.debug("review_id :" + review_id);
		logger.debug("isLike :" + isLike);
		
		if(storeService.editLikeHate(review_id, accountId, isLike) ==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}
	
	//좋아요 싫어요 삭제
	@DeleteMapping("/likeHates/{review_id}")
	public ResponseEntity  deleteLikeHate(@PathVariable("review_id") int review_id) {		
		//계정 정보를 받아오고
		int accountId =1;	
		
		logger.debug("accountId :" + accountId);
		logger.debug("review_id :" + review_id);
		
		if(storeService.deleteLikeHate(review_id, accountId) ==1) {
			return new ResponseEntity<>(HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}
	
		


	//리뷰 입력
	@PostMapping("/review")
	public String addReview() {
		
		return ""; 
	}
	
	//리뷰 수정
	@PutMapping("/review")
	public void editReview() {
		
		//json으로 수정 내용 전송
		
		//받는 쪽에서 refresh하게
	}
	
	//리뷰 삭제
	@DeleteMapping("/review")
	public void deleteReview() {
		
		//json으로 삭제 
		
		//받는 쪽에서 refresh하게 
	}
	
	
	
	
 }