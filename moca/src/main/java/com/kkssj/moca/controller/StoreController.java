package com.kkssj.moca.controller;


 import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;

import com.kkssj.moca.service.StoreService;

@Controller
public class StoreController {
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@Inject
	StoreService storeService;
	
	
 	//처음 상세페이지로 접속
//	@PostMapping("/store")


 	//리다이렉트로 상세페이지로
	@GetMapping("/stores/{storeId}")
	public String getStore(@PathVariable("storeId") int storeId, Model model) {
		logger.info("Welcome storeDetail!");
		
		//계정 정보를 받아오고
		int accountId =1;
		
		
		model.addAttribute("reviewVoList", storeService.getReviewList(accountId, storeId));

 		return "store_detail";
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
	
	//좋아요싫어요 추가
	@PostMapping("/likeHate")
	public void addLikeHate() {
		
		
	}
	
	//좋아요싫어요 수정
	@PutMapping("/likeHate")
	public void editLikeHate() {
		
	}
	
	//좋아요 싫어요 삭제
	@DeleteMapping("/likeHate")
	public void deleteLikeHate() {
		
	}
 }